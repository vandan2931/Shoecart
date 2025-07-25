package controller;

import dao.ProductDAO;
import model.Product;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "ProductServlet", urlPatterns = {
    "/products", 
    "/product/*"
})
public class ProductServlet extends HttpServlet {
    private ProductDAO productDAO;
    private static final int PRODUCTS_PER_PAGE = 12;

    @Override
    public void init() throws ServletException {
        super.init();
        productDAO = new ProductDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String path = request.getServletPath();
        
        try {
            if (path.equals("/products")) {
                showProducts(request, response);
            } else if (path.equals("/product")) {
                showProductDetails(request, response);
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        } catch (Exception e) {
            handleError(request, response, e);
        }
    }

    private void showProducts(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String categoryIdParam = request.getParameter("category");
        String pageParam = request.getParameter("page");
        int page = 1;
        
        if (pageParam != null && !pageParam.isEmpty()) {
            page = Integer.parseInt(pageParam);
            if (page < 1) page = 1;
        }
        
        int offset = (page - 1) * PRODUCTS_PER_PAGE;
        List<Product> products;
        int totalProducts;
        
        if (categoryIdParam != null && !categoryIdParam.isEmpty()) {
            int categoryId = Integer.parseInt(categoryIdParam);
            products = productDAO.getProductsByCategory(categoryId, offset, PRODUCTS_PER_PAGE);
            totalProducts = productDAO.getProductsCountByCategory(categoryId);
            request.setAttribute("categoryId", categoryId);
        } else {
            products = productDAO.getAllProducts(offset, PRODUCTS_PER_PAGE);
            totalProducts = productDAO.getTotalProductsCount();
        }
        
        int totalPages = (int) Math.ceil((double) totalProducts / PRODUCTS_PER_PAGE);
        
        request.setAttribute("products", products);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        
        request.getRequestDispatcher("/jsp/products.jsp").forward(request, response);
    }

    private void showProductDetails(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String productIdParam = request.getParameter("id");
        
        if (productIdParam == null || productIdParam.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/products");
            return;
        }
        
        int productId = Integer.parseInt(productIdParam);
        Product product = productDAO.getProductById(productId);
        
        if (product == null) {
            response.sendRedirect(request.getContextPath() + "/products");
            return;
        }
        
        request.setAttribute("product", product);
        request.getRequestDispatcher("/jsp/product-details.jsp").forward(request, response);
    }

    private void handleError(HttpServletRequest request, HttpServletResponse response, Exception e) 
            throws ServletException, IOException {
        request.setAttribute("error", "Failed to process request: " + e.getMessage());
        request.getRequestDispatcher("/jsp/error.jsp").forward(request, response);
    }

    @Override
    public void destroy() {
        if (productDAO != null) {
            productDAO.close();
        }
    }
}