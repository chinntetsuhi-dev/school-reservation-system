package com.example.interviewsystem.dao;

import com.example.interviewsystem.model.ReservationOption;
import com.example.interviewsystem.model.ScheduleStatus;

import javax.persistence.EntityManager;
import javax.persistence.Query;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Set;

public class ReservationDao {

    /*
     * 演示画面中使用的固定日期。
     */
    public static final List<String> FIXED_DATES =
            Collections.unmodifiableList(
                    Arrays.asList(
                            "2026-07-06",
                            "2026-07-07",
                            "2026-07-08",
                            "2026-07-09",
                            "2026-07-10"
                    )
            );

    /*
     * 演示画面中使用的固定时间。
     */
    public static final List<String> FIXED_TIMES =
            Collections.unmodifiableList(
                    Arrays.asList(
                            "12:20",
                            "13:00",
                            "14:20",
                            "15:00",
                            "15:40",
                            "16:20",
                            "17:00",
                            "17:40"
                    )
            );

    public List<ReservationOption> findOptions(
            String date,
            String facilityName,
            boolean onlyAvailable) {

        EntityManager em = null;

        try {
            em = JpaUtil.createEntityManager();

            String sql =
                    "SELECT id, "
                            + "DATE_FORMAT(option_date, '%Y-%m-%d'), "
                            + "option_time, "
                            + "available_flag "
                            + "FROM reservation_options "
                            + "WHERE option_date BETWEEN "
                            + "'2026-07-06' AND '2026-07-10' ";

            if (onlyAvailable) {
                sql += "AND available_flag = 1 ";
            }

            if (hasText(date)) {
                sql += "AND option_date = :date ";
            }

            sql +=
                    "ORDER BY option_date, "
                            + "FIELD(option_time, "
                            + "'12:20',"
                            + "'13:00',"
                            + "'14:20',"
                            + "'15:00',"
                            + "'15:40',"
                            + "'16:20',"
                            + "'17:00',"
                            + "'17:40')";

            Query query =
                    em.createNativeQuery(sql);

            if (hasText(date)) {
                query.setParameter("date", date);
            }

            @SuppressWarnings("unchecked")
            List<Object[]> rows =
                    query.getResultList();

            List<ReservationOption> result =
                    new ArrayList<>();

            for (Object[] row : rows) {

                ReservationOption option =
                        new ReservationOption();

                option.setId(
                        ((Number) row[0]).longValue()
                );

                option.setDate(
                        (String) row[1]
                );

                option.setTime(
                        (String) row[2]
                );

                option.setAvailable(
                        toBoolean(row[3])
                );

                result.add(option);
            }

            return result;

        } finally {
            if (em != null && em.isOpen()) {
                em.close();
            }
        }
    }

    public List<ReservationOption> findAllOptions() {

        ensureFixedOptions();

        return findOptions(
                null,
                null,
                false
        );
    }

    public List<ReservationOption> findAvailableOptions(
            String date,
            String facilityName) {

        ensureFixedOptions();

        return findOptions(
                date,
                null,
                true
        );
    }

    public List<ReservationOption> findOptionsByDate(
            String date) {

        ensureOptionsForDate(date);

        return findOptions(
                date,
                null,
                false
        );
    }

    public String findFirstOptionDate() {
        return FIXED_DATES.get(0);
    }

    public List<String> findFixedDates() {

        ensureFixedOptions();

        return FIXED_DATES;
    }

    public List<String> findFixedTimes() {

        ensureFixedOptions();

        return FIXED_TIMES;
    }

    /*
     * 固定日程に必要な時間データがなければ、
     * reservation_optionsへ追加します。
     */
    public void ensureFixedOptions() {

        for (String date : FIXED_DATES) {
            ensureOptionsForDate(date);
        }
    }

    public void ensureOptionsForDate(String date) {

        if (!hasText(date)
                || !FIXED_DATES.contains(date)) {

            return;
        }

        EntityManager em = null;

        try {
            em = JpaUtil.createEntityManager();

            Query countQuery =
                    em.createNativeQuery(
                            "SELECT COUNT(*) "
                                    + "FROM reservation_options "
                                    + "WHERE option_date = :date"
                    );

            countQuery.setParameter("date", date);

            Number count =
                    (Number) countQuery.getSingleResult();

            if (count.longValue()
                    == FIXED_TIMES.size()) {

                return;
            }

            em.getTransaction().begin();

            for (String time : FIXED_TIMES) {

                Query insertQuery =
                        em.createNativeQuery(
                                "INSERT IGNORE INTO "
                                        + "reservation_options "
                                        + "(option_date, "
                                        + "option_time, "
                                        + "available_flag) "
                                        + "VALUES "
                                        + "(:date, :time, 0)"
                        );

                insertQuery.setParameter(
                        "date",
                        date
                );

                insertQuery.setParameter(
                        "time",
                        time
                );

                insertQuery.executeUpdate();
            }

            em.getTransaction().commit();

        } catch (RuntimeException e) {

            if (em != null
                    && em.getTransaction().isActive()) {

                em.getTransaction().rollback();
            }

            throw e;

        } finally {

            if (em != null && em.isOpen()) {
                em.close();
            }
        }
    }

