<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Admin Dashboard</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/sidebar.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    </head>
    <body>
        <div class="admin-container">
            <jsp:include page="/jsp/admin/sidebar.jsp">
                <jsp:param name="active" value="dashboard" />
            </jsp:include>


            <!-- Content -->
            <div class="content" id="content">
                <!-- Page Heading -->
                <div class="d-sm-flex align-items-center justify-content-between mb-4">
                    <h1 class="h3 mb-0 text-gray-800">Dashboard</h1>
                </div>

                <!-- Alert Messages -->
                <c:if test="${not empty error}">
                    <div class="alert alert-danger alert-dismissible fade show">
                        ${error}
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                </c:if>

                <!-- Stats Cards -->
                <div class="row">
                    <!-- Total Products Card -->
                    <div class="col-xl-3 col-md-6 mb-4">
                        <div class="stat-card primary">
                            <div class="icon">
                                <i class="fas fa-box-open"></i>
                            </div>
                            <h3>Total Products</h3>
                            <p>${totalProducts}</p>
                        </div>
                    </div>

                    <!-- Total Orders Card -->
                    <div class="col-xl-3 col-md-6 mb-4">
                        <div class="stat-card success">
                            <div class="icon">
                                <i class="fas fa-shopping-cart"></i>
                            </div>
                            <h3>Total Orders</h3>
                            <p>${totalOrders}</p>
                        </div>
                    </div>

                    <!-- Total Revenue Card -->
                    <div class="col-xl-3 col-md-6 mb-4">
                        <div class="stat-card warning">
                            <div class="icon">
                                <i class="fas fa-dollar-sign"></i>
                            </div>
                            <h3>Total Revenue</h3>
                            <p><fmt:formatNumber value="${totalRevenue}" type="currency"/></p>
                        </div>
                    </div>

                    <!-- Total Users Card -->
                    <div class="col-xl-3 col-md-6 mb-4">
                        <div class="stat-card danger">
                            <div class="icon">
                                <i class="fas fa-users"></i>
                            </div>
                            <h3>Total Users</h3>
                            <p>${totalUsers}</p>
                        </div>
                    </div>
                </div>

                <!-- Charts Row -->
                <div class="row">
                    <!-- Revenue Chart -->
                    <div class="col-xl-8 col-lg-7">
                        <div class="card shadow mb-4">
                            <div class="card-header py-3 d-flex flex-row align-items-center justify-content-between">
                                <h6 class="m-0 font-weight-bold text-primary">Revenue Overview</h6>
                            </div>
                            <div class="card-body">
                                <div class="chart-area">
                                    <canvas id="revenueChart"></canvas>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Pie Chart -->
                    <div class="col-xl-4 col-lg-5">
                        <div class="card shadow mb-4">
                            <div class="card-header py-3 d-flex flex-row align-items-center justify-content-between">
                                <h6 class="m-0 font-weight-bold text-primary">Revenue Sources</h6>
                            </div>
                            <div class="card-body">
                                <div class="chart-pie pt-4 pb-2">
                                    <canvas id="categoryChart"></canvas>
                                </div>
                                <div class="mt-4 text-center small">
                                    <span class="mr-2">
                                        <i class="fas fa-circle text-primary"></i> Running
                                    </span>
                                    <span class="mr-2">
                                        <i class="fas fa-circle text-success"></i> Casual
                                    </span>
                                    <span class="mr-2">
                                        <i class="fas fa-circle text-info"></i> Sports
                                    </span>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Recent Orders -->
                <div class="card shadow mb-4">
                    <div class="card-header py-3 d-flex flex-row align-items-center justify-content-between">
                        <h6 class="m-0 font-weight-bold text-primary">Recent Orders</h6>
                        <a href="${pageContext.request.contextPath}/admin/orders" class="btn btn-sm btn-primary">
                            <i class="fas fa-list"></i> View All
                        </a>
                    </div>
                    <div class="card-body">
                        <c:choose>
                            <c:when test="${not empty recentOrders and not recentOrders.isEmpty()}">
                                <div class="table-responsive">
                                    <table class="table table-bordered" width="100%" cellspacing="0">
                                        <thead>
                                            <tr>
                                                <th>Order ID</th>
                                                <th>Customer</th>
                                                <th>Date</th>
                                                <th>Amount</th>
                                                <th>Status</th>
                                                <th>Action</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach items="${recentOrders}" var="order">
                                                <tr>
                                                    <td>#${order.orderId}</td>
                                                    <td>${order.customerName}</td>
                                                    <td><fmt:formatDate value="${order.orderDate}" pattern="MMM dd, yyyy"/></td>
                                                    <td><fmt:formatNumber value="${order.totalAmount}" type="currency"/></td>
                                                    <td>
                                                        <span class="badge ${order.status == 'COMPLETED' ? 'bg-success' : 
                                                                             order.status == 'PENDING' ? 'bg-warning' : 'bg-danger'}">
                                                                  ${order.status}
                                                              </span>
                                                        </td>
                                                        <td>
                                                            <a href="${pageContext.request.contextPath}/admin/orders/details?id=${order.orderId}" 
                                                               class="btn btn-sm btn-primary">
                                                                <i class="fas fa-eye"></i> View
                                                            </a>
                                                        </td>
                                                    </tr>
                                                </c:forEach>
                                            </tbody>
                                        </table>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <div class="alert alert-info">
                                        <i class="fas fa-info-circle"></i> No recent orders found
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>
            </div>

            <!-- JavaScript Libraries -->
            <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
            <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
            <script src="${pageContext.request.contextPath}/assets/js/admin.js"></script>

            <!-- Chart Scripts -->
            <script>
                // Revenue Chart
                const revenueCtx = document.getElementById('revenueChart').getContext('2d');
                const revenueChart = new Chart(revenueCtx, {
                    type: 'line',
                    data: {
                        labels: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'],
                        datasets: [{
                                label: 'Revenue',
                                data: [5000, 8000, 12000, 15000, 18000, 20000, 22000, 25000, 21000, 18000, 16000, 20000],
                                backgroundColor: 'rgba(78, 115, 223, 0.05)',
                                borderColor: 'rgba(78, 115, 223, 1)',
                                pointBackgroundColor: 'rgba(78, 115, 223, 1)',
                                pointBorderColor: '#fff',
                                pointHoverBackgroundColor: '#fff',
                                pointHoverBorderColor: 'rgba(78, 115, 223, 1)',
                                borderWidth: 2,
                                tension: 0.3
                            }]
                    },
                    options: {
                        maintainAspectRatio: false,
                        plugins: {
                            legend: {
                                display: false
                            },
                            tooltip: {
                                backgroundColor: 'rgba(0, 0, 0, 0.8)',
                                titleFont: {
                                    size: 14
                                },
                                bodyFont: {
                                    size: 12
                                }
                            }
                        },
                        scales: {
                            y: {
                                beginAtZero: true,
                                ticks: {
                                    callback: function (value) {
                                        return '$' + value.toLocaleString();
                                    }
                                },
                                grid: {
                                    drawBorder: false
                                }
                            },
                            x: {
                                grid: {
                                    display: false
                                }
                            }
                        }
                    }
                });

                // Category Chart
                const categoryCtx = document.getElementById('categoryChart').getContext('2d');
                const categoryChart = new Chart(categoryCtx, {
                    type: 'doughnut',
                    data: {
                        labels: ['Running', 'Casual', 'Sports'],
                        datasets: [{
                                data: [55, 30, 15],
                                backgroundColor: ['#4e73df', '#1cc88a', '#36b9cc'],
                                hoverBackgroundColor: ['#2e59d9', '#17a673', '#2c9faf'],
                                hoverBorderColor: 'rgba(234, 236, 244, 1)',
                            }],
                    },
                    options: {
                        maintainAspectRatio: false,
                        plugins: {
                            legend: {
                                display: false
                            },
                            tooltip: {
                                backgroundColor: 'rgba(0, 0, 0, 0.8)',
                                bodyFont: {
                                    size: 12
                                },
                                callbacks: {
                                    label: function (context) {
                                        return context.label + ': ' + context.raw + '%';
                                    }
                                }
                            }
                        },
                        cutout: '70%',
                    },
                });
            </script>
        </body>
    </html>