<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Order Confirmation | ShoeCart</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">
        <link href="https://fonts.googleapis.com/css2?family=Bungee&family=Poppins:wght@400;500;600;700&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/checkout-order.css">


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
            <div class="confirmation-header text-center">
                <i class="bi bi-check-circle-fill" style="font-size: 3rem;"></i>
                <h2 class="mt-3">Thank you for your order!</h2>
                <p class="mb-0">Your order has been placed successfully. We've sent a confirmation to your email.</p>
            </div>

            <div class="row">
                <div class="col-lg-8">
                    <div class="card order-card">
                        <div class="card-header">
                            <h3 class="mb-0">Order #${order.orderId}</h3>
                        </div>
                        <div class="card-body">
                            <div class="row mb-4">
                                <div class="col-md-6">
                                    <div class="d-flex">
                                        <span class="order-detail-label">Order Date:</span>
                                        <span class="order-detail-value">${order.orderDate}</span>
                                    </div>
                                    <div class="d-flex">
                                        <span class="order-detail-label">Status:</span>
                                        <span class="order-detail-value badge bg-success">${order.status}</span>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="d-flex">
                                        <span class="order-detail-label">Estimated Delivery:</span>
                                        <span class="order-detail-value">${order.estimatedDelivery}</span>
                                    </div>
                                    <div class="d-flex">
                                        <span class="order-detail-label">Payment Method:</span>
                                        <span class="order-detail-value">${order.paymentMethod}</span>
                                    </div>
                                </div>
                            </div>

                            <h4 class="mb-3">Order Items</h4>
                            <div class="table-responsive">
                                <table class="table">
                                    <thead>
                                        <tr>
                                            <th>Product</th>
                                            <th>Size</th>
                                            <th>Price</th>
                                            <th>Qty</th>
                                            <th>Total</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach items="${order.items}" var="item">
                                            <tr>
                                                <td>
                                                    <div class="d-flex align-items-center">
                                                        <img src="${pageContext.request.contextPath}/assets/images/products/${item.productId}.jpg" 
                                                             alt="${item.productName}" class="item-image me-3">
                                                        <div>${item.productName}</div>
                                                    </div>
                                                </td>
                                                <td>${item.size}</td>
                                                <td>$${item.price}</td>
                                                <td>${item.quantity}</td>
                                                <td>$${item.price * item.quantity}</td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="col-lg-4">
                    <div class="card order-card">
                        <div class="card-header">
                            <h3 class="mb-0">Shipping Information</h3>
                        </div>
                        <div class="card-body">
                            <div class="mb-3">
                                <h5>Shipping Address</h5>
                                <p>${order.shippingAddress}</p>
                            </div>
                            <hr>
                            <div class="mb-3">
                                <h5>Order Summary</h5>
                                <div class="d-flex justify-content-between mb-2">
                                    <span>Subtotal (${order.items.size()} items)</span>
                                    <span>$${order.totalAmount}</span>
                                </div>
                                <div class="d-flex justify-content-between mb-2">
                                    <span>Shipping</span>
                                    <span>Free</span>
                                </div>
                                <div class="d-flex justify-content-between mb-2">
                                    <span>Tax</span>
                                    <span>$0.00</span>
                                </div>
                                <hr>
                                <div class="d-flex justify-content-between fw-bold total-amount">
                                    <span>Total</span>
                                    <span>$${order.totalAmount}</span>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="d-grid gap-2 mt-3">
                        <a href="${pageContext.request.contextPath}/products" class="btn btn-continue">
                            <i class="bi bi-arrow-left"></i> Continue Shopping
                        </a>
                        <a href="${pageContext.request.contextPath}/orders" class="btn btn-orders">
                            <i class="bi bi-list-ul"></i> View All Orders
                        </a>
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
                            <li><a href="${pageContext.request.contextPath}/" class="text-white">Home</a></li>
                            <li><a href="${pageContext.request.contextPath}/products" class="text-white">Products</a></li>
                            <li><a href="${pageContext.request.contextPath}/jsp/about.jsp" class="text-white">About Us</a></li>
                        </ul>
                    </div>
                    <div class="col-md-4">
                        <h5>Contact Us</h5>
                        <address>
                            123 Shoe Street<br>
                            Footwear City, FC 12345<br>
                            Email: info@shoecart.com
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