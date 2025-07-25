<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Admin - Order Details</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/adminorder.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/sidebar.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">


    </head>
    <body>
        <div class="admin-container">
            <jsp:include page="/jsp/admin/sidebar.jsp">
                <jsp:param name="active" value="orders" />
            </jsp:include>

            <div class="content">
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <h1>Order Details - #${order.orderId}</h1>
                    <a href="${pageContext.request.contextPath}/admin/orders" class="btn btn-outline-secondary">
                        <i class="bi bi-arrow-left"></i> Back to Orders
                    </a>
                </div>

                <c:if test="${not empty success}">
                    <div class="alert alert-success alert-dismissible fade show" role="alert">
                        ${success}
                        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                    </div>
                </c:if>
                <c:if test="${not empty error}">
                    <div class="alert alert-danger alert-dismissible fade show" role="alert">
                        ${error}
                        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                    </div>
                </c:if>

                <div class="row">
                    <div class="col-md-4">
                        <div class="info-section">
                            <h3>Customer Information</h3>
                            <p><strong>Name:</strong> ${order.customerName}</p>
                            <p><strong>Email:</strong> ${order.customerEmail}</p>
                            <p><strong>Phone:</strong> ${order.customerPhone}</p>
                        </div>
                    </div>

                    <div class="col-md-4">
                        <div class="info-section">
                            <h3>Shipping Information</h3>
                            <p><strong>Address:</strong> ${order.shippingAddress}</p>
                            <p><strong>Status:</strong> <span class="status-${order.status.toLowerCase()}">${order.status}</span></p>
                            <p><strong>Order Date:</strong> <fmt:formatDate value="${order.orderDate}" pattern="MMM dd, yyyy HH:mm"/></p>
                            <p><strong>Estimated Delivery:</strong> 
                                <c:choose>
                                    <c:when test="${not empty order.estimatedDelivery}">
                                        <fmt:formatDate value="${order.estimatedDelivery}" pattern="MMM dd, yyyy"/>
                                    </c:when>
                                    <c:otherwise>
                                        Not estimated yet
                                    </c:otherwise>
                                </c:choose>
                            </p>
                        </div>
                    </div>

                    <div class="col-md-4">
                        <div class="info-section">
                            <h3>Payment Information</h3>
                            <p><strong>Method:</strong> ${order.paymentMethod}</p>
                            <p><strong>Total:</strong> <fmt:formatNumber value="${order.totalAmount}" type="currency"/></p>
                        </div>
                    </div>
                </div>

                <div class="info-section">
                    <h3>Order Items</h3>
                    <div class="table-responsive">
                        <table class="table">
                            <thead>
                                <tr>
                                    <th>Product</th>
                                    <th>Size</th>
                                    <th>Price</th>
                                    <th>Quantity</th>
                                    <th>Total</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach items="${order.items}" var="item">
                                    <tr>
                                        <td>${item.productName}</td>
                                        <td>${item.size}</td>
                                        <td><fmt:formatNumber value="${item.price}" type="currency"/></td>
                                        <td>${item.quantity}</td>
                                        <td><fmt:formatNumber value="${item.price * item.quantity}" type="currency"/></td>
                                    </tr>
                                </c:forEach>
                                <tr>
                                    <td colspan="4" class="text-end"><strong>Order Total:</strong></td>
                                    <td><strong><fmt:formatNumber value="${order.totalAmount}" type="currency"/></strong></td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>

                <div class="row">
                    <div class="col-md-6">
                        <div class="info-section">
                            <h3>Order History</h3>
                            <c:forEach items="${order.history}" var="history">
                                <div class="order-history-item">
                                    <div class="d-flex justify-content-between">
                                        <strong>${history.status}</strong>
                                        <small class="text-muted"><fmt:formatDate value="${history.timestamp}" pattern="MMM dd, yyyy HH:mm"/></small>
                                    </div>
                                    <c:if test="${not empty history.notes}">
                                        <p class="mb-0">${history.notes}</p>
                                    </c:if>
                                </div>
                            </c:forEach>
                        </div>
                    </div>

                    <div class="col-md-6">
                        <div class="info-section">
                            <h3>Update Status</h3>
                            <form method="post" action="${pageContext.request.contextPath}/admin/orders/update-status">
                                <input type="hidden" name="orderId" value="${order.orderId}">
                                <div class="mb-3">
                                    <label for="status" class="form-label">New Status</label>
                                    <select name="status" id="status" class="form-select">
                                        <option value="Pending" ${order.status eq 'Pending' ? 'selected' : ''}>Pending</option>
                                        <option value="Processing" ${order.status eq 'Processing' ? 'selected' : ''}>Processing</option>
                                        <option value="Shipped" ${order.status eq 'Shipped' ? 'selected' : ''}>Shipped</option>
                                        <option value="Delivered" ${order.status eq 'Delivered' ? 'selected' : ''}>Delivered</option>
                                        <option value="Cancelled" ${order.status eq 'Cancelled' ? 'selected' : ''}>Cancelled</option>
                                    </select>
                                </div>
                                <div class="mb-3">
                                    <label for="notes" class="form-label">Notes</label>
                                    <textarea name="notes" id="notes" class="form-control" rows="3" placeholder="Optional notes"></textarea>
                                </div>
                                <button type="submit" class="btn btn-primary">
                                    <i class="bi bi-check-circle"></i> Update Status
                                </button>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>