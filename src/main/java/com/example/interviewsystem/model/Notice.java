package com.example.interviewsystem.model;

public class Notice {

    private Long id;
    private String title;
    private String content;
    private boolean active;
    private String targetRole;

    public Notice() {
    }

    public Notice(Long id, String title, String content, boolean active, String targetRole) {
        this.id = id;
        this.title = title;
        this.content = content;
        this.active = active;
        this.targetRole = targetRole;
    }

    public Long getId() {
        return id;
    }

    public String getTitle() {
        return title;
    }

    public String getContent() {
        return content;
    }

    public boolean isActive() {
        return active;
    }

    public String getTargetRole() {
        return targetRole;
    }

    public String getTargetRoleLabel() {
        if ("PARENT".equals(targetRole)) return "保護者";
        if ("STUDENT".equals(targetRole)) return "児童";
        return "保護者・児童";
    }

    public String getStatusLabel() {
        return active ? "公開中" : "非公開";
    }

    public void setId(Long id) {
        this.id = id;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public void setActive(boolean active) {
        this.active = active;
    }

    public void setTargetRole(String targetRole) {
        this.targetRole = targetRole;
    }
}