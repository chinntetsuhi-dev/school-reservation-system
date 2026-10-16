package com.example.interviewsystem.model;

public class AvailableOption {

    private Long id;
    private String facilityName;
    private String date;
    private String time;

    public AvailableOption() {
    }

    public AvailableOption(Long id, String facilityName, String date, String time) {
        this.id = id;
        this.facilityName = facilityName;
        this.date = date;
        this.time = time;
    }

    public Long getId() {
        return id;
    }

    public String getFacilityName() {
        return facilityName;
    }

    public String getDate() {
        return date;
    }

    public String getTime() {
        return time;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public void setFacilityName(String facilityName) {
        this.facilityName = facilityName;
    }

    public void setDate(String date) {
        this.date = date;
    }

    public void setTime(String time) {
        this.time = time;
    }
}