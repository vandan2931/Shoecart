package model;

import java.io.Serializable;
import java.util.List;

public class Product implements Serializable {
    public static final String STATUS_ACTIVE = "Active";
    public static final String STATUS_INACTIVE = "Inactive";
    public static final String STATUS_OUT_OF_STOCK = "Out of Stock";

    private int productId;
    private String name;
    private String description;
    private double price;
    private String imagePath;
    private int categoryId;
    private int stockQuantity;
    private List<String> sizes;
    private String categoryName;
    private String status;

    public Product() {}

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
            throw new IllegalArgumentException("Product name cannot be empty");
        }
        this.name = name; 
    }
    
    public String getDescription() { return description; }
    public void setDescription(String description) { 
        this.description = description; 
    }
    
    public double getPrice() { return price; }
    public void setPrice(double price) { 
        if (price < 0) {
            throw new IllegalArgumentException("Price cannot be negative");
        }
        this.price = price; 
    }
    
    public String getImagePath() { return imagePath; }
    public void setImagePath(String imagePath) { 
        this.imagePath = imagePath; 
    }
    
    public int getCategoryId() { return categoryId; }
    public void setCategoryId(int categoryId) { 
        if (categoryId <= 0) {
            throw new IllegalArgumentException("Category ID must be positive");
        }
        this.categoryId = categoryId; 
    }
    
    public int getStockQuantity() { return stockQuantity; }
    public void setStockQuantity(int stockQuantity) { 
        if (stockQuantity < 0) {
            throw new IllegalArgumentException("Stock quantity cannot be negative");
        }
        this.stockQuantity = stockQuantity; 
    }
    
    public List<String> getSizes() { return sizes; }
    public void setSizes(List<String> sizes) { 
        if (sizes == null || sizes.isEmpty()) {
            throw new IllegalArgumentException("Product must have at least one size");
        }
        this.sizes = sizes; 
    }
    
    public String getCategoryName() { return categoryName; }
    public void setCategoryName(String categoryName) { 
        this.categoryName = categoryName; 
    }
    
    public String getStatus() { return status; }
    public void setStatus(String status) { 
        if (status == null || status.trim().isEmpty()) {
            throw new IllegalArgumentException("Status cannot be empty");
        }
        if (!status.equals(STATUS_ACTIVE) && !status.equals(STATUS_INACTIVE) && 
            !status.equals(STATUS_OUT_OF_STOCK)) {
            throw new IllegalArgumentException("Invalid product status");
        }
        this.status = status; 
    }

    public boolean isAvailableInSize(String size) {
        return sizes != null && sizes.contains(size);
    }

    @Override
    public String toString() {
        return "Product{" +
                "productId=" + productId +
                ", name='" + name + '\'' +
                ", price=" + price +
                ", stockQuantity=" + stockQuantity +
                ", categoryName='" + categoryName + '\'' +
                ", status='" + status + '\'' +
                '}';
    }
}