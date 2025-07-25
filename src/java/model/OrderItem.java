package model;

import java.io.Serializable;

public class OrderItem implements Serializable {
    private int orderItemId;
    private int orderId;
    private int productId;
    private String productName;
    private int quantity;
    private double price;
    private String size;

    // Getters and Setters with validation
    public int getOrderItemId() { return orderItemId; }
    public void setOrderItemId(int orderItemId) { 
        if (orderItemId <= 0) {
            throw new IllegalArgumentException("Order item ID must be positive");
        }
        this.orderItemId = orderItemId; 
    }
    
    public int getOrderId() { return orderId; }
    public void setOrderId(int orderId) { 
        if (orderId <= 0) {
            throw new IllegalArgumentException("Order ID must be positive");
        }
        this.orderId = orderId; 
    }
    
    public int getProductId() { return productId; }
    public void setProductId(int productId) { 
        if (productId <= 0) {
            throw new IllegalArgumentException("Product ID must be positive");
        }
        this.productId = productId; 
    }
    
    public String getProductName() { return productName; }
    public void setProductName(String productName) { 
        if (productName == null || productName.trim().isEmpty()) {
            throw new IllegalArgumentException("Product name cannot be empty");
        }
        this.productName = productName; 
    }
    
    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { 
        if (quantity <= 0) {
            throw new IllegalArgumentException("Quantity must be positive");
        }
        this.quantity = quantity; 
    }
    
    public double getPrice() { return price; }
    public void setPrice(double price) { 
        if (price <= 0) {
            throw new IllegalArgumentException("Price must be positive");
        }
        this.price = price; 
    }
    
    public String getSize() { return size; }
    public void setSize(String size) { 
        this.size = size; // Size can be null for products without size options
    }
    
    // Helper method
    public double getTotalPrice() {
        return price * quantity;
    }

    public void setImagePath(String string) {
        throw new UnsupportedOperationException("Not supported yet."); //To change body of generated methods, choose Tools | Templates.
    }

    public String getImagePath() {
        throw new UnsupportedOperationException("Not supported yet."); //To change body of generated methods, choose Tools | Templates.
    }
}