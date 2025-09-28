package com.edu.model;

import java.sql.Timestamp;
import java.time.LocalDateTime;

public class TutoringSession {
    private long id;
    private String title;
    private String description;
    private String tutorName;
    private LocalDateTime sessionDateTime;
    private Long classId;
    private Long subjectId;
    private String meetingLink;
    private long createdBy;
    private Timestamp createdAt;
    private Timestamp sessionTimestamp;
    private String className;
    private String subjectName;

    public long getId() {
        return id;
    }

    public void setId(long id) {
        this.id = id;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getTutorName() {
        return tutorName;
    }

    public void setTutorName(String tutorName) {
        this.tutorName = tutorName;
    }

    public LocalDateTime getSessionDateTime() {
        return sessionDateTime;
    }

    public void setSessionDateTime(LocalDateTime sessionDateTime) {
        this.sessionDateTime = sessionDateTime;
        if (sessionDateTime != null) {
            this.sessionTimestamp = Timestamp.valueOf(sessionDateTime);
        }
    }

    public Long getClassId() {
        return classId;
    }

    public void setClassId(Long classId) {
        this.classId = classId;
    }

    public Long getSubjectId() {
        return subjectId;
    }

    public void setSubjectId(Long subjectId) {
        this.subjectId = subjectId;
    }

    public String getMeetingLink() {
        return meetingLink;
    }

    public void setMeetingLink(String meetingLink) {
        this.meetingLink = meetingLink;
    }

    public long getCreatedBy() {
        return createdBy;
    }

    public void setCreatedBy(long createdBy) {
        this.createdBy = createdBy;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public Timestamp getSessionTimestamp() {
        if (sessionTimestamp == null && sessionDateTime != null) {
            sessionTimestamp = Timestamp.valueOf(sessionDateTime);
        }
        return sessionTimestamp;
    }

    public void setSessionTimestamp(Timestamp sessionTimestamp) {
        this.sessionTimestamp = sessionTimestamp;
        if (sessionTimestamp != null) {
            this.sessionDateTime = sessionTimestamp.toLocalDateTime();
        }
    }

    public String getClassName() {
        return className;
    }

    public void setClassName(String className) {
        this.className = className;
    }

    public String getSubjectName() {
        return subjectName;
    }

    public void setSubjectName(String subjectName) {
        this.subjectName = subjectName;
    }
}
