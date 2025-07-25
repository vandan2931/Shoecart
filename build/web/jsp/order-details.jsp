<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>ShoeCart - Order Details</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/order.css">
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
                            <a class="nav-link" href="${pageContext.request.contextPath}/jsp/home.jsp">Home</a>
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
                                        <c:if test="${cartCount > 0}">
                                            <span class="badge bg-danger">${cartCount}</span>
                                        </c:if>
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
            <div class="card">
                <div class="card-header bg-primary text-white">
                    <h3 class="mb-0"><i class="bi bi-receipt"></i> Order #${order.orderId}</h3>
                </div>

                <div class="card-body">
                    <div class="row mb-4">
                        <div class="col-md-6">
                            <h5>Order Summary</h5>
                            <ul class="list-group list-group-flush">
                                <li class="list-group-item d-flex justify-content-between">
                                    <span>Order Date:</span>
                                    <span><fmt:formatDate value="${order.orderDate}" pattern="MMM dd, yyyy hh:mm a"/></span>
                                </li>
                                <li class="list-group-item d-flex justify-content-between">
                                    <span>Status:</span>
                                    <span class="badge bg-${order.status == 'Delivered' ? 'success' : 
                                                            order.status == 'Shipped' ? 'primary' : 
                                                            order.status == 'Processing' ? 'warning' : 
                                                            order.status == 'Cancelled' ? 'danger' : 'secondary'}">
                                              ${order.status}
                                          </span>
                                    </li>
                                    <li class="list-group-item d-flex justify-content-between">
                                        <span>Total:</span>
                                        <span><fmt:formatNumber value="${order.totalAmount}" type="currency"/></span>
                                    </li>
                                    <li class="list-group-item d-flex justify-content-between">
                                        <span>Payment Method:</span>
                                        <span>
                                            <c:choose>
                                                <c:when test="${order.paymentMethod eq 'credit_card'}">
                                                    <i class="bi bi-credit-card"></i> Credit Card
                                                </c:when>
                                                <c:otherwise>
                                                    ${order.paymentMethod}
                                                </c:otherwise>
                                            </c:choose>
                                        </span>
                                    </li>
                                </ul>
                            </div>

                            <div class="col-md-6">
                                <h5>Shipping Information</h5>
                                <div class="card">
                                    <div class="card-body">
                                        <address>
                                            ${order.shippingAddress}
                                        </address>
                                        <c:if test="${not empty order.estimatedDelivery}">
                                            <div class="mt-2">
                                                <strong>Estimated Delivery:</strong>
                                                <fmt:formatDate value="${order.estimatedDelivery}" pattern="EEEE, MMMM dd, yyyy"/>
                                            </div>
                                        </c:if>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <h5>Order Items</h5>
                        <div class="table-responsive">
                            <table class="table">
                                <thead class="table-light">
                                    <tr>
                                        <th>Product</th>
                                        <th>Size</th>
                                        <th>Price</th>
                                        <th>Quantity</th>
                                        <th>Subtotal</th>
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
                                </tbody>
                                <tfoot class="table-light">
                                    <tr>
                                        <td colspan="4" class="text-end"><strong>Total:</strong></td>
                                        <td><strong><fmt:formatNumber value="${order.totalAmount}" type="currency"/></strong></td>
                                    </tr>
                                </tfoot>
                            </table>
                        </div>

                        <div class="d-flex justify-content-between mt-4">
                            <a href="${pageContext.request.contextPath}/orders" class="btn btn-outline-secondary">
                                <i class="bi bi-arrow-left"></i> Back to Orders
                            </a>
                            <c:if test="${order.status == 'Processing' || order.status == 'Pending'}">
                                <form action="${pageContext.request.contextPath}/order/cancel/${order.orderId}" method="post">
                                    <button type="submit" class="btn btn-danger" 
                                            onclick="return confirm('Are you sure you want to cancel this order?')">
                                        <i class="bi bi-x-circle"></i> Cancel Order
                                    </button>
                                </form>
                            </c:if>
                        </div>
                    </div>
                </div>
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