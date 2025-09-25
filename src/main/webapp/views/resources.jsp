<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Available Resources</title>
    <jsp:include page="../common/bootstrap.jsp" />
    <style>
        .container { max-width: 900px; margin-top: 40px; }
        .resource-card { margin-bottom: 24px; }
        .resource-title { font-size: 1.2rem; font-weight: 700; color: #2563eb; }
        .resource-meta { color: #64748b; font-size: 0.98rem; }
    </style>
</head>
<body>
<div class="container">
    <h2 class="mb-4">Available Resources</h2>

    <!-- Subject Navigation Links -->
    <c:if test="${not empty subjects}">
        <div class="mb-3">
            <span style="font-weight:600;">Browse by Subject:</span>
            <a href="${pageContext.request.contextPath}/resources" class="btn btn-outline-primary btn-sm mx-1 <c:if test='${empty param.subject}'>active</c:if>'">All</a>
            <c:forEach var="s" items="${subjects}">
                <a href="${pageContext.request.contextPath}/resources?subject=${s}" class="btn btn-outline-primary btn-sm mx-1 <c:if test='${param.subject == s}'>active</c:if>'">${s}</a>
            </c:forEach>
        </div>
    </c:if>

    <form method="get" action="${pageContext.request.contextPath}/resources" class="mb-4" id="resourceFilterForm">
    <div class="row g-2 align-items-end">
            <div class="col-md-3">
                <label for="search" class="form-label">Search Title/Subject</label>
                <input type="text" class="form-control" id="search" name="search" value="${param.search != null ? param.search : ''}">
            </div>
            <div class="col-md-2">
                <label for="grade" class="form-label">Grade</label>
                <select class="form-select" id="grade" name="grade">
                    <option value="">All</option>
                    <c:forEach var="g" items="${grades}">
                        <option value="${g}" ${(param.grade != null && param.grade == g) ? 'selected' : ''}>
                            <c:choose>
                                <c:when test="${userGrade == g}">
                                    ${g} (my class)
                                </c:when>
                                <c:otherwise>
                                    ${g}
                                </c:otherwise>
                            </c:choose>
                        </option>
                    </c:forEach>
                </select>
            </div>
            <div class="col-md-2">
                <label for="subject" class="form-label">Subject</label>
                <select class="form-select" id="subject" name="subject">
                    <option value="">All</option>
                    <c:forEach var="s" items="${subjects}">
                        <option value="${s}" ${(param.subject != null && param.subject == s) ? 'selected' : ''}>${s}</option>
                    </c:forEach>
                </select>
            </div>
            <!-- Stream dropdown: only show for grades 11/12 -->
            <c:if test="${not empty streams}">
            <div class="col-md-2">
                <label for="stream" class="form-label">Stream</label>
                <select class="form-select" id="stream" name="stream">
                    <option value="">All</option>
                    <c:forEach var="streamName" items="${streams}">
                        <option value="${streamName}" ${(selectedStream != null && selectedStream == streamName) ? 'selected' : ''}>${streamName}</option>
                    </c:forEach>
                </select>
            </div>
            </c:if>
                </select>
            </div>
            <div class="col-md-2">
                <label for="type" class="form-label">Type</label>
                <select class="form-select" id="type" name="type">
                    <option value="">All</option>
                    <option value="PDF" ${(param.type != null && param.type == 'PDF') ? 'selected' : ''}>PDF</option>
                    <option value="Video" ${(param.type != null && param.type == 'Video') ? 'selected' : ''}>Video</option>
                    <option value="Quiz" ${(param.type != null && param.type == 'Quiz') ? 'selected' : ''}>Quiz</option>
                </select>
            </div>
            <div class="col-md-2">
                <label for="language" class="form-label">Language</label>
                <select class="form-select" id="language" name="language">
                    <option value="">All</option>
                    <option value="English" ${(param.language != null && param.language == 'English') ? 'selected' : ''}>English</option>
                    <option value="Tamil" ${(param.language != null && param.language == 'Tamil') ? 'selected' : ''}>Tamil</option>
                </select>
            </div>
            <div class="col-md-1 d-flex flex-column align-items-stretch gap-2">
                <button type="submit" class="btn btn-primary w-100">Filter</button>
                <button type="button" class="btn btn-secondary w-100" id="clearFiltersBtn">Clear Filters</button>
            </div>
        </div>
    </form>
    <script>
    // Remove empty params and 'All' from filter form submission
    document.getElementById('resourceFilterForm').addEventListener('submit', function(e) {
        var form = e.target;
        var inputs = form.querySelectorAll('input, select');
        inputs.forEach(function(input) {
            // For grade, treat empty as 'All' and do not submit
            if ((input.name === 'grade' && input.value === '') || input.value === '') {
                input.disabled = true;
            }
        });
        setTimeout(function() {
            inputs.forEach(function(input) { input.disabled = false; });
        }, 100);
    });

    // Clear Filters button
    document.getElementById('clearFiltersBtn').addEventListener('click', function() {
        window.location.href = "${pageContext.request.contextPath}/resources";
    });
    </script>
    <c:choose>
        <c:when test="${empty resources}">
            <div class="alert alert-info">No resources available for your class at this time.</div>
        </c:when>
        <c:otherwise>
            <div class="row">
                <c:forEach var="resource" items="${resources}">
                    <div class="col-md-6">
                        <div class="card resource-card">
                            <div class="card-body">
                                <div class="resource-title">${resource.title}</div>
                                <div class="resource-meta">
                                    Grade: ${resource.grade} | Subject: ${resource.subject} | Type: ${resource.type} | Language: ${resource.language}
                                </div>
                                <a href="${pageContext.request.contextPath}/view-resource?id=${resource.id}" class="btn btn-primary btn-sm mt-3">View Resource</a>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </c:otherwise>
    </c:choose>
    <a href="<%= request.getContextPath() %>/views/studentDashboard.jsp" class="btn btn-link mt-4">Back to Dashboard</a>
</div>
</body>
</html>
