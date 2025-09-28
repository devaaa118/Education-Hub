<%-- File: src/main/webapp/views/viewResource.jsp --%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<%@ include file="studentDashboardHeader.jsp" %>
<html>
<head>
    <meta charset="UTF-8">
    <title>${resource.title} - Resource Details</title>
    <jsp:include page="../common/bootstrap.jsp" />
    <style>
        .container {
            max-width: 800px;
            margin-top: 30px;
        }
        .resource-details {
            margin-top: 20px;
        }
        .resource-actions {
            margin-top: 30px;
        }
    </style>
</head>
<body>
<jsp:include page="../common/googleTranslateWidget.jspf" />
    <div class="container">
        <h2 class="mb-4">${resource.title}</h2>
        
        <c:choose>
            <c:when test="${fn:startsWith(resource.fileLink, 'http://') || fn:startsWith(resource.fileLink, 'https://')}">
                <c:set var="resourceLink" value="${resource.fileLink}" />
                <c:set var="externalResource" value="${true}" />
            </c:when>
            <c:otherwise>
                <c:set var="resourceLink" value="${pageContext.request.contextPath}/${resource.fileLink}" />
                <c:set var="externalResource" value="${false}" />
            </c:otherwise>
        </c:choose>

        <div class="resource-details">
            <div class="card">
                <div class="card-body">
                    <h5 class="card-title">Resource Details</h5>
                    <p><strong>Grade:</strong> ${resource.grade}</p>
                    <p><strong>Subject:</strong> ${resource.subject}</p>
                    <p><strong>Type:</strong> ${resource.type}</p>
                    <p><strong>Language:</strong> ${resource.language}</p>
                    <c:if test="${externalResource}">
                        <p><span class="badge badge-info">External link</span> <a href="${resourceLink}" target="_blank" rel="noopener">Open resource in new tab</a></p>
                    </c:if>
                    
                    <c:if test="${resource.type eq 'PDF' && user.role eq 'student' && !externalResource}">
                        <div class="embed-responsive embed-responsive-16by9 mt-3">
                            <iframe class="embed-responsive-item" src="${resourceLink}" width="100%" height="500px"></iframe>
                        </div>
                    </c:if>
                    
                    <c:if test="${resource.type eq 'Video' && user.role eq 'student' && !externalResource}">
                        <div class="embed-responsive embed-responsive-16by9 mt-3">
                            <video class="embed-responsive-item" controls width="100%">
                                <source src="${resourceLink}" type="video/mp4">
                                Your browser does not support the video tag.
                            </video>
                        </div>
                    </c:if>
                </div>
            </div>
        </div>
        
        <div class="resource-actions">
            <a href="${pageContext.request.contextPath}/download-resource?id=${resource.id}" class="btn btn-primary">${externalResource ? 'Open Resource' : 'Download Resource'}</a>
            
            <c:if test="${user.role eq 'teacher' && user.id eq resource.uploadedBy}">
                <a href="${pageContext.request.contextPath}/edit-resource?id=${resource.id}" class="btn btn-secondary">Edit Resource</a>
                <a href="${pageContext.request.contextPath}/delete-resource?id=${resource.id}" class="btn btn-danger" onclick="return confirm('Are you sure you want to delete this resource?')">Delete Resource</a>
                <a href="${pageContext.request.contextPath}/my-resources" class="btn btn-link">Back to My Resources</a>
                <a href="${pageContext.request.contextPath}/teacherDashboard" class="btn btn-link">Back to Dashboard</a>
            </c:if>
            
            <c:if test="${user.role ne 'teacher'}">
                <a href="${pageContext.request.contextPath}/studentDashboard" class="btn btn-link">Back to Dashboard</a>
            </c:if>
        </div>
    </div>
</body>
</html>
