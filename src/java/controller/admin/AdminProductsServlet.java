package controller.admin;

import dao.ProductDAO;
import model.Product;
import util.AdminAuth;
import util.FileUploadUtil;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*;
import java.io.IOException;
import java.util.Arrays;
import java.util.List;

@WebServlet(name = "AdminProductsServlet", urlPatterns = {
    "/admin/products",
    "/admin/products/add",
    "/admin/products/edit",
    "/admin/products/delete"
})
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 1, // 1 MB
    maxFileSize = 1024 * 1024 * 10, // 10 MB
    maxRequestSize = 1024 * 1024 * 100 // 100 MB
)
public class AdminProductsServlet extends HttpServlet {

    private ProductDAO productDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        productDAO = new ProductDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        AdminAuth.requireAdmin(request);

        String path = request.getServletPath();

        try {
            if ("/admin/products".equals(path)) {
                String searchTerm = request.getParameter("search");
                int page = request.getParameter("page") != null ? Integer.parseInt(request.getParameter("page")) : 1;
                int limit = 10;
                int offset = (page - 1) * limit;

                List<Product> products;
                int totalProducts;
                
                if (searchTerm != null && !searchTerm.isEmpty()) {
                    products = productDAO.searchProducts(searchTerm);
                    totalProducts = products.size();
                } else {
                    products = productDAO.getAllProducts(offset, limit);
                    totalProducts = productDAO.getTotalProductsCount();
                }
                
                int totalPages = (int) Math.ceil((double) totalProducts / limit);

                request.setAttribute("products", products);
                request.setAttribute("currentPage", page);
                request.setAttribute("totalPages", totalPages);
                request.getRequestDispatcher("/jsp/admin/products.jsp").forward(request, response);
            } else if ("/admin/products/add".equals(path)) {
                request.getRequestDispatcher("/jsp/admin/product-form.jsp").forward(request, response);
            } else if ("/admin/products/edit".equals(path)) {
                int productId = Integer.parseInt(request.getParameter("id"));
                Product product = productDAO.getProductById(productId);
                if (product != null) {
                    request.setAttribute("product", product);
                    request.setAttribute("editMode", true);
                    request.getRequestDispatcher("/jsp/admin/product-form.jsp").forward(request, response);
                } else {
                    response.sendError(HttpServletResponse.SC_NOT_FOUND, "Product not found");
                }
            }
        } catch (Exception e) {
            request.setAttribute("error", "Failed to process request: " + e.getMessage());
            request.getRequestDispatcher("/jsp/admin/products.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        AdminAuth.requireAdmin(request);

        String path = request.getServletPath();

        try {
            if ("/admin/products/add".equals(path)) {
                addProduct(request, response);
            } else if ("/admin/products/edit".equals(path)) {
                updateProduct(request, response);
            } else if ("/admin/products/delete".equals(path)) {
                deleteProduct(request, response);
            }
        } catch (Exception e) {
            request.getSession().setAttribute("error", "Failed to process request: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/admin/products");
        }
    }

    private void addProduct(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Product product = new Product();
        product.setName(request.getParameter("name"));
        product.setDescription(request.getParameter("description"));
        product.setPrice(Double.parseDouble(request.getParameter("price")));

        // Handle file upload
        Part filePart = request.getPart("image");
        if (filePart != null && filePart.getSize() > 0) {
            String imagePath = FileUploadUtil.saveFile(request, filePart);
            product.setImagePath(imagePath);
        } else {
            product.setImagePath("/assets/images/no-image.png");
        }

        product.setCategoryId(Integer.parseInt(request.getParameter("categoryId")));
        product.setStockQuantity(Integer.parseInt(request.getParameter("stockQuantity")));
        product.setStatus(request.getParameter("status"));

        String[] sizes = request.getParameterValues("sizes");
        if (sizes != null) {
            product.setSizes(Arrays.asList(sizes));
        }

        if (productDAO.addProduct(product)) {
            request.getSession().setAttribute("success", "Product added successfully");
            response.sendRedirect(request.getContextPath() + "/admin/products");
        } else {
            request.setAttribute("error", "Failed to add product");
            request.setAttribute("product", product);
            request.getRequestDispatcher("/jsp/admin/product-form.jsp").forward(request, response);
        }
    }

    private void updateProduct(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int productId = Integer.parseInt(request.getParameter("productId"));
        Product product = productDAO.getProductById(productId);

        if (product == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Product not found");
            return;
        }

        product.setName(request.getParameter("name"));
        product.setDescription(request.getParameter("description"));
        product.setPrice(Double.parseDouble(request.getParameter("price")));

        // Handle file upload
        Part filePart = request.getPart("image");
        boolean keepImage = request.getParameter("keepImage") != null;
        
        if (filePart != null && filePart.getSize() > 0) {
            // Delete old image if exists
            if (product.getImagePath() != null && !product.getImagePath().isEmpty()
                    && !product.getImagePath().equals("/assets/images/no-image.png")) {
                FileUploadUtil.deleteFile(request, product.getImagePath());
            }
            // Save new image
            String imagePath = FileUploadUtil.saveFile(request, filePart);
            product.setImagePath(imagePath);
        } else if (keepImage) {
            // Keep existing image
            product.setImagePath(product.getImagePath());
        } else {
            // No image provided and not keeping existing one
            product.setImagePath("/assets/images/no-image.png");
        }

        product.setCategoryId(Integer.parseInt(request.getParameter("categoryId")));
        product.setStockQuantity(Integer.parseInt(request.getParameter("stockQuantity")));
        product.setStatus(request.getParameter("status"));

        String[] sizes = request.getParameterValues("sizes");
        if (sizes != null) {
            product.setSizes(Arrays.asList(sizes));
        }

        if (productDAO.updateProduct(product)) {
            request.getSession().setAttribute("success", "Product updated successfully");
            response.sendRedirect(request.getContextPath() + "/admin/products");
        } else {
            request.setAttribute("error", "Failed to update product");
            request.setAttribute("product", product);
            request.setAttribute("editMode", true);
            request.getRequestDispatcher("/jsp/admin/product-form.jsp").forward(request, response);
        }
    }

    private void deleteProduct(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int productId = Integer.parseInt(request.getParameter("id"));
        Product product = productDAO.getProductById(productId);

        if (product != null && product.getImagePath() != null && !product.getImagePath().isEmpty()
                && !product.getImagePath().equals("/assets/images/no-image.png")) {
            FileUploadUtil.deleteFile(request, product.getImagePath());
        }
        
        if (productDAO.deleteProduct(productId)) {
            request.getSession().setAttribute("success", "Product deleted successfully");
        } else {
            request.getSession().setAttribute("error", "Failed to delete product");
        }
        response.sendRedirect(request.getContextPath() + "/admin/products");
    }
}