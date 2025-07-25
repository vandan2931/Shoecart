<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Admin - Manage Orders</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/sidebar.css">

        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/adminorder.css">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    </head>
    <body>
        <div class="admin-container">
            <jsp:include page="/jsp/admin/sidebar.jsp">
                <jsp:param name="active" value="orders" />
            </jsp:include>


            <!-- Content -->
            <div class="content" id="content">
                <!-- Page Heading -->
                <div class="d-sm-flex align-items-center justify-content-between mb-4">
                    <h1 class="h3 mb-0 text-gray-800">Manage Orders</h1>
                    <div class="dropdown">
                        <button class="btn btn-outline-secondary dropdown-toggle" type="button" id="filterDropdown" 
                                data-bs-toggle="dropdown" aria-expanded="false">
                            <i class="fas fa-filter"></i> Filter
                        </button>
                        <ul class="dropdown-menu" aria-labelledby="filterDropdown">
                            <li><a class="dropdown-item ${empty param.status ? 'active' : ''}" 
                                   href="${pageContext.request.contextPath}/admin/orders">All Orders</a></li>
                            <li><hr class="dropdown-divider"></li>
                            <li><a class="dropdown-item ${param.status eq 'Pending' ? 'active' : ''}" 
                                   href="${pageContext.request.contextPath}/admin/orders?status=Pending">Pending</a></li>
                            <li><a class="dropdown-item ${param.status eq 'Processing' ? 'active' : ''}" 
                                   href="${pageContext.request.contextPath}/admin/orders?status=Processing">Processing</a></li>
                            <li><a class="dropdown-item ${param.status eq 'Shipped' ? 'active' : ''}" 
                                   href="${pageContext.request.contextPath}/admin/orders?status=Shipped">Shipped</a></li>
                            <li><a class="dropdown-item ${param.status eq 'Delivered' ? 'active' : ''}" 
                                   href="${pageContext.request.contextPath}/admin/orders?status=Delivered">Delivered</a></li>
                            <li><a class="dropdown-item ${param.status eq 'Cancelled' ? 'active' : ''}" 
                                   href="${pageContext.request.contextPath}/admin/orders?status=Cancelled">Cancelled</a></li>
                        </ul>
                    </div>
                </div>

                <!-- Alert Messages -->
                <c:if test="${not empty success}">
                    <div class="alert alert-success alert-dismissible fade show">
                        ${success}
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                    <c:remove var="success" scope="session" />
                </c:if>
                <c:if test="${not empty error}">
                    <div class="alert alert-danger alert-dismissible fade show">
                        ${error}
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                    <c:remove var="error" scope="session" />
                </c:if>

                <!-- Orders Table -->
                <div class="card shadow mb-4">
                    <div class="card-body">
                        <div class="table-responsive">
                            <table class="table table-bordered" width="100%" cellspacing="0">
                                <thead>
                                    <tr>
                                        <th>Order ID</th>
                                        <th>Customer</th>
                                        <th>Date</th>
                                        <th>Total</th>
                                        <th>Status</th>
                                        <th>Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach items="${orders}" var="order">
                                        <tr>
                                            <td>#${order.orderId}</td>
                                            <td>${order.customerName}</td>
                                            <td><fmt:formatDate value="${order.orderDate}" pattern="MMM dd, yyyy"/></td>
                                            <td><fmt:formatNumber value="${order.totalAmount}" type="currency"/></td>
                                            <td>
                                                <span class="status-badge status-${order.status.toLowerCase()}">
                                                    ${order.status}
                                                </span>
                                            </td>
                                            <td>
                                                <a href="${pageContext.request.contextPath}/admin/orders/details?id=${order.orderId}" 
                                                   class="btn btn-sm btn-primary">
                                                    <i class="fas fa-eye"></i> View
                                                </a>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                    <c:if test="${empty orders}">
                                        <tr>
                                            <td colspan="6" class="text-center py-4">No orders found</td>
                                        </tr>
                                    </c:if>
                                </tbody>
                            </table>
                        </div>

                        <!-- Pagination -->
                        <c:if test="${totalPages > 1}">
                            <nav aria-label="Page navigation" class="mt-4">
                                <ul class="pagination justify-content-center">
                                    <c:if test="${currentPage > 1}">
                                        <li class="page-item">
                                            <a class="page-link" 
                                               href="${pageContext.request.contextPath}/admin/orders?page=${currentPage - 1}<c:if test="${not empty param.status}">&status=${param.status}</c:if>">
                                                   Previous
                                               </a>
                                            </li>
                                    </c:if>

                                    <c:forEach begin="1" end="${totalPages}" var="i">
                                        <li class="page-item ${i == currentPage ? 'active' : ''}">
                                            <a class="page-link" 
                                               href="${pageContext.request.contextPath}/admin/orders?page=${i}<c:if test="${not empty param.status}">&status=${param.status}</c:if>">
                                                ${i}
                                            </a>
                                        </li>
                                    </c:forEach>

                                    <c:if test="${currentPage < totalPages}">
                                        <li class="page-item">
                                            <a class="page-link" 
                                               href="${pageContext.request.contextPath}/admin/orders?page=${currentPage + 1}<c:if test="${not empty param.status}">&status=${param.status}</c:if>">
                                                   Next
                                               </a>
                                            </li>
                                    </c:if>
                                </ul>
                            </nav>
                        </c:if>
                    </div>
                </div>
            </div>
        </div>

        <!-- JavaScript Libraries -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/admin.js"></script>
    </body>
</html>