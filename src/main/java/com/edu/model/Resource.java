package com.edu.model;

import javax.persistence.Entity;
import java.sql.Timestamp;

@Entity
public class Resource {
    private int id;            
    private String grade;       // VARCHAR(10)
    private String subject;     // VARCHAR(50)
    private String title;       // VARCHAR(255)
    private String fileLink;    // VARCHAR(500)
    private String type;        // ENUM('PDF', 'Video', 'Quiz')
    private String language;    // ENUM('Tamil', 'English')
    private Timestamp createdAt;
    private long uploadedBy;  // Foreign key to users table
    private Integer streamId; // Optional stream association for grades 11/12
    private boolean verified;
    private Long verifiedBy;
    private Timestamp verifiedAt;

    // Getters & Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getGrade() { return grade; }
    public void setGrade(String grade) { this.grade = grade; }

    public String getSubject() { return subject; }
    public void setSubject(String subject) { this.subject = subject; }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public String getFileLink() { return fileLink; }
    public void setFileLink(String fileLink) { this.fileLink = fileLink; }

    public String getType() { return type; }
    public void setType(String type) { this.type = type; }

    public String getLanguage() { return language; }
    public void setLanguage(String language) { this.language = language; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }

    public long getUploadedBy() { return uploadedBy; }
    public void setUploadedBy(long uploadedBy) { this.uploadedBy = uploadedBy; }

    public Integer getStreamId() { return streamId; }
    public void setStreamId(Integer streamId) { this.streamId = streamId; }

    public boolean isVerified() { return verified; }
    public void setVerified(boolean verified) { this.verified = verified; }

    public Long getVerifiedBy() { return verifiedBy; }
    public void setVerifiedBy(Long verifiedBy) { this.verifiedBy = verifiedBy; }

    public Timestamp getVerifiedAt() { return verifiedAt; }
    public void setVerifiedAt(Timestamp verifiedAt) { this.verifiedAt = verifiedAt; }
}
