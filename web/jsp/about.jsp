<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>ShoeCart - About Us</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
        <link href="https://fonts.googleapis.com/css2?family=Bungee&family=Poppins:wght@400;500;600;700&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">
        <style>
            .about-hero {
                background: linear-gradient(rgba(0,0,0,0.7), rgba(0,0,0,0.7)), 
                    url('${pageContext.request.contextPath}/assets/images/about-bg.jpg');
                background-size: cover;
                background-position: center;
                color: white;
                padding: 5rem 0;
                margin-bottom: 3rem;
            }
            .team-member img {
                width: 150px;
                height: 150px;
                object-fit: cover;
                border-radius: 50%;
                border: 5px solid #f8f9fa;
            }
            .contact-hero {
                --hero-image: url('${pageContext.request.contextPath}/assets/images/contact-bg.jpg');
            }
            .about-hero {
                --hero-image: url('${pageContext.request.contextPath}/assets/images/about-bg.jpg');
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
                            <a class="nav-link" href="${pageContext.request.contextPath}/jsp/home.jsp">Home</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="${pageContext.request.contextPath}/products">Products</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link active" href="${pageContext.request.contextPath}/jsp/about.jsp">About</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="${pageContext.request.contextPath}/jsp/contact.jsp">Contact</a>
                        </li>
                    </ul>
                    <ul class="navbar-nav">
                        <c:choose>

                            <li class="nav-item">
                                <a class="nav-link" href="${pageContext.request.contextPath}/cart">
                                    <i class="bi bi-cart"></i> Cart
                                </a>
                            </li>
                            </c:when>

                        </c:choose>
                    </ul>
                </div>
            </div>
        </nav>

        <div class="about-hero text-center">
            <div class="container">
                <h1 class="display-4 fw-bold">About ShoeCart</h1>
                <p class="lead">Your journey to perfect footwear starts here</p>
            </div>
        </div>

        <main class="container my-5">
            <section class="mb-5">
                <div class="row">
                    <div class="col-lg-6">
                        <h2 class="mb-4">Our Story</h2>
                        <p class="lead">Founded in 2010, ShoeCart began as a small boutique shoe store with a passion for quality footwear.</p>
                        <p>Today, we've grown into one of the leading online shoe retailers, offering a carefully curated selection of footwear for every occasion. Our mission is to provide exceptional comfort, style, and quality in every pair we sell.</p>
                        <p>We believe that the right pair of shoes can transform your day, your outfit, and even your confidence. That's why we meticulously select each product in our collection.</p>
                    </div>
                    <div class="col-lg-6">
                        <img src="${pageContext.request.contextPath}/assets/images/store.jpg" alt="Our Store" class="img-fluid rounded shadow">
                    </div>
                </div>
            </section>

            <section class="mb-5">
                <h2 class="text-center mb-5">Why Choose ShoeCart?</h2>
                <div class="row g-4">
                    <div class="col-md-4">
                        <div class="card h-100 border-0 shadow-sm">
                            <div class="card-body text-center">
                                <i class="bi bi-stars fs-1 text-primary mb-3"></i>
                                <h5>Premium Quality</h5>
                                <p>We source only the highest quality materials and work with reputable manufacturers.</p>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="card h-100 border-0 shadow-sm">
                            <div class="card-body text-center">
                                <i class="bi bi-truck fs-1 text-primary mb-3"></i>
                                <h5>Fast Shipping</h5>
                                <p>Get your orders delivered quickly with our reliable shipping partners.</p>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="card h-100 border-0 shadow-sm">
                            <div class="card-body text-center">
                                <i class="bi bi-arrow-repeat fs-1 text-primary mb-3"></i>
                                <h5>Easy Returns</h5>
                                <p>Not satisfied? Our hassle-free return policy has you covered.</p>
                            </div>
                        </div>
                    </div>
                </div>
            </section>

            <section class="mb-5">
                <h2 class="text-center mb-5">Meet Our Team</h2>
                <div class="row g-4 justify-content-center">
                    <div class="col-md-4 col-lg-3 text-center">
                        <div class="team-member">
                            <img src="${pageContext.request.contextPath}/assets/images/team1.jpg" alt="Team Member" class="mb-3">
                            <h5>Sarah Johnson</h5>
                            <p class="text-muted">Founder & CEO</p>
                        </div>
                    </div>
                    <div class="col-md-4 col-lg-3 text-center">
                        <div class="team-member">
                            <img src="${pageContext.request.contextPath}/assets/images/team2.jpg" alt="Team Member" class="mb-3">
                            <h5>Michael Chen</h5>
                            <p class="text-muted">Head of Operations</p>
                        </div>
                    </div>
                    <div class="col-md-4 col-lg-3 text-center">
                        <div class="team-member">
                            <img src="${pageContext.request.contextPath}/assets/images/team3.jpg" alt="Team Member" class="mb-3">
                            <h5>Emily Rodriguez</h5>
                            <p class="text-muted">Customer Experience</p>
                        </div>
                    </div>
                </div>
            </section>
        </main>

        <footer class="bg-dark text-white py-4">
            <div class="container text-center">
                <p>&copy; 2023 ShoeCart. All rights reserved.</p>
                <div class="social-links">
                    <a href="#" class="text-white mx-2"><i class="bi bi-facebook"></i></a>
                    <a href="#" class="text-white mx-2"><i class="bi bi-twitter"></i></a>
                    <a href="#" class="text-white mx-2"><i class="bi bi-instagram"></i></a>
                </div>
            </div>
        </footer>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>