    /*
     * 指定した日付だけの利用可能時間を保存します。
     * 旧画面から利用される可能性があるため残しています。
     */
    public void saveAvailableOptionsForDate(
            String date,
            List<Long> availableOptionIds) {

        ensureOptionsForDate(date);

        EntityManager em = null;

        try {
            em = JpaUtil.createEntityManager();
            em.getTransaction().begin();

            Query resetQuery =
                    em.createNativeQuery(
                            "UPDATE reservation_options ro "
                                    + "SET ro.available_flag = 0 "
                                    + "WHERE ro.option_date = :date "
                                    + "AND ro.id NOT IN "
                                    + "(SELECT fp.selected_option_id "
                                    + "FROM final_plans fp)"
                    );

            resetQuery.setParameter(
                    "date",
                    date
            );

            resetQuery.executeUpdate();

            if (availableOptionIds != null
                    && !availableOptionIds.isEmpty()) {

                Query updateQuery =
                        em.createNativeQuery(
                                "UPDATE reservation_options ro "
                                        + "SET ro.available_flag = 1 "
                                        + "WHERE ro.option_date = :date "
                                        + "AND ro.id IN (:ids) "
                                        + "AND ro.id NOT IN "
                                        + "(SELECT fp.selected_option_id "
                                        + "FROM final_plans fp)"
                        );

                updateQuery.setParameter(
                        "date",
                        date
                );

                updateQuery.setParameter(
                        "ids",
                        availableOptionIds
                );

                updateQuery.executeUpdate();
            }

            em.getTransaction().commit();

        } catch (RuntimeException e) {

            if (em != null
                    && em.getTransaction().isActive()) {

                em.getTransaction().rollback();
            }

            throw e;

        } finally {

            if (em != null && em.isOpen()) {
                em.close();
            }
        }
    }

    /*
     * 教師画面の固定時間表で選択された時間を保存します。
     */
    public void saveAvailableOptions(
            List<Long> availableOptionIds) {

        ensureFixedOptions();

        EntityManager em = null;

        try {
            em = JpaUtil.createEntityManager();
            em.getTransaction().begin();

            Query resetQuery =
                    em.createNativeQuery(
                            "UPDATE reservation_options ro "
                                    + "SET ro.available_flag = 0 "
                                    + "WHERE ro.option_date BETWEEN "
                                    + "'2026-07-06' "
                                    + "AND '2026-07-10' "
                                    + "AND ro.id NOT IN "
                                    + "(SELECT fp.selected_option_id "
                                    + "FROM final_plans fp)"
                    );

            resetQuery.executeUpdate();

            if (availableOptionIds != null
                    && !availableOptionIds.isEmpty()) {

                Query updateQuery =
                        em.createNativeQuery(
                                "UPDATE reservation_options ro "
                                        + "SET ro.available_flag = 1 "
                                        + "WHERE ro.id IN (:ids) "
                                        + "AND ro.option_date BETWEEN "
                                        + "'2026-07-06' "
                                        + "AND '2026-07-10' "
                                        + "AND ro.id NOT IN "
                                        + "(SELECT fp.selected_option_id "
                                        + "FROM final_plans fp)"
                        );

                updateQuery.setParameter(
                        "ids",
                        availableOptionIds
                );

                updateQuery.executeUpdate();
            }

            em.getTransaction().commit();

        } catch (RuntimeException e) {

            if (em != null
                    && em.getTransaction().isActive()) {

                em.getTransaction().rollback();
            }

            throw e;

        } finally {

            if (em != null && em.isOpen()) {
                em.close();
            }
        }
    }

