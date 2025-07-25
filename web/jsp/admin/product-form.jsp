<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>${not empty editMode ? 'Edit' : 'Add'} Product</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/adminproduct.css">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    </head>
    <body>
        <div class="admin-container">
            <jsp:include page="/jsp/admin/sidebar.jsp">
                <jsp:param name="active" value="products" />
            </jsp:include>

          

            <!-- Content -->
            <div class="content" id="content">
                <!-- Page Heading -->
                <div class="d-sm-flex align-items-center justify-content-between mb-4">
                    <h1 class="h3 mb-0 text-gray-800">${not empty editMode ? 'Edit' : 'Add'} Product</h1>
                    <a href="${pageContext.request.contextPath}/admin/products" class="d-none d-sm-inline-block btn btn-sm btn-secondary shadow-sm">
                        <i class="fas fa-arrow-left fa-sm text-white-50"></i> Back to Products
                    </a>
                </div>

                <!-- Alert Messages -->
                <c:if test="${not empty error}">
                    <div class="alert alert-danger alert-dismissible fade show">
                        ${error}
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                </c:if>

                <!-- Product Form -->
                <div class="card shadow mb-4">
                    <div class="card-body">
                        <form method="post" action="${pageContext.request.contextPath}/admin/products/${not empty editMode ? 'edit' : 'add'}" 
                              enctype="multipart/form-data" class="product-form">
                            <c:if test="${not empty editMode}">
                                <input type="hidden" name="productId" value="${product.productId}">
                            </c:if>

                            <div class="row">
                                <div class="col-md-6">
                                    <!-- Product Name -->
                                    <div class="form-group">
                                        <label for="name" class="form-label">Product Name</label>
                                        <input type="text" class="form-control" id="name" name="name" 
                                               value="${product.name}" required>
                                    </div>

                                    <!-- Description -->
                                    <div class="form-group">
                                        <label for="description" class="form-label">Description</label>
                                        <textarea class="form-control" id="description" name="description" 
                                                  rows="4">${product.description}</textarea>
                                    </div>

                                    <!-- Price -->
                                    <div class="form-group">
                                        <label for="price" class="form-label">Price ($)</label>
                                        <input type="number" class="form-control" id="price" name="price" 
                                               step="0.01" min="0" value="${product.price}" required>
                                    </div>
                                </div>

                                <div class="col-md-6">
                                    <!-- Product Image -->
                                    <div class="form-group">
                                        <label for="image" class="form-label">Product Image</label>
                                        <input type="file" class="form-control" id="image" name="image" 
                                               accept="image/png, image/jpeg, image/jpg, image/webp"
                                               ${empty editMode ? 'required' : ''}>
                                        <small class="text-muted">Allowed formats: PNG, JPG, JPEG, WEBP. Max size: 10MB</small>
                                        
                                        <c:if test="${not empty editMode && not empty product.imagePath}">
                                            <div class="mt-3">
                                                <img src="${pageContext.request.contextPath}${product.imagePath}" 
                                                     alt="Current Product Image" class="product-form-image-preview">
                                                <div class="form-check mt-2">
                                                    <input class="form-check-input" type="checkbox" id="keepImage" name="keepImage" value="true">
                                                    <label class="form-check-label" for="keepImage">Keep current image</label>
                                                </div>
                                            </div>
                                        </c:if>
                                    </div>

                                    <!-- Category -->
                                    <div class="form-group">
                                        <label for="categoryId" class="form-label">Category</label>
                                        <select class="form-select" id="categoryId" name="categoryId" required>
                                            <option value="1" ${product.categoryId == 1 ? 'selected' : ''}>Running</option>
                                            <option value="2" ${product.categoryId == 2 ? 'selected' : ''}>Casual</option>
                                            <option value="3" ${product.categoryId == 3 ? 'selected' : ''}>Sports</option>
                                            <option value="4" ${product.categoryId == 4 ? 'selected' : ''}>Formal</option>
                                        </select>
                                    </div>
                                </div>
                            </div>

                            <div class="row">
                                <div class="col-md-6">
                                    <!-- Stock Quantity -->
                                    <div class="form-group">
                                        <label for="stockQuantity" class="form-label">Stock Quantity</label>
                                        <input type="number" class="form-control" id="stockQuantity" name="stockQuantity" 
                                               min="0" value="${product.stockQuantity}" required>
                                    </div>
                                </div>

                                <div class="col-md-6">
                                    <!-- Status -->
                                    <div class="form-group">
                                        <label for="status" class="form-label">Status</label>
                                        <select class="form-select" id="status" name="status" required>
                                            <option value="Active" ${product.status == 'Active' ? 'selected' : ''}>Active</option>
                                            <option value="Inactive" ${product.status == 'Inactive' ? 'selected' : ''}>Inactive</option>
                                            <option value="Out of Stock" ${product.status == 'Out of Stock' ? 'selected' : ''}>Out of Stock</option>
                                        </select>
                                    </div>
                                </div>
                            </div>

                            <!-- Available Sizes -->
                            <div class="form-group">
                                <label class="form-label">Available Sizes</label>
                                <div class="size-selector">
                                    <div class="size-option">
                                        <input type="checkbox" id="size6" name="sizes" value="6" 
                                               ${product.sizes.contains('6') ? 'checked' : ''}>
                                        <label for="size6">6</label>
                                    </div>
                                    <div class="size-option">
                                        <input type="checkbox" id="size7" name="sizes" value="7" 
                                               ${product.sizes.contains('7') ? 'checked' : ''}>
                                        <label for="size7">7</label>
                                    </div>
                                    <div class="size-option">
                                        <input type="checkbox" id="size8" name="sizes" value="8" 
                                               ${product.sizes.contains('8') ? 'checked' : ''}>
                                        <label for="size8">8</label>
                                    </div>
                                    <div class="size-option">
                                        <input type="checkbox" id="size9" name="sizes" value="9" 
                                               ${product.sizes.contains('9') ? 'checked' : ''}>
                                        <label for="size9">9</label>
                                    </div>
                                    <div class="size-option">
                                        <input type="checkbox" id="size10" name="sizes" value="10" 
                                               ${product.sizes.contains('10') ? 'checked' : ''}>
                                        <label for="size10">10</label>
                                    </div>
                                </div>
                            </div>

                            <!-- Form Actions -->
                            <div class="form-actions mt-4">
                                <button type="submit" class="btn btn-primary">
                                    <i class="fas fa-save"></i> ${not empty editMode ? 'Update' : 'Save'} Product
                                </button>
                                <a href="${pageContext.request.contextPath}/admin/products" class="btn btn-secondary">
                                    <i class="fas fa-times"></i> Cancel
                                </a>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>

        <!-- JavaScript Libraries -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/admin.js"></script>
        
        <!-- Image Preview Script -->
        <script>
            document.getElementById('image').addEventListener('change', function(e) {
                if (this.files && this.files[0]) {
                    const reader = new FileReader();
                    reader.onload = function(e) {
                        const preview = document.querySelector('.product-form-image-preview');
                        if (preview) {
                            preview.src = e.target.result;
                        } else {
                            const container = document.querySelector('.form-group');
                            const img = document.createElement('img');
                            img.src = e.target.result;
                            img.className = 'product-form-image-preview mt-3';
                            container.appendChild(img);
                        }
                        
                        const keepImageCheckbox = document.getElementById('keepImage');
                        if (keepImageCheckbox) {
                            keepImageCheckbox.checked = false;
                        }
                    }
                    reader.readAsDataURL(this.files[0]);
                }
            });
        </script>
    </body>
</html>