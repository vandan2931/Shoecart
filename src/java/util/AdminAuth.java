package util;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import model.User;

public class AdminAuth {
    
    public static boolean isAdminLoggedIn(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session != null) {
            User user = (User) session.getAttribute("user");
            return user != null && "ADMIN".equalsIgnoreCase(user.getRole());
        }
        return false;
    }
    
    public static void requireAdmin(HttpServletRequest request) throws SecurityException {
        if (!isAdminLoggedIn(request)) {
            throw new SecurityException("Admin access required");
        }
    }
}