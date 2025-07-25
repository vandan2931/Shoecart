package dao;

import model.Product;
import util.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class ProductDAO {

    private static final Logger logger = Logger.getLogger(ProductDAO.class.getName());

    public List<Product> getAllProducts(int offset, int limit) {
        List<Product> products = new ArrayList<>();
        String query = "SELECT p.*, c.name as category_name FROM products p "
                + "JOIN categories c ON p.category_id = c.category_id "
                + "ORDER BY p.product_id LIMIT ? OFFSET ?";

        try (Connection connection = DBConnection.getConnection();
                PreparedStatement ps = connection.prepareStatement(query)) {

            ps.setInt(1, limit);
            ps.setInt(2, offset);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Product product = resultSetToProduct(rs, connection);
                    products.add(product);
                }
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error in getAllProducts", e);
            throw new RuntimeException("Failed to get all products", e);
        }
        return products;
    }

    public Product getProductById(int productId) {
        String query = "SELECT p.*, c.name as category_name FROM products p "
                + "JOIN categories c ON p.category_id = c.category_id "
                + "WHERE p.product_id = ?";

        try (Connection connection = DBConnection.getConnection();
                PreparedStatement ps = connection.prepareStatement(query)) {

            ps.setInt(1, productId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return resultSetToProduct(rs, connection);
                }
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error in getProductById for ID: " + productId, e);
            throw new RuntimeException("Failed to get product by ID", e);
        }
        return null;
    }

    public List<Product> getProductsByCategory(int categoryId, int offset, int limit) {
        List<Product> products = new ArrayList<>();
        String query = "SELECT p.*, c.name as category_name FROM products p "
                + "JOIN categories c ON p.category_id = c.category_id "
                + "WHERE p.category_id = ? ORDER BY p.product_id LIMIT ? OFFSET ?";

        try (Connection connection = DBConnection.getConnection();
                PreparedStatement ps = connection.prepareStatement(query)) {

            ps.setInt(1, categoryId);
            ps.setInt(2, limit);
            ps.setInt(3, offset);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Product product = resultSetToProduct(rs, connection);
                    products.add(product);
                }
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error in getProductsByCategory for category: " + categoryId, e);
            throw new RuntimeException("Failed to get products by category", e);
        }
        return products;
    }

    public int getTotalProductsCount() {
        String query = "SELECT COUNT(*) FROM products";
        try (Connection connection = DBConnection.getConnection();
                PreparedStatement ps = connection.prepareStatement(query);
                ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error in getTotalProductsCount", e);
            throw new RuntimeException("Failed to get total products count", e);
        }
        return 0;
    }

    public int getProductsCountByCategory(int categoryId) {
        String query = "SELECT COUNT(*) FROM products WHERE category_id = ?";
        try (Connection connection = DBConnection.getConnection();
                PreparedStatement ps = connection.prepareStatement(query)) {

            ps.setInt(1, categoryId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error in getProductsCountByCategory for category: " + categoryId, e);
            throw new RuntimeException("Failed to get products count by category", e);
        }
        return 0;
    }

    public List<Product> searchProducts(String searchTerm) {
        List<Product> products = new ArrayList<>();
        String query = "SELECT p.*, c.name as category_name FROM products p "
                + "JOIN categories c ON p.category_id = c.category_id "
                + "WHERE p.name LIKE ? OR p.description LIKE ?";

        try (Connection connection = DBConnection.getConnection();
                PreparedStatement ps = connection.prepareStatement(query)) {

            String likeTerm = "%" + searchTerm + "%";
            ps.setString(1, likeTerm);
            ps.setString(2, likeTerm);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Product product = resultSetToProduct(rs, connection);
                    products.add(product);
                }
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error in searchProducts for term: " + searchTerm, e);
            throw new RuntimeException("Failed to search products", e);
        }
        return products;
    }

    public boolean updateProductStock(Connection connection, int productId, String size, int quantity) throws SQLException {
        if (!isSizeAvailable(connection, productId, size)) {
            logger.log(Level.WARNING, "Size not available for product: " + productId + ", size: " + size);
            return false;
        }

        String sql = "UPDATE products SET stock_quantity = stock_quantity - ? "
                + "WHERE product_id = ? AND stock_quantity >= ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, quantity);
            ps.setInt(2, productId);
            ps.setInt(3, quantity);

            int rowsAffected = ps.executeUpdate();
            if (rowsAffected == 0) {
                logger.log(Level.WARNING, "Insufficient stock for product: " + productId);
                return false;
            }
            return true;
        }
    }

    public boolean addProduct(Product product) {
        String productSql = "INSERT INTO products (name, description, price, image_path, category_id, stock_quantity) "
                + "VALUES (?, ?, ?, ?, ?, ?)";

        String sizeSql = "INSERT INTO product_sizes (product_id, size) VALUES (?, ?)";

        Connection connection = null;
        try {
            connection = DBConnection.getConnection();
            connection.setAutoCommit(false);

            // Insert product
            try (PreparedStatement ps = connection.prepareStatement(productSql, Statement.RETURN_GENERATED_KEYS)) {
                ps.setString(1, product.getName());
                ps.setString(2, product.getDescription());
                ps.setDouble(3, product.getPrice());
                ps.setString(4, product.getImagePath());
                ps.setInt(5, product.getCategoryId());
                ps.setInt(6, product.getStockQuantity());

                int affectedRows = ps.executeUpdate();
                if (affectedRows == 0) {
                    throw new SQLException("Creating product failed, no rows affected.");
                }

                try (ResultSet generatedKeys = ps.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        product.setProductId(generatedKeys.getInt(1));
                    } else {
                        throw new SQLException("Creating product failed, no ID obtained.");
                    }
                }
            }

            // Insert sizes
            try (PreparedStatement ps = connection.prepareStatement(sizeSql)) {
                for (String size : product.getSizes()) {
                    ps.setInt(1, product.getProductId());
                    ps.setString(2, size);
                    ps.addBatch();
                }
                ps.executeBatch();
            }

            connection.commit();
            return true;
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error adding product", e);
            if (connection != null) {
                try {
                    connection.rollback();
                } catch (SQLException ex) {
                    logger.log(Level.SEVERE, "Error rolling back transaction", ex);
                }
            }
            throw new RuntimeException("Failed to add product", e);
        } finally {
            if (connection != null) {
                try {
                    connection.setAutoCommit(true);
                    connection.close();
                } catch (SQLException e) {
                    logger.log(Level.WARNING, "Error closing connection", e);
                }
            }
        }
    }

    public boolean updateProduct(Product product) {
        String productSql = "UPDATE products SET name = ?, description = ?, price = ?, "
                + "image_path = ?, category_id = ?, stock_quantity = ? "
                + "WHERE product_id = ?";

        String deleteSizesSql = "DELETE FROM product_sizes WHERE product_id = ?";
        String insertSizesSql = "INSERT INTO product_sizes (product_id, size) VALUES (?, ?)";

        Connection connection = null;
        try {
            connection = DBConnection.getConnection();
            connection.setAutoCommit(false);

            // Update product
            try (PreparedStatement ps = connection.prepareStatement(productSql)) {
                ps.setString(1, product.getName());
                ps.setString(2, product.getDescription());
                ps.setDouble(3, product.getPrice());
                ps.setString(4, product.getImagePath());
                ps.setInt(5, product.getCategoryId());
                ps.setInt(6, product.getStockQuantity());
                ps.setInt(7, product.getProductId());

                int affectedRows = ps.executeUpdate();
                if (affectedRows == 0) {
                    throw new SQLException("Updating product failed, no rows affected.");
                }
            }

            // Update sizes - first delete existing sizes
            try (PreparedStatement ps = connection.prepareStatement(deleteSizesSql)) {
                ps.setInt(1, product.getProductId());
                ps.executeUpdate();
            }

            // Then insert new sizes
            try (PreparedStatement ps = connection.prepareStatement(insertSizesSql)) {
                for (String size : product.getSizes()) {
                    ps.setInt(1, product.getProductId());
                    ps.setString(2, size);
                    ps.addBatch();
                }
                ps.executeBatch();
            }

            connection.commit();
            return true;
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error updating product", e);
            if (connection != null) {
                try {
                    connection.rollback();
                } catch (SQLException ex) {
                    logger.log(Level.SEVERE, "Error rolling back transaction", ex);
                }
            }
            throw new RuntimeException("Failed to update product", e);
        } finally {
            if (connection != null) {
                try {
                    connection.setAutoCommit(true);
                    connection.close();
                } catch (SQLException e) {
                    logger.log(Level.WARNING, "Error closing connection", e);
                }
            }
        }
    }

    public boolean deleteProduct(int productId) {
        String deleteSizesSql = "DELETE FROM product_sizes WHERE product_id = ?";
        String deleteProductSql = "DELETE FROM products WHERE product_id = ?";

        Connection connection = null;
        try {
            connection = DBConnection.getConnection();
            connection.setAutoCommit(false);

            // First delete sizes
            try (PreparedStatement ps = connection.prepareStatement(deleteSizesSql)) {
                ps.setInt(1, productId);
                ps.executeUpdate();
            }

            // Then delete product
            try (PreparedStatement ps = connection.prepareStatement(deleteProductSql)) {
                ps.setInt(1, productId);
                int affectedRows = ps.executeUpdate();
                if (affectedRows == 0) {
                    throw new SQLException("Deleting product failed, no rows affected.");
                }
            }

            connection.commit();
            return true;
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error deleting product with ID: " + productId, e);
            if (connection != null) {
                try {
                    connection.rollback();
                } catch (SQLException ex) {
                    logger.log(Level.SEVERE, "Error rolling back transaction", ex);
                }
            }
            throw new RuntimeException("Failed to delete product", e);
        } finally {
            if (connection != null) {
                try {
                    connection.setAutoCommit(true);
                    connection.close();
                } catch (SQLException e) {
                    logger.log(Level.WARNING, "Error closing connection", e);
                }
            }
        }
    }

    private boolean isSizeAvailable(Connection connection, int productId, String size) throws SQLException {
        String query = "SELECT 1 FROM product_sizes WHERE product_id = ? AND size = ?";
        try (PreparedStatement ps = connection.prepareStatement(query)) {
            ps.setInt(1, productId);
            ps.setString(2, size);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        }
    }

    private Product resultSetToProduct(ResultSet rs, Connection connection) throws SQLException {
        Product product = new Product();
        product.setProductId(rs.getInt("product_id"));
        product.setName(rs.getString("name"));
        product.setDescription(rs.getString("description"));
        product.setPrice(rs.getDouble("price"));
        product.setImagePath(rs.getString("image_path"));
        product.setCategoryId(rs.getInt("category_id"));
        product.setStockQuantity(rs.getInt("stock_quantity"));
        product.setCategoryName(rs.getString("category_name"));
        product.setSizes(getProductSizes(product.getProductId(), connection));
        return product;
    }

    private List<String> getProductSizes(int productId, Connection connection) throws SQLException {
        List<String> sizes = new ArrayList<>();
        String query = "SELECT size FROM product_sizes WHERE product_id = ?";

        try (PreparedStatement ps = connection.prepareStatement(query)) {
            ps.setInt(1, productId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    sizes.add(rs.getString("size"));
                }
            }
        }
        return sizes;
    }

    public void close() {
        // Connection pooling handles this in production
    }
}
