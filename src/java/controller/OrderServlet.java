package controller;

import dao.OrderDAO;
import model.Order;
import model.User;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*;
import java.io.IOException;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet(name = "OrderServlet", urlPatterns = {
    "/orders",
    "/order/details/*",
    "/order/cancel/*",
    "/order/confirmation/*"
})
public class OrderServlet extends HttpServlet {

    private static final Logger logger = Logger.getLogger(OrderServlet.class.getName());
    private OrderDAO orderDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        orderDAO = new OrderDAO();
        logger.info("OrderServlet initialized successfully");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            HttpSession session = request.getSession(false);
            if (session == null || session.getAttribute("user") == null) {
                response.sendRedirect(request.getContextPath() + "/login");
                return;
            }

            User user = (User) session.getAttribute("user");
            String path = request.getServletPath();
            String extraPath = request.getPathInfo();

            if ("/orders".equals(path)) {
                handleOrdersRequest(request, response, user);
            } else if ("/order/details".equals(path) && extraPath != null) {
                handleOrderDetailsRequest(request, response, extraPath.substring(1), user);
            } else if ("/order/confirmation".equals(path) && extraPath != null) {
                handleOrderConfirmationRequest(request, response, extraPath.substring(1), user);
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error processing GET request", e);
            request.setAttribute("error", "Error processing your request: " + e.getMessage());
            request.getRequestDispatcher("/jsp/error.jsp").forward(request, response);
        }
    }

    private void handleOrdersRequest(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException {
        try {
            List<Order> orders = orderDAO.getOrdersByUserId(user.getUserId());

            if (orders == null) {
                throw new ServletException("Failed to retrieve orders");
            }

            request.setAttribute("orders", orders);

            // Set pagination attributes (even if we're not using them yet)
            request.setAttribute("currentPage", 1);
            request.setAttribute("totalPages", 1);

            request.getRequestDispatcher("/jsp/orders.jsp").forward(request, response);
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Failed to retrieve orders", e);
            request.setAttribute("error", "Failed to load your orders. Please try again later.");
            request.getRequestDispatcher("/jsp/error.jsp").forward(request, response);
        }
    }

    private void handleOrderDetailsRequest(HttpServletRequest request, HttpServletResponse response,
            String orderIdStr, User user) throws ServletException, IOException {
        try {
            int orderId = Integer.parseInt(orderIdStr);
            Order order = orderDAO.getOrderById(orderId);

            if (order == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Order not found");
                return;
            }

            if (order.getUserId() != user.getUserId()) {
                response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access denied");
                return;
            }

            request.setAttribute("order", order);
            RequestDispatcher dispatcher = request.getRequestDispatcher("/jsp/order-details.jsp");
            dispatcher.forward(request, response);
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid order ID");
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error loading order details", e);
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Server error");
        }
    }

    private void handleOrderConfirmationRequest(HttpServletRequest request, HttpServletResponse response,
            String orderIdStr, User user) throws ServletException, IOException {
        HttpSession session = request.getSession();
        Order order = (Order) session.getAttribute("currentOrder");

        if (order == null) {
            try {
                int orderId = Integer.parseInt(orderIdStr);
                order = orderDAO.getOrderById(orderId);

                if (order == null || order.getUserId() != user.getUserId()) {
                    response.sendError(HttpServletResponse.SC_NOT_FOUND);
                    return;
                }
            } catch (NumberFormatException e) {
                throw new ServletException("Invalid order ID", e);
            }
        }

        request.setAttribute("order", order);
        request.getRequestDispatcher("/jsp/order-confirmation.jsp").forward(request, response);
        session.removeAttribute("currentOrder");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            HttpSession session = request.getSession(false);
            if (session == null || session.getAttribute("user") == null) {
                response.sendRedirect(request.getContextPath() + "/login");
                return;
            }

            User user = (User) session.getAttribute("user");
            String path = request.getServletPath();
            String extraPath = request.getPathInfo();

            if ("/order/cancel".equals(path) && extraPath != null) {
                handleOrderCancelRequest(request, response, extraPath.substring(1), user);
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error processing POST request", e);
            request.setAttribute("error", "Error processing your request");
            request.getRequestDispatcher("/jsp/error.jsp").forward(request, response);
        }
    }

    private void handleOrderCancelRequest(HttpServletRequest request, HttpServletResponse response,
            String orderIdStr, User user) throws ServletException, IOException {
        try {
            int orderId = Integer.parseInt(orderIdStr);
            Order order = orderDAO.getOrderById(orderId);

            if (order == null || order.getUserId() != user.getUserId()) {
                response.sendError(HttpServletResponse.SC_FORBIDDEN);
                return;
            }

            if (!order.isCancellable()) {
                request.setAttribute("error", "Order cannot be cancelled in its current status");
                handleOrderDetailsRequest(request, response, orderIdStr, user);
                return;
            }

            boolean success = orderDAO.updateOrderStatus(orderId, Order.STATUS_CANCELLED);
            if (success) {
                response.sendRedirect(request.getContextPath() + "/orders?cancelSuccess=true");
            } else {
                response.sendRedirect(request.getContextPath() + "/orders?cancelError=true");
            }
        } catch (NumberFormatException e) {
            throw new ServletException("Invalid order ID", e);
        }
    }

    @Override
    public void destroy() {
        if (orderDAO != null) {
            orderDAO.close();
        }
    }
}
