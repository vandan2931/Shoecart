package dao;

import model.Cart;
import model.CartItem;
import util.DBConnection;
import java.sql.*;
import java.util.logging.Level;
import java.util.logging.Logger;

public class CartDAO {
    private static final Logger logger = Logger.getLogger(CartDAO.class.getName());

    public Cart getCartByUserId(int userId) {
        Cart cart = new Cart();
        cart.setUserId(userId);

        String query = "SELECT ci.*, p.name, p.price, p.image_path " +
                      "FROM cart_items ci " +
                      "JOIN products p ON ci.product_id = p.product_id " +
                      "WHERE ci.cart_id IN (SELECT cart_id FROM carts WHERE user_id = ?)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    CartItem item = new CartItem();
                    item.setCartItemId(rs.getInt("cart_item_id"));
                    item.setProductId(rs.getInt("product_id"));
                    item.setName(rs.getString("name"));
                    item.setSize(rs.getString("size"));
                    item.setPrice(rs.getDouble("price"));
                    item.setQuantity(rs.getInt("quantity"));
                    item.setImagePath(rs.getString("image_path"));
                    cart.addItem(item);
                }
            }
            
            ensureCartExists(conn, userId);
            
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Failed to get cart by user ID: " + userId, e);
            throw new RuntimeException("Failed to get cart by user ID", e);
        }
        return cart;
    }

    private void ensureCartExists(Connection conn, int userId) throws SQLException {
        String checkCartSQL = "SELECT 1 FROM carts WHERE user_id = ?";
        try (PreparedStatement ps = conn.prepareStatement(checkCartSQL)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (!rs.next()) {
                    String createCartSQL = "INSERT INTO carts (user_id) VALUES (?)";
                    try (PreparedStatement createPs = conn.prepareStatement(createCartSQL, Statement.RETURN_GENERATED_KEYS)) {
                        createPs.setInt(1, userId);
                        createPs.executeUpdate();
                    }
                }
            }
        }
    }

    public boolean addToCart(int userId, CartItem item) {
        if (item == null || item.getProductId() <= 0 || item.getQuantity() <= 0) {
            return false;
        }

        try (Connection conn = DBConnection.getConnection()) {
            conn.setAutoCommit(false);
            
            try {
                int cartId = getOrCreateCartId(conn, userId);
                if (cartId == 0) {
                    conn.rollback();
                    return false;
                }
                
                if (itemExistsInCart(conn, cartId, item.getProductId(), item.getSize())) {
                    int newQuantity = getCurrentQuantity(conn, cartId, item.getProductId(), item.getSize()) + item.getQuantity();
                    if (!updateCartItemQuantity(conn, cartId, item.getProductId(), item.getSize(), newQuantity)) {
                        conn.rollback();
                        return false;
                    }
                } else {
                    String query = "INSERT INTO cart_items (cart_id, product_id, size, quantity) VALUES (?, ?, ?, ?)";
                    try (PreparedStatement ps = conn.prepareStatement(query)) {
                        ps.setInt(1, cartId);
                        ps.setInt(2, item.getProductId());
                        ps.setString(3, item.getSize());
                        ps.setInt(4, item.getQuantity());
                        if (ps.executeUpdate() != 1) {
                            conn.rollback();
                            return false;
                        }
                    }
                }
                conn.commit();
                return true;
            } catch (SQLException e) {
                conn.rollback();
                throw e;
            } finally {
                conn.setAutoCommit(true);
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Failed to add item to cart for user: " + userId, e);
            throw new RuntimeException("Failed to add item to cart", e);
        }
    }

    public boolean removeFromCart(int userId, int productId, String size) {
        try (Connection conn = DBConnection.getConnection()) {
            int cartId = getCartId(conn, userId);
            if (cartId == 0) return false;
            
            String query = "DELETE FROM cart_items WHERE cart_id = ? AND product_id = ? AND size = ?";
            try (PreparedStatement ps = conn.prepareStatement(query)) {
                ps.setInt(1, cartId);
                ps.setInt(2, productId);
                ps.setString(3, size);
                return ps.executeUpdate() > 0;
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Failed to remove item from cart for user: " + userId, e);
            throw new RuntimeException("Failed to remove item from cart", e);
        }
    }

    public boolean updateCartItem(int userId, int productId, String size, int quantity) {
        if (quantity <= 0) {
            return removeFromCart(userId, productId, size);
        }

        try (Connection conn = DBConnection.getConnection()) {
            int cartId = getCartId(conn, userId);
            if (cartId == 0) return false;
            
            String query = "UPDATE cart_items SET quantity = ? WHERE cart_id = ? AND product_id = ? AND size = ?";
            try (PreparedStatement ps = conn.prepareStatement(query)) {
                ps.setInt(1, quantity);
                ps.setInt(2, cartId);
                ps.setInt(3, productId);
                ps.setString(4, size);
                return ps.executeUpdate() > 0;
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Failed to update cart item for user: " + userId, e);
            throw new RuntimeException("Failed to update cart item", e);
        }
    }

    public boolean clearCart(int userId) {
        logger.info("Attempting to clear cart for user: " + userId);
        String deleteItemsSQL = "DELETE FROM cart_items WHERE cart_id = (SELECT cart_id FROM carts WHERE user_id = ?)";
        String resetCartSQL = "UPDATE carts SET total = 0 WHERE user_id = ?";
        
        try (Connection conn = DBConnection.getConnection()) {
            conn.setAutoCommit(false);
            
            try (PreparedStatement deleteStmt = conn.prepareStatement(deleteItemsSQL);
                 PreparedStatement resetStmt = conn.prepareStatement(resetCartSQL)) {
                
                // Delete cart items
                deleteStmt.setInt(1, userId);
                int itemsDeleted = deleteStmt.executeUpdate();
                logger.info("Deleted " + itemsDeleted + " items from cart for user: " + userId);
                
                // Reset cart total
                resetStmt.setInt(1, userId);
                int updated = resetStmt.executeUpdate();
                logger.info("Reset cart total for user: " + userId + ". Rows updated: " + updated);
                
                conn.commit();
                logger.info("Successfully cleared cart for user: " + userId);
                return true;
            } catch (SQLException e) {
                conn.rollback();
                logger.log(Level.SEVERE, "Failed to clear cart for user: " + userId, e);
                return false;
            } finally {
                conn.setAutoCommit(true);
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Database error while clearing cart for user: " + userId, e);
            return false;
        }
    }

    // Helper methods
    private int getOrCreateCartId(Connection conn, int userId) throws SQLException {
        int cartId = getCartId(conn, userId);
        if (cartId == 0) {
            String query = "INSERT INTO carts (user_id) VALUES (?)";
            try (PreparedStatement ps = conn.prepareStatement(query, Statement.RETURN_GENERATED_KEYS)) {
                ps.setInt(1, userId);
                ps.executeUpdate();
                
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        cartId = rs.getInt(1);
                    }
                }
            }
        }
        return cartId;
    }

    private int getCartId(Connection conn, int userId) throws SQLException {
        String query = "SELECT cart_id FROM carts WHERE user_id = ?";
        try (PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? rs.getInt("cart_id") : 0;
            }
        }
    }

    private boolean itemExistsInCart(Connection conn, int cartId, int productId, String size) throws SQLException {
        String query = "SELECT 1 FROM cart_items WHERE cart_id = ? AND product_id = ? AND size = ?";
        try (PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, cartId);
            ps.setInt(2, productId);
            ps.setString(3, size);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        }
    }

    private int getCurrentQuantity(Connection conn, int cartId, int productId, String size) throws SQLException {
        String query = "SELECT quantity FROM cart_items WHERE cart_id = ? AND product_id = ? AND size = ?";
        try (PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, cartId);
            ps.setInt(2, productId);
            ps.setString(3, size);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? rs.getInt("quantity") : 0;
            }
        }
    }

    private boolean updateCartItemQuantity(Connection conn, int cartId, int productId, String size, int quantity) throws SQLException {
        String query = "UPDATE cart_items SET quantity = ? WHERE cart_id = ? AND product_id = ? AND size = ?";
        try (PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, quantity);
            ps.setInt(2, cartId);
            ps.setInt(3, productId);
            ps.setString(4, size);
            return ps.executeUpdate() > 0;
        }
    }

    public void close() {
        // Connection is managed by DBConnection utility
    }
}