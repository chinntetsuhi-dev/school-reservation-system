package com.example.interviewsystem.dao;

import com.example.interviewsystem.model.ParentRequest;
import com.example.interviewsystem.model.ScheduleBuildCell;
import com.example.interviewsystem.model.ScheduleBuildSummary;

import javax.persistence.EntityManager;
import javax.persistence.Query;

import java.util.ArrayList;
import java.util.List;

public class ScheduleBuildDao {

    public List<ParentRequest> findSubmissionRows() {

        return new ParentRequestDao()
                .findSubmissionRows();
    }

    public ScheduleBuildSummary getSummary() {

        EntityManager em = null;

        try {
            em = JpaUtil.createEntityManager();

            Query totalQuery =
                    em.createNativeQuery(
                            "SELECT COUNT(*) "
                                    + "FROM users "
                                    + "WHERE role = 'STUDENT'"
                    );

            Query submittedQuery =
                    em.createNativeQuery(
                            "SELECT COUNT("
                                    + "DISTINCT child_user_id) "
                                    + "FROM parent_requests"
                    );

            int total =
                    ((Number) totalQuery
                            .getSingleResult())
                            .intValue();

            int submitted =
                    ((Number) submittedQuery
                            .getSingleResult())
                            .intValue();

            return new ScheduleBuildSummary(
                    total,
                    submitted
            );

        } finally {

            if (em != null && em.isOpen()) {
                em.close();
            }
        }
    }

    public List<String> findDates() {

        return new ArrayList<>(
                ReservationDao.FIXED_DATES
        );
    }

    public List<String> findTimes() {

        return new ArrayList<>(
                ReservationDao.FIXED_TIMES
        );
    }

    public int countManualRequired() {

        EntityManager em = null;

        try {
            em = JpaUtil.createEntityManager();

            Query query =
                    em.createNativeQuery(
                            "SELECT COUNT(*) "
                                    + "FROM parent_requests pr "
                                    + "LEFT JOIN final_plans fp "
                                    + "ON pr.id "
                                    + "= fp.parent_request_id "
                                    + "WHERE pr.request_status "
                                    + "= 'MANUAL_REQUIRED' "
                                    + "AND fp.id IS NULL"
                    );

            Number count =
                    (Number) query.getSingleResult();

            return count.intValue();

        } finally {

            if (em != null && em.isOpen()) {
                em.close();
            }
        }
    }

    public List<ScheduleBuildCell> findCells() {

        EntityManager em = null;

        try {
            em = JpaUtil.createEntityManager();

            Query query =
                    em.createNativeQuery(
                            "SELECT ro.id, "
                                    + "DATE_FORMAT("
                                    + "ro.option_date, '%Y-%m-%d'), "
                                    + "ro.option_time, "
                                    + "ro.available_flag, "
                                    + "fp.response_status, "
                                    + "u.display_name, "
                                    + "pr.child_name, "
                                    + "("
                                    + " SELECT COUNT(*) "
                                    + " FROM parent_request_options pro2 "
                                    + " JOIN parent_requests pr2 "
                                    + " ON pro2.parent_request_id = pr2.id "
                                    + " LEFT JOIN final_plans fp2 "
                                    + " ON pr2.id = fp2.parent_request_id "
                                    + " JOIN reservation_options ro2 "
                                    + " ON pro2.reservation_option_id "
                                    + "= ro2.id "
                                    + " WHERE "
                                    + "pro2.reservation_option_id = ro.id "
                                    + " AND pro2.priority = 1 "
                                    + " AND pr2.request_status "
                                    + "= 'MANUAL_REQUIRED' "
                                    + " AND fp2.id IS NULL "
                                    + ") AS manual_count "
                                    + "FROM reservation_options ro "
                                    + "LEFT JOIN final_plans fp "
                                    + "ON ro.id = fp.selected_option_id "
                                    + "LEFT JOIN parent_requests pr "
                                    + "ON fp.parent_request_id = pr.id "
                                    + "LEFT JOIN users u "
                                    + "ON pr.parent_user_id = u.id "
                                    + "WHERE ro.option_date BETWEEN "
                                    + "'2026-07-06' "
                                    + "AND '2026-07-10' "
                                    + "ORDER BY "
                                    + "ro.option_date ASC, "
                                    + "FIELD(ro.option_time, "
                                    + "'12:20',"
                                    + "'13:00',"
                                    + "'14:20',"
                                    + "'15:00',"
                                    + "'15:40',"
                                    + "'16:20',"
                                    + "'17:00',"
                                    + "'17:40')"
                    );

            @SuppressWarnings("unchecked")
            List<Object[]> rows =
                    query.getResultList();

            List<ScheduleBuildCell> result =
                    new ArrayList<>();

            for (Object[] row : rows) {

                ScheduleBuildCell cell =
                        new ScheduleBuildCell();

                Long optionId =
                        ((Number) row[0])
                                .longValue();

                String date =
                        (String) row[1];

                String time =
                        (String) row[2];

                boolean available =
                        toBoolean(row[3]);

                String responseStatus =
                        (String) row[4];

                String parentName =
                        (String) row[5];

                String childName =
                        (String) row[6];

                int manualCount =
                        ((Number) row[7])
                                .intValue();

                cell.setOptionId(optionId);
                cell.setDate(date);
                cell.setTime(time);

                cell.setParentName(
                        parentName
                );

                cell.setChildName(
                        childName
                );

                cell.setManualCount(
                        manualCount
                );

                if ("WAITING_PARENT".equals(
                        responseStatus)
                        || "PARENT_CONFIRMING".equals(
                        responseStatus)) {

                    cell.setStatus(
                            "WAITING_PARENT"
                    );

                    cell.setLabel(
                            childName != null
                                    ? childName
                                    : "保護者確認待ち"
                    );

                } else if (
                        "SIBLING_AUTO_CONFIRMED"
                                .equals(responseStatus)) {

                    cell.setStatus(
                            "SIBLING_AUTO_CONFIRMED"
                    );

                    cell.setLabel(
                            childName != null
                                    ? childName
                                    : "兄弟連立"
                    );

                } else if (
                        "AUTO_CONFIRMED"
                                .equals(responseStatus)) {

                    cell.setStatus(
                            "AUTO_CONFIRMED"
                    );

                    cell.setLabel(
                            childName != null
                                    ? childName
                                    : "第1希望確定"
                    );

                } else if ("CONFIRMED".equals(
                        responseStatus)) {

                    cell.setStatus("CONFIRMED");

                    cell.setLabel(
                            childName != null
                                    ? childName
                                    : "確定済み"
                    );

                } else if (manualCount > 0) {

                    cell.setStatus(
                            "MANUAL_REQUIRED"
                    );

                    cell.setLabel(
                            "手動確認必要（"
                                    + manualCount
                                    + "名）"
                    );

                } else if (!available) {

                    cell.setStatus("CLOSED");
                    cell.setLabel("非公開");

                } else {

                    cell.setStatus("OPEN");
                    cell.setLabel("空き");
                }

                result.add(cell);
            }

            return result;

        } finally {

            if (em != null && em.isOpen()) {
                em.close();
            }
        }
    }

