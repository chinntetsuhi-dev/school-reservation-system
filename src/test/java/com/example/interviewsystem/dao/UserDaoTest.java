package com.example.interviewsystem.dao;

import com.example.interviewsystem.model.User;

import org.junit.Test;

import static org.junit.Assert.*;

public class UserDaoTest {

    @Test
    public void testFindByLoginIdAndPasswordTeacher() {
        UserDao dao = new UserDao();

        User user = dao.findByLoginIdAndPassword("T1", "1234");

        assertNotNull(user);
        assertEquals("T1", user.getLoginId());
        assertTrue("TEACHER".equalsIgnoreCase(user.getRole()));
    }

    @Test
    public void testFindByLoginIdAndPasswordNotFound() {
        UserDao dao = new UserDao();

        User user = dao.findByLoginIdAndPassword("NOT_EXIST_USER", "wrong");

        assertNull(user);
    }

    @Test
    public void testFindByIdNotFound() {
        UserDao dao = new UserDao();

        User user = dao.findById(-99999L);

        assertNull(user);
    }
}