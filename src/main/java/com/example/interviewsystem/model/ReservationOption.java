package com.example.interviewsystem.model;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.Locale;

public class ReservationOption {

    private Long id;
    private String date;
    private String time;
    private boolean available;

    public ReservationOption() {
    }

    public ReservationOption(
            Long id,
            String date,
            String time,
            boolean available) {

        this.id = id;
        this.date = date;
        this.time = time;
        this.available = available;
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

    public boolean isAvailable() {
        return available;
    }

    public boolean getAvailable() {
        return available;
    }

    public String getStatusLabel() {
        return available ? "利用可能" : "利用不可";
    }

    public String getDisplayDate() {
        if (date == null || date.trim().isEmpty()) {
            return "";
        }

        LocalDate localDate = LocalDate.parse(date);

        DateTimeFormatter formatter =
                DateTimeFormatter.ofPattern(
                        "M/d（E）",
                        Locale.JAPANESE
                );

        return localDate.format(formatter);
    }

    public String getDisplayTime() {
        if (time == null || time.trim().isEmpty()) {
            return "";
        }

        return time.endsWith("〜")
                ? time
                : time + "〜";
    }

    public String getDisplayLabel() {
        String displayDate = getDisplayDate();
        String displayTime = getDisplayTime();

        if (displayDate.isEmpty() && displayTime.isEmpty()) {
            return "";
        }

        if (displayDate.isEmpty()) {
            return displayTime;
        }

        if (displayTime.isEmpty()) {
            return displayDate;
        }

        return displayDate + " " + displayTime;
    }

    /*
     * 旧画面との互換性を残すためのメソッドです。
     * 今回の固定時間表では施設情報を使用しません。
     */
    public String getFacilityName() {
        return "";
    }

    public Long getFacilityId() {
        return null;
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

    public void setAvailable(boolean available) {
        this.available = available;
    }

    public void setFacilityName(String facilityName) {
        // 今回は使用しません
    }

    public void setFacilityId(Long facilityId) {
        // 今回は使用しません
    }
}