package dao;

import model.OrderHistory;
import util.DBConnection;
import java.sql.*;
import java.util.logging.Level;
import java.util.logging.Logger;

public class OrderHistoryDAO {
    private static final Logger logger = Logger.getLogger(OrderHistoryDAO.class.getName());

    public boolean addHistoryEntry(int orderId, OrderHistory history) {
        String sql = "INSERT INTO order_history (order_id, timestamp, status, notes) VALUES (?, ?, ?, ?)";
        
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement pstmt = connection.prepareStatement(sql)) {
            
            pstmt.setInt(1, orderId);
            pstmt.setTimestamp(2, history.getTimestamp());
            pstmt.setString(3, history.getStatus());
            pstmt.setString(4, history.getNotes());
            
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Failed to add order history entry", e);
            return false;
        }
    }

    public void close() {
        // Connection is managed by DBConnection utility class
    }
}