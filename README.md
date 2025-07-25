# 🚀 ShoeCart - E-Commerce Platform for Footwear

ShoeCart is a full-featured e-commerce web application specializing in footwear, built using Java technologies, JSP/Servlets, and MySQL. It provides both customers and administrators with a smooth, interactive experience.

## 📽️ Live Demo

▶️ [Click here to watch the live demo](https://drive.google.com/drive/folders/1OYhIW2X4pgRwrWWTbFji0u-_XETQBLUx?usp=drive_link)

> This video showcases the entire functionality of ShoeCart — including user login, product browsing, cart management, and the admin dashboard.

---

## ✨ Features

### 🛍️ Shopping Experience
- Product listing with images, prices, and descriptions
- Add to cart, update quantity, and remove items
- Real-time cart summary
- Checkout and order placement

### 👤 User System
- Secure login and signup
- Profile view and order tracking
- Session-based authentication

### 🧑‍💼 Admin Panel
- Add, update, and delete products
- View all orders and manage inventory
- Simple dashboard for tracking system activity

---

## 🛠️ Tech Stack

### Frontend
- HTML5, CSS3 (with Bootstrap 5)
- JavaScript (Vanilla + Fetch API)
- JSP for dynamic rendering

### Backend
- Java Servlets and JSP
- JDBC for database access
- JSTL for server-side logic

### Database
- MySQL (user data, products, orders)

### Infrastructure
- Apache Tomcat 9
- Maven for build and dependency management

---

## 🚀 Getting Started

### Prerequisites
- Java JDK 11+
- Apache Tomcat 9+
- MySQL 8+
- Maven 3.6+

### Installation Steps

1. **Clone the repository**
   ```bash
   git clone https://github.com/vandan2931/Shoecart.git
   cd Shoecart
````

2. **Set up the database**

   ```bash
   mysql -u root -p < db/shoecart.sql
   ```

3. **Configure database credentials**

   * Locate `db.properties` (or `DatabaseConnection.java`) and update with your DB user, password, and URL.

4. **Build and deploy**

   ```bash
   mvn clean package
   cp target/Shoecart.war /path/to/tomcat/webapps/
   ```

5. **Run the server**

   * Start Tomcat and go to `http://localhost:8080/Shoecart`

---

## 📂 Project Structure

```
Shoecart/
├── src/
│   ├── main/
│   │   ├── java/
│   │   │   ├── com/shoecart/controller/   # Servlets
│   │   │   ├── com/shoecart/dao/          # DAO classes
│   │   │   ├── com/shoecart/model/        # POJOs
│   │   │   └── com/shoecart/util/         # Utility classes
│   │   ├── resources/
│   │   │   └── db.properties              # DB config
│   │   └── webapp/
│   │       ├── assets/                    # Images, CSS, JS
│   │       ├── WEB-INF/                   # Config files
│   │       └── jsp/                       # JSP pages
├── database/
│   └── shoecart.sql                       # Database schema
├── web.xml                                # Maven config
└── README.md
```

---

## 🤝 Contributing

We welcome contributions! Here's how:

1. Fork the project
2. Create your feature branch

   ```bash
   git checkout -b feature/YourFeatureName
   ```
3. Commit your changes

   ```bash
   git commit -m "Add your message"
   ```
4. Push the branch

   ```bash
   git push origin feature/YourFeatureName
   ```
5. Open a Pull Request

---

## 📄 License

Distributed under the MIT License. See `LICENSE` for more details.

---

## 📧 Contact

Maintained by: **Vandan Shah**
📧 Email: [vandan2931@gmail.com](mailto:vandan2931@gmail.com)
🔗 GitHub: [https://github.com/vandan2931/Shoecart](https://github.com/vandan2931/Shoecart)
