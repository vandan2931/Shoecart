package controller.admin;

import dao.OrderDAO;
import dao.OrderHistoryDAO;
import model.Order;
import model.OrderHistory;
import util.AdminAuth;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*;
import java.io.IOException;
import java.sql.Timestamp;
import java.time.Instant;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet(name = "AdminOrdersServlet", urlPatterns = {
    "/admin/orders",
    "/admin/orders/details",
    "/admin/orders/update-status"
})
public class AdminOrdersServlet extends HttpServlet {
    private static final Logger logger = Logger.getLogger(AdminOrdersServlet.class.getName());
    private OrderDAO orderDAO;
    private OrderHistoryDAO orderHistoryDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        orderDAO = new OrderDAO();
        orderHistoryDAO = new OrderHistoryDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            AdminAuth.requireAdmin(request);
            
            String path = request.getServletPath();
            
            if ("/admin/orders".equals(path)) {
                handleOrdersList(request, response);
            } else if ("/admin/orders/details".equals(path)) {
                handleOrderDetails(request, response);
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error processing request", e);
            request.setAttribute("error", "Failed to process request: " + e.getMessage());
            request.getRequestDispatcher("/jsp/admin/orders.jsp").forward(request, response);
        }
    }

    private void handleOrdersList(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String statusFilter = request.getParameter("status");
        List<Order> orders;
        
        if (statusFilter != null && !statusFilter.isEmpty()) {
            orders = orderDAO.getOrdersByStatus(statusFilter);
        } else {
            orders = orderDAO.getAllOrders();
        }
        
        request.setAttribute("orders", orders);
        request.getRequestDispatcher("/jsp/admin/orders.jsp").forward(request, response);
    }

    private void handleOrderDetails(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int orderId = Integer.parseInt(request.getParameter("id"));
            Order order = orderDAO.getOrderById(orderId);
            
            if (order == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Order not found");
                return;
            }
            
            request.setAttribute("order", order);
            request.getRequestDispatcher("/jsp/admin/order-details.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            throw new ServletException("Invalid order ID format", e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            AdminAuth.requireAdmin(request);
            
            String path = request.getServletPath();
            
            if ("/admin/orders/update-status".equals(path)) {
                updateOrderStatus(request, response);
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error processing request", e);
            request.getSession().setAttribute("error", "Failed to process request: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/admin/orders");
        }
    }

    private void updateOrderStatus(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int orderId = Integer.parseInt(request.getParameter("orderId"));
            String newStatus = request.getParameter("status");
            String notes = request.getParameter("notes");
            
            Order order = orderDAO.getOrderById(orderId);
            if (order == null) {
                request.getSession().setAttribute("error", "Order not found");
                response.sendRedirect(request.getContextPath() + "/admin/orders");
                return;
            }
            
            if (!isValidStatusTransition(order.getStatus(), newStatus)) {
                request.getSession().setAttribute("error", 
                    "Invalid status transition from " + order.getStatus() + " to " + newStatus);
                response.sendRedirect(request.getContextPath() + "/admin/orders");
                return;
            }
            
            if (orderDAO.updateOrderStatus(orderId, newStatus)) {
                addOrderHistory(orderId, newStatus, notes != null ? notes : "Status updated by admin");
                request.getSession().setAttribute("success", 
                    "Order #" + orderId + " status updated to " + newStatus);
            } else {
                request.getSession().setAttribute("error", "Failed to update order status");
            }
            response.sendRedirect(request.getContextPath() + "/admin/orders/details?id=" + orderId);
        } catch (NumberFormatException e) {
            throw new ServletException("Invalid order ID format", e);
        }
    }

    private boolean isValidStatusTransition(String currentStatus, String newStatus) {
        if (currentStatus.equals(newStatus)) {
            return false;
        }
        
        // Allow any valid status transition except going backwards
        return true;
    }

    private void addOrderHistory(int orderId, String status, String notes) {
        OrderHistory history = new OrderHistory(
            Timestamp.from(Instant.now()),
            status,
            notes
        );
        orderHistoryDAO.addHistoryEntry(orderId, history);
    }

    @Override
    public void destroy() {
        if (orderDAO != null) {
            orderDAO.close();
        }
        if (orderHistoryDAO != null) {
            orderHistoryDAO.close();
        }
    }
}