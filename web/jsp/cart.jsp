<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>ShoeCart - Your Cart</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/products.css">
        <link href="https://fonts.googleapis.com/css2?family=Bungee&family=Poppins:wght@400;500;600;700&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">
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
            <h1 class="mb-4">Your Shopping Cart</h1>

            <c:if test="${not empty param.success}">
                <div class="alert alert-success">${param.success}</div>
            </c:if>
            <c:if test="${not empty param.error}">
                <div class="alert alert-danger">${param.error}</div>
            </c:if>

            <c:choose>
                <c:when test="${empty cart or empty cart.items}">
                    <div class="alert alert-info">
                        Your cart is empty. <a href="${pageContext.request.contextPath}/products">Continue shopping</a>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="row">
                        <div class="col-md-8">
                            <div class="card">
                                <div class="card-body">
                                    <table class="table">
                                        <thead>
                                            <tr>
                                                <th>Product</th>
                                                <th>Size</th>
                                                <th>Price</th>
                                                <th>Quantity</th>
                                                <th>Total</th>
                                                <th>Action</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach items="${cart.items}" var="item">
                                                <tr>
                                                    <!-- In the table row where product images are displayed -->
                                                    <td>
                                                        <div class="d-flex align-items-center">
                                                            <img src="${pageContext.request.contextPath}${item.imagePath}" 
                                                                 alt="${item.name}" class="img-thumbnail" style="width: 80px;">
                                                            <div class="ms-3">
                                                                <h5>${item.name}</h5>
                                                            </div>
                                                        </div>
                                                    </td>
                                                    <td>${item.size}</td>
                                                    <td>$${item.price}</td>
                                                    <td>
                                                        <form action="${pageContext.request.contextPath}/cart/update" method="post" class="d-flex">
                                                            <input type="hidden" name="productId" value="${item.productId}">
                                                            <input type="hidden" name="size" value="${item.size}">
                                                            <input type="number" name="quantity" value="${item.quantity}" min="1" 
                                                                   class="form-control form-control-sm" style="width: 70px;">
                                                            <button type="submit" class="btn btn-sm btn-outline-primary ms-2">Update</button>
                                                        </form>
                                                    </td>
                                                    <td>$${item.price * item.quantity}</td>
                                                    <td>
                                                        <form action="${pageContext.request.contextPath}/cart/remove" method="post">
                                                            <input type="hidden" name="productId" value="${item.productId}">
                                                            <input type="hidden" name="size" value="${item.size}">
                                                            <button type="submit" class="btn btn-sm btn-outline-danger">Remove</button>
                                                        </form>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="card">
                                <div class="card-body">
                                    <h5 class="card-title">Order Summary</h5>
                                    <hr>
                                    <div class="d-flex justify-content-between mb-2">
                                        <span>Subtotal (${cart.getTotalItems()} items)</span>
                                        <span>$${cart.total}</span>
                                    </div>
                                    <div class="d-flex justify-content-between mb-2">
                                        <span>Shipping</span>
                                        <span>Free</span>
                                    </div>
                                    <hr>
                                    <div class="d-flex justify-content-between fw-bold">
                                        <span>Total</span>
                                        <span>$${cart.total}</span>
                                    </div>
                                    <hr>
                                    <a href="${pageContext.request.contextPath}/checkout" class="btn btn-primary w-100">Proceed to Checkout</a>
                                    <a href="${pageContext.request.contextPath}/products" class="btn btn-outline-secondary w-100 mt-2">Continue Shopping</a>
                                </div>
                            </div>
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