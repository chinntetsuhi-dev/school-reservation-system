package com.example.interviewsystem.dao;

import com.example.interviewsystem.model.ChatRoom;

import org.junit.Test;

import java.util.List;

import static org.junit.Assert.*;

public class ChatRoomDaoTest {

    @Test
    public void testFindAll() {
        ChatRoomDao dao = new ChatRoomDao();

        List<ChatRoom> rooms = dao.findAll();

        assertNotNull(rooms);
    }

    @Test
    public void testFindByIdNotFound() {
        ChatRoomDao dao = new ChatRoomDao();

        ChatRoom room = dao.findById(-99999L);

        assertNull(room);
    }

    @Test
    public void testTeacherCanAccessAnyRoom() {
        ChatRoomDao dao = new ChatRoomDao();

        boolean result = dao.canAccessRoom(-99999L, -99999L, "TEACHER");

        assertTrue(result);
    }

    @Test
    public void testUnknownRoleCannotAccessRoom() {
        ChatRoomDao dao = new ChatRoomDao();

        boolean result = dao.canAccessRoom(-99999L, -99999L, "UNKNOWN");

        assertFalse(result);
    }
}