    /*
     * 自动分配处理：
     *
     * 1. 只检查第一希望是否冲突。
     * 2. 第一希望相同的所有申请都标记为
     *    MANUAL_REQUIRED。
     * 3. 冲突双方都不会自动分配。
     * 4. 其余申请按照希望顺序寻找可用时间。
     */
    public int executeAutoAssign() {

        EntityManager em = null;

        try {
            em = JpaUtil.createEntityManager();
            em.getTransaction().begin();

            Query conflictQuery =
                    em.createNativeQuery(
                            "SELECT DISTINCT pr.id "
                                    + "FROM parent_requests pr "
                                    + "JOIN parent_request_options pro "
                                    + "ON pr.id "
                                    + "= pro.parent_request_id "
                                    + "LEFT JOIN final_plans fp "
                                    + "ON pr.id "
                                    + "= fp.parent_request_id "
                                    + "WHERE pr.request_status "
                                    + "= 'SUBMITTED' "
                                    + "AND fp.id IS NULL "
                                    + "AND pro.priority = 1 "
                                    + "AND "
                                    + "pro.reservation_option_id IN ("
                                    + "SELECT "
                                    + "pro2.reservation_option_id "
                                    + "FROM "
                                    + "parent_request_options pro2 "
                                    + "JOIN parent_requests pr2 "
                                    + "ON "
                                    + "pro2.parent_request_id "
                                    + "= pr2.id "
                                    + "LEFT JOIN final_plans fp2 "
                                    + "ON pr2.id "
                                    + "= fp2.parent_request_id "
                                    + "WHERE pro2.priority = 1 "
                                    + "AND pr2.request_status "
                                    + "= 'SUBMITTED' "
                                    + "AND fp2.id IS NULL "
                                    + "GROUP BY "
                                    + "pro2.reservation_option_id "
                                    + "HAVING COUNT(*) > 1"
                                    + ")"
                    );

            @SuppressWarnings("unchecked")
            List<Number> conflictRequestIds =
                    conflictQuery.getResultList();

            for (Number conflictRequestId :
                    conflictRequestIds) {

                Query markManual =
                        em.createNativeQuery(
                                "UPDATE parent_requests "
                                        + "SET request_status "
                                        + "= 'MANUAL_REQUIRED' "
                                        + "WHERE id = :requestId"
                        );

                markManual.setParameter(
                        "requestId",
                        conflictRequestId.longValue()
                );

                markManual.executeUpdate();
            }

            /*
             * 上面的冲突处理后，仍然是SUBMITTED的申请だけ
             * 会进入自动分配。
             */
            Query requestQuery =
                    em.createNativeQuery(
                            "SELECT pr.id, "
                                    + "pc.has_sibling_flag "
                                    + "FROM parent_requests pr "
                                    + "LEFT JOIN parent_children pc "
                                    + "ON pr.parent_user_id "
                                    + "= pc.parent_user_id "
                                    + "AND pr.child_user_id "
                                    + "= pc.child_user_id "
                                    + "LEFT JOIN final_plans fp "
                                    + "ON pr.id "
                                    + "= fp.parent_request_id "
                                    + "WHERE pr.request_status "
                                    + "= 'SUBMITTED' "
                                    + "AND fp.id IS NULL "
                                    + "ORDER BY pr.created_at ASC"
                    );

            @SuppressWarnings("unchecked")
            List<Object[]> requests =
                    requestQuery.getResultList();

            int count = 0;

            for (Object[] requestRow : requests) {

                Long requestId =
                        ((Number) requestRow[0])
                                .longValue();

                boolean hasSibling =
                        toBoolean(requestRow[1]);

                ChoiceResult choice =
                        findBestAssignableChoice(
                                em,
                                requestId
                        );

                if (choice == null) {
                    continue;
                }

                String responseStatus;
                String requestStatus;
                String teacherComment;

                if (choice.priority == 1) {

                    responseStatus =
                            hasSibling
                                    ? "SIBLING_AUTO_CONFIRMED"
                                    : "AUTO_CONFIRMED";

                    requestStatus = "CONFIRMED";

                    teacherComment =
                            "第1希望のため自動確定";

                } else {

                    responseStatus =
                            "WAITING_PARENT";

                    requestStatus =
                            "WAITING_PARENT";

                    teacherComment =
                            "第"
                                    + choice.priority
                                    + "希望のため"
                                    + "保護者確認待ち";
                }

                Query insertPlan =
                        em.createNativeQuery(
                                "INSERT INTO final_plans "
                                        + "(parent_request_id, "
                                        + "selected_option_id, "
                                        + "teacher_comment, "
                                        + "response_status) "
                                        + "VALUES "
                                        + "(:requestId, "
                                        + ":optionId, "
                                        + ":teacherComment, "
                                        + ":responseStatus)"
                        );

                insertPlan.setParameter(
                        "requestId",
                        requestId
                );

                insertPlan.setParameter(
                        "optionId",
                        choice.optionId
                );

                insertPlan.setParameter(
                        "teacherComment",
                        teacherComment
                );

                insertPlan.setParameter(
                        "responseStatus",
                        responseStatus
                );

                insertPlan.executeUpdate();

                Query updateRequest =
                        em.createNativeQuery(
                                "UPDATE parent_requests "
                                        + "SET request_status "
                                        + "= :requestStatus "
                                        + "WHERE id = :requestId"
                        );

                updateRequest.setParameter(
                        "requestStatus",
                        requestStatus
                );

                updateRequest.setParameter(
                        "requestId",
                        requestId
                );

                updateRequest.executeUpdate();

                Query updateOption =
                        em.createNativeQuery(
                                "UPDATE reservation_options "
                                        + "SET available_flag = 0 "
                                        + "WHERE id = :optionId"
                        );

                updateOption.setParameter(
                        "optionId",
                        choice.optionId
                );

                updateOption.executeUpdate();

                count++;
            }

            em.getTransaction().commit();

            return count;

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

    private ChoiceResult findBestAssignableChoice(
            EntityManager em,
            Long requestId) {

        Query query =
                em.createNativeQuery(
                        "SELECT "
                                + "pro.reservation_option_id, "
                                + "pro.priority "
                                + "FROM "
                                + "parent_request_options pro "
                                + "JOIN reservation_options ro "
                                + "ON "
                                + "pro.reservation_option_id "
                                + "= ro.id "
                                + "WHERE "
                                + "pro.parent_request_id "
                                + "= :requestId "
                                + "AND ro.available_flag = 1 "
                                + "ORDER BY pro.priority ASC"
                );

        query.setParameter(
                "requestId",
                requestId
        );

        @SuppressWarnings("unchecked")
        List<Object[]> choices =
                query.getResultList();

        for (Object[] row : choices) {

            Long optionId =
                    ((Number) row[0])
                            .longValue();

            int priority =
                    ((Number) row[1])
                            .intValue();

            return new ChoiceResult(
                    optionId,
                    priority
            );
        }

        return null;
    }

    public boolean publishSchedule() {

        if (countManualRequired() > 0) {
            return false;
        }

        EntityManager em = null;

        try {
            em = JpaUtil.createEntityManager();
            em.getTransaction().begin();

            Query query =
                    em.createNativeQuery(
                            "UPDATE final_plans "
                                    + "SET response_status "
                                    + "= 'CONFIRMED' "
                                    + "WHERE response_status IN "
                                    + "('AUTO_CONFIRMED', "
                                    + "'SIBLING_AUTO_CONFIRMED')"
                    );

            query.executeUpdate();

            em.getTransaction().commit();

            return true;

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
            return ((Number) value)
                    .intValue() == 1;
        }

        return false;
    }

    private static class ChoiceResult {

        private final Long optionId;
        private final int priority;

        private ChoiceResult(
                Long optionId,
                int priority) {

            this.optionId = optionId;
            this.priority = priority;
        }
    }
}