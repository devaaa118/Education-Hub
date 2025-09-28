<%-- File: src/main/webapp/views/myResources.jsp --%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>My Uploaded Resources</title>
    <jsp:include page="../common/bootstrap.jsp" />
    <style>
        .container {
            max-width: 1100px;
            margin-top: 30px;
        }
        .filters .form-group {
            margin-bottom: 15px;
        }
        .table-responsive {
            margin-top: 25px;
        }
    </style>
</head>
<body>
    <jsp:include page="../common/googleTranslateWidget.jspf" />
    <div class="container">
        <div class="d-flex justify-content-between align-items-center mb-3">
            <h2>My Resources</h2>
            <a href="${pageContext.request.contextPath}/teacher/library" class="btn btn-primary">Open Library</a>
        </div>

        <c:if test="${param.updated eq '1'}">
            <div class="alert alert-success" role="alert">Resource updated successfully.</div>
        </c:if>
        <c:if test="${param.deleted eq '1'}">
            <div class="alert alert-success" role="alert">Resource deleted successfully.</div>
        </c:if>
        <c:if test="${param.deleted eq '0'}">
            <div class="alert alert-danger" role="alert">We couldn't delete that resource. Please try again.</div>
        </c:if>

        <form class="filters" method="get" action="${pageContext.request.contextPath}/my-resources">
            <div class="row">
                <div class="col-md-3">
                    <div class="form-group">
                        <label for="grade">Grade</label>
                        <select class="form-control" id="grade" name="grade">
                            <option value="">All</option>
                            <c:forEach var="grade" items="${gradeOptions}">
                                <option value="${grade}" ${grade eq param.grade ? 'selected' : ''}>Grade ${grade}</option>
                            </c:forEach>
                        </select>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="form-group">
                        <label for="subject">Subject</label>
                        <select class="form-control" id="subject" name="subject">
                            <option value="">All</option>
                            <c:forEach var="subject" items="${subjectOptions}">
                                <option value="${subject}" ${subject eq param.subject ? 'selected' : ''}>${subject}</option>
                            </c:forEach>
                        </select>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="form-group">
                        <label for="type">Type</label>
                        <select class="form-control" id="type" name="type">
                            <option value="">All</option>
                            <c:forEach var="option" items="${typeOptions}">
                                <option value="${option}" ${option eq param.type ? 'selected' : ''}>${option}</option>
                            </c:forEach>
                        </select>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="form-group">
                        <label for="language">Language</label>
                        <select class="form-control" id="language" name="language">
                            <option value="">All</option>
                            <c:forEach var="option" items="${languageOptions}">
                                <option value="${option}" ${option eq param.language ? 'selected' : ''}>${option}</option>
                            </c:forEach>
                        </select>
                    </div>
                </div>
            </div>
            <div class="d-flex justify-content-end gap-2">
                <button class="btn btn-primary mr-2" type="submit">Apply Filters</button>
                <a class="btn btn-outline-secondary" href="${pageContext.request.contextPath}/my-resources">Clear</a>
            </div>
        </form>

        <div class="table-responsive">
            <c:if test="${empty resources}">
                <div class="alert alert-info">No resources match the selected filters.</div>
            </c:if>
            <c:if test="${not empty resources}">
                <table class="table table-striped table-hover">
                    <thead>
                        <tr>
                            <th>Title</th>
                            <th>Grade</th>
                            <th>Subject</th>
                            <th>Type</th>
                            <th>Language</th>
                            <th>Uploaded On</th>
                            <th class="text-right">Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="resource" items="${resources}">
                            <tr>
                                <td>${resource.title}</td>
                                <td>Grade ${resource.grade}</td>
                                <td>${resource.subject}</td>
                                <td>${resource.type}</td>
                                <td>${resource.language}</td>
                                <td>
                                    <c:choose>
                                        <c:when test="${not empty resource.createdAt}">
                                            <fmt:formatDate value="${resource.createdAt}" pattern="dd MMM yyyy" />
                                        </c:when>
                                        <c:otherwise>
                                            —
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td class="text-right">
                                    <a href="${pageContext.request.contextPath}/view-resource?id=${resource.id}" class="btn btn-link btn-sm">View</a>
                                    <a href="${pageContext.request.contextPath}/edit-resource?id=${resource.id}" class="btn btn-link btn-sm">Edit</a>
                                    <a href="${pageContext.request.contextPath}/delete-resource?id=${resource.id}" class="btn btn-link btn-sm text-danger" onclick="return confirm('Delete this resource?')">Delete</a>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </c:if>
        </div>

        <a href="${pageContext.request.contextPath}/teacherDashboard" class="btn btn-secondary mt-3">Back to Dashboard</a>
    </div>
</body>
</html>
