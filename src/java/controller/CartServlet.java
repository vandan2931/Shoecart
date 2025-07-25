package controller;

import dao.CartDAO;
import dao.ProductDAO;
import model.Cart;
import model.CartItem;
import model.Product;
import model.User;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*;
import java.io.IOException;
import java.util.logging.Level;

@WebServlet(name = "CartServlet", urlPatterns = {"/cart", "/cart/add", "/cart/update", "/cart/remove"})
public class CartServlet extends HttpServlet {
    private CartDAO cartDAO;
    private ProductDAO productDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        cartDAO = new CartDAO();
        productDAO = new ProductDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
            // Always get fresh cart data from database
            Cart cart = cartDAO.getCartByUserId(user.getUserId());
            request.setAttribute("cart", cart);
            request.getRequestDispatcher("/jsp/cart.jsp").forward(request, response);
        } catch (Exception e) {
            session.setAttribute("error", "Failed to load your cart");
            response.sendRedirect(request.getContextPath() + "/products");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String path = request.getServletPath();
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        switch (path) {
            case "/cart/add":
                addToCart(request, response, user.getUserId());
                break;
            case "/cart/update":
                updateCartItem(request, response, user.getUserId());
                break;
            case "/cart/remove":
                removeFromCart(request, response, user.getUserId());
                break;
            default:
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    private void addToCart(HttpServletRequest request, HttpServletResponse response, int userId)
            throws IOException, ServletException {
        try {
            int productId = Integer.parseInt(request.getParameter("productId"));
            String size = request.getParameter("size");
            int quantity = Integer.parseInt(request.getParameter("quantity"));

            Product product = productDAO.getProductById(productId);
            if (product == null || !product.isAvailableInSize(size)) {
                response.sendRedirect(request.getContextPath() + "/product?id=" + productId + "&error=Invalid product or size");
                return;
            }

            if (quantity <= 0 || quantity > product.getStockQuantity()) {
                response.sendRedirect(request.getContextPath() + "/product?id=" + productId + "&error=Invalid quantity");
                return;
            }

            CartItem item = new CartItem();
            item.setProductId(productId);
            item.setSize(size);
            item.setQuantity(quantity);
            item.setName(product.getName());
            item.setPrice(product.getPrice());
            item.setImagePath(product.getImagePath());

            if (cartDAO.addToCart(userId, item)) {
                request.setAttribute("success", "Item added to cart");
                doGet(request, response);
            } else {
                response.sendRedirect(request.getContextPath() + "/product?id=" + productId + "&error=Failed to add item to cart");
            }
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/products");
        }
    }

    private void updateCartItem(HttpServletRequest request, HttpServletResponse response, int userId) throws IOException {
        try {
            int productId = Integer.parseInt(request.getParameter("productId"));
            String size = request.getParameter("size");
            int quantity = Integer.parseInt(request.getParameter("quantity"));

            if (quantity <= 0) {
                response.sendRedirect(request.getContextPath() + "/cart?error=Quantity must be positive");
                return;
            }

            Product product = productDAO.getProductById(productId);
            if (product != null && quantity > product.getStockQuantity()) {
                response.sendRedirect(request.getContextPath() + "/cart?error=Not enough stock available");
                return;
            }

            if (cartDAO.updateCartItem(userId, productId, size, quantity)) {
                response.sendRedirect(request.getContextPath() + "/cart");
            } else {
                response.sendRedirect(request.getContextPath() + "/cart?error=Failed to update cart");
            }
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/cart");
        }
    }

    private void removeFromCart(HttpServletRequest request, HttpServletResponse response, int userId) throws IOException {
        try {
            int productId = Integer.parseInt(request.getParameter("productId"));
            String size = request.getParameter("size");

            if (cartDAO.removeFromCart(userId, productId, size)) {
                response.sendRedirect(request.getContextPath() + "/cart?success=Item removed from cart");
            } else {
                response.sendRedirect(request.getContextPath() + "/cart?error=Failed to remove item from cart");
            }
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/cart");
        }
    }

    @Override
    public void destroy() {
        cartDAO = null;
        productDAO.close();
        super.destroy();
    }
}