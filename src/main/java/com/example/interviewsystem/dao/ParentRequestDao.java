package com.example.interviewsystem.dao;

import com.example.interviewsystem.model.ParentRequest;
import com.example.interviewsystem.model.ReservationOption;

import javax.persistence.EntityManager;
import javax.persistence.Query;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

public class ParentRequestDao {

    public void insert(
            Long parentUserId,
            Long childUserId,
            String childName,
            Long firstOptionId,
            Long secondOptionId,
            Long thirdOptionId,
            String comment) {

        EntityManager em = null;

        try {
            em = JpaUtil.createEntityManager();
            em.getTransaction().begin();

            Query requestQuery =
                    em.createNativeQuery(
                            "INSERT INTO parent_requests "
                                    + "(parent_user_id, "
                                    + "child_user_id, "
                                    + "child_name, "
                                    + "comment, "
                                    + "request_status) "
                                    + "VALUES "
                                    + "(:parentUserId, "
                                    + ":childUserId, "
                                    + ":childName, "
                                    + ":comment, "
                                    + "'SUBMITTED')"
                    );

            requestQuery.setParameter(
                    "parentUserId",
                    parentUserId
            );

            requestQuery.setParameter(
                    "childUserId",
                    childUserId
            );

            requestQuery.setParameter(
                    "childName",
                    childName
            );

            requestQuery.setParameter(
                    "comment",
                    comment
            );

            requestQuery.executeUpdate();

            Query idQuery =
                    em.createNativeQuery(
                            "SELECT LAST_INSERT_ID()"
                    );

            Long requestId =
                    ((Number) idQuery
                            .getSingleResult())
                            .longValue();

            insertRequestOption(
                    em,
                    requestId,
                    firstOptionId,
                    1
            );

            if (secondOptionId != null) {
                insertRequestOption(
                        em,
                        requestId,
                        secondOptionId,
                        2
                );
            }

            if (thirdOptionId != null) {
                insertRequestOption(
                        em,
                        requestId,
                        thirdOptionId,
                        3
                );
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

    private void insertRequestOption(
            EntityManager em,
            Long requestId,
            Long optionId,
            int priority) {

        Query query =
                em.createNativeQuery(
                        "INSERT INTO parent_request_options "
                                + "(parent_request_id, "
                                + "reservation_option_id, "
                                + "priority) "
                                + "VALUES "
                                + "(:requestId, "
                                + ":optionId, "
                                + ":priority)"
                );

        query.setParameter(
                "requestId",
                requestId
        );

        query.setParameter(
                "optionId",
                optionId
        );

        query.setParameter(
                "priority",
                priority
        );

        query.executeUpdate();
    }

    public boolean existsUnfinishedRequestByChildUserId(
            Long childUserId) {

        EntityManager em = null;

        try {
            em = JpaUtil.createEntityManager();

            Query query =
                    em.createNativeQuery(
                            "SELECT COUNT(*) "
                                    + "FROM parent_requests "
                                    + "WHERE child_user_id "
                                    + "= :childUserId "
                                    + "AND request_status IN "
                                    + "('SUBMITTED', "
                                    + "'MANUAL_REQUIRED', "
                                    + "'PARENT_CONFIRMING', "
                                    + "'WAITING_PARENT', "
                                    + "'RESUBMITTED')"
                    );

            query.setParameter(
                    "childUserId",
                    childUserId
            );

            Number count =
                    (Number) query.getSingleResult();

            return count.longValue() > 0;

        } finally {

            if (em != null && em.isOpen()) {
                em.close();
            }
        }
    }

    public List<ParentRequest> findAll() {

        EntityManager em = null;

        try {
            em = JpaUtil.createEntityManager();

            Query query =
                    em.createNativeQuery(
                            "SELECT pr.id, "
                                    + "pr.parent_user_id, "
                                    + "u.display_name, "
                                    + "pr.child_user_id, "
                                    + "pr.child_name, "
                                    + "pr.comment, "
                                    + "pr.request_status, "
                                    + "DATE_FORMAT("
                                    + "pr.created_at, "
                                    + "'%Y-%m-%d %H:%i:%s'), "
                                    + "pc.has_sibling_flag, "
                                    + "pc.sibling_group "
                                    + "FROM parent_requests pr "
                                    + "JOIN users u "
                                    + "ON pr.parent_user_id = u.id "
                                    + "LEFT JOIN parent_children pc "
                                    + "ON pr.parent_user_id "
                                    + "= pc.parent_user_id "
                                    + "AND pr.child_user_id "
                                    + "= pc.child_user_id "
                                    + "ORDER BY "
                                    + "pr.parent_user_id ASC, "
                                    + "pr.created_at ASC"
                    );

            @SuppressWarnings("unchecked")
            List<Object[]> rows =
                    query.getResultList();

            List<ParentRequest> requests =
                    convertRows(rows);

            attachOptions(requests);
            applyRecommendedOptions(requests);

            return requests;

        } finally {

            if (em != null && em.isOpen()) {
                em.close();
            }
        }
    }

    /*
     * 所有学生的提交状态。
     * 即使还没有提交，也会显示在教师端列表中。
     */
    public List<ParentRequest> findSubmissionRows() {

    EntityManager em = null;

    try {
        em = JpaUtil.createEntityManager();

        Query query =
                em.createNativeQuery(
                        "SELECT "
                                + "pr.id AS request_id, "
                                + "pc.parent_user_id AS parent_user_id, "
                                + "p.display_name AS parent_name, "
                                + "c.id AS child_user_id, "
                                + "c.display_name AS child_name, "
                                + "pr.comment AS request_comment, "
                                + "pr.request_status AS request_status, "
                                + "DATE_FORMAT("
                                + "pr.created_at, "
                                + "'%Y-%m-%d %H:%i'"
                                + ") AS created_at_text, "
                                + "pc.has_sibling_flag "
                                + "AS has_sibling_flag, "
                                + "pc.sibling_group "
                                + "AS sibling_group "
                                + "FROM users c "
                                + "LEFT JOIN parent_children pc "
                                + "ON c.id = pc.child_user_id "
                                + "LEFT JOIN users p "
                                + "ON pc.parent_user_id = p.id "
                                + "LEFT JOIN parent_requests pr "
                                + "ON pr.id = ("
                                + "SELECT MAX(pr2.id) "
                                + "FROM parent_requests pr2 "
                                + "WHERE pr2.child_user_id = c.id"
                                + ") "
                                + "WHERE c.role = 'STUDENT' "
                                + "ORDER BY c.login_id ASC"
                );

        @SuppressWarnings("unchecked")
        List<Object[]> rows =
                query.getResultList();

        List<ParentRequest> requests =
                convertRows(rows);

        attachOptions(requests);

        return requests;

    } finally {

        if (em != null && em.isOpen()) {
            em.close();
        }
    }
}

    public List<ParentRequest>
    findUnfinishedForTeacher() {

        return findUnfinishedForTeacher(null);
    }

    /*
     * 第一希望发生冲突时，可按照第一希望时间
     * 取得需要手动确认的学生。
     */
    public List<ParentRequest>
    findUnfinishedForTeacher(Long firstOptionId) {

        EntityManager em = null;

        try {
            em = JpaUtil.createEntityManager();

            String sql =
                    "SELECT pr.id, "
                            + "pr.parent_user_id, "
                            + "u.display_name, "
                            + "pr.child_user_id, "
                            + "pr.child_name, "
                            + "pr.comment, "
                            + "pr.request_status, "
                            + "DATE_FORMAT("
                            + "pr.created_at, "
                            + "'%Y-%m-%d %H:%i:%s'), "
                            + "pc.has_sibling_flag, "
                            + "pc.sibling_group "
                            + "FROM parent_requests pr "
                            + "JOIN users u "
                            + "ON pr.parent_user_id = u.id "
                            + "LEFT JOIN parent_children pc "
                            + "ON pr.parent_user_id "
                            + "= pc.parent_user_id "
                            + "AND pr.child_user_id "
                            + "= pc.child_user_id "
                            + "LEFT JOIN final_plans fp "
                            + "ON pr.id = fp.parent_request_id "
                            + "WHERE pr.request_status IN "
                            + "('SUBMITTED', 'MANUAL_REQUIRED') "
                            + "AND fp.id IS NULL ";

            if (firstOptionId != null) {
                sql +=
                        "AND EXISTS ("
                                + "SELECT 1 "
                                + "FROM parent_request_options pro "
                                + "WHERE pro.parent_request_id "
                                + "= pr.id "
                                + "AND pro.priority = 1 "
                                + "AND pro.reservation_option_id "
                                + "= :firstOptionId"
                                + ") ";
            }

            sql +=
                    "ORDER BY "
                            + "pr.parent_user_id ASC, "
                            + "pr.created_at ASC";

            Query query =
                    em.createNativeQuery(sql);

            if (firstOptionId != null) {
                query.setParameter(
                        "firstOptionId",
                        firstOptionId
                );
            }

            @SuppressWarnings("unchecked")
            List<Object[]> rows =
                    query.getResultList();

            List<ParentRequest> requests =
                    convertRows(rows);

            attachOptions(requests);
            applyRecommendedOptions(requests);

            return requests;

        } finally {

            if (em != null && em.isOpen()) {
                em.close();
            }
        }
    }

    public List<ParentRequest> findByParentUserId(
            Long parentUserId) {

        EntityManager em = null;

        try {
            em = JpaUtil.createEntityManager();

            Query query =
                    em.createNativeQuery(
                            "SELECT pr.id, "
                                    + "pr.parent_user_id, "
                                    + "u.display_name, "
                                    + "pr.child_user_id, "
                                    + "pr.child_name, "
                                    + "pr.comment, "
                                    + "pr.request_status, "
                                    + "DATE_FORMAT("
                                    + "pr.created_at, "
                                    + "'%Y-%m-%d %H:%i:%s'), "
                                    + "pc.has_sibling_flag, "
                                    + "pc.sibling_group "
                                    + "FROM parent_requests pr "
                                    + "JOIN users u "
                                    + "ON pr.parent_user_id = u.id "
                                    + "LEFT JOIN parent_children pc "
                                    + "ON pr.parent_user_id "
                                    + "= pc.parent_user_id "
                                    + "AND pr.child_user_id "
                                    + "= pc.child_user_id "
                                    + "WHERE pr.parent_user_id "
                                    + "= :parentUserId "
                                    + "ORDER BY pr.created_at DESC"
                    );

            query.setParameter(
                    "parentUserId",
                    parentUserId
            );

            @SuppressWarnings("unchecked")
            List<Object[]> rows =
                    query.getResultList();

            List<ParentRequest> requests =
                    convertRows(rows);

            attachOptions(requests);
            applyRecommendedOptions(requests);

            return requests;

        } finally {

            if (em != null && em.isOpen()) {
                em.close();
            }
        }
    }

    public ParentRequest findById(Long id) {

        EntityManager em = null;

        try {
            em = JpaUtil.createEntityManager();

            Query query =
                    em.createNativeQuery(
                            "SELECT pr.id, "
                                    + "pr.parent_user_id, "
                                    + "u.display_name, "
                                    + "pr.child_user_id, "
                                    + "pr.child_name, "
                                    + "pr.comment, "
                                    + "pr.request_status, "
                                    + "DATE_FORMAT("
                                    + "pr.created_at, "
                                    + "'%Y-%m-%d %H:%i:%s'), "
                                    + "pc.has_sibling_flag, "
                                    + "pc.sibling_group "
                                    + "FROM parent_requests pr "
                                    + "JOIN users u "
                                    + "ON pr.parent_user_id = u.id "
                                    + "LEFT JOIN parent_children pc "
                                    + "ON pr.parent_user_id "
                                    + "= pc.parent_user_id "
                                    + "AND pr.child_user_id "
                                    + "= pc.child_user_id "
                                    + "WHERE pr.id = :id"
                    );

            query.setParameter("id", id);

            @SuppressWarnings("unchecked")
            List<Object[]> rows =
                    query.getResultList();

            List<ParentRequest> result =
                    convertRows(rows);

            if (result.isEmpty()) {
                return null;
            }

            attachOptions(result);
            applyRecommendedOptions(result);

            return result.get(0);

        } finally {

            if (em != null && em.isOpen()) {
                em.close();
            }
        }
    }

    public void updateStatus(
            Long requestId,
            String status) {

        EntityManager em = null;

        try {
            em = JpaUtil.createEntityManager();
            em.getTransaction().begin();

            Query query =
                    em.createNativeQuery(
                            "UPDATE parent_requests "
                                    + "SET request_status = :status "
                                    + "WHERE id = :id"
                    );

            query.setParameter(
                    "status",
                    status
            );

            query.setParameter(
                    "id",
                    requestId
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

    private void attachOptions(
            List<ParentRequest> requests) {

        for (ParentRequest request : requests) {

            if (request.getId() == null) {
                continue;
            }

            request.setFirstOption(
                    findOptionByRequestIdAndPriority(
                            request.getId(),
                            1
                    )
            );

            request.setSecondOption(
                    findOptionByRequestIdAndPriority(
                            request.getId(),
                            2
                    )
            );

            request.setThirdOption(
                    findOptionByRequestIdAndPriority(
                            request.getId(),
                            3
                    )
            );
        }
    }

    private ReservationOption
    findOptionByRequestIdAndPriority(
            Long requestId,
            int priority) {

        EntityManager em = null;

        try {
            em = JpaUtil.createEntityManager();

            Query query =
                    em.createNativeQuery(
                            "SELECT ro.id, "
                                    + "DATE_FORMAT("
                                    + "ro.option_date, '%Y-%m-%d'), "
                                    + "ro.option_time, "
                                    + "ro.available_flag "
                                    + "FROM parent_request_options pro "
                                    + "JOIN reservation_options ro "
                                    + "ON pro.reservation_option_id "
                                    + "= ro.id "
                                    + "WHERE pro.parent_request_id "
                                    + "= :requestId "
                                    + "AND pro.priority = :priority"
                    );

            query.setParameter(
                    "requestId",
                    requestId
            );

            query.setParameter(
                    "priority",
                    priority
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
     * 教师手动确认画面中使用的推荐候选。
     * 实际的冲突判定仍然只确认第一希望。
     */
    private void applyRecommendedOptions(
            List<ParentRequest> requests) {

        Set<Long> usedOptionIds =
                new HashSet<>();

        for (ParentRequest request : requests) {

            if (request.getId() == null) {
                continue;
            }

            ReservationOption siblingBase =
                    findSiblingBaseOption(
                            requests,
                            request
                    );

            if (request.isHasSibling()
                    && siblingBase != null) {

                ReservationOption nearOption =
                        findNearSiblingOption(
                                request,
                                siblingBase,
                                usedOptionIds
                        );

                if (nearOption != null) {

                    request.setRecommendedOption(
                            nearOption
                    );

                    request.setRecommendedPriorityLabel(
                            getPriorityLabel(
                                    request,
                                    nearOption
                            )
                    );

                    request.setRecommendationMessage(
                            "兄弟調整：同じ日で"
                                    + "近い時間のため推薦"
                    );

                    usedOptionIds.add(
                            nearOption.getId()
                    );

                    continue;
                }
            }

            ReservationOption normalOption =
                    findFirstAvailableOption(
                            request,
                            usedOptionIds
                    );

            if (normalOption != null) {

                request.setRecommendedOption(
                        normalOption
                );

                request.setRecommendedPriorityLabel(
                        getPriorityLabel(
                                request,
                                normalOption
                        )
                );

                if (request.isHasSibling()) {
                    request.setRecommendationMessage(
                            "兄弟あり："
                                    + "通常の希望順位で推薦"
                    );

                } else {
                    request.setRecommendationMessage(
                            "先着順と希望順位により推薦"
                    );
                }

                usedOptionIds.add(
                        normalOption.getId()
                );

            } else {

                request.setRecommendedOption(null);

                request.setRecommendedPriorityLabel(
                        "要調整"
                );

                if (request.isHasSibling()) {
                    request.setRecommendationMessage(
                            "兄弟あり："
                                    + "利用可能な候補がないため要調整"
                    );

                } else {
                    request.setRecommendationMessage(
                            "利用可能な希望がありません"
                    );
                }
            }
        }
    }

    private ReservationOption
    findFirstAvailableOption(
            ParentRequest request,
            Set<Long> usedOptionIds) {

        ReservationOption[] options = {
                request.getFirstOption(),
                request.getSecondOption(),
                request.getThirdOption()
        };

        for (ReservationOption option : options) {

            if (option != null
                    && option.isAvailable()
                    && !usedOptionIds.contains(
                    option.getId())) {

                return option;
            }
        }

        return null;
    }

    private ReservationOption
    findSiblingBaseOption(
            List<ParentRequest> requests,
            ParentRequest current) {

        for (ParentRequest other : requests) {

            if (other.getId().equals(
                    current.getId())) {

                continue;
            }

            if (other.getParentUserId().equals(
                    current.getParentUserId())
                    && other.getRecommendedOption()
                    != null) {

                return other.getRecommendedOption();
            }
        }

        return null;
    }

    private ReservationOption
    findNearSiblingOption(
            ParentRequest request,
            ReservationOption base,
            Set<Long> usedOptionIds) {

        ReservationOption best = null;
        int bestScore = -1;

        ReservationOption[] options = {
                request.getFirstOption(),
                request.getSecondOption(),
                request.getThirdOption()
        };

        for (ReservationOption option : options) {

            if (option == null
                    || !option.isAvailable()
                    || usedOptionIds.contains(
                    option.getId())) {

                continue;
            }

            int score =
                    scoreSiblingOption(
                            option,
                            base
                    );

            if (score > bestScore) {
                bestScore = score;
                best = option;
            }
        }

        return best;
    }

    private int scoreSiblingOption(
            ReservationOption option,
            ReservationOption base) {

        int score = 0;

        if (option.getDate().equals(
                base.getDate())) {

            score += 100;
        }

        int diff =
                Math.abs(
                        getStartMinutes(
                                option.getTime()
                        )
                                - getStartMinutes(
                                base.getTime()
                        )
                );

        if (diff == 40) {
            score += 60;

        } else if (diff == 80) {
            score += 40;

        } else if (diff == 120) {
            score += 20;
        }

        return score;
    }

    private int getStartMinutes(
            String timeRange) {

        if (timeRange == null
                || !timeRange.contains(":")) {

            return 0;
        }

        String start =
                timeRange.split("-")[0];

        String[] parts =
                start.split(":");

        return Integer.parseInt(parts[0])
                * 60
                + Integer.parseInt(parts[1]);
    }

    private String getPriorityLabel(
            ParentRequest request,
            ReservationOption option) {

        if (request.getFirstOption() != null
                && request.getFirstOption()
                .getId()
                .equals(option.getId())) {

            return "第1希望";
        }

        if (request.getSecondOption() != null
                && request.getSecondOption()
                .getId()
                .equals(option.getId())) {

            return "第2希望";
        }

        if (request.getThirdOption() != null
                && request.getThirdOption()
                .getId()
                .equals(option.getId())) {

            return "第3希望";
        }

        return "推薦候補";
    }

    private List<ParentRequest> convertRows(
            List<Object[]> rows) {

        List<ParentRequest> result =
                new ArrayList<>();

        for (Object[] row : rows) {

            ParentRequest request =
                    new ParentRequest();

            if (row[0] != null) {
                request.setId(
                        ((Number) row[0])
                                .longValue()
                );
            }

            if (row[1] != null) {
                request.setParentUserId(
                        ((Number) row[1])
                                .longValue()
                );
            }

            request.setParentUsername(
                    (String) row[2]
            );

            if (row[3] != null) {
                request.setChildUserId(
                        ((Number) row[3])
                                .longValue()
                );
            }

            request.setChildName(
                    (String) row[4]
            );

            request.setComment(
                    (String) row[5]
            );

            request.setRequestStatus(
                    (String) row[6]
            );

            request.setCreatedAt(
                    (String) row[7]
            );

            request.setHasSibling(
                    toBoolean(row[8])
            );

            request.setSiblingGroup(
                    (String) row[9]
            );

            request.setManualRequired(
                    "MANUAL_REQUIRED".equals(
                            request.getRequestStatus()
                    )
            );

            result.add(request);
        }

        return result;
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
}