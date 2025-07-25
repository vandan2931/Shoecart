<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>ShoeCart - Checkout</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/checkout-order.css">
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
            <div class="row">
                <div class="col-lg-8">
                    <div class="card mb-4">
                        <div class="card-header bg-primary text-white">
                            <h3 class="mb-0"><i class="bi bi-cart-check"></i> Checkout</h3>
                        </div>

                        <c:if test="${not empty error}">
                            <div class="alert alert-danger alert-dismissible fade show m-3">
                                ${error}
                                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                            </div>
                        </c:if>

                        <div class="card-body">
                            <form id="checkoutForm" action="${pageContext.request.contextPath}/checkout/process" method="post">
                                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>

                                <h4 class="mb-3"><i class="bi bi-truck"></i> Shipping Information</h4>
                                <div class="mb-3">
                                    <label for="shippingAddress" class="form-label">Shipping Address</label>
                                    <textarea class="form-control" id="shippingAddress" name="shippingAddress" 
                                              rows="3" required minlength="10">${param.shippingAddress}</textarea>
                                    <div class="invalid-feedback">Please enter a valid shipping address (at least 10 characters).</div>
                                </div>

                                <hr class="my-4">

                                <h4 class="mb-3"><i class="bi bi-credit-card"></i> Payment Method</h4>
                                <div class="form-check mb-3">
                                    <input class="form-check-input" type="radio" name="paymentMethod" 
                                           id="creditCard" value="credit_card" checked required>
                                    <label class="form-check-label" for="creditCard">
                                        Credit Card
                                    </label>
                                </div>

                                <div id="creditCardForm" class="ps-4">
                                    <div class="row g-3">
                                        <div class="col-12">
                                            <label for="cardNumber" class="form-label">Card Number</label>
                                            <input type="text" class="form-control" id="cardNumber" name="cardNumber" 
                                                   placeholder="4242 4242 4242 4242" required
                                                   pattern="\d{4}\s?\d{4}\s?\d{4}\s?\d{4}"
                                                   value="${param.cardNumber}">
                                            <small class="text-muted">Use test card: 4242 4242 4242 4242</small>
                                            <div class="invalid-feedback">Please enter a valid 16-digit card number.</div>
                                        </div>
                                        <div class="col-md-6">
                                            <label for="cardExpiry" class="form-label">Expiration Date</label>
                                            <input type="text" class="form-control" id="cardExpiry" name="cardExpiry" 
                                                   placeholder="12/25" required
                                                   pattern="(0[1-9]|1[0-2])\/[0-9]{2}"
                                                   value="${param.cardExpiry}">
                                            <small class="text-muted">Use test expiry: 12/25</small>
                                            <div class="invalid-feedback">Please enter a valid expiration date (MM/YY).</div>
                                        </div>
                                        <div class="col-md-6">
                                            <label for="cardCvv" class="form-label">CVV</label>
                                            <input type="text" class="form-control" id="cardCvv" name="cardCvv" 
                                                   placeholder="123" required
                                                   pattern="\d{3,4}"
                                                   value="${param.cardCvv}">
                                            <small class="text-muted">Use test CVV: 123</small>
                                            <div class="invalid-feedback">Please enter a valid CVV (3 or 4 digits).</div>
                                        </div>
                                    </div>
                                </div>

                                <hr class="my-4">

                                <button type="submit" class="btn btn-primary btn-lg w-100 py-3">
                                    <span id="submitText">Complete Order</span>
                                    <span id="spinner" class="spinner-border spinner-border-sm d-none" role="status"></span>
                                </button>
                            </form>
                        </div>
                    </div>
                </div>

                <div class="col-lg-4">
                    <div class="card">
                        <div class="card-header bg-light">
                            <h4 class="mb-0"><i class="bi bi-receipt"></i> Order Summary</h4>
                        </div>
                        <div class="card-body">
                            <ul class="list-group list-group-flush mb-3">
                                <c:forEach items="${cart.items}" var="item">
                                    <li class="list-group-item d-flex justify-content-between align-items-start">
                                        <div>
                                            <h6 class="my-0">${item.name} (${item.size})</h6>
                                            <small class="text-muted">Qty: ${item.quantity}</small>
                                        </div>
                                        <span class="text-primary">$${item.price * item.quantity}</span>
                                    </li>
                                </c:forEach>

                                <li class="list-group-item d-flex justify-content-between bg-light">
                                    <span>Subtotal</span>
                                    <strong>$${cart.total}</strong>
                                </li>
                                <li class="list-group-item d-flex justify-content-between bg-light">
                                    <span>Shipping</span>
                                    <strong>Free</strong>
                                </li>
                                <li class="list-group-item d-flex justify-content-between">
                                    <span class="h5">Total</span>
                                    <span class="h5 text-primary">$${cart.total}</span>
                                </li>
                            </ul>
                        </div>
                    </div>
                </div>
            </div>
        </main>
        <footer class="bg-dark text-white py-4">
            <div class="container">
                <div class="row">
                    <div class="col-md-4">
                        <h5>About ShoeCart</h5>
                        <p>Your one-stop shop for the latest and greatest in footwear fashion.</p>
                    </div>
                    <div class="col-md-4">
                        <h5>Quick Links</h5>
                        <ul class="list-unstyled">
                            <li><a href="${pageContext.request.contextPath}/home" class="text-white">Home</a></li>
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
        <script>
            // Enhanced form validation
            (function () {
                'use strict';

                const form = document.getElementById('checkoutForm');
                const cardNumber = document.getElementById('cardNumber');
                const cardExpiry = document.getElementById('cardExpiry');
                const cardCvv = document.getElementById('cardCvv');

                // Validate form on submit
                form.addEventListener('submit', function (e) {
                    if (!form.checkValidity()) {
                        e.preventDefault();
                        e.stopPropagation();
                    } else {
                        // Show loading spinner
                        document.getElementById('submitText').classList.add('d-none');
                        document.getElementById('spinner').classList.remove('d-none');
                    }

                    form.classList.add('was-validated');
                }, false);

                // Format card number as user types
                cardNumber.addEventListener('input', function (e) {
                    let value = e.target.value.replace(/\s+/g, '');
                    if (value.length > 0) {
                        value = value.match(new RegExp('.{1,4}', 'g')).join(' ');
                    }
                    e.target.value = value;

                    // Validate card number using Luhn algorithm
                    const isValid = /^\d{4}\s?\d{4}\s?\d{4}\s?\d{4}$/.test(value) &&
                            validateCardNumber(value.replace(/\s/g, ''));

                    if (value.length > 0) {
                        if (isValid) {
                            cardNumber.classList.remove('is-invalid');
                            cardNumber.classList.add('is-valid');
                        } else {
                            cardNumber.classList.remove('is-valid');
                            cardNumber.classList.add('is-invalid');
                        }
                    } else {
                        cardNumber.classList.remove('is-valid', 'is-invalid');
                    }
                });

                // Format expiry date as user types
                cardExpiry.addEventListener('input', function (e) {
                    let value = e.target.value.replace(/\D/g, '');
                    if (value.length > 2) {
                        value = value.substring(0, 2) + '/' + value.substring(2, 4);
                    }
                    e.target.value = value;

                    // Validate expiry date
                    const isValid = /^(0[1-9]|1[0-2])\/?([0-9]{2})$/.test(value) &&
                            validateExpiryDate(value);

                    if (value.length > 0) {
                        if (isValid) {
                            cardExpiry.classList.remove('is-invalid');
                            cardExpiry.classList.add('is-valid');
                        } else {
                            cardExpiry.classList.remove('is-valid');
                            cardExpiry.classList.add('is-invalid');
                        }
                    } else {
                        cardExpiry.classList.remove('is-valid', 'is-invalid');
                    }
                });

                // Validate CVV
                cardCvv.addEventListener('input', function (e) {
                    const value = e.target.value;
                    const isValid = /^\d{3,4}$/.test(value);

                    if (value.length > 0) {
                        if (isValid) {
                            cardCvv.classList.remove('is-invalid');
                            cardCvv.classList.add('is-valid');
                        } else {
                            cardCvv.classList.remove('is-valid');
                            cardCvv.classList.add('is-invalid');
                        }
                    } else {
                        cardCvv.classList.remove('is-valid', 'is-invalid');
                    }
                });

                // Luhn algorithm implementation for client-side validation
                function validateCardNumber(cardNumber) {
                    let sum = 0;
                    let alternate = false;
                    for (let i = cardNumber.length - 1; i >= 0; i--) {
                        let digit = parseInt(cardNumber.substring(i, i + 1));
                        if (alternate) {
                            digit *= 2;
                            if (digit > 9) {
                                digit = (digit % 10) + 1;
                            }
                        }
                        sum += digit;
                        alternate = !alternate;
                    }
                    return (sum % 10 === 0);
                }

                // Expiry date validation
                function validateExpiryDate(expiry) {
                    const parts = expiry.split('/');
                    if (parts.length !== 2)
                        return false;

                    const month = parseInt(parts[0]);
                    const year = 2000 + parseInt(parts[1]);

                    if (month < 1 || month > 12)
                        return false;

                    const currentDate = new Date();
                    const currentMonth = currentDate.getMonth() + 1;
                    const currentYear = currentDate.getFullYear();

                    return (year > currentYear) || (year === currentYear && month >= currentMonth);
                }
            })();
        </script>
    </body>
</html>