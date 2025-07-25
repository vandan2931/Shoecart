package model;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

public class Cart implements Serializable {
    private int cartId;
    private int userId;
    private List<CartItem> items;
    private double total;

    public Cart() {
        this.items = new ArrayList<>();
        this.total = 0.0;
    }

    // Getters and Setters
    public int getCartId() { return cartId; }
    public void setCartId(int cartId) { this.cartId = cartId; }
    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }
    public List<CartItem> getItems() { return new ArrayList<>(items); }
    public void setItems(List<CartItem> items) { 
        this.items = new ArrayList<>(items);
        calculateTotal();
    }
    public double getTotal() { return total; }
    public void setTotal(double total) { this.total = total; }

    // Helper methods
    public void addItem(CartItem item) {
        if (item == null) return;
        items.add(item);
        calculateTotal();
    }

    public void removeItem(int productId, String size) {
        items.removeIf(item -> 
            item.getProductId() == productId && 
            (size == null || item.getSize().equals(size)));
        calculateTotal();
    }

    public void updateQuantity(int productId, String size, int quantity) {
        if (quantity <= 0) {
            removeItem(productId, size);
            return;
        }

        for (CartItem item : items) {
            if (item.getProductId() == productId && 
                (size == null || item.getSize().equals(size))) {
                item.setQuantity(quantity);
                break;
            }
        }
        calculateTotal();
    }

    private void calculateTotal() {
        total = items.stream()
            .mapToDouble(item -> item.getPrice() * item.getQuantity())
            .sum();
    }

    public int getTotalItems() {
        return items.stream()
            .mapToInt(CartItem::getQuantity)
            .sum();
    }
}