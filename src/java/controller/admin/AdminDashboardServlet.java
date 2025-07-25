package controller.admin;

import dao.OrderDAO;
import dao.ProductDAO;
import dao.UserDAO;
import model.Order;
import util.AdminAuth;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet(name = "AdminDashboardServlet", value = "/admin/dashboard")
public class AdminDashboardServlet extends HttpServlet {
    private OrderDAO orderDAO;
    private ProductDAO productDAO;
    private UserDAO userDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        orderDAO = new OrderDAO();
        productDAO = new ProductDAO();
        userDAO = new UserDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            AdminAuth.requireAdmin(request);
            
            // Get dashboard statistics
            int totalProducts = productDAO.getTotalProductsCount();
            int totalOrders = orderDAO.getTotalOrdersCount();
            double totalRevenue = orderDAO.getTotalRevenue();
            int totalUsers = userDAO.getTotalUsersCount();
            
            // Get recent orders
            List<Order> recentOrders = orderDAO.getRecentOrders(5);
            
            // Set attributes for JSP
            request.setAttribute("totalProducts", totalProducts);
            request.setAttribute("totalOrders", totalOrders);
            request.setAttribute("totalRevenue", totalRevenue);
            request.setAttribute("totalUsers", totalUsers);
            request.setAttribute("recentOrders", recentOrders);
            
            request.getRequestDispatcher("/jsp/admin/dashboard.jsp").forward(request, response);
            
        } catch (Exception e) {
            request.setAttribute("error", "Failed to load dashboard: " + e.getMessage());
            request.getRequestDispatcher("/jsp/admin/dashboard.jsp").forward(request, response);
        }
    }
}