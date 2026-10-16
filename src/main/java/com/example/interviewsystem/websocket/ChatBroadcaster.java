package com.example.interviewsystem.websocket;

import javax.websocket.OnClose;
import javax.websocket.OnError;
import javax.websocket.OnOpen;
import javax.websocket.Session;
import javax.websocket.server.PathParam;
import javax.websocket.server.ServerEndpoint;

import java.io.IOException;
import java.util.Collections;
import java.util.Set;
import java.util.concurrent.ConcurrentHashMap;

@ServerEndpoint("/ws/chat/{roomId}")
public class ChatBroadcaster {

    private static final ConcurrentHashMap<Long, Set<Session>> ROOM_SESSIONS =
            new ConcurrentHashMap<Long, Set<Session>>();

    @OnOpen
    public void onOpen(
            Session session,
            @PathParam("roomId") String roomIdText) {

        Long roomId = parseLong(roomIdText);

        if (roomId == null) {
            try {
                session.close();
            } catch (IOException e) {
                // 何もしない
            }
            return;
        }

        session.getUserProperties().put("roomId", roomId);

        Set<Session> sessions =
                ROOM_SESSIONS.get(roomId);

        if (sessions == null) {
            sessions =
                    Collections.newSetFromMap(
                            new ConcurrentHashMap<Session, Boolean>()
                    );

            Set<Session> existing =
                    ROOM_SESSIONS.putIfAbsent(roomId, sessions);

            if (existing != null) {
                sessions = existing;
            }
        }

        sessions.add(session);
    }

    @OnClose
    public void onClose(Session session) {
        removeSession(session);
    }

    @OnError
    public void onError(
            Session session,
            Throwable throwable) {

        removeSession(session);
    }

    public static void broadcastRoom(
            Long roomId,
            String message) {

        if (roomId == null) {
            return;
        }

        Set<Session> sessions =
                ROOM_SESSIONS.get(roomId);

        if (sessions == null || sessions.isEmpty()) {
            return;
        }

        for (Session session : sessions) {
            if (session != null && session.isOpen()) {
                try {
                    session.getBasicRemote().sendText(message);
                } catch (IOException e) {
                    removeSession(session);
                }
            }
        }
    }

    private static void removeSession(Session session) {
        if (session == null) {
            return;
        }

        Object roomIdObject =
                session.getUserProperties().get("roomId");

        if (!(roomIdObject instanceof Long)) {
            return;
        }

        Long roomId = (Long) roomIdObject;

        Set<Session> sessions =
                ROOM_SESSIONS.get(roomId);

        if (sessions != null) {
            sessions.remove(session);

            if (sessions.isEmpty()) {
                ROOM_SESSIONS.remove(roomId);
            }
        }
    }

    private static Long parseLong(String value) {
        if (value == null || value.trim().isEmpty()) {
            return null;
        }

        try {
            return Long.valueOf(value);
        } catch (NumberFormatException e) {
            return null;
        }
    }
}