    /*
     * 教師・保護者の日程表示で使用する一覧を取得します。
     */
    public List<ScheduleStatus> findScheduleStatus(
            String date) {

        EntityManager em = null;

        try {
            ensureFixedOptions();

            em = JpaUtil.createEntityManager();

            String sql =
                    "SELECT ro.id, "
                            + "DATE_FORMAT("
                            + "ro.option_date, '%Y-%m-%d'), "
                            + "ro.option_time, "
                            + "ro.available_flag, "
                            + "fp.response_status, "
                            + "u.display_name, "
                            + "pr.child_name "
                            + "FROM reservation_options ro "
                            + "LEFT JOIN final_plans fp "
                            + "ON ro.id = fp.selected_option_id "
                            + "LEFT JOIN parent_requests pr "
                            + "ON fp.parent_request_id = pr.id "
                            + "LEFT JOIN users u "
                            + "ON pr.parent_user_id = u.id "
                            + "WHERE ro.option_date BETWEEN "
                            + "'2026-07-06' "
                            + "AND '2026-07-10' ";

            if (hasText(date)) {
                sql += "AND ro.option_date = :date ";
            }

            sql +=
                    "ORDER BY ro.option_date ASC, "
                            + "FIELD(ro.option_time, "
                            + "'12:20',"
                            + "'13:00',"
                            + "'14:20',"
                            + "'15:00',"
                            + "'15:40',"
                            + "'16:20',"
                            + "'17:00',"
                            + "'17:40')";

            Query query =
                    em.createNativeQuery(sql);

            if (hasText(date)) {
                query.setParameter("date", date);
            }

            @SuppressWarnings("unchecked")
            List<Object[]> rows =
                    query.getResultList();

            List<ScheduleStatus> result =
                    new ArrayList<>();

            for (Object[] row : rows) {

                ScheduleStatus status =
                        new ScheduleStatus();

                status.setOptionId(
                        ((Number) row[0]).longValue()
                );

                status.setDate(
                        (String) row[1]
                );

                status.setTime(
                        (String) row[2]
                );

                status.setAvailable(
                        toBoolean(row[3])
                );

                status.setPlanStatus(
                        (String) row[4]
                );

                status.setParentName(
                        (String) row[5]
                );

                status.setChildName(
                        (String) row[6]
                );

                result.add(status);
            }

            return result;

        } finally {

            if (em != null && em.isOpen()) {
                em.close();
            }
        }
    }

    /*
     * 今回は施設による絞り込みを行いません。
     * 旧Controllerとの互換性のため残しています。
     */
    public Set<String> findFacilityNames() {
        return new LinkedHashSet<String>();
    }

    public ReservationOption findOptionById(
            Long optionId) {

        if (optionId == null) {
            return null;
        }

        EntityManager em = null;

        try {
            em = JpaUtil.createEntityManager();

            Query query =
                    em.createNativeQuery(
                            "SELECT id, "
                                    + "DATE_FORMAT("
                                    + "option_date, '%Y-%m-%d'), "
                                    + "option_time, "
                                    + "available_flag "
                                    + "FROM reservation_options "
                                    + "WHERE id = :id"
                    );

            query.setParameter(
                    "id",
                    optionId
            );

            @SuppressWarnings("unchecked")
            List<Object[]> rows =
                    query.getResultList();

            if (rows.isEmpty()) {
                return null;
            }

            Object[] row = rows.get(0);

            ReservationOption option =
                    new ReservationOption();

            option.setId(
                    ((Number) row[0]).longValue()
            );

            option.setDate(
                    (String) row[1]
            );

            option.setTime(
                    (String) row[2]
            );

            option.setAvailable(
                    toBoolean(row[3])
            );

            return option;

        } finally {

            if (em != null && em.isOpen()) {
                em.close();
            }
        }
    }

    /*
     * 第1希望から第3希望までが、
     * すべて利用可能で重複していないか確認します。
     */
    public boolean areAvailableOptions(
            List<Long> optionIds) {

        if (optionIds == null
                || optionIds.isEmpty()) {

            return false;
        }

        Set<Long> uniqueIds =
                new LinkedHashSet<Long>(optionIds);

        if (uniqueIds.size()
                != optionIds.size()) {

            return false;
        }

        EntityManager em = null;

        try {
            em = JpaUtil.createEntityManager();

            Query query =
                    em.createNativeQuery(
                            "SELECT COUNT(*) "
                                    + "FROM reservation_options "
                                    + "WHERE id IN (:ids) "
                                    + "AND available_flag = 1 "
                                    + "AND option_date BETWEEN "
                                    + "'2026-07-06' "
                                    + "AND '2026-07-10'"
                    );

            query.setParameter(
                    "ids",
                    uniqueIds
            );

            Number count =
                    (Number) query.getSingleResult();

            return count.intValue()
                    == uniqueIds.size();

        } finally {

            if (em != null && em.isOpen()) {
                em.close();
            }
        }
    }

    public void updateAvailable(
            Long optionId,
            boolean available) {

        EntityManager em = null;

        try {
            em = JpaUtil.createEntityManager();
            em.getTransaction().begin();

            Query query =
                    em.createNativeQuery(
                            "UPDATE reservation_options "
                                    + "SET available_flag = :available "
                                    + "WHERE id = :id"
                    );

            query.setParameter(
                    "available",
                    available ? 1 : 0
            );

            query.setParameter(
                    "id",
                    optionId
            );

            query.executeUpdate();

            em.getTransaction().commit();

        } catch (RuntimeException e) {

            if (em != null
                    && em.getTransaction().isActive()) {

                em.getTransaction().rollback();
            }

            throw e;

        } finally {

            if (em != null && em.isOpen()) {
                em.close();
            }
        }
    }

    private boolean toBoolean(Object value) {

        if (value instanceof Boolean) {
            return (Boolean) value;
        }

        if (value instanceof Number) {
            return ((Number) value).intValue() == 1;
        }

        return false;
    }

    private boolean hasText(String value) {
        return value != null && !value.trim().isEmpty();
    }
}