package model;

import java.io.Serializable;
import java.sql.Timestamp;

public class OrderHistory implements Serializable {
    private Timestamp timestamp;
    private String status;
    private String notes;

    // Constructor
    public OrderHistory(Timestamp timestamp, String status, String notes) {
        setTimestamp(timestamp);
        setStatus(status);
        setNotes(notes);
    }

    // Getters and Setters with validation
    public Timestamp getTimestamp() {
        return timestamp;
    }

    public void setTimestamp(Timestamp timestamp) {
        if (timestamp == null) {
            throw new IllegalArgumentException("Timestamp cannot be null");
        }
        this.timestamp = timestamp;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        if (status == null || status.trim().isEmpty()) {
            throw new IllegalArgumentException("Status cannot be empty");
        }
        this.status = status;
    }

    public String getNotes() {
        return notes;
    }

    public void setNotes(String notes) {
        // Notes can be null or empty (optional field)
        this.notes = notes;
    }

    @Override
    public String toString() {
        return "OrderHistory{" +
                "timestamp=" + timestamp +
                ", status='" + status + '\'' +
                ", notes='" + notes + '\'' +
                '}';
    }
}