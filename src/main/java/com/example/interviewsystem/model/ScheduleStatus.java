package com.example.interviewsystem.model;

public class ScheduleStatus {

    private Long optionId;
    private String date;
    private String time;
    private boolean available;
    private String planStatus;
    private String parentName;
    private String childName;

    public ScheduleStatus() {
    }

    public Long getOptionId() {
        return optionId;
    }

    public String getDate() {
        return date;
    }

    public String getTime() {
        return time;
    }

    public boolean isAvailable() {
        return available;
    }

    public String getPlanStatus() {
        return planStatus;
    }

    public String getParentName() {
        return parentName;
    }

    public String getChildName() {
        return childName;
    }

    public String getStatusLabel() {
        if ("CONFIRMED".equals(planStatus)) {
            return "予約済み";
        }

        if ("PARENT_CONFIRMING".equals(planStatus)
                || "WAITING_PARENT".equals(planStatus)) {

            return "確認待ち";
        }

        if (available) {
            return "利用可能";
        }

        return "非公開";
    }

    public boolean isConfirmed() {
        return "CONFIRMED".equals(planStatus);
    }

    public String getDisplayName() {
        if (isConfirmed() && childName != null) {
            return childName;
        }

        return "";
    }

    public String getStatusClass() {
        if ("CONFIRMED".equals(planStatus)) {
            return "status-confirmed";
        }

        if ("PARENT_CONFIRMING".equals(planStatus)
                || "WAITING_PARENT".equals(planStatus)) {

            return "status-parent-confirming";
        }

        if (available) {
            return "status-submitted";
        }

        return "status-resubmitted";
    }

    public void setOptionId(Long optionId) {
        this.optionId = optionId;
    }

    public void setDate(String date) {
        this.date = date;
    }

    public void setTime(String time) {
        this.time = time;
    }

    public void setAvailable(boolean available) {
        this.available = available;
    }

    public void setPlanStatus(String planStatus) {
        this.planStatus = planStatus;
    }

    public void setParentName(String parentName) {
        this.parentName = parentName;
    }

    public void setChildName(String childName) {
        this.childName = childName;
    }
}