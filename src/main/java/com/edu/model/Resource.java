package com.edu.model;

import javax.persistence.Entity;

@Entity
public class Resource {
    private int id;             // INT -> int
    private String grade;       // VARCHAR(10)
    private String subject;     // VARCHAR(50)
    private String title;       // VARCHAR(255)
    private String fileLink;    // VARCHAR(500)
    private String type;        // ENUM('PDF', 'Video', 'Quiz')
    private String language;    // ENUM('Tamil', 'English')

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
}
