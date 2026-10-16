package com.example.interviewsystem.model;

public class ScheduleBuildCell {

    private Long optionId;
    private String date;
    private String time;
    private String status;
    private String label;
    private String childName;
    private String parentName;
    private int manualCount;

    public Long getOptionId() {
        return optionId;
    }

    public String getDate() {
        return date;
    }

    public String getTime() {
        return time;
    }

    public String getStatus() {
        return status;
    }

    public String getLabel() {
        return label;
    }

    public String getChildName() {
        return childName;
    }

    public String getParentName() {
        return parentName;
    }

    public int getManualCount() {
        return manualCount;
    }

    public String getCssClass() {
        if ("AUTO_CONFIRMED".equals(status)) {
            return "cell-auto";
        }

        if ("SIBLING_AUTO_CONFIRMED".equals(status)) {
            return "cell-sibling";
        }

        if ("WAITING_PARENT".equals(status)) {
            return "cell-waiting";
        }

        if ("CONFIRMED".equals(status)) {
            return "cell-published";
        }

        if ("MANUAL_REQUIRED".equals(status)) {
            return "cell-manual";
        }

        if ("CLOSED".equals(status)) {
            return "cell-closed";
        }

        return "cell-open";
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

    public void setStatus(String status) {
        this.status = status;
    }

    public void setLabel(String label) {
        this.label = label;
    }

    public void setChildName(String childName) {
        this.childName = childName;
    }

    public void setParentName(String parentName) {
        this.parentName = parentName;
    }

    public void setManualCount(int manualCount) {
        this.manualCount = manualCount;
    }
}