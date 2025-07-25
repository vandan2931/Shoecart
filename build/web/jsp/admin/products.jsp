<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Admin - Manage Products</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/adminproduct.css">
 <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">  
    </head>
    <body>
        <div class="admin-container">
            <jsp:include page="/jsp/admin/sidebar.jsp">
                <jsp:param name="active" value="products" />
            </jsp:include>

            <div class="content">
                <div class="header d-flex justify-content-between align-items-center mb-4">
                    <h1>Manage Products</h1>
                    <a href="${pageContext.request.contextPath}/admin/products/add" class="btn btn-primary">
                        <i class="fas fa-plus"></i> Add Product
                    </a>
                </div>

                <c:if test="${not empty success}">
                    <div class="alert alert-success">${success}</div>
                    <c:remove var="success" scope="session" />
                </c:if>
                <c:if test="${not empty error}">
                    <div class="alert alert-danger">${error}</div>
                    <c:remove var="error" scope="session" />
                </c:if>

                <div class="search-bar mb-4">
                    <form method="get" action="${pageContext.request.contextPath}/admin/products" class="d-flex">
                        <input type="text" class="form-control me-2" name="search" placeholder="Search products..." value="${param.search}">
                        <button type="submit" class="btn btn-outline-secondary"><i class="fas fa-search"></i></button>
                    </form>
                </div>

                <div class="table-responsive">
                    <table class="table table-striped table-hover">
                        <thead class="table-dark">
                            <tr>
                                <th>ID</th>
                                <th>Image</th>
                                <th>Name</th>
                                <th>Price</th>
                                <th>Stock</th>
                                <th>Category</th>
                                <th>Status</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${products}" var="product">
                                <tr>
                                    <td>${product.productId}</td>
                                    <td>
                                        <img src="${pageContext.request.contextPath}${product.imagePath}" 
                                             alt="${product.name}" style="max-height: 50px;">
                                    </td>
                                    <td>${product.name}</td>
                                    <td>$${product.price}</td>
                                    <td>${product.stockQuantity}</td>
                                    <td>${product.categoryName}</td>
                                    <td>
                                        <span class="badge ${product.status == 'Active' ? 'bg-success' : 
                                                             product.status == 'Inactive' ? 'bg-secondary' : 'bg-warning'}">
                                                  ${product.status}
                                              </span>
                                        </td>
                                        <td>
                                            <div class="d-flex gap-2">
                                                <a href="${pageContext.request.contextPath}/admin/products/edit?id=${product.productId}" 
                                                   class="btn btn-sm btn-primary"><i class="fas fa-edit"></i></a>
                                                <form method="post" action="${pageContext.request.contextPath}/admin/products/delete" 
                                                      onsubmit="return confirm('Are you sure you want to delete this product?');">
                                                    <input type="hidden" name="id" value="${product.productId}">
                                                    <button type="submit" class="btn btn-sm btn-danger"><i class="fas fa-trash"></i></button>
                                                </form>
                                            </div>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>

                    <c:if test="${totalPages > 1}">
                        <nav aria-label="Page navigation">
                            <ul class="pagination justify-content-center">
                                <c:forEach begin="1" end="${totalPages}" var="i">
                                    <li class="page-item ${i == currentPage ? 'active' : ''}">
                                        <a class="page-link" 
                                           href="${pageContext.request.contextPath}/admin/products?page=${i}<c:if test="${not empty param.search}">&search=${param.search}</c:if>">${i}</a>
                                        </li>
                                </c:forEach>
                            </ul>
                        </nav>
                    </c:if>
                </div>
            </div>

            <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        </body>
    </html>
