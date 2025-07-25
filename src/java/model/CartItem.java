package model;

import java.io.Serializable;

public class CartItem implements Serializable {
    private int cartItemId;
    private int productId;
    private String name;
    private String size;
    private double price;
    private int quantity;
    private String imagePath;

    // Getters and Setters
    public int getCartItemId() { return cartItemId; }
    public void setCartItemId(int cartItemId) { 
        if (cartItemId <= 0) {
            throw new IllegalArgumentException("CartItem ID must be positive");
        }
        this.cartItemId = cartItemId; 
    }
    
    public int getProductId() { return productId; }
    public void setProductId(int productId) { 
        if (productId <= 0) {
            throw new IllegalArgumentException("Product ID must be positive");
        }
        this.productId = productId; 
    }
    
    public String getName() { return name; }
    public void setName(String name) { 
        if (name == null || name.trim().isEmpty()) {
            throw new IllegalArgumentException("Name cannot be empty");
        }
        this.name = name; 
    }
    
    public String getSize() { return size; }
    public void setSize(String size) { 
        this.size = size; // Size can be null for products without size options
    }
    
    public double getPrice() { return price; }
    public void setPrice(double price) { 
        if (price < 0) {
            throw new IllegalArgumentException("Price cannot be negative");
        }
        this.price = price; 
    }
    
    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { 
        if (quantity <= 0) {
            throw new IllegalArgumentException("Quantity must be positive");
        }
        this.quantity = quantity; 
    }
    
    public String getImagePath() { return imagePath; }
    public void setImagePath(String imagePath) { 
        this.imagePath = imagePath; 
    }

    // Helper method to calculate item total
    public double getItemTotal() {
        return price * quantity;
    }
}