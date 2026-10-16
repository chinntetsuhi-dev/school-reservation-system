package com.example.interviewsystem.model;

public class InterviewSlot {

    private Long id;
    private String date;
    private String time;
    private boolean deleted;

    public InterviewSlot() {
    }

    public InterviewSlot(Long id, String date, String time, boolean deleted) {
        this.id = id;
        this.date = date;
        this.time = time;
        this.deleted = deleted;
    }

    public Long getId() {
        return id;
    }

    public String getDate() {
        return date;
    }

    public String getTime() {
        return time;
    }

    public boolean isDeleted() {
        return deleted;
    }

    public String getStatusLabel() {
        return deleted ? "削除済み" : "利用可能";
    }

    public void setId(Long id) {
        this.id = id;
    }

    public void setDate(String date) {
        this.date = date;
    }

    public void setTime(String time) {
        this.time = time;
    }

    public void setDeleted(boolean deleted) {
        this.deleted = deleted;
    }
}