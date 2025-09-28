<%-- File: src/main/webapp/views/teacherLibrary.jsp (Resources view) --%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Teacher Resource Library · Resources</title>
    <jsp:include page="../common/bootstrap.jsp" />
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
    <style>
        body { background: #f1f5f9; }
        .hero-card {
            background: linear-gradient(135deg, rgba(37,99,235,0.12), rgba(109,40,217,0.12));
            border-radius: 24px;
            padding: 2.5rem;
            box-shadow: 0 2rem 4rem rgba(30,64,175,0.12);
        }
        .resource-card {
            border: none;
            border-radius: 20px;
            box-shadow: 0 1.5rem 3rem rgba(15,23,42,0.08);
            transition: transform .2s ease, box-shadow .2s ease;
        }
        .resource-card:hover {
            transform: translateY(-6px);
            box-shadow: 0 2.5rem 3.5rem rgba(109,40,217,0.16);
        }
    </style>
</head>
<body>
<div style="display:none"><jsp:include page="../common/googleTranslateWidget.jspf" /></div>
<div class="container py-5">
    <c:set var="currentStreamId" value="${not empty selectedStream ? selectedStream : formStreamId}" />

    <div class="hero-card mb-5">
        <div class="d-flex flex-column flex-xl-row align-items-xl-center justify-content-between gap-4">
            <div>
                <span class="badge text-bg-primary rounded-pill mb-2">${selectedGradeName}</span>
                <h1 class="h3 fw-bold text-primary mb-1">${selectedSubject}</h1>
                <p class="text-muted mb-0">Keep your ${selectedSubject} resources up to date for every student<c:if test="${not empty selectedStreamName}"> in the ${selectedStreamName} stream</c:if>.</p>
            </div>
            <div class="text-xl-end">
                <span class="display-6 fw-bold text-primary">${fn:length(resources)}</span>
                <p class="text-muted mb-0">Resources published</p>
                <div class="d-flex flex-wrap gap-2 justify-content-xl-end mt-3">
                    <c:url var="subjectsUrl" value="/teacher/library">
                        <c:param name="grade" value="${selectedGrade}" />
                        <c:if test="${not empty currentStreamId}">
                            <c:param name="stream" value="${currentStreamId}" />
                        </c:if>
                    </c:url>
                    <a href="${subjectsUrl}" class="btn btn-outline-secondary"><i class="bi bi-arrow-left me-1"></i>Subjects</a>

                    <c:if test="${not empty streams}">
                        <c:url var="streamSelectUrl" value="/teacher/library">
                            <c:param name="grade" value="${selectedGrade}" />
                        </c:url>
                        <a href="${streamSelectUrl}" class="btn btn-outline-secondary"><i class="bi bi-layers me-1"></i>Change stream</a>
                    </c:if>

                    <c:url var="classesUrl" value="/teacher/library" />
                    <a href="${classesUrl}" class="btn btn-outline-secondary"><i class="bi bi-grid"></i> Classes</a>
                    <button class="btn btn-primary" type="button" data-bs-toggle="modal" data-bs-target="#uploadModal">
                        <i class="bi bi-plus-lg"></i> Add resource
                    </button>
                </div>
            </div>
        </div>
    </div>

    <c:if test="${not empty message}">
        <div class="alert alert-${messageType} shadow-sm mb-4">${message}</div>
    </c:if>

    <c:if test="${not empty streams}">
        <div class="mb-4">
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
            <div class="row g-4">
                <c:forEach var="resource" items="${resources}">
                    <div class="col-12 col-md-6">
                        <div class="card resource-card h-100">
                            <div class="card-body d-flex flex-column gap-3">
                                <div class="d-flex justify-content-between align-items-start">
                                    <div>
                                        <span class="badge text-bg-light text-primary small mb-2">${resource.type}</span>
                                        <h2 class="h5 fw-semibold text-dark mb-1">${resource.title}</h2>
                                        <div class="text-muted small d-flex flex-wrap gap-3">
                                            <span><i class="bi bi-translate me-1"></i>${resource.language}</span>
                                            <c:if test="${not empty resource.createdAt}">
                                                <span><i class="bi bi-clock-history me-1"></i><fmt:formatDate value="${resource.createdAt}" pattern="dd MMM yyyy" /></span>
                                            </c:if>
                                        </div>
                                    </div>
                                    <span class="text-muted"><i class="bi bi-three-dots"></i></span>
                                </div>
                                <div class="d-flex flex-wrap gap-2 mt-auto">
                                    <c:url var="viewUrl" value="/view-resource">
                                        <c:param name="id" value="${resource.id}" />
                                    </c:url>
                                    <a href="${viewUrl}" class="btn btn-outline-primary btn-sm" target="_blank"><i class="bi bi-eye me-1"></i>View</a>

                                    <c:url var="downloadUrl" value="/download-resource">
                                        <c:param name="id" value="${resource.id}" />
                                    </c:url>
                                    <a href="${downloadUrl}" class="btn btn-outline-success btn-sm"><i class="bi bi-download me-1"></i>Download</a>

                                    <c:url var="editUrl" value="/edit-resource">
                                        <c:param name="id" value="${resource.id}" />
                                    </c:url>
                                    <a href="${editUrl}" class="btn btn-outline-secondary btn-sm"><i class="bi bi-pencil me-1"></i>Edit</a>

                                    <c:url var="deleteUrl" value="/delete-resource">
                                        <c:param name="id" value="${resource.id}" />
                                    </c:url>
                                    <a href="${deleteUrl}" class="btn btn-outline-danger btn-sm" onclick="return confirm('Delete this resource?');"><i class="bi bi-trash me-1"></i>Delete</a>
                                </div>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </c:when>
        <c:otherwise>
            <div class="card border-0 shadow-sm rounded-4">
                <div class="card-body text-center py-5">
                    <div class="mb-3">
                        <span class="badge text-bg-info text-uppercase">Empty state</span>
                    </div>
                    <h3 class="fw-bold mb-3">No resources yet for ${selectedSubject}</h3>
                    <p class="text-muted mb-4">Be the first to share slides, worksheets, or videos to kick-start this subject.</p>
                    <button class="btn btn-primary" type="button" data-bs-toggle="modal" data-bs-target="#uploadModal">
                        <i class="bi bi-plus-lg me-1"></i>Add resource
                    </button>
                </div>
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
<jsp:include page="../common/i18n-scripts.jspf" />
            if (uploadModalEl) {
                const modal = new bootstrap.Modal(uploadModalEl);
                modal.show();
            }
        </c:if>
    });
</script>
</body>
</html>
