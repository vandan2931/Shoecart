<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Error - ShoeCart</title>
    <style>
        body { font-family: Arial, sans-serif; text-align: center; padding: 50px; background-color: #f5f5f5; }
        .error-container { max-width: 600px; margin: 0 auto; padding: 30px; background: white; 
                         border-radius: 8px; box-shadow: 0 0 10px rgba(0,0,0,0.1); }
        h1 { color: #d9534f; margin-bottom: 20px; }
        .error-message { margin-bottom: 30px; font-size: 1.1em; }
        .actions { margin-top: 30px; }
        .btn { display: inline-block; padding: 10px 20px; margin: 0 10px; 
              background-color: #0066cc; color: white; text-decoration: none; 
              border-radius: 4px; }
        .btn:hover { background-color: #0052a3; }
    </style>
</head>
<body>
    <div class="error-container">
        <h1>Oops! Something went wrong</h1>
        <div class="error-message">
            <c:choose>
                <c:when test="${not empty error}">
                    <p><c:out value="${error}"/></p>
                </c:when>
                <c:otherwise>
                    <p>We're sorry, but an unexpected error occurred.</p>
                </c:otherwise>
            </c:choose>
        </div>
        <div class="actions">
            <a href="${pageContext.request.contextPath}/" class="btn">Home</a>
            <a href="${pageContext.request.contextPath}/products" class="btn">Products</a>
            <a href="javascript:history.back()" class="btn">Go Back</a>
        </div>
    </div>
</body>
</html>