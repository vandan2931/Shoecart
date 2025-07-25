<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>ShoeCart - Home</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
        <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&family=Bungee&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">
    </head>
    <body>
        <nav class="navbar navbar-expand-lg navbar-light bg-white sticky-top shadow-sm">
            <div class="container">
                <a class="navbar-brand fw-bold" href="${pageContext.request.contextPath}/jsp/home.jsp">
                    <i class="bi bi-shop-window me-2"></i> ShoeCart
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
                                        <i class="bi bi-person-circle me-1"></i> ${user.name}
                                    </a>
                                    <ul class="dropdown-menu">
                                        <li><a class="dropdown-item" href="${pageContext.request.contextPath}/profile"><i class="bi bi-person me-2"></i>Profile</a></li>
                                        <li><a class="dropdown-item" href="${pageContext.request.contextPath}/orders"><i class="bi bi-bag me-2"></i>Orders</a></li>
                                        <li><hr class="dropdown-divider"></li>
                                        <li><a class="dropdown-item" href="${pageContext.request.contextPath}/logout"><i class="bi bi-box-arrow-right me-2"></i>Logout</a></li>
                                    </ul>
                                </li>
                                <li class="nav-item">
                                    <a class="nav-link position-relative" href="${pageContext.request.contextPath}/cart">
                                        <i class="bi bi-cart3"></i> Cart
                                        <span class="position-absolute top-0 start-100 translate-middle badge rounded-pill bg-danger">
                                            3
                                        </span>
                                    </a>
                                </li>
                            </c:when>
                            <c:otherwise>
                                <li class="nav-item">
                                    <a class="nav-link" href="${pageContext.request.contextPath}/login"><i class="bi bi-box-arrow-in-right me-1"></i>Login</a>
                                </li>
                                <li class="nav-item">
                                    <a class="nav-link" href="${pageContext.request.contextPath}/register"><i class="bi bi-person-plus me-1"></i>Register</a>
                                </li>
                            </c:otherwise>
                        </c:choose>
                    </ul>
                </div>
            </div>
        </nav>

        <div class="promo-banner bg-primary text-white py-2">
            <div class="container">
                <div class="d-flex justify-content-between align-items-center">
                    <p class="mb-0">
                        <i class="bi bi-truck"></i> Free shipping on orders over $100 | <strong>Summer Sale:</strong> 20% off selected items
                    </p>
                    <a href="${pageContext.request.contextPath}/products?promo=summer" class="text-white fw-bold">Shop Now <i class="bi bi-arrow-right"></i></a>
                </div>
            </div>
        </div>

        <main class="container my-5">
            <section class="hero-section mb-5">
                <div class="row align-items-center g-5">
                    <div class="col-lg-6">
                        <h1 class="display-4 fw-bold mb-4">Step into Style</h1>
                        <p class="lead mb-4">Discover the perfect pair of shoes for every occasion in our exclusive collection. Quality footwear for every step of your journey.</p>
                        <div class="d-flex gap-3">
                            <a href="${pageContext.request.contextPath}/products" class="btn btn-primary btn-lg px-4">Shop Now</a>
                            <a href="#featured-products" class="btn btn-outline-primary btn-lg px-4">Featured</a>
                        </div>
                        <div class="d-flex gap-4 mt-4">
                            <div>
                                <h4 class="fw-bold mb-0">10K+</h4>
                                <p class="text-muted mb-0">Happy Customers</p>
                            </div>
                            <div>
                                <h4 class="fw-bold mb-0">500+</h4>
                                <p class="text-muted mb-0">Products</p>
                            </div>
                            <div>
                                <h4 class="fw-bold mb-0">24/7</h4>
                                <p class="text-muted mb-0">Support</p>
                            </div>
                        </div>
                    </div>
                    <div class="col-lg-6">
                        <img src="${pageContext.request.contextPath}/assets/images/hero-shoes.jpg" alt="Featured Shoes" class="img-fluid rounded-3 shadow-lg hero-image">
                    </div>
                </div>
            </section>

            <section class="brands-section mb-5 py-4">
                <div class="container">
                    <div class="row g-4 justify-content-center">
                        <div class="col-auto text-center">
                            <img src="${pageContext.request.contextPath}/assets/images/brand1.png" alt="Brand Logo" class="img-fluid brand-logo" style="height: 40px;">
                        </div>
                        <div class="col-auto text-center">
                            <img src="${pageContext.request.contextPath}/assets/images/brand2.png" alt="Brand Logo" class="img-fluid brand-logo" style="height: 40px;">
                        </div>
                        <div class="col-auto text-center">
                            <img src="${pageContext.request.contextPath}/assets/images/brand3.png" alt="Brand Logo" class="img-fluid brand-logo" style="height: 40px;">
                        </div>
                        <div class="col-auto text-center">
                            <img src="${pageContext.request.contextPath}/assets/images/brand4.png" alt="Brand Logo" class="img-fluid brand-logo" style="height: 40px;">
                        </div>
                        <div class="col-auto text-center">
                            <img src="${pageContext.request.contextPath}/assets/images/brand5.png" alt="Brand Logo" class="img-fluid brand-logo" style="height: 40px;">
                        </div>
                    </div>
                </div>
            </section>

            <section id="featured-products" class="featured-products mb-5">
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <h2 class="mb-0">Featured Products</h2>
                    <a href="${pageContext.request.contextPath}/products" class="btn btn-sm btn-outline-primary">View All</a>
                </div>
                <div class="row g-4">
                    <div class="col-md-6 col-lg-4 col-xl-3">
                        <div class="card h-100 product-card">
                            <div class="badge bg-danger position-absolute" style="top: 0.5rem; right: 0.5rem">Sale</div>
                            <img src="${pageContext.request.contextPath}/assets/images/product1.jpg" class="card-img-top" alt="Running Shoes">
                            <div class="card-body">
                                <div class="d-flex justify-content-between mb-2">
                                    <span class="text-muted">Running</span>
                                    <div class="star-rating">
                                        <i class="bi bi-star-fill text-warning"></i>
                                        <i class="bi bi-star-fill text-warning"></i>
                                        <i class="bi bi-star-fill text-warning"></i>
                                        <i class="bi bi-star-fill text-warning"></i>
                                        <i class="bi bi-star-half text-warning"></i>
                                        <span class="ms-1 small">(42)</span>
                                    </div>
                                </div>
                                <h5 class="card-title">Air Runner Pro</h5>
                                <p class="card-text text-muted">Lightweight running shoes with advanced cushioning technology for maximum comfort.</p>
                                <div class="d-flex justify-content-between align-items-center mt-auto">
                                    <div>
                                        <span class="text-decoration-line-through text-muted me-2">$140.00</span>
                                        <span class="fw-bold text-primary">$120.00</span>
                                    </div>
                                    <a href="${pageContext.request.contextPath}/product?id=1" class="btn btn-sm btn-outline-primary">View</a>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-6 col-lg-4 col-xl-3">
                        <div class="card h-100 product-card">
                            <img src="${pageContext.request.contextPath}/assets/images/product2.jpg" class="card-img-top" alt="Casual Shoes">
                            <div class="card-body">
                                <div class="d-flex justify-content-between mb-2">
                                    <span class="text-muted">Casual</span>
                                    <div class="star-rating">
                                        <i class="bi bi-star-fill text-warning"></i>
                                        <i class="bi bi-star-fill text-warning"></i>
                                        <i class="bi bi-star-fill text-warning"></i>
                                        <i class="bi bi-star-fill text-warning"></i>
                                        <i class="bi bi-star text-warning"></i>
                                        <span class="ms-1 small">(28)</span>
                                    </div>
                                </div>
                                <h5 class="card-title">Urban Walker</h5>
                                <p class="card-text text-muted">Comfortable and stylish shoes perfect for everyday wear in the city.</p>
                                <div class="d-flex justify-content-between align-items-center mt-auto">
                                    <span class="fw-bold text-primary">$80.00</span>
                                    <a href="${pageContext.request.contextPath}/product?id=2" class="btn btn-sm btn-outline-primary">View</a>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-6 col-lg-4 col-xl-3">
                        <div class="card h-100 product-card">
                            <div class="badge bg-success position-absolute" style="top: 0.5rem; right: 0.5rem">New</div>
                            <img src="${pageContext.request.contextPath}/assets/images/product3.jpg" class="card-img-top" alt="Basketball Shoes">
                            <div class="card-body">
                                <div class="d-flex justify-content-between mb-2">
                                    <span class="text-muted">Basketball</span>
                                    <div class="star-rating">
                                        <i class="bi bi-star-fill text-warning"></i>
                                        <i class="bi bi-star-fill text-warning"></i>
                                        <i class="bi bi-star-fill text-warning"></i>
                                        <i class="bi bi-star-fill text-warning"></i>
                                        <i class="bi bi-star-fill text-warning"></i>
                                        <span class="ms-1 small">(56)</span>
                                    </div>
                                </div>
                                <h5 class="card-title">Basketball Elite</h5>
                                <p class="card-text text-muted">High-performance basketball shoes with superior ankle support and grip.</p>
                                <div class="d-flex justify-content-between align-items-center mt-auto">
                                    <span class="fw-bold text-primary">$150.00</span>
                                    <a href="${pageContext.request.contextPath}/product?id=3" class="btn btn-sm btn-outline-primary">View</a>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-6 col-lg-4 col-xl-3">
                        <div class="card h-100 product-card">
                            <div class="badge bg-info position-absolute" style="top: 0.5rem; right: 0.5rem">Popular</div>
                            <img src="${pageContext.request.contextPath}/assets/images/product4.jpg" class="card-img-top" alt="Hiking Shoes">
                            <div class="card-body">
                                <div class="d-flex justify-content-between mb-2">
                                    <span class="text-muted">Hiking</span>
                                    <div class="star-rating">
                                        <i class="bi bi-star-fill text-warning"></i>
                                        <i class="bi bi-star-fill text-warning"></i>
                                        <i class="bi bi-star-fill text-warning"></i>
                                        <i class="bi bi-star-fill text-warning"></i>
                                        <i class="bi bi-star-half text-warning"></i>
                                        <span class="ms-1 small">(37)</span>
                                    </div>
                                </div>
                                <h5 class="card-title">Trail Master</h5>
                                <p class="card-text text-muted">Durable hiking shoes with waterproof membrane and rugged outsole.</p>
                                <div class="d-flex justify-content-between align-items-center mt-auto">
                                    <span class="fw-bold text-primary">$110.00</span>
                                    <a href="${pageContext.request.contextPath}/product?id=4" class="btn btn-sm btn-outline-primary">View</a>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </section>

            <section class="cta-section mb-5 py-5 bg-light rounded-3">
                <div class="container text-center py-4">
                    <h2 class="mb-4">Join Our Shoe Lovers Community</h2>
                    <p class="lead mb-4">Subscribe to get exclusive offers, new arrivals and style tips</p>
                    <div class="row justify-content-center">
                        <div class="col-md-6">
                            <form class="input-group">
                                <input type="email" class="form-control" placeholder="Your email address">
                                <button class="btn btn-primary" type="submit">Subscribe</button>
                            </form>
                        </div>
                    </div>
                </div>
            </section>
        </main>

        <footer class="bg-dark text-white pt-5 pb-4">
            <div class="container">
                <div class="row g-4">
                    <div class="col-lg-3 col-md-6">
                        <h5 class="text-uppercase mb-4"><i class="bi bi-shop-window me-2"></i> ShoeCart</h5>
                        <p>Your one-stop shop for the latest and greatest in footwear fashion. Quality shoes for every occasion.</p>
                        <div class="social-icons mt-3">
                            <a href="#" class="text-white me-3"><i class="bi bi-facebook"></i></a>
                            <a href="#" class="text-white me-3"><i class="bi bi-twitter"></i></a>
                            <a href="#" class="text-white me-3"><i class="bi bi-instagram"></i></a>
                            <a href="#" class="text-white"><i class="bi bi-pinterest"></i></a>
                        </div>
                    </div>
                    <div class="col-lg-3 col-md-6">
                        <h5 class="text-uppercase mb-4">Quick Links</h5>
                        <ul class="list-unstyled">
                            <li class="mb-2"><a href="${pageContext.request.contextPath}/home" class="text-white text-decoration-none">Home</a></li>
                            <li class="mb-2"><a href="${pageContext.request.contextPath}/products" class="text-white text-decoration-none">Products</a></li>
                            <li class="mb-2"><a href="${pageContext.request.contextPath}/about" class="text-white text-decoration-none">About Us</a></li>
                            <li class="mb-2"><a href="${pageContext.request.contextPath}/contact" class="text-white text-decoration-none">Contact</a></li>
                            <li class="mb-2"><a href="${pageContext.request.contextPath}/faq" class="text-white text-decoration-none">FAQs</a></li>
                        </ul>
                    </div>
                    <div class="col-lg-3 col-md-6">
                        <h5 class="text-uppercase mb-4">Customer Service</h5>
                        <ul class="list-unstyled">
                            <li class="mb-2"><a href="${pageContext.request.contextPath}/shipping" class="text-white text-decoration-none">Shipping Policy</a></li>
                            <li class="mb-2"><a href="${pageContext.request.contextPath}/returns" class="text-white text-decoration-none">Returns & Exchanges</a></li>
                            <li class="mb-2"><a href="${pageContext.request.contextPath}/size-guide" class="text-white text-decoration-none">Size Guide</a></li>
                            <li class="mb-2"><a href="${pageContext.request.contextPath}/privacy" class="text-white text-decoration-none">Privacy Policy</a></li>
                            <li class="mb-2"><a href="${pageContext.request.contextPath}/terms" class="text-white text-decoration-none">Terms of Service</a></li>
                        </ul>
                    </div>
                    <div class="col-lg-3 col-md-6">
                        <h5 class="text-uppercase mb-4">Contact Us</h5>
                        <address>
                            <p><i class="bi bi-geo-alt-fill me-2"></i> 123 Shoe Street, Footwear City, 12345</p>
                            <p><i class="bi bi-envelope-fill me-2"></i> info@shoecart.com</p>
                            <p><i class="bi bi-telephone-fill me-2"></i> (123) 456-7890</p>
                        </address>
                        <h6 class="text-uppercase mb-3">Payment Methods</h6>
                        <div class="payment-methods">
                            <i class="bi bi-credit-card me-2"></i>
                            <i class="bi bi-paypal me-2"></i>
                            <i class="bi bi-currency-bitcoin me-2"></i>
                            <i class="bi bi-bank me-2"></i>
                        </div>
                    </div>
                </div>
                <hr class="mt-4 mb-3">
                <div class="row">
                    <div class="col-md-6 text-center text-md-start">
                        <p class="mb-0">&copy; 2025 ShoeCart. All rights reserved.</p>
                    </div>
                    <div class="col-md-6 text-center text-md-end">
                        <p class="mb-0">Designed with <i class="bi bi-heart-fill text-danger"></i> by ShoeCart Team</p>
                    </div>
                </div>
            </div>
        </footer>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/script.js"></script>
    </body>
</html>