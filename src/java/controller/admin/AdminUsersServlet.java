package controller.admin;

import dao.UserDAO;
import model.User;
import util.AdminAuth;
import util.PasswordUtil;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet(name = "AdminUsersServlet", value = {
    "/admin/users",
    "/admin/users/add",
    "/admin/users/edit",
    "/admin/users/update",
    "/admin/users/delete"
})
public class AdminUsersServlet extends HttpServlet {
    private UserDAO userDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        userDAO = new UserDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            AdminAuth.requireAdmin(request);
            
            String path = request.getServletPath();
            
            if (path.equals("/admin/users")) {
                listUsers(request, response);
            } else if (path.equals("/admin/users/add")) {
                showAddForm(request, response);
            } else if (path.equals("/admin/users/edit")) {
                showEditForm(request, response);
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        } catch (Exception e) {
            handleError(request, response, "Failed to process request: " + e.getMessage(), "/jsp/admin/users.jsp");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            AdminAuth.requireAdmin(request);
            
            String path = request.getServletPath();
            
            if (path.equals("/admin/users/add")) {
                addUser(request, response);
            } else if (path.equals("/admin/users/update")) {
                updateUser(request, response);
            } else if (path.equals("/admin/users/delete")) {
                deleteUser(request, response);
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        } catch (Exception e) {
            request.getSession().setAttribute("error", "Failed to process request: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/admin/users");
        }
    }

    private void listUsers(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException, SQLException {
        String search = request.getParameter("search");
        String role = request.getParameter("role");
        
        List<User> users;
        if (search != null && !search.isEmpty()) {
            users = userDAO.searchUsers(search);
        } else if (role != null && !role.isEmpty()) {
            users = userDAO.getUsersByRole(role);
        } else {
            users = userDAO.getAllUsers();
        }
        
        request.setAttribute("users", users);
        request.getRequestDispatcher("/jsp/admin/users.jsp").forward(request, response);
    }

    private void showAddForm(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.getRequestDispatcher("/jsp/admin/user-form.jsp").forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException, SQLException {
        int userId = Integer.parseInt(request.getParameter("id"));
        User user = userDAO.getUserById(userId);
        
        if (user == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "User not found");
            return;
        }
        
        request.setAttribute("user", user);
        request.getRequestDispatcher("/jsp/admin/user-form.jsp").forward(request, response);
    }

    private void addUser(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException, SQLException {
        User user = new User();
        user.setName(request.getParameter("name"));
        user.setEmail(request.getParameter("email"));
        user.setPassword(PasswordUtil.hashPassword(request.getParameter("password")));
        user.setPhone(request.getParameter("phone"));
        user.setAddress(request.getParameter("address"));
        user.setRole(request.getParameter("role"));
        
        if (userDAO.addUser(user)) {
            request.getSession().setAttribute("success", "User added successfully");
        } else {
            request.getSession().setAttribute("error", "Failed to add user");
        }
        response.sendRedirect(request.getContextPath() + "/admin/users");
    }

    private void updateUser(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException, SQLException {
        User user = new User();
        user.setUserId(Integer.parseInt(request.getParameter("userId")));
        user.setName(request.getParameter("name"));
        user.setEmail(request.getParameter("email"));
        user.setPhone(request.getParameter("phone"));
        user.setAddress(request.getParameter("address"));
        user.setRole(request.getParameter("role"));

        String password = request.getParameter("password");
        if (password != null && !password.isEmpty()) {
            user.setPassword(PasswordUtil.hashPassword(password));
        }

        if (userDAO.updateUser(user)) {
            request.getSession().setAttribute("success", "User updated successfully");
        } else {
            request.getSession().setAttribute("error", "Failed to update user");
        }
        response.sendRedirect(request.getContextPath() + "/admin/users");
    }

    private void deleteUser(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException, SQLException {
        int userId = Integer.parseInt(request.getParameter("id"));
        
        if (userDAO.deleteUser(userId)) {
            request.getSession().setAttribute("success", "User deleted successfully");
        } else {
            request.getSession().setAttribute("error", "Failed to delete user");
        }
        response.sendRedirect(request.getContextPath() + "/admin/users");
    }

    private void handleError(HttpServletRequest request, HttpServletResponse response, 
                           String errorMessage, String view) throws ServletException, IOException {
        request.setAttribute("error", errorMessage);
        request.getRequestDispatcher(view).forward(request, response);
    }
}