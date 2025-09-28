<%-- File: src/main/webapp/views/uploadResource.jsp --%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Upload Educational Resource</title>
    <jsp:include page="../common/bootstrap.jsp" />
    <style>
        .container {
            max-width: 800px;
            margin-top: 30px;
        }
        .form-group {
            margin-bottom: 20px;
        }
        .selection-summary {
            background-color: #f1f5f9;
            border-radius: 8px;
            padding: 12px 16px;
            display: flex;
            flex-wrap: wrap;
            gap: 16px;
            margin-bottom: 16px;
        }
        .selection-summary span {
            font-size: 0.95rem;
            color: #475569;
        }
        .selection-summary strong {
            color: #1d4ed8;
        }
        .class-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(190px, 1fr));
            gap: 16px;
        }
        .class-card {
            border: 1px solid #e2e8f0;
            border-radius: 12px;
            padding: 16px;
            background-color: #fff;
            box-shadow: 0 1px 2px rgba(15, 23, 42, 0.08);
            cursor: pointer;
            transition: all 0.2s ease;
        }
        .class-card.active {
            border-color: #2563eb;
            box-shadow: 0 10px 20px rgba(37, 99, 235, 0.15);
        }
        .class-card h5 {
            font-size: 1rem;
            font-weight: 700;
            margin-bottom: 12px;
            color: #1f2937;
        }
        .subject-chip-group {
            display: flex;
            flex-wrap: wrap;
            gap: 8px;
        }
        .subject-chip {
            border: 1px solid #d1d5db;
            border-radius: 999px;
            padding: 6px 12px;
            background-color: #f8fafc;
            font-size: 0.85rem;
            color: #1f2937;
            cursor: pointer;
            transition: all 0.2s ease;
        }
        .subject-chip:hover {
            background-color: #e0f2fe;
            border-color: #0ea5e9;
        }
        .subject-chip.selected {
            background-color: #2563eb;
            border-color: #1d4ed8;
            color: #fff;
            box-shadow: 0 4px 12px rgba(37, 99, 235, 0.3);
        }
    </style>
