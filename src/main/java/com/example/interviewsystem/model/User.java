package com.example.interviewsystem.model;

public class User {

    private Long id;
    private String loginId;
    private String password;
    private String role;
    private String displayName;
    private String className;

    public User() {
    }

    public User(Long id, String loginId, String password, String role, String displayName, String className) {
        this.id = id;
        this.loginId = loginId;
        this.password = password;
        this.role = role;
        this.displayName = displayName;
        this.className = className;
    }

    public Long getId() {
        return id;
    }

    public String getLoginId() {
        return loginId;
    }

    public String getPassword() {
        return password;
    }

    public String getRole() {
        return role;
    }

    public String getDisplayName() {
        return displayName;
    }

    public String getClassName() {
        return className;
    }

    public String getRoleLabel() {
        if ("TEACHER".equals(role)) return "先生";
        if ("PARENT".equals(role)) return "保護者";
        if ("STUDENT".equals(role)) return "生徒";
        return role;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public void setLoginId(String loginId) {
        this.loginId = loginId;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public void setRole(String role) {
        this.role = role;
    }

    public void setDisplayName(String displayName) {
        this.displayName = displayName;
    }

    public void setClassName(String className) {
        this.className = className;
    }
}