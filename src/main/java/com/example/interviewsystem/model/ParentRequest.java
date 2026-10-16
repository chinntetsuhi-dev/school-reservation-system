package com.example.interviewsystem.model;

public class ParentRequest {

    private Long id;
    private Long parentUserId;
    private String parentUsername;
    private Long childUserId;
    private String childName;
    private String comment;
    private String requestStatus;
    private String createdAt;

    private boolean hasSibling;
    private String siblingGroup;

    private ReservationOption firstOption;
    private ReservationOption secondOption;
    private ReservationOption thirdOption;

    private ReservationOption recommendedOption;
    private String recommendedPriorityLabel;
    private String recommendationMessage;
    private boolean manualRequired;

    public ParentRequest() {
    }

    public Long getId() {
        return id;
    }

    public Long getParentUserId() {
        return parentUserId;
    }

    public String getParentUsername() {
        return parentUsername;
    }

    public Long getChildUserId() {
        return childUserId;
    }

    public String getChildName() {
        return childName;
    }

    public String getComment() {
        return comment;
    }

    public String getRequestStatus() {
        return requestStatus;
    }

    public String getCreatedAt() {
        return createdAt;
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

    public ReservationOption getFirstOption() {
        return firstOption;
    }

    public ReservationOption getSecondOption() {
        return secondOption;
    }

    public ReservationOption getThirdOption() {
        return thirdOption;
    }

    public ReservationOption getRecommendedOption() {
        return recommendedOption;
    }

    public String getRecommendedPriorityLabel() {
        return recommendedPriorityLabel;
    }

    public String getRecommendationMessage() {
        return recommendationMessage;
    }

    public boolean isManualRequired() {
        return manualRequired;
    }

    public String getRequestStatusLabel() {
        if (manualRequired
                || "MANUAL_REQUIRED".equals(requestStatus)) {

            return "手動確認必要";
        }

        if ("SUBMITTED".equals(requestStatus)) {
            return "提出済み";
        }

        if ("PARENT_CONFIRMING".equals(requestStatus)
                || "WAITING_PARENT".equals(requestStatus)) {

            return "保護者確認中";
        }

        if ("CONFIRMED".equals(requestStatus)) {
            return "確定";
        }

        if ("RESUBMITTED".equals(requestStatus)) {
            return "再提出";
        }

        if ("CANCELLED".equals(requestStatus)) {
            return "取消";
        }

        return requestStatus == null
                ? "未提出"
                : requestStatus;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public void setParentUserId(Long parentUserId) {
        this.parentUserId = parentUserId;
    }

    public void setParentUsername(String parentUsername) {
        this.parentUsername = parentUsername;
    }

    public void setChildUserId(Long childUserId) {
        this.childUserId = childUserId;
    }

    public void setChildName(String childName) {
        this.childName = childName;
    }

    public void setComment(String comment) {
        this.comment = comment;
    }

    public void setRequestStatus(String requestStatus) {
        this.requestStatus = requestStatus;
    }

    public void setCreatedAt(String createdAt) {
        this.createdAt = createdAt;
    }

    public void setHasSibling(boolean hasSibling) {
        this.hasSibling = hasSibling;
    }

    public void setSiblingGroup(String siblingGroup) {
        this.siblingGroup = siblingGroup;
    }

    public void setFirstOption(
            ReservationOption firstOption) {

        this.firstOption = firstOption;
    }

    public void setSecondOption(
            ReservationOption secondOption) {

        this.secondOption = secondOption;
    }

    public void setThirdOption(
            ReservationOption thirdOption) {

        this.thirdOption = thirdOption;
    }

    public void setRecommendedOption(
            ReservationOption recommendedOption) {

        this.recommendedOption = recommendedOption;
    }

    public void setRecommendedPriorityLabel(
            String recommendedPriorityLabel) {

        this.recommendedPriorityLabel =
                recommendedPriorityLabel;
    }

    public void setRecommendationMessage(
            String recommendationMessage) {

        this.recommendationMessage =
                recommendationMessage;
    }

    public void setManualRequired(
            boolean manualRequired) {

        this.manualRequired = manualRequired;
    }
}