</head>
<body>
<jsp:include page="../common/googleTranslateWidget.jspf" />
    <div class="container">
        <h2 class="mb-4">Upload Educational Resource</h2>
        
        <c:if test="${not empty message}">
            <div class="alert alert-${messageType}" role="alert">
                ${message}
            </div>
        </c:if>

        <c:set var="selectedGradeName" value="" />
        <c:forEach var="classInfo" items="${classOptions}">
            <c:if test="${formGrade eq classInfo.id}">
                <c:set var="selectedGradeName" value="${classInfo.name}" />
            </c:if>
        </c:forEach>
        
        <form id="uploadForm" action="${pageContext.request.contextPath}/upload-resource" method="post" enctype="multipart/form-data">
            <div class="form-group">
                <label for="title">Title:</label>
                <input type="text" class="form-control" id="title" name="title" value="${empty formTitle ? '' : formTitle}" required>
            </div>
            
            <div class="form-group">
                <label>Choose Class &amp; Subject:</label>
                <p class="text-muted small mb-3">Click a class card and then one of its subjects to attach your resource.</p>
                <div class="selection-summary">
                    <span>Class: <strong id="selectedGradeLabel">${empty selectedGradeName ? 'Not selected' : selectedGradeName}</strong></span>
                    <span>Subject: <strong id="selectedSubjectLabel">${empty formSubject ? 'Not selected' : formSubject}</strong></span>
                </div>
                <div class="class-grid">
                    <c:forEach var="classInfo" items="${classOptions}">
                        <c:set var="isActive" value="${formGrade eq classInfo.id}" />
                        <div class="class-card ${isActive ? 'active' : ''}" data-grade-id="${classInfo.id}" data-grade-name="${classInfo.name}">
                            <h5>${classInfo.name}</h5>
                            <div class="subject-chip-group">
                                <c:forEach var="subject" items="${subjectsByClass[classInfo.id]}">
                                    <c:set var="isSelected" value="${isActive and formSubject eq subject}" />
                                    <button type="button"
                                            class="subject-chip ${isSelected ? 'selected' : ''}"
                                            data-grade-id="${classInfo.id}"
                                            data-grade-name="${classInfo.name}"
                                            data-subject="${subject}">
                                        ${subject}
                                    </button>
                                </c:forEach>
                            </div>
                        </div>
                    </c:forEach>
                </div>
                <input type="hidden" id="grade" name="grade" value="${empty formGrade ? '' : formGrade}">
                <input type="hidden" id="subject" name="subject" value="${empty formSubject ? '' : formSubject}">
            </div>
            
            <div class="form-group">
                <label for="type">Resource Type:</label>
                <select class="form-control" id="type" name="type" required>
                    <option value="">Select Type</option>
                    <option value="PDF" ${formType eq 'PDF' ? 'selected' : ''}>PDF</option>
                    <option value="Video" ${formType eq 'Video' ? 'selected' : ''}>Video</option>
                    <option value="Quiz" ${formType eq 'Quiz' ? 'selected' : ''}>Quiz</option>
                </select>
            </div>
            
            <div class="form-group">
                <label for="language">Language:</label>
                <select class="form-control" id="language" name="language" required>
                    <option value="">Select Language</option>
                    <option value="English" ${formLanguage eq 'English' ? 'selected' : ''}>English</option>
                    <option value="Tamil" ${formLanguage eq 'Tamil' ? 'selected' : ''}>Tamil</option>
                </select>
            </div>
            
            <div class="form-group">
                <label>Resource Source:</label>
                <small class="form-text text-muted mb-2">Upload a file or paste an external URL. Provide at least one.</small>
                <div class="card p-3">
                    <div class="form-group mb-3">
                        <label for="resourceFile">Upload File</label>
                        <input type="file" class="form-control-file" id="resourceFile" name="resourceFile">
                        <small class="form-text text-muted">
                            Supported formats: PDF, MP4, DOCX (Max size: 50MB)
                        </small>
                    </div>
                    <div class="form-group mb-0">
                        <label for="resourceUrl">Resource URL</label>
                        <input type="url" class="form-control" id="resourceUrl" name="resourceUrl" placeholder="https://example.com/resource" value="${empty formResourceUrl ? '' : formResourceUrl}">
                        <small class="form-text text-muted">Provide a direct link to the resource (must start with http or https).</small>
                    </div>
                </div>
            </div>
            
            <button type="submit" class="btn btn-primary">Upload Resource</button>
            <a href="${pageContext.request.contextPath}/teacherDashboard" class="btn btn-secondary">Back to Dashboard</a>
        </form>
    </div>

    <script>
        document.addEventListener('DOMContentLoaded', function () {
            const classCards = Array.from(document.querySelectorAll('.class-card'));
            const getSubjectButtons = () => Array.from(document.querySelectorAll('.subject-chip'));
            const gradeInput = document.getElementById('grade');
            const subjectInput = document.getElementById('subject');
            const gradeLabel = document.getElementById('selectedGradeLabel');
            const subjectLabel = document.getElementById('selectedSubjectLabel');
            const fileInput = document.getElementById('resourceFile');
            const urlInput = document.getElementById('resourceUrl');
            const uploadForm = document.getElementById('uploadForm');

            function clearSubjectSelection() {
                subjectInput.value = '';
                subjectLabel.textContent = 'Not selected';
                getSubjectButtons().forEach(btn => btn.classList.remove('selected'));
            }

            classCards.forEach(card => {
                card.addEventListener('click', () => {
                    const gradeId = card.getAttribute('data-grade-id');
                    const gradeName = card.getAttribute('data-grade-name');
                    const previousGrade = gradeInput.value;

                    classCards.forEach(c => c.classList.remove('active'));
                    card.classList.add('active');

                    gradeInput.value = gradeId;
                    gradeLabel.textContent = gradeName;

                    if (previousGrade !== gradeId) {
                        clearSubjectSelection();
                    }
                });
            });

            getSubjectButtons().forEach(button => {
                button.addEventListener('click', (event) => {
                    event.stopPropagation();

                    const gradeId = button.getAttribute('data-grade-id');
                    const gradeName = button.getAttribute('data-grade-name');
                    const subject = button.getAttribute('data-subject');

                    classCards.forEach(c => c.classList.remove('active'));
                    const parentCard = button.closest('.class-card');
                    if (parentCard) {
                        parentCard.classList.add('active');
                    }

                    gradeInput.value = gradeId;
                    gradeLabel.textContent = gradeName;

                    getSubjectButtons().forEach(btn => btn.classList.remove('selected'));
                    button.classList.add('selected');
                    subjectInput.value = subject;
                    subjectLabel.textContent = subject;
                });
            });

            if (gradeInput.value) {
                const presetCard = classCards.find(card => card.getAttribute('data-grade-id') === gradeInput.value);
                if (presetCard) {
                    presetCard.classList.add('active');
                    gradeLabel.textContent = presetCard.getAttribute('data-grade-name');
                }
            }

            if (subjectInput.value) {
                getSubjectButtons().forEach(btn => {
                    if (btn.getAttribute('data-grade-id') === gradeInput.value &&
                        btn.getAttribute('data-subject') === subjectInput.value) {
                        btn.classList.add('selected');
                        subjectLabel.textContent = subjectInput.value;
                        const parentCard = btn.closest('.class-card');
                        if (parentCard) {
                            parentCard.classList.add('active');
                            gradeLabel.textContent = parentCard.getAttribute('data-grade-name');
                        }
                    }
                });
            }

            uploadForm.addEventListener('submit', function (event) {
                const gradeVal = gradeInput.value.trim();
                const subjectVal = subjectInput.value.trim();
                if (!gradeVal || !subjectVal) {
                    event.preventDefault();
                    alert('Please choose both class and subject before submitting.');
                    return;
                }

                const hasFile = fileInput && fileInput.files && fileInput.files.length > 0;
                const urlValue = urlInput && urlInput.value ? urlInput.value.trim() : '';
                if (!hasFile && urlValue === '') {
                    event.preventDefault();
                    alert('Please upload a file or provide a resource URL.');
                }
            });
        });
    </script>
</body>
</html>
