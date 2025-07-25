package controller;

import dao.CartDAO;
import dao.OrderDAO;
import dao.ProductDAO;
import model.*;
import util.PaymentProcessor;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*;
import java.io.IOException;
import java.sql.*;
import java.util.*;
import java.util.logging.*;
import util.DBConnection;

@WebServlet(name = "CheckoutServlet", urlPatterns = {"/checkout", "/checkout/process"})
public class CheckoutServlet extends HttpServlet {

    private static final Logger logger = Logger.getLogger(CheckoutServlet.class.getName());
    private CartDAO cartDAO;
    private OrderDAO orderDAO;
    private ProductDAO productDAO;

    @Override
    public void init() throws ServletException {
        try {
            super.init();
            cartDAO = new CartDAO();
            orderDAO = new OrderDAO();
            productDAO = new ProductDAO();
            logger.info("CheckoutServlet initialized successfully");
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Failed to initialize CheckoutServlet", e);
            throw new ServletException("Failed to initialize CheckoutServlet", e);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        User user = (User) session.getAttribute("user");
        try {
            Cart cart = cartDAO.getCartByUserId(user.getUserId());
            if (cart == null || cart.getItems().isEmpty()) {
                session.setAttribute("error", "Your cart is empty");
                response.sendRedirect(request.getContextPath() + "/cart");
                return;
            }

            String validationError = validateCartItemsWithDetails(cart);
            if (validationError != null) {
                session.setAttribute("error", validationError);
                response.sendRedirect(request.getContextPath() + "/cart");
                return;
            }

            session.setAttribute("checkoutCart", cart);
            request.setAttribute("cart", cart);
            request.getRequestDispatcher("/jsp/checkout.jsp").forward(request, response);
        } catch (Exception e) {
            handleError(request, response, session, "Failed to load checkout page", e, "/cart");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        if (request.getServletPath().equals("/checkout/process")) {
            processCheckout(request, response, session);
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    private void processCheckout(HttpServletRequest request, HttpServletResponse response,
            HttpSession session) throws ServletException, IOException {
        User user = (User) session.getAttribute("user");
        Cart cart = null;
        String paymentTransactionId = null;

        try {
            // 1. Retrieve and validate cart
            cart = getOrValidateCart(user, session, request, response);
            if (cart == null) {
                return;
            }

            // 2. Validate parameters
            Map<String, String> params = validateCheckoutParameters(request);
            String paramError = getParameterValidationError(params);
            if (paramError != null) {
                session.setAttribute("checkoutCart", cart);
                session.setAttribute("error", paramError);
                response.sendRedirect(request.getContextPath() + "/checkout");
                return;
            }

            // 3. Process payment
            paymentTransactionId = processPayment(cart, params, user, session, request, response);
            if (paymentTransactionId == null) {
                return;
            }

            // 4. Create and process order
            Order order = createAndProcessOrder(user, cart, params, paymentTransactionId, session, request, response);
            if (order == null) {
                return;
            }

            // 5. Clear the cart from database and session
            clearUserCart(user, session);

            // 6. Finalize checkout
            finalizeCheckout(user, session, order, request, response);

        } catch (Exception e) {
            handleCheckoutError(e, paymentTransactionId, session, request, response);
        }
    }

    private void clearUserCart(User user, HttpSession session) {
        try {
            // Clear cart from database
            boolean cartCleared = cartDAO.clearCart(user.getUserId());
            if (!cartCleared) {
                logger.warning("Failed to clear cart for user: " + user.getUserId());
            }

            // Clear cart from session
            session.removeAttribute("cart");
            session.removeAttribute("checkoutCart");
            
            logger.info("Successfully cleared cart for user: " + user.getUserId());
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error clearing cart for user: " + user.getUserId(), e);
        }
    }

    private Cart getOrValidateCart(User user, HttpSession session, HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        Cart cart = (Cart) session.getAttribute("checkoutCart");
        if (cart == null) {
            cart = cartDAO.getCartByUserId(user.getUserId());
        }

        if (cart == null || cart.getItems().isEmpty()) {
            session.setAttribute("error", "Your cart is empty");
            response.sendRedirect(request.getContextPath() + "/cart");
            return null;
        }

        String validationError = validateCartItemsWithDetails(cart);
        if (validationError != null) {
            session.setAttribute("error", validationError);
            response.sendRedirect(request.getContextPath() + "/cart");
            return null;
        }

        return cart;
    }

    private String processPayment(Cart cart, Map<String, String> params, User user,
            HttpSession session, HttpServletRequest request, HttpServletResponse response) throws IOException {
        logger.info("Processing payment for user: " + user.getUserId());
        String paymentTransactionId = PaymentProcessor.processPayment(
                params.get("cardNumber"),
                params.get("cardExpiry"),
                params.get("cardCvv"),
                cart.getTotal()
        );

        if (paymentTransactionId == null) {
            session.setAttribute("checkoutCart", cart);
            session.setAttribute("error", "Payment failed. Please check your payment details");
            response.sendRedirect(request.getContextPath() + "/checkout");
            return null;
        }
        return paymentTransactionId;
    }

    private Order createAndProcessOrder(User user, Cart cart, Map<String, String> params,
            String paymentTransactionId, HttpSession session,
            HttpServletRequest request, HttpServletResponse response)
            throws IOException, SQLException {
        Connection connection = null;
        Order order = null;
        try {
            connection = DBConnection.getConnection();
            connection.setAutoCommit(false);

            // Create order object
            order = createOrder(user, cart, params);

            // Use the connection-aware version of createOrder
            if (!orderDAO.createOrder(connection, order)) {
                connection.rollback();
                PaymentProcessor.refundPayment(paymentTransactionId);
                session.setAttribute("error", "Order creation failed. Please contact support");
                response.sendRedirect(request.getContextPath() + "/checkout");
                return null;
            }

            // Update product stocks
            if (!updateProductStocksWithRollback(cart, connection)) {
                connection.rollback();
                PaymentProcessor.refundPayment(paymentTransactionId);
                session.setAttribute("error", "Inventory update failed");
                response.sendRedirect(request.getContextPath() + "/checkout");
                return null;
            }

            connection.commit();
            return order;
        } catch (SQLException e) {
            if (connection != null) {
                try {
                    connection.rollback();
                } catch (SQLException ex) {
                    logger.log(Level.SEVERE, "Failed to rollback transaction", ex);
                }
            }
            PaymentProcessor.refundPayment(paymentTransactionId);
            logger.log(Level.SEVERE, "Order processing failed", e);
            session.setAttribute("error", "Order processing failed: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/checkout");
            return null;
        } finally {
            if (connection != null) {
                try {
                    connection.setAutoCommit(true);
                    connection.close();
                } catch (SQLException e) {
                    logger.log(Level.WARNING, "Failed to close connection", e);
                }
            }
        }
    }

    private void finalizeCheckout(User user, HttpSession session, Order order,
            HttpServletRequest request, HttpServletResponse response) throws IOException {
        try {
            Order verifiedOrder = orderDAO.getOrderById(order.getOrderId());
            if (verifiedOrder == null) {
                session.setAttribute("error", "Order confirmation failed");
                response.sendRedirect(request.getContextPath() + "/orders");
                return;
            }

            // Set the current order in session
            session.setAttribute("currentOrder", verifiedOrder);

            // Redirect to confirmation page
            response.sendRedirect(request.getContextPath() + "/order/confirmation/" + verifiedOrder.getOrderId());
        } catch (Exception e) {
            session.setAttribute("error", "Checkout completion failed");
            response.sendRedirect(request.getContextPath() + "/orders");
        }
    }

    private void handleCheckoutError(Exception e, String paymentTransactionId,
            HttpSession session, HttpServletRequest request, HttpServletResponse response) throws IOException {
        logger.log(Level.SEVERE, "Checkout process failed", e);

        if (paymentTransactionId != null) {
            PaymentProcessor.refundPayment(paymentTransactionId);
        }

        session.setAttribute("error", "Checkout failed: " + e.getMessage());
        response.sendRedirect(request.getContextPath() + "/checkout");
    }

    private void handleError(HttpServletRequest request, HttpServletResponse response,
            HttpSession session, String message, Exception e, String redirectPath)
            throws IOException {
        logger.log(Level.SEVERE, message, e);
        session.setAttribute("error", message);
        response.sendRedirect(request.getContextPath() + redirectPath);
    }

    private String validateCartItemsWithDetails(Cart cart) {
        try {
            for (CartItem item : cart.getItems()) {
                Product product = productDAO.getProductById(item.getProductId());
                if (product == null) {
                    return "Product no longer available: " + item.getName();
                }
                if (product.getStockQuantity() < item.getQuantity()) {
                    return "Only " + product.getStockQuantity() + " left of " + item.getName();
                }
                if (!product.isAvailableInSize(item.getSize())) {
                    return "Size " + item.getSize() + " unavailable for " + item.getName();
                }
            }
            return null;
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Cart validation failed", e);
            return "Unable to validate your cart. Please try again.";
        }
    }

    private boolean updateProductStocksWithRollback(Cart cart, Connection connection) throws SQLException {
        try {
            for (CartItem item : cart.getItems()) {
                if (!productDAO.updateProductStock(connection, item.getProductId(),
                        item.getSize(), item.getQuantity())) {
                    return false;
                }
            }
            return true;
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Stock update failed", e);
            throw e;
        }
    }

    private Map<String, String> validateCheckoutParameters(HttpServletRequest request) {
        Map<String, String> params = new HashMap<>();
        params.put("shippingAddress", validateField(request.getParameter("shippingAddress"), 10));
        params.put("paymentMethod", "credit_card".equals(request.getParameter("paymentMethod")) ? "credit_card" : null);
        params.put("cardNumber", PaymentProcessor.isValidCardNumber(request.getParameter("cardNumber"))
                ? request.getParameter("cardNumber").replaceAll("\\s", "") : null);
        params.put("cardExpiry", PaymentProcessor.isValidExpiryDate(request.getParameter("cardExpiry"))
                ? request.getParameter("cardExpiry").trim() : null);
        params.put("cardCvv", PaymentProcessor.isValidCvv(request.getParameter("cardCvv"))
                ? request.getParameter("cardCvv").trim() : null);
        return params;
    }

    private String validateField(String value, int minLength) {
        return (value == null || value.trim().length() < minLength) ? null : value.trim();
    }

    private String getParameterValidationError(Map<String, String> params) {
        if (params.get("shippingAddress") == null) {
            return "Invalid shipping address";
        }
        if (params.get("paymentMethod") == null) {
            return "Invalid payment method";
        }
        if (params.get("cardNumber") == null) {
            return "Invalid card number";
        }
        if (params.get("cardExpiry") == null) {
            return "Invalid expiration date";
        }
        if (params.get("cardCvv") == null) {
            return "Invalid CVV";
        }
        return null;
    }

    private Order createOrder(User user, Cart cart, Map<String, String> params) {
        Order order = new Order();
        order.setUserId(user.getUserId());
        order.setTotalAmount(cart.getTotal());
        order.setStatus("Processing");
        order.setShippingAddress(params.get("shippingAddress"));
        order.setPaymentMethod(params.get("paymentMethod"));
        order.setOrderDate(new Timestamp(System.currentTimeMillis()));
        order.setEstimatedDelivery(new Timestamp(System.currentTimeMillis() + (3L * 24 * 60 * 60 * 1000)));

        List<OrderItem> orderItems = new ArrayList<>();
        for (CartItem item : cart.getItems()) {
            OrderItem orderItem = new OrderItem();
            orderItem.setProductId(item.getProductId());
            orderItem.setProductName(item.getName());
            orderItem.setQuantity(item.getQuantity());
            orderItem.setPrice(item.getPrice());
            orderItem.setSize(item.getSize());
            orderItems.add(orderItem);
        }
        order.setItems(orderItems);
        return order;
    }

    @Override
    public void destroy() {
        try {
            if (cartDAO != null) {
                cartDAO.close();
            }
            if (orderDAO != null) {
                orderDAO.close();
            }
            if (productDAO != null) {
                productDAO.close();
            }
        } catch (Exception e) {
            logger.log(Level.WARNING, "Cleanup failed", e);
        }
    }
}