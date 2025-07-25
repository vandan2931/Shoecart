<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>ShoeCart - ${product.name}</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/products.css">
        <link href="https://fonts.googleapis.com/css2?family=Bungee&family=Poppins:wght@400;500;600;700&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">
    </head>
    <body>
        <nav class="navbar navbar-expand-lg navbar-dark bg-dark">
            <div class="container">
                <a class="navbar-brand" href="${pageContext.request.contextPath}/">ShoeCart</a>
                <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                    <span class="navbar-toggler-icon"></span>
                </button>
                <div class="collapse navbar-collapse" id="navbarNav">
                    <ul class="navbar-nav me-auto">
                        <li class="nav-item">
                            <a class="nav-link" href="${pageContext.request.contextPath}/">Home</a>
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
            <c:if test="${not empty success}">
                <div class="alert alert-success alert-dismissible fade show">
                    ${success}
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            </c:if>
            <c:if test="${not empty error}">
                <div class="alert alert-danger alert-dismissible fade show">
                    ${error}
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            </c:if>

            <div class="row">
                <div class="col-md-6">
                    <img src="${pageContext.request.contextPath}${product.imagePath}" 
     class="img-fluid rounded" alt="${product.name}" style="max-height: 500px; width: 100%; object-fit: contain;">
                </div>
                <div class="col-md-6">
                    <h1>${product.name}</h1>
                    <p class="text-muted">${product.categoryName}</p>
                    <p class="lead">$${product.price}</p>

                    <form action="${pageContext.request.contextPath}/cart/add" method="post">
                        <input type="hidden" name="productId" value="${product.productId}">

                        <div class="mb-3">
                            <label for="size" class="form-label">Size:</label>
                            <select class="form-select" id="size" name="size" required>
                                <option value="" selected disabled>Select size</option>
                                <c:forEach items="${product.sizes}" var="size">
                                    <option value="${size}">${size}</option>
                                </c:forEach>
                            </select>
                        </div>

                        <div class="mb-3">
                            <label for="quantity" class="form-label">Quantity:</label>
                            <input type="number" class="form-control" id="quantity" name="quantity" 
                                   min="1" max="${product.stockQuantity}" value="1" required>
                        </div>

                        <div class="d-grid gap-2 d-md-flex">
                            <button type="submit" class="btn btn-primary me-md-2" 
                                    ${product.stockQuantity <= 0 ? 'disabled' : ''}>
                                Add to Cart
                            </button>
                            <a href="${pageContext.request.contextPath}/cart" class="btn btn-outline-secondary">View Cart</a>
                        </div>
                    </form>

                    <hr>

                    <h4>Product Details</h4>
                    <p>${product.description}</p>

                    <div class="alert ${product.stockQuantity > 0 ? 'alert-success' : 'alert-danger'} mt-3">
                        <strong>Availability:</strong> 
                        <c:choose>
                            <c:when test="${product.stockQuantity > 0}">
                                In Stock (${product.stockQuantity} available)
                            </c:when>
                            <c:otherwise>
                                Out of Stock
                            </c:otherwise>
                        </c:choose>
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
                    <p>&copy; 2023 ShoeCart. All rights reserved.</p>
                </div>
            </div>
        </footer>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>