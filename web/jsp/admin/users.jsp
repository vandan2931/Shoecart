<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Admin - Manage Users</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/adminuser.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/sidebar.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">




    </head>
    <body>
        <div class="admin-container">
            <jsp:include page="/jsp/admin/sidebar.jsp">
                <jsp:param name="active" value="users" />
            </jsp:include>

            <div class="content">
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <h1>Manage Users</h1>
                    <a href="${pageContext.request.contextPath}/admin/users/add" class="btn btn-primary">
                        <i class="fas fa-plus"></i> Add User
                    </a>
                </div>

                <c:if test="${not empty success}">
                    <div class="alert alert-success alert-dismissible fade show" role="alert">
                        ${success}
                        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                    </div>
                    <c:remove var="success" scope="session" />
                </c:if>
                <c:if test="${not empty error}">
                    <div class="alert alert-danger alert-dismissible fade show" role="alert">
                        ${error}
                        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                    </div>
                    <c:remove var="error" scope="session" />
                </c:if>

                <div class="card mb-4">
                    <div class="card-body">
                        <div class="row">
                            <div class="col-md-6">
                                <div class="search-container">
                                    <form method="get" action="${pageContext.request.contextPath}/admin/users" class="input-group">
                                        <input type="text" class="form-control" name="search" placeholder="Search users..." value="${param.search}">
                                        <button type="submit" class="btn btn-outline-secondary">
                                            <i class="fas fa-search"></i>
                                        </button>
                                    </form>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="dropdown float-end">
                                    <button class="btn btn-outline-secondary dropdown-toggle" type="button" id="filterDropdown" 
                                            data-bs-toggle="dropdown" aria-expanded="false">
                                        <i class="fas fa-filter"></i> Filter
                                    </button>
                                    <ul class="dropdown-menu" aria-labelledby="filterDropdown">
                                        <li><a class="dropdown-item ${empty param.role ? 'active' : ''}" 
                                               href="${pageContext.request.contextPath}/admin/users">All Users</a></li>
                                        <li><hr class="dropdown-divider"></li>
                                        <li><a class="dropdown-item ${param.role eq 'ADMIN' ? 'active' : ''}" 
                                               href="${pageContext.request.contextPath}/admin/users?role=ADMIN">Admins</a></li>
                                        <li><a class="dropdown-item ${param.role eq 'USER' ? 'active' : ''}" 
                                               href="${pageContext.request.contextPath}/admin/users?role=USER">Regular Users</a></li>
                                    </ul>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="card">
                    <div class="card-body">
                        <div class="table-responsive">
                            <table class="table table-striped table-hover">
                                <thead>
                                    <tr>
                                        <th>ID</th>
                                        <th>Name</th>
                                        <th>Email</th>
                                        <th>Role</th>
                                        <th>Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach items="${users}" var="user">
                                        <tr>
                                            <td>${user.userId}</td>
                                            <td>${user.name}</td>
                                            <td>${user.email}</td>
                                            <td>
                                                <span class="badge ${user.role == 'ADMIN' ? 'admin-badge' : 'user-badge'}">
                                                    ${user.role}
                                                </span>
                                            </td>
                                            <td>
                                                <div class="d-flex gap-2">
                                                    <a href="${pageContext.request.contextPath}/admin/users/edit?id=${user.userId}" 
                                                       class="btn btn-sm btn-primary">
                                                        <i class="fas fa-edit"></i>
                                                    </a>
                                                    <form method="post" action="${pageContext.request.contextPath}/admin/users/delete" 
                                                          onsubmit="return confirm('Are you sure you want to delete this user?');">
                                                        <input type="hidden" name="id" value="${user.userId}">
                                                        <button type="submit" class="btn btn-sm btn-danger">
                                                            <i class="fas fa-trash"></i>
                                                        </button>
                                                    </form>
                                                </div>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                    <c:if test="${empty users}">
                                        <tr>
                                            <td colspan="5" class="text-center py-4">No users found</td>
                                        </tr>
                                    </c:if>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>