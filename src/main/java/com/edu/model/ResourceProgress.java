package com.edu.model;

import java.sql.Timestamp;

public class ResourceProgress {
    private long id;
    private long studentId;
    private int resourceId;
    private String status; // NOT_STARTED, IN_PROGRESS, COMPLETED
    private String notes;
    private Timestamp lastViewedAt;
    private Timestamp completedAt;

    public long getId() {
        return id;
    }

    public void setId(long id) {
        this.id = id;
    }

    public long getStudentId() {
        return studentId;
    }

    public void setStudentId(long studentId) {
        this.studentId = studentId;
    }

    public int getResourceId() {
        return resourceId;
    }

    public void setResourceId(int resourceId) {
        this.resourceId = resourceId;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getNotes() {
        return notes;
    }

    public void setNotes(String notes) {
        this.notes = notes;
    }

    public Timestamp getLastViewedAt() {
        return lastViewedAt;
    }

    public void setLastViewedAt(Timestamp lastViewedAt) {
        this.lastViewedAt = lastViewedAt;
    }

    public Timestamp getCompletedAt() {
        return completedAt;
    }

    public void setCompletedAt(Timestamp completedAt) {
        this.completedAt = completedAt;
    }
}
