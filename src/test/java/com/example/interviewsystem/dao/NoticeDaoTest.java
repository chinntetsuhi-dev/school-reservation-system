package com.example.interviewsystem.dao;

import com.example.interviewsystem.model.Notice;

import org.junit.Test;

import java.util.List;

import static org.junit.Assert.*;

public class NoticeDaoTest {

    @Test
    public void testFindAll() {
        NoticeDao dao = new NoticeDao();

        List<Notice> notices = dao.findAll();

        assertNotNull(notices);
    }

    @Test
    public void testFindActiveForRoleParent() {
        NoticeDao dao = new NoticeDao();

        List<Notice> notices = dao.findActiveForRole("PARENT");

        assertNotNull(notices);
    }

    @Test
    public void testFindByIdNotFound() {
        NoticeDao dao = new NoticeDao();

        Notice notice = dao.findById(-99999L);

        assertNull(notice);
    }
}