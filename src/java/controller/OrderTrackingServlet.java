package controller;

import dao.OrderDAO;
import model.Order;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*;
import java.io.IOException;

@WebServlet(name = "OrderTrackingServlet", urlPatterns = {"/track-order", "/order-tracking"})
public class OrderTrackingServlet extends HttpServlet {
    private OrderDAO orderDAO;

    @Override
    public void init() throws ServletException {
        orderDAO = new OrderDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Just show the tracking form
        request.getRequestDispatcher("/jsp/order-tracking.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String orderIdStr = request.getParameter("orderId");
        String email = request.getParameter("email");
        
        try {
            int orderId = Integer.parseInt(orderIdStr);
            Order order = orderDAO.getOrderById(orderId);
            
            // In a real application, you would verify the email matches the order's user email
            if (order != null) {
                request.setAttribute("order", order);
            } else {
                request.setAttribute("error", "Order not found");
            }
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Invalid order number");
        }
        
        request.getRequestDispatcher("/jsp/order-tracking.jsp").forward(request, response);
    }
}