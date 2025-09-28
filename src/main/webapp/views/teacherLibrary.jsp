<%-- File: src/main/webapp/views/teacherLibrary.jsp (Resources view) --%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Teacher Resource Library · Resources</title>
    <jsp:include page="../common/bootstrap.jsp" />
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
    <style>
        body { background: #f8fafc; }
        .page-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 24px; }
        .page-header h2 { margin: 0; font-weight: 700; color: #1e293b; }
        .page-header p { margin: 0; color: #64748b; }
        .action-buttons { display: flex; gap: 12px; flex-wrap: wrap; justify-content: flex-end; }
        .resource-list .list-group-item { border-radius: 12px; border: 1px solid #e2e8f0; margin-bottom: 12px; }
        .resource-list .list-group-item:hover { border-color: #2563eb; box-shadow: 0 12px 22px rgba(37, 99, 235, 0.12); }
        .resource-title { font-weight: 600; font-size: 1.05rem; color: #0f172a; }
        .resource-meta { font-size: 0.85rem; color: #475569; display: flex; gap: 16px; flex-wrap: wrap; margin-top: 8px; }
        .resource-meta .badge { font-size: 0.75rem; letter-spacing: 0.06em; text-transform: uppercase; }
        .resource-actions { display: flex; gap: 8px; flex-wrap: wrap; }
        .empty-state { background: #e0f2fe; border-radius: 16px; padding: 36px; text-align: center; color: #0f172a; }
        .empty-state h4 { font-weight: 700; margin-bottom: 12px; }
    </style>
</head>
<body>
<jsp:include page="../common/googleTranslateWidget.jspf" />
<div class="container py-4">
    <c:set var="currentStreamId" value="${not empty selectedStream ? selectedStream : formStreamId}" />

    <div class="page-header">
        <div>
            <h2 class="mb-1">${selectedSubject}</h2>
            <p class="mb-0">Resources for ${selectedGradeName}<c:if test="${not empty selectedStreamName}"> · ${selectedStreamName} Stream</c:if></p>
        </div>
        <div class="action-buttons">
            <c:url var="subjectsUrl" value="/teacher/library">
                <c:param name="grade" value="${selectedGrade}" />
                <c:if test="${not empty currentStreamId}">
                    <c:param name="stream" value="${currentStreamId}" />
                </c:if>
            </c:url>
            <a href="${subjectsUrl}" class="btn btn-outline-secondary"><i class="bi bi-arrow-left"></i> Subjects</a>

            <c:if test="${not empty streams}">
                <c:url var="streamSelectUrl" value="/teacher/library">
                    <c:param name="grade" value="${selectedGrade}" />
                </c:url>
                <a href="${streamSelectUrl}" class="btn btn-outline-secondary"><i class="bi bi-layers"></i> Change Stream</a>
            </c:if>

            <c:url var="classesUrl" value="/teacher/library" />
            <a href="${classesUrl}" class="btn btn-outline-secondary">Classes</a>
            <button class="btn btn-primary" type="button" data-bs-toggle="modal" data-bs-target="#uploadModal">
                <i class="bi bi-plus-lg"></i> Add Resource
            </button>
        </div>
    </div>

    <c:if test="${not empty message}">
        <div class="alert alert-${messageType}">${message}</div>
    </c:if>

    <c:if test="${not empty streams}">
        <div class="mb-3">
            <span class="text-muted d-block mb-2">Streams</span>
            <div class="d-flex flex-wrap gap-2">
                <c:forEach var="entry" items="${streams}">
                    <c:url var="streamLink" value="/teacher/library">
                        <c:param name="grade" value="${selectedGrade}" />
                        <c:param name="stream" value="${entry.key}" />
                    </c:url>
                    <a href="${streamLink}" class="btn btn-sm rounded-pill ${entry.key == currentStreamId ? 'btn-primary' : 'btn-outline-primary'}">
                        ${entry.value}
                    </a>
                </c:forEach>
            </div>
        </div>
    </c:if>

    <c:if test="${not empty subjects}">
        <div class="mb-4">
            <span class="text-muted d-block mb-2">Subjects</span>
            <div class="d-flex flex-wrap gap-2">
                <c:forEach var="subjectOption" items="${subjects}">
                    <c:url var="subjectUrl" value="/teacher/library">
                        <c:param name="grade" value="${selectedGrade}" />
                        <c:if test="${not empty currentStreamId}">
                            <c:param name="stream" value="${currentStreamId}" />
                        </c:if>
                        <c:param name="subject" value="${subjectOption}" />
                    </c:url>
                    <a href="${subjectUrl}" class="btn btn-sm rounded-pill ${subjectOption == selectedSubject ? 'btn-primary' : 'btn-outline-primary'}">
                        ${subjectOption}
                    </a>
                </c:forEach>
            </div>
        </div>
    </c:if>

    <c:choose>
        <c:when test="${not empty resources}">
            <div class="list-group resource-list">
                <c:forEach var="resource" items="${resources}">
                    <div class="list-group-item">
                        <div class="d-flex flex-column flex-md-row justify-content-between gap-3">
                            <div>
                                <div class="resource-title">${resource.title}</div>
                                <div class="resource-meta">
                                    <span class="badge bg-primary">${resource.type}</span>
                                    <span><i class="bi bi-translate"></i> ${resource.language}</span>
                                    <c:if test="${not empty resource.createdAt}">
                                        <span><i class="bi bi-clock-history"></i> <fmt:formatDate value="${resource.createdAt}" pattern="dd MMM yyyy" /></span>
                                    </c:if>
                                </div>
                            </div>
                            <div class="resource-actions">
                                <c:url var="viewUrl" value="/view-resource">
                                    <c:param name="id" value="${resource.id}" />
                                </c:url>
                                <a href="${viewUrl}" class="btn btn-outline-primary btn-sm" target="_blank">View</a>

                                <c:url var="downloadUrl" value="/download-resource">
                                    <c:param name="id" value="${resource.id}" />
                                </c:url>
                                <a href="${downloadUrl}" class="btn btn-outline-success btn-sm">Download</a>

                                <c:url var="editUrl" value="/edit-resource">
                                    <c:param name="id" value="${resource.id}" />
                                </c:url>
                                <a href="${editUrl}" class="btn btn-outline-secondary btn-sm">Edit</a>

                                <c:url var="deleteUrl" value="/delete-resource">
                                    <c:param name="id" value="${resource.id}" />
                                </c:url>
                                <a href="${deleteUrl}" class="btn btn-outline-danger btn-sm" onclick="return confirm('Delete this resource?');">Delete</a>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </c:when>
        <c:otherwise>
            <div class="empty-state">
                <h4>No resources yet for ${selectedSubject}</h4>
                <p class="mb-3">Be the first to share materials for this subject.</p>
                <button class="btn btn-primary" type="button" data-bs-toggle="modal" data-bs-target="#uploadModal">
                    <i class="bi bi-plus-lg"></i> Add Resource
                </button>
            </div>
        </c:otherwise>
    </c:choose>
</div>

<c:url var="libraryPost" value="/teacher/library" />
<div class="modal fade" id="uploadModal" tabindex="-1" aria-labelledby="uploadModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-lg modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="uploadModalLabel">Add Resource to ${selectedSubject}</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <form id="uploadForm" action="${libraryPost}" method="post" enctype="multipart/form-data">
                <input type="hidden" name="grade" value="${selectedGrade}" />
                <input type="hidden" name="subject" value="${selectedSubject}" />
                <c:if test="${not empty currentStreamId}">
                    <input type="hidden" name="stream" value="${currentStreamId}" />
                </c:if>
                <div class="modal-body">
                    <div class="row g-3">
                        <div class="col-md-12">
                            <label class="form-label">Title</label>
                            <input type="text" class="form-control" name="title" value="${empty formTitle ? '' : formTitle}" required />
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Resource Type</label>
                            <select class="form-select" name="type" required>
                                <option value="">Select Type</option>
                                <option value="PDF" ${formType eq 'PDF' ? 'selected' : ''}>PDF</option>
                                <option value="Video" ${formType eq 'Video' ? 'selected' : ''}>Video</option>
                                <option value="Quiz" ${formType eq 'Quiz' ? 'selected' : ''}>Quiz</option>
                            </select>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Language</label>
                            <select class="form-select" name="language" required>
                                <option value="">Select Language</option>
                                <option value="English" ${formLanguage eq 'English' ? 'selected' : ''}>English</option>
                                <option value="Tamil" ${formLanguage eq 'Tamil' ? 'selected' : ''}>Tamil</option>
                            </select>
                        </div>
                        <div class="col-md-12">
                            <label class="form-label">Upload File</label>
                            <input type="file" class="form-control" name="resourceFile" />
                            <div class="form-text">Supported: PDF, MP4, MOV, WEBM, DOCX, TXT (max 50 MB)</div>
                        </div>
                        <div class="col-md-12">
                            <label class="form-label">Or provide URL</label>
                            <input type="url" class="form-control" name="resourceUrl" placeholder="https://example.com/resource" value="${empty formResourceUrl ? '' : formResourceUrl}" />
                            <div class="form-text">Provide a direct link starting with http or https.</div>
                        </div>
                        <div class="col-md-12">
                            <div class="alert alert-info mb-0">
                                Either upload a file or share an external link. If both are provided, the uploaded file will be used.
                            </div>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn btn-primary">Upload Resource</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script>
    document.addEventListener('DOMContentLoaded', function () {
        const uploadForm = document.getElementById('uploadForm');
        if (uploadForm) {
            uploadForm.addEventListener('submit', function (event) {
                const fileInput = uploadForm.querySelector('input[name="resourceFile"]');
                const urlInput = uploadForm.querySelector('input[name="resourceUrl"]');
                const hasFile = fileInput && fileInput.files && fileInput.files.length > 0;
                const hasUrl = urlInput && urlInput.value.trim().length > 0;
                if (!hasFile && !hasUrl) {
                    event.preventDefault();
                    alert('Please upload a file or provide a resource URL.');
                }
            });
        }

        <c:if test="${showUploadModal}">
            const uploadModalEl = document.getElementById('uploadModal');
            if (uploadModalEl) {
                const modal = new bootstrap.Modal(uploadModalEl);
                modal.show();
            }
        </c:if>
    });
</script>
</body>
</html>
