<%@page contentType="text/html" pageEncoding="UTF-8"%>
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/sidebar.css">
<div class="sidebar">
    <!-- Sidebar Brand -->
    <a href="${pageContext.request.contextPath}/admin/dashboard" class="sidebar-brand d-flex align-items-center justify-content-center">
        <div class="sidebar-brand-icon">
            <i class="fas fa-shoe-prints"></i>
        </div>
        <div class="sidebar-brand-text mx-3">ShoeCart Admin</div>
    </a>

    <!-- Divider -->
    <hr class="sidebar-divider my-0">

    <!-- Nav Items -->
    <ul class="menu">
        <!-- Dashboard -->
        <li class="nav-item">
            <a href="${pageContext.request.contextPath}/admin/dashboard" class="nav-link ${param.active == 'dashboard' ? 'active' : ''}">
                <i class="fas fa-fw fa-tachometer-alt"></i>
                <span>Dashboard</span>
            </a>
        </li>

        <!-- Divider -->
        <hr class="sidebar-divider">

        <!-- Products -->
        <li class="nav-item">
            <a href="${pageContext.request.contextPath}/admin/products" class="nav-link ${param.active == 'products' ? 'active' : ''}">
                <i class="fas fa-fw fa-box-open"></i>
                <span>Products</span>
            </a>
        </li>

        <!-- Orders -->
        <li class="nav-item">
            <a href="${pageContext.request.contextPath}/admin/orders" class="nav-link ${param.active == 'orders' ? 'active' : ''}">
                <i class="fas fa-fw fa-shopping-cart"></i>
                <span>Orders</span>
            </a>
        </li>

        <!-- Users -->
        <li class="nav-item">
            <a href="${pageContext.request.contextPath}/admin/users" class="nav-link ${param.active == 'users' ? 'active' : ''}">
                <i class="fas fa-fw fa-users"></i>
                <span>Users</span>
            </a>
        </li>

        <!-- Divider -->
        <hr class="sidebar-divider d-none d-md-block">

        <!-- Logout -->
        <li class="nav-item">
            <a href="${pageContext.request.contextPath}/logout" class="nav-link">
                <i class="fas fa-fw fa-sign-out-alt"></i>
                <span>Logout</span>
            </a>
        </li>
    </ul>
</div>