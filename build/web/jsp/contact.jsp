<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>ShoeCart - Contact Us</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
        <link href="https://fonts.googleapis.com/css2?family=Bungee&family=Poppins:wght@400;500;600;700&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">
        <style>
            .contact-hero {
                background: linear-gradient(rgba(0,0,0,0.7), rgba(0,0,0,0.7)), 
                    url('${pageContext.request.contextPath}/assets/images/contact-bg.jpg');
                background-size: cover;
                background-position: center;
                color: white;
                padding: 5rem 0;
                margin-bottom: 3rem;
            }
            .contact-info i {
                font-size: 1.5rem;
                margin-right: 1rem;
                color: #0d6efd;
            }
            .contact-form .form-control {
                border-radius: 0;
                padding: 10px 15px;
            }
            .contact-form textarea {
                min-height: 150px;
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
                            <a class="nav-link" href="${pageContext.request.contextPath}/jsp/about.jsp">About</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link active" href="${pageContext.request.contextPath}/jsp/contact.jsp">Contact</a>
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

        <div class="contact-hero text-center">
            <div class="container">
                <h1 class="display-4 fw-bold">Contact Us</h1>
                <p class="lead">We'd love to hear from you</p>
            </div>
        </div>

        <main class="container my-5">
            <div class="row g-5">
                <div class="col-lg-6">
                    <h2 class="mb-4">Get In Touch</h2>
                    <p class="lead">Have questions about our products or need assistance with your order? Reach out to us!</p>

                    <div class="contact-info mt-5">
                        <div class="d-flex align-items-start mb-4">
                            <i class="bi bi-geo-alt-fill"></i>
                            <div>
                                <h5>Our Location</h5>
                                <p class="mb-0">123 Shoe Street, Footwear City, FC 12345</p>
                            </div>
                        </div>

                        <div class="d-flex align-items-start mb-4">
                            <i class="bi bi-telephone-fill"></i>
                            <div>
                                <h5>Phone</h5>
                                <p class="mb-0">+1 (555) 123-4567</p>
                                <p class="mb-0">Mon-Fri: 9am-6pm EST</p>
                            </div>
                        </div>

                        <div class="d-flex align-items-start mb-4">
                            <i class="bi bi-envelope-fill"></i>
                            <div>
                                <h5>Email</h5>
                                <p class="mb-0">info@shoecart.com</p>
                                <p class="mb-0">support@shoecart.com</p>
                            </div>
                        </div>
                    </div>

                    <div class="mt-5">
                        <h5>Follow Us</h5>
                        <div class="social-links">
                            <a href="#" class="btn btn-outline-primary btn-sm rounded-circle me-2"><i class="bi bi-facebook"></i></a>
                            <a href="#" class="btn btn-outline-primary btn-sm rounded-circle me-2"><i class="bi bi-twitter"></i></a>
                            <a href="#" class="btn btn-outline-primary btn-sm rounded-circle me-2"><i class="bi bi-instagram"></i></a>
                            <a href="#" class="btn btn-outline-primary btn-sm rounded-circle"><i class="bi bi-linkedin"></i></a>
                        </div>
                    </div>
                </div>

                <div class="col-lg-6">
                    <div class="card shadow-sm">
                        <div class="card-body p-4">
                            <h3 class="card-title mb-4">Send Us a Message</h3>
                            <form class="contact-form" action="${pageContext.request.contextPath}/contact/submit" method="post">
                                <div class="mb-3">
                                    <label for="name" class="form-label">Your Name</label>
                                    <input type="text" class="form-control" id="name" name="name" required>
                                </div>
                                <div class="mb-3">
                                    <label for="email" class="form-label">Email Address</label>
                                    <input type="email" class="form-control" id="email" name="email" required>
                                </div>
                                <div class="mb-3">
                                    <label for="subject" class="form-label">Subject</label>
                                    <input type="text" class="form-control" id="subject" name="subject" required>
                                </div>
                                <div class="mb-3">
                                    <label for="message" class="form-label">Message</label>
                                    <textarea class="form-control" id="message" name="message" required></textarea>
                                </div>
                                <button type="submit" class="btn btn-primary w-100 py-2">
                                    <i class="bi bi-send-fill me-2"></i> Send Message
                                </button>
                            </form>
                        </div>
                    </div>
                </div>
            </div>

            <div class="my-5">
                <div class="ratio ratio-16x9">
                    <iframe src="https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d3022.2155732912346!2d-73.98784492416476!3d40.74844097138939!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x89c259a9b3117469%3A0xd134e199a405a163!2sEmpire%20State%20Building!5e0!3m2!1sen!2sus!4v1689876423581!5m2!1sen!2sus" 
                            width="600" height="450" style="border:0;" allowfullscreen="" loading="lazy" referrerpolicy="no-referrer-when-downgrade"></iframe>
                </div>
            </div>
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