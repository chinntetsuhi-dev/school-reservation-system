package com.example.interviewsystem.model;

public class ChatMessage {

    private Long id;
    private Long roomId;
    private String senderName;
    private String message;
    private String sentAt;

    public ChatMessage() {
    }

    public Long getId() {
        return id;
    }

    public Long getRoomId() {
        return roomId;
    }

    public String getSenderName() {
        return senderName;
    }

    public String getMessage() {
        return message;
    }

    public String getSentAt() {
        return sentAt;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public void setRoomId(Long roomId) {
        this.roomId = roomId;
    }

    public void setSenderName(String senderName) {
        this.senderName = senderName;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public void setSentAt(String sentAt) {
        this.sentAt = sentAt;
    }
}