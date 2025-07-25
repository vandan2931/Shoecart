<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>ShoeCart - Register</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/auth.css">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
        <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;500;600;700&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
        <style>
            body {
                background-color: #f8f9fa;
            }
            .card {
                border-radius: 15px;
                box-shadow: 0 6px 10px rgba(0, 0, 0, 0.08);
            }
            .form-control:focus {
                border-color: #6c757d;
                box-shadow: 0 0 0 0.25rem rgba(108, 117, 125, 0.25);
            }
            .btn-primary {
                background-color: #6c757d;
                border-color: #6c757d;
            }
            .btn-primary:hover {
                background-color: #5a6268;
                border-color: #545b62;
            }
            .password-strength {
                height: 5px;
                margin-top: 5px;
                border-radius: 5px;
            }
            .strength-0 {
                width: 20%;
                background-color: #dc3545;
            }
            .strength-1 {
                width: 40%;
                background-color: #fd7e14;
            }
            .strength-2 {
                width: 60%;
                background-color: #ffc107;
            }
            .strength-3 {
                width: 80%;
                background-color: #28a745;
            }
            .strength-4 {
                width: 100%;
                background-color: #28a745;
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

                            </c:otherwise>
                        </c:choose>
                    </ul>
                </div>
            </div>
        </nav>

        <main class="container my-5">
            <div class="row justify-content-center">
                <div class="col-md-8 col-lg-6">
                    <div class="card shadow">
                        <div class="card-body p-4">
                            <h2 class="card-title text-center mb-4">Create Account</h2>

                            <c:if test="${not empty error}">
                                <div class="alert alert-danger alert-dismissible fade show">
                                    ${error}
                                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                                </div>
                            </c:if>

                            <form id="registerForm" action="${pageContext.request.contextPath}/register" method="post">
                                <div class="row mb-3">
                                    <div class="col-md-6 mb-3 mb-md-0">
                                        <label for="name" class="form-label">Full Name</label>
                                        <div class="input-group">
                                            <span class="input-group-text"><i class="fas fa-user"></i></span>
                                            <input type="text" class="form-control" id="name" name="name" required>
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <label for="email" class="form-label">Email</label>
                                        <div class="input-group">
                                            <span class="input-group-text"><i class="fas fa-envelope"></i></span>
                                            <input type="email" class="form-control" id="email" name="email" required>
                                        </div>
                                    </div>
                                </div>

                                <div class="row mb-3">
                                    <div class="col-md-6 mb-3 mb-md-0">
                                        <label for="password" class="form-label">Password</label>
                                        <div class="input-group">
                                            <span class="input-group-text"><i class="fas fa-lock"></i></span>
                                            <input type="password" class="form-control" id="password" name="password" required>
                                        </div>
                                        <div id="password-strength" class="password-strength strength-0"></div>
                                        <small class="text-muted">Password must be at least 8 characters long</small>
                                    </div>
                                    <div class="col-md-6">
                                        <label for="confirmPassword" class="form-label">Confirm Password</label>
                                        <div class="input-group">
                                            <span class="input-group-text"><i class="fas fa-lock"></i></span>
                                            <input type="password" class="form-control" id="confirmPassword" name="confirmPassword" required>
                                        </div>
                                        <div id="password-match" class="text-danger small"></div>
                                    </div>
                                </div>



                                <div class="form-check mb-4">
                                    <input class="form-check-input" type="checkbox" id="terms" name="terms" required>
                                    <label class="form-check-label" for="terms">
                                        I agree to the <a href="#" data-bs-toggle="modal" data-bs-target="#termsModal">Terms and Conditions</a>
                                    </label>
                                </div>

                                <div class="d-grid gap-2">
                                    <button type="submit" class="btn btn-primary">
                                        <i class="fas fa-user-plus me-2"></i> Register
                                    </button>
                                </div>
                            </form>

                            <div class="mt-3 text-center">
                                <p>Already have an account? <a href="${pageContext.request.contextPath}/login">Login here</a></p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </main>

        <!-- Terms Modal -->
        <div class="modal fade" id="termsModal" tabindex="-1" aria-labelledby="termsModalLabel" aria-hidden="true">
            <div class="modal-dialog modal-lg">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="termsModalLabel">Terms and Conditions</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <h6>1. Acceptance of Terms</h6>
                        <p>By registering an account with ShoeCart, you agree to be bound by these Terms and Conditions.</p>

                        <h6>2. Account Registration</h6>
                        <p>You must provide accurate and complete information when creating an account.</p>

                        <h6>3. Privacy Policy</h6>
                        <p>Your personal information will be handled in accordance with our Privacy Policy.</p>

                        <h6>4. User Responsibilities</h6>
                        <p>You are responsible for maintaining the confidentiality of your account credentials.</p>

                        <h6>5. Changes to Terms</h6>
                        <p>We reserve the right to modify these terms at any time.</p>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                    </div>
                </div>
            </div>
        </div>

        <footer class="bg-dark text-white py-4 mt-5">
            <div class="container text-center">
                <p>&copy; 2023 ShoeCart. All rights reserved.</p>
            </div>
        </footer>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        <script>
            document.addEventListener('DOMContentLoaded', function () {
                const password = document.getElementById('password');
                const confirmPassword = document.getElementById('confirmPassword');
                const passwordStrength = document.getElementById('password-strength');
                const passwordMatch = document.getElementById('password-match');
                const registerForm = document.getElementById('registerForm');

                // Password strength indicator
                password.addEventListener('input', function () {
                    const strength = calculatePasswordStrength(password.value);
                    passwordStrength.className = 'password-strength strength-' + strength;
                });

                // Password confirmation check
                confirmPassword.addEventListener('input', function () {
                    if (password.value !== confirmPassword.value) {
                        passwordMatch.textContent = 'Passwords do not match';
                    } else {
                        passwordMatch.textContent = '';
                    }
                });

                // Form validation
                registerForm.addEventListener('submit', function (e) {
                    if (password.value !== confirmPassword.value) {
                        e.preventDefault();
                        passwordMatch.textContent = 'Passwords do not match';
                        confirmPassword.focus();
                    }

                    if (!document.getElementById('terms').checked) {
                        e.preventDefault();
                        alert('You must agree to the terms and conditions');
                    }
                });

                function calculatePasswordStrength(password) {
                    let strength = 0;

                    // Length check
                    if (password.length >= 8)
                        strength++;
                    if (password.length >= 12)
                        strength++;

                    // Character type checks
                    if (/[A-Z]/.test(password))
                        strength++;
                    if (/[0-9]/.test(password))
                        strength++;
                    if (/[^A-Za-z0-9]/.test(password))
                        strength++;

                    // Cap at 4 for our CSS classes
                    return Math.min(strength, 4);
                }
            });
        </script>
    </body>
</html>