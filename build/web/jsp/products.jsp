<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>ShoeCart - Products</title>
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
                            <a class="nav-link active" href="${pageContext.request.contextPath}/products">Products</a>
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

            <div class="row mb-4">
                <div class="col-md-6">
                    <h1>Our Products</h1>
                    <c:if test="${not empty searchTerm}">
                        <!--<p class="text-muted">Showing results for: "${searchTerm}"</p>-->
                    </c:if>
                </div>
                <div class="col-md-6">
                    <div class="d-flex justify-content-end gap-2">

                        <div class="dropdown">
                            <button class="btn btn-secondary dropdown-toggle" type="button" id="categoryDropdown" 
                                    data-bs-toggle="dropdown" aria-expanded="false">
                                Filter by Category
                            </button>
                            <ul class="dropdown-menu" aria-labelledby="categoryDropdown">
                                <li><a class="dropdown-item" href="${pageContext.request.contextPath}/products">All Categories</a></li>
                                <li><hr class="dropdown-divider"></li>
                                <li><a class="dropdown-item" href="${pageContext.request.contextPath}/products?category=1">Running</a></li>
                                <li><a class="dropdown-item" href="${pageContext.request.contextPath}/products?category=2">Casual</a></li>
                                <li><a class="dropdown-item" href="${pageContext.request.contextPath}/products?category=3">Sports</a></li>
                                <li><a class="dropdown-item" href="${pageContext.request.contextPath}/products?category=4">Formal</a></li>
                            </ul>
                        </div>
                    </div>
                </div>
            </div>

            <c:choose>
                <c:when test="${not empty products && !products.isEmpty()}">
                    <div class="row">
                        <c:forEach items="${products}" var="product">
                            <div class="col-md-4 mb-4">
                                <div class="card h-100">
                                    <img src="${pageContext.request.contextPath}${product.imagePath}" 
                                         class="card-img-top" alt="${product.name}" 
                                         style="height: 200px; object-fit: cover;">
                                    <div class="card-body">
                                        <h5 class="card-title">${product.name}</h5>
                                        <p class="text-muted">${product.categoryName}</p>
                                        <p class="card-text">${product.description.length() > 100 ? 
                                                               product.description.substring(0, 100) + '...' : product.description}</p>
                                        <div class="d-flex justify-content-between align-items-center">
                                            <span class="fw-bold">$${product.price}</span>
                                            <a href="${pageContext.request.contextPath}/product?id=${product.productId}" 
                                               class="btn btn-sm btn-outline-primary">View Details</a>
                                        </div>
                                    </div>
                                    <div class="card-footer bg-transparent">
                                        <small class="text-muted">
                                            <c:choose>
                                                <c:when test="${product.stockQuantity > 0}">
                                                    <span class="text-success">In Stock (${product.stockQuantity} available)</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="text-danger">Out of Stock</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </small>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </div>

                    <c:if test="${empty searchTerm}">
                        <nav aria-label="Page navigation" class="mt-4">
                            <ul class="pagination justify-content-center">
                                <c:if test="${currentPage > 1}">
                                    <li class="page-item">
                                        <a class="page-link" 
                                           href="${pageContext.request.contextPath}/products?page=${currentPage - 1}<c:if test="${not empty param.category}">&category=${param.category}</c:if>" 
                                               aria-label="Previous">
                                               <span aria-hidden="true">&laquo;</span>
                                           </a>
                                        </li>
                                </c:if>

                                <c:forEach begin="1" end="${totalPages}" var="i">
                                    <li class="page-item ${i == currentPage ? 'active' : ''}">
                                        <a class="page-link" 
                                           href="${pageContext.request.contextPath}/products?page=${i}<c:if test="${not empty param.category}">&category=${param.category}</c:if>">
                                            ${i}
                                        </a>
                                    </li>
                                </c:forEach>

                                <c:if test="${currentPage < totalPages}">
                                    <li class="page-item">
                                        <a class="page-link" 
                                           href="${pageContext.request.contextPath}/products?page=${currentPage + 1}<c:if test="${not empty param.category}">&category=${param.category}</c:if>" 
                                               aria-label="Next">
                                               <span aria-hidden="true">&raquo;</span>
                                           </a>
                                        </li>
                                </c:if>
                            </ul>
                        </nav>
                    </c:if>
                </c:when>
                <c:otherwise>
                    <div class="alert alert-info text-center">
                        <h4 class="alert-heading">No Products Found</h4>
                        <p>We couldn't find any products matching your criteria.</p>
                        <c:if test="${not empty error}">
                            <div class="mt-2 text-danger">
                                <strong>Error:</strong> ${error}
                            </div>
                        </c:if>
                        <a href="${pageContext.request.contextPath}/products" class="btn btn-primary mt-2">Browse All Products</a>
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