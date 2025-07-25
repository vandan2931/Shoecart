package dao;

import model.Order;
import model.OrderItem;
import model.OrderHistory;
import util.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class OrderDAO {
    private static final Logger logger = Logger.getLogger(OrderDAO.class.getName());

    public boolean createOrder(Order order) {
        Connection connection = null;
        try {
            connection = DBConnection.getConnection();
            connection.setAutoCommit(false);
            return createOrder(connection, order);
        } catch (SQLException e) {
            rollbackTransaction(connection);
            logger.log(Level.SEVERE, "Order creation failed", e);
            throw new RuntimeException("Order creation failed. Please try again.", e);
        } finally {
            closeConnection(connection);
        }
    }

    public boolean createOrder(Connection connection, Order order) throws SQLException {
        try {
            validateOrder(order);

            int orderId = insertOrderHeader(connection, order);
            if (orderId <= 0) {
                connection.rollback();
                logger.severe("Failed to create order header");
                return false;
            }

            if (!insertOrderItems(connection, orderId, order.getItems())) {
                connection.rollback();
                logger.severe("Failed to insert order items");
                return false;
            }

            // Add initial history entry
            OrderHistory history = new OrderHistory(
                order.getOrderDate(), 
                order.getStatus(), 
                "Order created"
            );
            if (!insertOrderHistory(connection, orderId, history)) {
                connection.rollback();
                logger.severe("Failed to insert order history");
                return false;
            }

            connection.commit();
            logger.info("Order created successfully. ID: " + orderId);
            order.setOrderId(orderId);
            return true;
        } catch (IllegalArgumentException e) {
            connection.rollback();
            logger.log(Level.SEVERE, "Invalid order data", e);
            throw new SQLException(e.getMessage(), e);
        }
    }

    public List<Order> getAllOrders() {
        List<Order> orders = new ArrayList<>();
        String sql = "SELECT o.*, u.name as customer_name, u.email as customer_email, u.phone as customer_phone " +
                    "FROM orders o JOIN users u ON o.user_id = u.user_id " +
                    "ORDER BY o.order_date DESC";
        
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement pstmt = connection.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {
            
            while (rs.next()) {
                orders.add(mapOrderFromResultSet(rs, connection));
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Failed to get all orders", e);
            throw new RuntimeException("Failed to retrieve orders", e);
        }
        return orders;
    }

    public List<Order> getOrdersByStatus(String status) {
        List<Order> orders = new ArrayList<>();
        String sql = "SELECT o.*, u.name as customer_name, u.email as customer_email, u.phone as customer_phone " +
                    "FROM orders o JOIN users u ON o.user_id = u.user_id " +
                    "WHERE o.status = ? ORDER BY o.order_date DESC";
        
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement pstmt = connection.prepareStatement(sql)) {
            
            pstmt.setString(1, status);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    orders.add(mapOrderFromResultSet(rs, connection));
                }
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Failed to get orders by status: " + status, e);
            throw new RuntimeException("Failed to retrieve orders by status", e);
        }
        return orders;
    }

    public List<Order> getOrdersByUserId(int userId) {
        List<Order> orders = new ArrayList<>();
        String sql = "SELECT o.*, u.name as customer_name, u.email as customer_email, u.phone as customer_phone " +
                    "FROM orders o JOIN users u ON o.user_id = u.user_id " +
                    "WHERE o.user_id = ? ORDER BY o.order_date DESC";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement pstmt = connection.prepareStatement(sql)) {

            pstmt.setInt(1, userId);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    orders.add(mapOrderFromResultSet(rs, connection));
                }
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Failed to get orders for user: " + userId, e);
            throw new RuntimeException("Failed to retrieve orders", e);
        }
        return orders;
    }

    public Order getOrderById(int orderId) {
        String sql = "SELECT o.*, u.name as customer_name, u.email as customer_email, u.phone as customer_phone " +
                    "FROM orders o JOIN users u ON o.user_id = u.user_id " +
                    "WHERE o.order_id = ?";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement pstmt = connection.prepareStatement(sql)) {

            pstmt.setInt(1, orderId);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return mapOrderFromResultSet(rs, connection);
                }
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Failed to get order by ID: " + orderId, e);
            throw new RuntimeException("Failed to retrieve order details", e);
        }
        return null;
    }

    public boolean verifyOrderOwnership(int orderId, int userId) {
        String sql = "SELECT 1 FROM orders WHERE order_id = ? AND user_id = ?";
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement pstmt = connection.prepareStatement(sql)) {
            pstmt.setInt(1, orderId);
            pstmt.setInt(2, userId);
            try (ResultSet rs = pstmt.executeQuery()) {
                return rs.next();
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error verifying order ownership", e);
            return false;
        }
    }

    public boolean updateOrderStatus(int orderId, String status) {
        String sql = "UPDATE orders SET status = ? WHERE order_id = ?";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement pstmt = connection.prepareStatement(sql)) {

            pstmt.setString(1, status);
            pstmt.setInt(2, orderId);
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Failed to update order status", e);
            throw new RuntimeException("Failed to update order status", e);
        }
    }

    private Order mapOrderFromResultSet(ResultSet rs, Connection connection) throws SQLException {
    Order order = new Order();
    order.setOrderId(rs.getInt("order_id"));
    order.setUserId(rs.getInt("user_id"));
    order.setOrderDate(rs.getTimestamp("order_date"));
    order.setTotalAmount(rs.getDouble("total_amount"));
    order.setStatus(rs.getString("status"));
    order.setShippingAddress(rs.getString("shipping_address"));
    order.setPaymentMethod(rs.getString("payment_method"));
    order.setEstimatedDelivery(rs.getTimestamp("estimated_delivery"));
    
    // Make customer info optional
    String customerName = rs.getString("customer_name");
    if (!rs.wasNull()) {
        order.setCustomerName(customerName);
    }
    
    String customerEmail = rs.getString("customer_email");
    if (!rs.wasNull()) {
        order.setCustomerEmail(customerEmail);
    }
    
    String customerPhone = rs.getString("customer_phone");
    if (!rs.wasNull()) {
        order.setCustomerPhone(customerPhone);
    }
    
    order.setItems(getOrderItems(connection, order.getOrderId()));
    order.setHistory(getOrderHistory(connection, order.getOrderId()));
    return order;
}

    private List<OrderItem> getOrderItems(Connection connection, int orderId) throws SQLException {
        List<OrderItem> items = new ArrayList<>();
        String sql = "SELECT order_item_id, product_id, product_name, quantity, price, size " +
                   "FROM order_items WHERE order_id = ?";

        try (PreparedStatement pstmt = connection.prepareStatement(sql)) {
            pstmt.setInt(1, orderId);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    OrderItem item = new OrderItem();
                    item.setOrderItemId(rs.getInt("order_item_id"));
                    item.setOrderId(orderId);
                    item.setProductId(rs.getInt("product_id"));
                    item.setProductName(rs.getString("product_name"));
                    item.setQuantity(rs.getInt("quantity"));
                    item.setPrice(rs.getDouble("price"));
                    item.setSize(rs.getString("size"));
                    items.add(item);
                }
            }
        }
        return items;
    }

    private List<OrderHistory> getOrderHistory(Connection connection, int orderId) throws SQLException {
        List<OrderHistory> history = new ArrayList<>();
        String sql = "SELECT timestamp, status, notes FROM order_history WHERE order_id = ? ORDER BY timestamp";

        try (PreparedStatement pstmt = connection.prepareStatement(sql)) {
            pstmt.setInt(1, orderId);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    history.add(new OrderHistory(
                        rs.getTimestamp("timestamp"),
                        rs.getString("status"),
                        rs.getString("notes")
                    ));
                }
            }
        }
        return history;
    }

    private boolean insertOrderHistory(Connection connection, int orderId, OrderHistory history) throws SQLException {
        String sql = "INSERT INTO order_history (order_id, timestamp, status, notes) VALUES (?, ?, ?, ?)";
        
        try (PreparedStatement pstmt = connection.prepareStatement(sql)) {
            pstmt.setInt(1, orderId);
            pstmt.setTimestamp(2, history.getTimestamp());
            pstmt.setString(3, history.getStatus());
            pstmt.setString(4, history.getNotes());
            return pstmt.executeUpdate() > 0;
        }
    }

    private void validateOrder(Order order) {
        if (order == null) {
            throw new IllegalArgumentException("Order cannot be null");
        }
        if (order.getUserId() <= 0) {
            throw new IllegalArgumentException("Invalid user ID");
        }
        if (order.getTotalAmount() <= 0) {
            throw new IllegalArgumentException("Order total must be positive");
        }
        if (order.getShippingAddress() == null || order.getShippingAddress().trim().isEmpty()) {
            throw new IllegalArgumentException("Shipping address is required");
        }
        if (order.getItems() == null || order.getItems().isEmpty()) {
            throw new IllegalArgumentException("Order must contain items");
        }
    }

    private int insertOrderHeader(Connection connection, Order order) throws SQLException {
        String sql = "INSERT INTO orders (user_id, total_amount, status, shipping_address, " +
                   "payment_method, order_date, estimated_delivery) VALUES (?, ?, ?, ?, ?, ?, ?)";

        try (PreparedStatement pstmt = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            pstmt.setInt(1, order.getUserId());
            pstmt.setDouble(2, order.getTotalAmount());
            pstmt.setString(3, order.getStatus());
            pstmt.setString(4, order.getShippingAddress());
            pstmt.setString(5, order.getPaymentMethod());
            pstmt.setTimestamp(6, order.getOrderDate());
            pstmt.setTimestamp(7, order.getEstimatedDelivery());

            if (pstmt.executeUpdate() == 0) {
                return 0;
            }

            try (ResultSet rs = pstmt.getGeneratedKeys()) {
                return rs.next() ? rs.getInt(1) : 0;
            }
        }
    }

    private boolean insertOrderItems(Connection connection, int orderId, List<OrderItem> items) throws SQLException {
        String sql = "INSERT INTO order_items (order_id, product_id, product_name, quantity, price, size) " +
                   "VALUES (?, ?, ?, ?, ?, ?)";

        try (PreparedStatement pstmt = connection.prepareStatement(sql)) {
            for (OrderItem item : items) {
                pstmt.setInt(1, orderId);
                pstmt.setInt(2, item.getProductId());
                pstmt.setString(3, item.getProductName());
                pstmt.setInt(4, item.getQuantity());
                pstmt.setDouble(5, item.getPrice());
                pstmt.setString(6, item.getSize());
                pstmt.addBatch();
            }

            int[] results = pstmt.executeBatch();
            for (int result : results) {
                if (result == Statement.EXECUTE_FAILED) {
                    return false;
                }
            }
            return true;
        }
    }

    private void rollbackTransaction(Connection connection) {
        try {
            if (connection != null) {
                connection.rollback();
            }
        } catch (SQLException ex) {
            logger.log(Level.SEVERE, "Transaction rollback failed", ex);
        }
    }

    private void closeConnection(Connection connection) {
        if (connection != null) {
            try {
                connection.setAutoCommit(true);
                connection.close();
            } catch (SQLException e) {
                logger.log(Level.WARNING, "Failed to close connection", e);
            }
        }
    }
    public int getTotalOrdersCount() {
    String query = "SELECT COUNT(*) FROM orders";
    try (Connection connection = DBConnection.getConnection();
         PreparedStatement ps = connection.prepareStatement(query);
         ResultSet rs = ps.executeQuery()) {
        
        if (rs.next()) {
            return rs.getInt(1);
        }
    } catch (SQLException e) {
        logger.log(Level.SEVERE, "Failed to get total orders count", e);
        throw new RuntimeException("Failed to get total orders count", e);
    }
    return 0;
}

