package com.example.interviewsystem.model;

public class ScheduleBuildSummary {

    private int totalParentCount;
    private int submittedParentCount;
    private int notSubmittedParentCount;

    public ScheduleBuildSummary() {
    }

    public ScheduleBuildSummary(int totalParentCount, int submittedParentCount) {
        this.totalParentCount = totalParentCount;
        this.submittedParentCount = submittedParentCount;
        this.notSubmittedParentCount = totalParentCount - submittedParentCount;
    }

    public int getTotalParentCount() {
        return totalParentCount;
    }

    public int getSubmittedParentCount() {
        return submittedParentCount;
    }

    public int getNotSubmittedParentCount() {
        return notSubmittedParentCount;
    }
}