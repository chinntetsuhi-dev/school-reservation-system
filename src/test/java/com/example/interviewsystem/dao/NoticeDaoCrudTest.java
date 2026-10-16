package com.example.interviewsystem.dao;

import com.example.interviewsystem.model.Notice;

import org.junit.Test;

import java.util.List;

import static org.junit.Assert.*;

public class NoticeDaoCrudTest {

    @Test
    public void testInsertUpdateToggleDeleteNotice() {
        NoticeDao dao = new NoticeDao();

        String title = "JUnitテスト用お知らせ";
        String content = "JUnitテスト用本文";

        dao.insert(title, content, true, "ALL");

        Notice inserted = findByTitle(dao.findAll(), title);
        assertNotNull(inserted);
        assertEquals(title, inserted.getTitle());
        assertEquals(content, inserted.getContent());
        assertTrue(inserted.isActive());

        Long id = inserted.getId();

        dao.update(id, "JUnit更新タイトル", "JUnit更新本文", false, "TEACHER");

        Notice updated = dao.findById(id);
        assertNotNull(updated);
        assertEquals("JUnit更新タイトル", updated.getTitle());
        assertEquals("JUnit更新本文", updated.getContent());
        assertFalse(updated.isActive());
        assertEquals("TEACHER", updated.getTargetRole());

        dao.toggle(id);

        Notice toggled = dao.findById(id);
        assertNotNull(toggled);
        assertTrue(toggled.isActive());

        dao.delete(id);

        Notice deleted = dao.findById(id);
        assertNull(deleted);
    }

    private Notice findByTitle(List<Notice> notices, String title) {
        if (notices == null) {
            return null;
        }

        for (Notice notice : notices) {
            if (title.equals(notice.getTitle())) {
                return notice;
            }
        }

        return null;
    }
}