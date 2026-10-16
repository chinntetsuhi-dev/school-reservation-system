package com.example.interviewsystem.dao;

import com.example.interviewsystem.model.ReservationOption;

import org.junit.Test;

import java.util.List;

import static org.junit.Assert.*;

public class ReservationDaoTest {

    @Test
    public void testFixedDates() {
        assertNotNull(ReservationDao.FIXED_DATES);
        assertEquals(5, ReservationDao.FIXED_DATES.size());
        assertEquals("2026-07-06", ReservationDao.FIXED_DATES.get(0));
        assertEquals("2026-07-10", ReservationDao.FIXED_DATES.get(4));
    }

    @Test
    public void testFixedTimes() {
        assertNotNull(ReservationDao.FIXED_TIMES);
        assertEquals(8, ReservationDao.FIXED_TIMES.size());
        assertEquals("12:20", ReservationDao.FIXED_TIMES.get(0));
        assertEquals("17:40", ReservationDao.FIXED_TIMES.get(7));
    }

    @Test
    public void testFindOptionsByDate() {
        ReservationDao dao = new ReservationDao();

        List<ReservationOption> options =
                dao.findOptions("2026-07-06", null, false);

        assertNotNull(options);

        for (ReservationOption option : options) {
            assertEquals("2026-07-06", option.getDate());
        }
    }

    @Test
    public void testFindAvailableOptionsByDate() {
        ReservationDao dao = new ReservationDao();

        List<ReservationOption> options =
                dao.findOptions("2026-07-06", null, true);

        assertNotNull(options);

        for (ReservationOption option : options) {
            assertTrue(option.isAvailable());
        }
    }
}