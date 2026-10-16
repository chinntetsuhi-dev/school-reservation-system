package com.example.interviewsystem.model;

public class FinalPlan {

    private Long id;
    private Long parentRequestId;
    private Long selectedOptionId;
    private String teacherComment;
    private String responseStatus;

    public FinalPlan() {
    }

    public FinalPlan(Long id, Long parentRequestId, Long selectedOptionId,
                     String teacherComment, String responseStatus) {
        this.id = id;
        this.parentRequestId = parentRequestId;
        this.selectedOptionId = selectedOptionId;
        this.teacherComment = teacherComment;
        this.responseStatus = responseStatus;
    }

    public Long getId() {
        return id;
    }

    public Long getParentRequestId() {
        return parentRequestId;
    }

    public Long getSelectedOptionId() {
        return selectedOptionId;
    }

    public String getTeacherComment() {
        return teacherComment;
    }

    public String getResponseStatus() {
        return responseStatus;
    }

    public String getResponseStatusLabel() {
        if ("PARENT_CONFIRMING".equals(responseStatus)) {
            return "保護者確認中";
        }
        if ("CONFIRMED".equals(responseStatus)) {
            return "確定";
        }
        if ("RESUBMITTED".equals(responseStatus)) {
            return "再提出";
        }
        if ("WAITING_PARENT".equals(responseStatus)) {
            return "保護者確認待ち";
        }
        if ("CANCELLED".equals(responseStatus)) {
            return "取消";
        }
        return responseStatus;
    }

    public boolean isConfirmed() {
        return "CONFIRMED".equals(responseStatus);
    }

    public void setId(Long id) {
        this.id = id;
    }

    public void setParentRequestId(Long parentRequestId) {
        this.parentRequestId = parentRequestId;
    }

    public void setSelectedOptionId(Long selectedOptionId) {
        this.selectedOptionId = selectedOptionId;
    }

    public void setTeacherComment(String teacherComment) {
        this.teacherComment = teacherComment;
    }

    public void setResponseStatus(String responseStatus) {
        this.responseStatus = responseStatus;
    }
}