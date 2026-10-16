package com.example.interviewsystem.model;

public class ChildInfo {

    private Long childUserId;
    private String childLoginId;
    private String childName;
    private String className;
    private boolean hasSibling;
    private String siblingGroup;

    public ChildInfo() {
    }

    public ChildInfo(Long childUserId, String childLoginId, String childName, String className, boolean hasSibling, String siblingGroup) {
        this.childUserId = childUserId;
        this.childLoginId = childLoginId;
        this.childName = childName;
        this.className = className;
        this.hasSibling = hasSibling;
        this.siblingGroup = siblingGroup;
    }

    public Long getChildUserId() {
        return childUserId;
    }

    public String getChildLoginId() {
        return childLoginId;
    }

    public String getChildName() {
        return childName;
    }

    public String getClassName() {
        return className;
    }

    public boolean isHasSibling() {
        return hasSibling;
    }

    public String getSiblingGroup() {
        return siblingGroup;
    }

    public String getSiblingLabel() {
        return hasSibling ? "兄弟あり" : "兄弟なし";
    }

    public void setChildUserId(Long childUserId) {
        this.childUserId = childUserId;
    }

    public void setChildLoginId(String childLoginId) {
        this.childLoginId = childLoginId;
    }

    public void setChildName(String childName) {
        this.childName = childName;
    }

    public void setClassName(String className) {
        this.className = className;
    }

    public void setHasSibling(boolean hasSibling) {
        this.hasSibling = hasSibling;
    }

    public void setSiblingGroup(String siblingGroup) {
        this.siblingGroup = siblingGroup;
    }
}