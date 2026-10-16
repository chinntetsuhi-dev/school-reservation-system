package com.example.interviewsystem.dao;

import com.example.interviewsystem.model.ScheduleBuildCell;
import com.example.interviewsystem.model.ScheduleBuildSummary;

import org.junit.Test;

import java.util.List;

import static org.junit.Assert.*;

public class ScheduleBuildDaoTest {

    @Test
    public void testFindDates() {
        ScheduleBuildDao dao = new ScheduleBuildDao();

        List<String> dates = dao.findDates();

        assertNotNull(dates);
        assertEquals(5, dates.size());
    }

    @Test
    public void testFindTimes() {
        ScheduleBuildDao dao = new ScheduleBuildDao();

        List<String> times = dao.findTimes();

        assertNotNull(times);
        assertEquals(8, times.size());
    }

    @Test
    public void testCountManualRequired() {
        ScheduleBuildDao dao = new ScheduleBuildDao();

        int count = dao.countManualRequired();

        assertTrue(count >= 0);
    }

    @Test
    public void testGetSummary() {
        ScheduleBuildDao dao = new ScheduleBuildDao();

        ScheduleBuildSummary summary = dao.getSummary();

        assertNotNull(summary);
    }

    @Test
    public void testFindCells() {
        ScheduleBuildDao dao = new ScheduleBuildDao();

        List<ScheduleBuildCell> cells = dao.findCells();

        assertNotNull(cells);
    }
}