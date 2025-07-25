package model;

import java.io.Serializable;
import java.sql.Timestamp;

public class User implements Serializable {
    private int userId;
    private String name;
    private String email;
    private String password;
    private String phone;
    private String address;
    private String role;
    private Timestamp createdAt;

    public User() {
        this.role = "customer";
    }

    public User(String name, String email, String password) {
        this();
        this.name = name;
        this.email = email;
        this.password = password;
    }

    // Getters and Setters with validation
    public int getUserId() { return userId; }
    public void setUserId(int userId) { 
        if (userId <= 0) {
            throw new IllegalArgumentException("User ID must be positive");
        }
        this.userId = userId; 
    }

    public String getName() { return name; }
    public void setName(String name) { 
        if (name == null || name.trim().isEmpty()) {
            throw new IllegalArgumentException("Name cannot be empty");
        }
        this.name = name.trim(); 
    }

    public String getEmail() { return email; }
    public void setEmail(String email) { 
        if (email == null || email.trim().isEmpty()) {
            throw new IllegalArgumentException("Email cannot be empty");
        }
        this.email = email.toLowerCase().trim();
    }

    public String getPassword() { return password; }
    public void setPassword(String password) { 
        if (password == null || password.trim().isEmpty()) {
            throw new IllegalArgumentException("Password cannot be empty");
        }
        this.password = password; 
    }

    public String getPhone() { return phone; }
    public void setPhone(String phone) { 
        this.phone = phone != null ? phone.trim() : null; 
    }

    public String getAddress() { return address; }
    public void setAddress(String address) { 
        this.address = address != null ? address.trim() : null; 
    }

    public String getRole() { return role; }
    public void setRole(String role) { 
        this.role = (role != null && (role.equals("admin") || role.equals("customer"))) ? 
                    role : "customer"; 
    }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { 
        this.createdAt = createdAt; 
    }
}