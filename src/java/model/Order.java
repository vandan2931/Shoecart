package model;

import java.io.Serializable;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

public class Order implements Serializable {

    public static final String STATUS_PENDING = "Pending";
    public static final String STATUS_PROCESSING = "Processing";
    public static final String STATUS_SHIPPED = "Shipped";
    public static final String STATUS_DELIVERED = "Delivered";
    public static final String STATUS_CANCELLED = "Cancelled";

    private int orderId;
    private int userId;
    private Timestamp orderDate;
    private double totalAmount;
    private String status;
    private String shippingAddress;
    private String paymentMethod;
    private Timestamp estimatedDelivery;
    private List<OrderItem> items;
    private String customerName;
    private String customerEmail;
    private String customerPhone;
    private List<OrderHistory> history;

    public int getOrderId() {
        return orderId;
    }

    public void setOrderId(int orderId) {
        if (orderId <= 0) {
            throw new IllegalArgumentException("Order ID must be positive");
        }
        this.orderId = orderId;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        if (userId <= 0) {
            throw new IllegalArgumentException("User ID must be positive");
        }
        this.userId = userId;
    }

    public Timestamp getOrderDate() {
        return orderDate;
    }

    public void setOrderDate(Timestamp orderDate) {
        if (orderDate == null) {
            throw new IllegalArgumentException("Order date cannot be null");
        }
        this.orderDate = orderDate;
    }

    public double getTotalAmount() {
        return totalAmount;
    }

    public void setTotalAmount(double totalAmount) {
        if (totalAmount < 0) {
            throw new IllegalArgumentException("Total amount cannot be negative");
        }
        this.totalAmount = totalAmount;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        if (status == null || status.trim().isEmpty()) {
            throw new IllegalArgumentException("Status cannot be empty");
        }
        if (!status.equals(STATUS_PENDING) && !status.equals(STATUS_PROCESSING)
                && !status.equals(STATUS_SHIPPED) && !status.equals(STATUS_DELIVERED)
                && !status.equals(STATUS_CANCELLED)) {
            throw new IllegalArgumentException("Invalid order status");
        }
        this.status = status;
    }

    public String getShippingAddress() {
        return shippingAddress;
    }

    public void setShippingAddress(String shippingAddress) {
        if (shippingAddress == null || shippingAddress.trim().isEmpty()) {
            throw new IllegalArgumentException("Shipping address cannot be empty");
        }
        this.shippingAddress = shippingAddress;
    }

    public String getPaymentMethod() {
        return paymentMethod;
    }

    public void setPaymentMethod(String paymentMethod) {
        if (paymentMethod == null || paymentMethod.trim().isEmpty()) {
            throw new IllegalArgumentException("Payment method cannot be empty");
        }
        this.paymentMethod = paymentMethod;
    }

    public Timestamp getEstimatedDelivery() {
        return estimatedDelivery;
    }

    public void setEstimatedDelivery(Timestamp estimatedDelivery) {
        if (estimatedDelivery == null) {
            throw new IllegalArgumentException("Estimated delivery cannot be null");
        }
        this.estimatedDelivery = estimatedDelivery;
    }

    public List<OrderItem> getItems() {
        return items;
    }

    public void setItems(List<OrderItem> items) {
        if (items == null || items.isEmpty()) {
            throw new IllegalArgumentException("Order must contain items");
        }
        this.items = items;
    }

    public String getCustomerName() {
        return customerName;
    }

    public void setCustomerName(String customerName) {
        if (customerName == null || customerName.trim().isEmpty()) {
            throw new IllegalArgumentException("Customer name cannot be empty");
        }
        this.customerName = customerName;
    }

   public String getCustomerEmail() {
        return customerEmail;
    }

    public void setCustomerEmail(String customerEmail) {
        // Make email validation optional for display purposes
        if (customerEmail == null || customerEmail.trim().isEmpty()) {
            this.customerEmail = "";
            return;
        }
        this.customerEmail = customerEmail;
    }


    public String getCustomerPhone() {
        return customerPhone;
    }

    public void setCustomerPhone(String customerPhone) {
        if (customerPhone == null || customerPhone.trim().isEmpty()) {
            throw new IllegalArgumentException("Customer phone cannot be empty");
        }
        if (!customerPhone.matches("^[\\d()+-]+$")) {
            throw new IllegalArgumentException("Invalid phone number format");
        }
        this.customerPhone = customerPhone;
    }

    public List<OrderHistory> getHistory() {
        return history;
    }

    public void setHistory(List<OrderHistory> history) {
        this.history = history;
    }

    public int getItemCount() {
        return items != null ? items.size() : 0;
    }

    public boolean isCancellable() {
        return STATUS_PROCESSING.equals(status) || STATUS_PENDING.equals(status);
    }

    public boolean isShipped() {
        return STATUS_SHIPPED.equals(status);
    }

    public boolean isDelivered() {
        return STATUS_DELIVERED.equals(status);
    }

    public boolean isCancelled() {
        return STATUS_CANCELLED.equals(status);
    }

    public void calculateTotalAmount() {
        if (items == null || items.isEmpty()) {
            this.totalAmount = 0;
            return;
        }

        double total = 0;
        for (OrderItem item : items) {
            total += item.getPrice() * item.getQuantity();
        }
        this.totalAmount = total;
    }

    @Override
    public String toString() {
        return "Order{"
                + "orderId=" + orderId
                + ", userId=" + userId
                + ", orderDate=" + orderDate
                + ", totalAmount=" + totalAmount
                + ", status='" + status + '\''
                + ", shippingAddress='" + shippingAddress + '\''
                + ", paymentMethod='" + paymentMethod + '\''
                + ", estimatedDelivery=" + estimatedDelivery
                + ", itemCount=" + getItemCount()
                + ", customerName='" + customerName + '\''
                + '}';
    }

    public void addHistoryEntry(OrderHistory history) {
        if (history == null) {
            throw new IllegalArgumentException("History entry cannot be null");
        }
        if (this.history == null) {
            this.history = new ArrayList<>();
        }
        this.history.add(history);
    }
}
