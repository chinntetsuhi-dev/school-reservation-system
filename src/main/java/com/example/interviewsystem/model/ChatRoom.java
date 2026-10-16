package com.example.interviewsystem.model;

public class ChatRoom {

    private Long id;
    private String roomName;
    private Long parentUserId;
    private String parentName;
    private String status;

    public ChatRoom() {
    }

    public ChatRoom(Long id, String roomName, Long parentUserId, String parentName, String status) {
        this.id = id;
        this.roomName = roomName;
        this.parentUserId = parentUserId;
        this.parentName = parentName;
        this.status = status;
    }

    public Long getId() {
        return id;
    }

    public String getRoomName() {
        return roomName;
    }

    public Long getParentUserId() {
        return parentUserId;
    }

    public String getParentName() {
        return parentName;
    }

    public String getStatus() {
        return status;
    }

    public String getStatusLabel() {
        if ("OPEN".equals(status)) return "利用中";
        if ("CLOSED".equals(status)) return "停止中";
        return status;
    }

    public boolean isOpen() {
        return "OPEN".equals(status);
    }

    public void setId(Long id) {
        this.id = id;
    }

    public void setRoomName(String roomName) {
        this.roomName = roomName;
    }

    public void setParentUserId(Long parentUserId) {
        this.parentUserId = parentUserId;
    }

    public void setParentName(String parentName) {
        this.parentName = parentName;
    }

    public void setStatus(String status) {
        this.status = status;
    }
}