public double getTotalRevenue() {
    String query = "SELECT SUM(total_amount) FROM orders WHERE status != 'Cancelled'";
    try (Connection connection = DBConnection.getConnection();
         PreparedStatement ps = connection.prepareStatement(query);
         ResultSet rs = ps.executeQuery()) {
        
        if (rs.next()) {
            return rs.getDouble(1);
        }
    } catch (SQLException e) {
        logger.log(Level.SEVERE, "Failed to get total revenue", e);
        throw new RuntimeException("Failed to get total revenue", e);
    }
    return 0;
}

public List<Order> getRecentOrders(int limit) {
    List<Order> orders = new ArrayList<>();
    String sql = "SELECT o.*, u.name as customer_name, u.email as customer_email, u.phone as customer_phone " +
                "FROM orders o JOIN users u ON o.user_id = u.user_id " +
                "ORDER BY o.order_date DESC LIMIT ?";
    
    try (Connection connection = DBConnection.getConnection();
         PreparedStatement pstmt = connection.prepareStatement(sql)) {
        
        pstmt.setInt(1, limit);
        try (ResultSet rs = pstmt.executeQuery()) {
            while (rs.next()) {
                orders.add(mapOrderFromResultSet(rs, connection));
            }
        }
    } catch (SQLException e) {
        logger.log(Level.SEVERE, "Failed to get recent orders", e);
        throw new RuntimeException("Failed to get recent orders", e);
    }
    return orders;
}

    public void close() {
        // Connection is managed by DBConnection utility class
    }
}