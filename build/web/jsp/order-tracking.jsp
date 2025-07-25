<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>ShoeCart - Track Order</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
</head>
<body>
    <jsp:include page="/jsp/navbar.jsp" />

    <main class="container my-5">
        <div class="row">
            <div class="col-lg-8 mx-auto">
                <div class="card">
                    <div class="card-header bg-light">
                        <h4 class="card-title mb-0"><i class="bi bi-truck"></i> Track Your Order</h4>
                    </div>
                    <div class="card-body">
                        <form action="${pageContext.request.contextPath}/track-order" method="get">
                            <div class="row g-3">
                                <div class="col-md-6">
                                    <label for="orderId" class="form-label">Order Number</label>
                                    <input type="text" class="form-control" id="orderId" name="orderId" 
                                           value="${param.orderId}" required>
                                </div>
                                <div class="col-md-6">
                                    <label for="email" class="form-label">Email Address</label>
                                    <input type="email" class="form-control" id="email" name="email" 
                                           value="${param.email}" required>
                                </div>
                            </div>
                            <div class="d-grid mt-3">
                                <button type="submit" class="btn btn-primary">
                                    <i class="bi bi-search"></i> Track Order
                                </button>
                            </div>
                        </form>
                    </div>
                </div>

                <c:if test="${not empty error}">
                    <div class="alert alert-danger mt-4">
                        ${error}
                    </div>
                </c:if>

                <c:if test="${not empty order}">
                    <div class="card mt-4">
                        <div class="card-header bg-light">
                            <div class="d-flex justify-content-between align-items-center">
                                <h5 class="card-title mb-0">Order #${order.orderId}</h5>
                                <span class="badge bg-${order.status == 'Delivered' ? 'success' : 
                                                     order.status == 'Shipped' ? 'primary' : 
                                                     order.status == 'Processing' ? 'warning' : 'secondary'}">
                                    ${order.status}
                                </span>
                            </div>
                        </div>
                        <div class="card-body">
                            <div class="progress mb-4" style="height: 10px;">
                                <div class="progress-bar progress-bar-striped progress-bar-animated bg-success" 
                                     role="progressbar" 
                                     style="width: ${order.status == 'Processing' ? 25 : 
                                                  order.status == 'Shipped' ? 50 : 
                                                  order.status == 'In Transit' ? 75 : 100}%" 
                                     aria-valuenow="${order.status == 'Processing' ? 25 : 
                                                   order.status == 'Shipped' ? 50 : 
                                                   order.status == 'In Transit' ? 75 : 100}" 
                                     aria-valuemin="0" 
                                     aria-valuemax="100">
                                </div>
                            </div>
                            
                            <div class="row">
                                <div class="col-md-6">
                                    <ul class="list-unstyled">
                                        <li class="mb-3 d-flex">
                                            <div class="me-3">
                                                <i class="bi bi-check-circle-fill text-success fs-4"></i>
                                            </div>
                                            <div>
                                                <h6 class="mb-1">Order Placed</h6>
                                                <small class="text-muted"><fmt:formatDate value="${order.orderDate}" pattern="MMM dd, yyyy hh:mm a"/></small>
                                            </div>
                                        </li>
                                        <li class="mb-3 d-flex">
                                            <div class="me-3">
                                                <i class="bi ${order.status == 'Processing' || 
                                                             order.status == 'Shipped' || 
                                                             order.status == 'In Transit' || 
                                                             order.status == 'Delivered' ? 
                                                             'bi-check-circle-fill text-success' : 'bi-circle'} fs-4"></i>
                                            </div>
                                            <div>
                                                <h6 class="mb-1">Processing</h6>
                                                <c:if test="${order.status == 'Processing' || order.status == 'Shipped' || 
                                                             order.status == 'In Transit' || order.status == 'Delivered'}">
                                                    <small class="text-muted"><fmt:formatDate value="${order.orderDate}" pattern="MMM dd, yyyy hh:mm a"/></small>
                                                </c:if>
                                            </div>
                                        </li>
                                        <li class="mb-3 d-flex">
                                            <div class="me-3">
                                                <i class="bi ${order.status == 'Shipped' || 
                                                             order.status == 'In Transit' || 
                                                             order.status == 'Delivered' ? 
                                                             'bi-check-circle-fill text-success' : 'bi-circle'} fs-4"></i>
                                            </div>
                                            <div>
                                                <h6 class="mb-1">Shipped</h6>
                                                <c:if test="${order.status == 'Shipped' || order.status == 'In Transit' || order.status == 'Delivered'}">
                                                    <small class="text-muted">Shipped on <fmt:formatDate value="${order.shipDate}" pattern="MMM dd, yyyy"/></small>
                                                </c:if>
                                            </div>
                                        </li>
                                        <li class="mb-3 d-flex">
                                            <div class="me-3">
                                                <i class="bi ${order.status == 'In Transit' || 
                                                             order.status == 'Delivered' ? 
                                                             'bi-check-circle-fill text-success' : 'bi-circle'} fs-4"></i>
                                            </div>
                                            <div>
                                                <h6 class="mb-1">In Transit</h6>
                                                <c:if test="${order.status == 'In Transit' || order.status == 'Delivered'}">
                                                    <small class="text-muted">In transit since <fmt:formatDate value="${order.transitDate}" pattern="MMM dd, yyyy"/></small>
                                                </c:if>
                                            </div>
                                        </li>
                                        <li class="d-flex">
                                            <div class="me-3">
                                                <i class="bi ${order.status == 'Delivered' ? 
                                                             'bi-check-circle-fill text-success' : 'bi-circle'} fs-4"></i>
                                            </div>
                                            <div>
                                                <h6 class="mb-1">Delivered</h6>
                                                <c:if test="${order.status == 'Delivered'}">
                                                    <small class="text-muted">Delivered on <fmt:formatDate value="${order.deliveryDate}" pattern="MMM dd, yyyy"/></small>
                                                </c:if>
                                            </div>
                                        </li>
                                    </ul>
                                </div>
                                
                                <div class="col-md-6">
                                    <div class="card">
                                        <div class="card-body">
                                            <h6 class="card-title">Delivery Information</h6>
                                            <hr>
                                            <p><strong>Tracking Number:</strong> SHC${order.orderId}US</p>
                                            <c:if test="${not empty order.estimatedDelivery}">
                                                <p><strong>Estimated Delivery:</strong> 
                                                    <fmt:formatDate value="${order.estimatedDelivery}" pattern="EEEE, MMMM dd, yyyy"/></p>
                                            </c:if>
                                            <p><strong>Shipping Address:</strong></p>
                                            <address>${order.shippingAddress}</address>
                                            
                                            <c:if test="${order.status == 'Shipped' || order.status == 'In Transit'}">
                                                <div class="alert alert-info mt-3">
                                                    <p class="mb-1"><strong>Carrier:</strong> ShoeCart Express</p>
                                                    <p class="mb-0"><strong>Service:</strong> Standard Shipping</p>
                                                </div>
                                            </c:if>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            
                            <div class="d-grid gap-2 d-md-flex justify-content-md-end mt-3">
                                <a href="${pageContext.request.contextPath}/order/details/${order.orderId}" 
                                   class="btn btn-outline-primary me-md-2">
                                    <i class="bi bi-receipt"></i> View Order Details
                                </a>
                                <a href="${pageContext.request.contextPath}/contact" class="btn btn-outline-secondary">
                                    <i class="bi bi-headset"></i> Contact Support
                                </a>
                            </div>
                        </div>
                    </div>
                </c:if>
            </div>
        </div>
    </main>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>