<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>ShoeCart - My Orders</title>

        <link href="https://fonts.googleapis.com/css2?family=Bungee&family=Poppins:wght@400;500;600;700&display=swap" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/order.css">
        <style>
            .error-container {
                padding: 40px;
                text-align: center;
                color: #dc3545;
            }
        </style>
    </head>
    <body>
        <nav class="navbar navbar-expand-lg navbar-dark bg-dark">
            <div class="container">
                <a class="navbar-brand fw-bold" href="${pageContext.request.contextPath}/jsp/home.jsp">
                    <i class="bi bi-shop-window"></i> ShoeCart
                </a>      
                <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                    <span class="navbar-toggler-icon"></span>
                </button>
                <div class="collapse navbar-collapse" id="navbarNav">
                    <ul class="navbar-nav me-auto">
                        <li class="nav-item">
                            <a class="nav-link active" href="${pageContext.request.contextPath}/jsp/home.jsp">Home</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="${pageContext.request.contextPath}/products">Products</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="${pageContext.request.contextPath}/jsp/about.jsp">About</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="${pageContext.request.contextPath}/jsp/contact.jsp">Contact</a>
                        </li>
                    </ul>
                    <ul class="navbar-nav">
                        <c:choose>
                            <c:when test="${not empty user}">
                                <li class="nav-item dropdown">
                                    <a class="nav-link dropdown-toggle" href="#" id="navbarDropdown" role="button" data-bs-toggle="dropdown">
                                        ${user.name}
                                    </a>
                                    <ul class="dropdown-menu">
                                        <li><a class="dropdown-item" href="${pageContext.request.contextPath}/profile">Profile</a></li>
                                        <li><a class="dropdown-item" href="${pageContext.request.contextPath}/orders">Orders</a></li>
                                        <li><hr class="dropdown-divider"></li>
                                        <li><a class="dropdown-item" href="${pageContext.request.contextPath}/logout">Logout</a></li>
                                    </ul>
                                </li>
                                <li class="nav-item">
                                    <a class="nav-link" href="${pageContext.request.contextPath}/cart">
                                        <i class="bi bi-cart"></i> Cart
                                    </a>
                                </li>
                            </c:when>
                            <c:otherwise>
                                <li class="nav-item">
                                    <a class="nav-link" href="${pageContext.request.contextPath}/login">Login</a>
                                </li>
                                <li class="nav-item">
                                    <a class="nav-link" href="${pageContext.request.contextPath}/register">Register</a>
                                </li>
                            </c:otherwise>
                        </c:choose>
                    </ul>
                </div>
            </div>
        </nav>
        <main class="container my-5">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h2><i class="bi bi-receipt"></i> My Orders</h2>
                <a href="${pageContext.request.contextPath}/products" class="btn btn-outline-primary">
                    <i class="bi bi-bag"></i> Continue Shopping
                </a>
            </div>

            <c:if test="${not empty cancelSuccess}">
                <div class="alert alert-success alert-dismissible fade show" role="alert">
                    Order cancelled successfully
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            </c:if>
            <c:if test="${not empty cancelError}">
                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                    Failed to cancel order
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            </c:if>

            <c:if test="${not empty error}">
                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                    ${error}
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            </c:if>

            <c:choose>
                <c:when test="${not empty orders and not empty orders[0]}">
                    <div class="table-responsive">
                        <table class="table table-hover align-middle">
                            <thead class="table-light">
                                <tr>
                                    <th>Order #</th>
                                    <th>Date</th>
                                    <th>Items</th>
                                    <th>Total</th>
                                    <th>Status</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach items="${orders}" var="order">
                                    <tr>
                                        <td>
                                            <strong>${order.orderId}</strong>
                                            <c:if test="${not empty order.estimatedDelivery}">
                                                <div class="small text-muted">
                                                    Est. delivery: <fmt:formatDate value="${order.estimatedDelivery}" pattern="MMM dd"/>
                                                </div>
                                            </c:if>
                                        </td>
                                        <td><fmt:formatDate value="${order.orderDate}" pattern="MMM dd, yyyy"/></td>
                                        <td>${order.items.size()} item(s)</td>
                                        <td><fmt:formatNumber value="${order.totalAmount}" type="currency"/></td>
                                        <td>
                                            <span class="badge bg-${order.status == 'Delivered' ? 'success' : 
                                                                    order.status == 'Shipped' ? 'primary' : 
                                                                    order.status == 'Processing' ? 'warning' : 
                                                                    order.status == 'Cancelled' ? 'danger' : 'secondary'}">
                                                      ${order.status}
                                                  </span>
                                            </td>
                                            <td>
                                                <div class="d-flex gap-2">
                                                    <a href="${pageContext.request.contextPath}/order/details/${order.orderId}" 
                                                       class="btn btn-sm btn-outline-primary">
                                                        <i class="bi bi-eye"></i> View
                                                    </a>
                                                    <c:if test="${order.status == 'Processing' || order.status == 'Pending'}">
                                                        <form action="${pageContext.request.contextPath}/order/cancel/${order.orderId}" 
                                                              method="post" class="d-inline">
                                                            <button type="submit" class="btn btn-sm btn-outline-danger" 
                                                                    onclick="return confirm('Are you sure you want to cancel this order?')">
                                                                <i class="bi bi-x-circle"></i> Cancel
                                                            </button>
                                                        </form>
                                                    </c:if>
                                                </div>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="card text-center py-5">
                            <div class="card-body">
                                <i class="bi bi-cart-x text-muted" style="font-size: 3rem;"></i>
                                <h5 class="card-title mt-3">You haven't placed any orders yet</h5>
                                <p class="card-text text-muted">Start shopping to see your orders here</p>
                                <a href="${pageContext.request.contextPath}/products" class="btn btn-primary mt-3">
                                    <i class="bi bi-bag"></i> Shop Now
                                </a>
                            </div>
                        </div>
                    </c:otherwise>
                </c:choose>
            </main>
            <footer class="bg-dark text-white py-4 mt-5">
                <div class="container">
                    <div class="row">
                        <div class="col-md-4">
                            <h5>About ShoeCart</h5>
                            <p>Your one-stop shop for the latest and greatest in footwear fashion.</p>
                        </div>
                        <div class="col-md-4">
                            <h5>Quick Links</h5>
                            <ul class="list-unstyled">
                                <li><a href="${pageContext.request.contextPath}/jsp/home.jsp" class="text-white">Home</a></li>
                                <li><a href="${pageContext.request.contextPath}/products" class="text-white">Products</a></li>
                                <li><a href="${pageContext.request.contextPath}/jsp/about.jsp" class="text-white">About Us</a></li>
                                <li><a href="${pageContext.request.contextPath}/jsp/contact.jsp" class="text-white">Contact</a></li>
                            </ul>
                        </div>
                        <div class="col-md-4">
                            <h5>Contact Us</h5>
                            <address>
                                123 Shoe Street<br>
                                Footwear City, FC 12345<br>
                                Email: info@shoecart.com<br>
                                Phone: (123) 456-7890
                            </address>
                        </div>
                    </div>
                    <hr>
                    <div class="text-center">
                        <p>&copy; 2025 ShoeCart. All rights reserved.</p>
                    </div>
                </div>
            </footer>
            <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        </body>
    </html>