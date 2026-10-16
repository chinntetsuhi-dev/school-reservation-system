package com.example.interviewsystem.controller;

import com.example.interviewsystem.dao.JpaUtil;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import javax.persistence.EntityManager;
import javax.persistence.Query;
import javax.servlet.http.HttpSession;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

@Controller
public class ScheduleChangeController {

    @GetMapping("/teacher/schedule-change")
    public String scheduleChange(
            HttpSession session,
            @RequestParam(
                    value = "message",
                    required = false
            ) String message,
            Model model) {

        Long loginUserId =
                (Long) session.getAttribute("loginUserId");

        String role =
                (String) session.getAttribute("loginRole");

        if (loginUserId == null
                || !"TEACHER".equals(role)) {

            return "redirect:/login";
        }

        List<String> dates = findDates();
        List<String> times = findTimes();
        List<ScheduleChangeCell> cells = findCells();

        Map<String, ScheduleChangeCell> cellMap =
                new HashMap<String, ScheduleChangeCell>();

        for (ScheduleChangeCell cell : cells) {
            cellMap.put(
                    cell.getDate()
                            + "_"
                            + cell.getTime(),
                    cell
            );
        }

        int manualCount =
                countManualRequired();

        model.addAttribute("dates", dates);
        model.addAttribute("times", times);
        model.addAttribute("cellMap", cellMap);
        model.addAttribute("manualCount", manualCount);
        model.addAttribute("message", null);

        if ("manualRemaining".equals(message)) {
            model.addAttribute(
                    "errorMessage",
                    "手動確認が必要な児童が残っています。"
                            + "赤色の枠を確認してください。"
            );
        }

        return "teacher/schedule-change";
    }

    @PostMapping("/teacher/schedule-change/save")
    public String saveScheduleChange(
            HttpSession session,
            @RequestParam(
                    value = "assignments",
                    required = false
            ) String assignments,
            Model model) {

        Long loginUserId =
                (Long) session.getAttribute("loginUserId");

        String role =
                (String) session.getAttribute("loginRole");

        if (loginUserId == null
                || !"TEACHER".equals(role)) {

            return "redirect:/login";
        }

        if (assignments == null
                || assignments.trim().isEmpty()) {

            return "redirect:/teacher/schedule-change";
        }

        boolean success =
                updateAssignments(assignments);

        List<String> dates = findDates();
        List<String> times = findTimes();
        List<ScheduleChangeCell> cells = findCells();

        Map<String, ScheduleChangeCell> cellMap =
                new HashMap<String, ScheduleChangeCell>();

        for (ScheduleChangeCell cell : cells) {
            cellMap.put(
                    cell.getDate()
                            + "_"
                            + cell.getTime(),
                    cell
            );
        }

        int manualCount =
                countManualRequired();

        model.addAttribute("dates", dates);
        model.addAttribute("times", times);
        model.addAttribute("cellMap", cellMap);
        model.addAttribute("manualCount", manualCount);

        if (success) {
            model.addAttribute(
                    "message",
                    "日程変更を保存しました。"
            );
        } else {
            model.addAttribute(
                    "errorMessage",
                    "日程変更の保存に失敗しました。"
            );
        }

        return "teacher/schedule-change";
    }

    private List<String> findDates() {
        EntityManager em = null;

        try {
            em = JpaUtil.createEntityManager();

            Query query =
                    em.createNativeQuery(
                            "SELECT DATE_FORMAT(option_date, '%Y-%m-%d') "
                                    + "FROM reservation_options "
                                    + "WHERE option_date BETWEEN "
                                    + "'2026-07-06' AND '2026-07-10' "
                                    + "GROUP BY option_date "
                                    + "ORDER BY option_date ASC"
                    );

            @SuppressWarnings("unchecked")
            List<String> rows =
                    query.getResultList();

            return rows;

        } finally {
            if (em != null && em.isOpen()) {
                em.close();
            }
        }
    }

    private List<String> findTimes() {
        EntityManager em = null;

        try {
            em = JpaUtil.createEntityManager();

            Query query =
                    em.createNativeQuery(
                            "SELECT option_time "
                                    + "FROM reservation_options "
                                    + "WHERE option_date BETWEEN "
                                    + "'2026-07-06' AND '2026-07-10' "
                                    + "GROUP BY option_time "
                                    + "ORDER BY FIELD("
                                    + "option_time, "
                                    + "'12:20', "
                                    + "'13:00', "
                                    + "'14:20', "
                                    + "'15:00', "
                                    + "'15:40', "
                                    + "'16:20', "
                                    + "'17:00', "
                                    + "'17:40')"
                    );

            @SuppressWarnings("unchecked")
            List<String> rows =
                    query.getResultList();

            return rows;

        } finally {
            if (em != null && em.isOpen()) {
                em.close();
            }
        }
    }

    private List<ScheduleChangeCell> findCells() {
        EntityManager em = null;

        try {
            em = JpaUtil.createEntityManager();

            Query query =
                    em.createNativeQuery(
                            "SELECT "
                                    + "ro.id AS option_id, "
                                    + "DATE_FORMAT(ro.option_date, '%Y-%m-%d') AS option_date, "
                                    + "ro.option_time, "
                                    + "fp.id AS plan_id, "
                                    + "fp.parent_request_id, "
                                    + "fp.response_status, "
                                    + "pr.child_name, "
                                    + "child.display_name AS child_display_name, "
                                    + "child.class_name, "
                                    + "parent.display_name AS parent_name, "
                                    + "("
                                    + " SELECT COUNT(*) "
                                    + " FROM parent_request_options pro2 "
                                    + " JOIN parent_requests pr2 "
                                    + " ON pro2.parent_request_id = pr2.id "
                                    + " LEFT JOIN final_plans fp2 "
                                    + " ON pr2.id = fp2.parent_request_id "
                                    + " WHERE pro2.reservation_option_id = ro.id "
                                    + " AND pro2.priority = 1 "
                                    + " AND pr2.request_status = 'MANUAL_REQUIRED' "
                                    + " AND fp2.id IS NULL "
                                    + ") AS manual_count, "
                                    + "("
                                    + " SELECT GROUP_CONCAT("
                                    + " COALESCE(st2.display_name, pr3.child_name) "
                                    + " ORDER BY COALESCE(st2.display_name, pr3.child_name) "
                                    + " SEPARATOR '、') "
                                    + " FROM parent_request_options pro3 "
                                    + " JOIN parent_requests pr3 "
                                    + " ON pro3.parent_request_id = pr3.id "
                                    + " LEFT JOIN final_plans fp3 "
                                    + " ON pr3.id = fp3.parent_request_id "
                                    + " LEFT JOIN users st2 "
                                    + " ON pr3.child_user_id = st2.id "
                                    + " WHERE pro3.reservation_option_id = ro.id "
                                    + " AND pro3.priority = 1 "
                                    + " AND pr3.request_status = 'MANUAL_REQUIRED' "
                                    + " AND fp3.id IS NULL "
                                    + ") AS manual_names "
                                    + "FROM reservation_options ro "
                                    + "LEFT JOIN final_plans fp "
                                    + "ON ro.id = fp.selected_option_id "
                                    + "AND fp.response_status IN "
                                    + "('CONFIRMED', 'AUTO_CONFIRMED', 'SIBLING_AUTO_CONFIRMED') "
                                    + "LEFT JOIN parent_requests pr "
                                    + "ON fp.parent_request_id = pr.id "
                                    + "LEFT JOIN users child "
                                    + "ON pr.child_user_id = child.id "
                                    + "LEFT JOIN users parent "
                                    + "ON pr.parent_user_id = parent.id "
                                    + "WHERE ro.option_date BETWEEN "
                                    + "'2026-07-06' AND '2026-07-10' "
                                    + "ORDER BY ro.option_date ASC, "
                                    + "FIELD(ro.option_time, "
                                    + "'12:20', "
                                    + "'13:00', "
                                    + "'14:20', "
                                    + "'15:00', "
                                    + "'15:40', "
                                    + "'16:20', "
                                    + "'17:00', "
                                    + "'17:40')"
                    );

            @SuppressWarnings("unchecked")
            List<Object[]> rows =
                    query.getResultList();

            List<ScheduleChangeCell> result =
                    new ArrayList<ScheduleChangeCell>();

            for (Object[] row : rows) {
                ScheduleChangeCell cell =
                        new ScheduleChangeCell();

                cell.setOptionId(
                        ((Number) row[0]).longValue()
                );

                cell.setDate(
                        (String) row[1]
                );

                cell.setTime(
                        (String) row[2]
                );

                if (row[3] != null) {
                    cell.setPlanId(
                            ((Number) row[3]).longValue()
                    );
                }

                if (row[4] != null) {
                    cell.setParentRequestId(
                            ((Number) row[4]).longValue()
                    );
                }

                cell.setResponseStatus(
                        (String) row[5]
                );

                String childName =
                        row[7] != null
                                ? (String) row[7]
                                : (String) row[6];

                cell.setChildName(childName);
                cell.setClassName((String) row[8]);
                cell.setParentName((String) row[9]);

                int manualCount = 0;

                if (row[10] != null) {
                    manualCount =
                            ((Number) row[10]).intValue();
                }

                cell.setManualCount(manualCount);
                cell.setManualNames((String) row[11]);

                result.add(cell);
            }

            return result;

        } finally {
            if (em != null && em.isOpen()) {
                em.close();
            }
        }
    }

    private int countManualRequired() {
        EntityManager em = null;

        try {
            em = JpaUtil.createEntityManager();

            Query query =
                    em.createNativeQuery(
                            "SELECT COUNT(*) "
                                    + "FROM parent_requests pr "
                                    + "LEFT JOIN final_plans fp "
                                    + "ON pr.id = fp.parent_request_id "
                                    + "WHERE pr.request_status = 'MANUAL_REQUIRED' "
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

    private boolean updateAssignments(String assignments) {
        Map<Long, Long> planToNewOption =
                parseAssignments(assignments);

        if (planToNewOption.isEmpty()) {
            return false;
        }

        Set<Long> uniqueOptionIds =
                new HashSet<Long>(
                        planToNewOption.values()
                );

        if (uniqueOptionIds.size()
                != planToNewOption.values().size()) {

            return false;
        }

        EntityManager em = null;

        try {
            em = JpaUtil.createEntityManager();
            em.getTransaction().begin();

            Map<Long, Long> oldOptionMap =
                    findCurrentOptionMap(
                            em,
                            planToNewOption.keySet()
                    );

            for (Map.Entry<Long, Long> entry :
                    planToNewOption.entrySet()) {

                Long planId = entry.getKey();
                Long newOptionId = entry.getValue();

                if (!oldOptionMap.containsKey(planId)) {
                    em.getTransaction().rollback();
                    return false;
                }

                Query updatePlanQuery =
                        em.createNativeQuery(
                                "UPDATE final_plans "
                                        + "SET selected_option_id = :optionId, "
                                        + "response_status = 'CONFIRMED' "
                                        + "WHERE id = :planId"
                        );

                updatePlanQuery.setParameter(
                        "optionId",
                        newOptionId
                );

                updatePlanQuery.setParameter(
                        "planId",
                        planId
                );

                updatePlanQuery.executeUpdate();

                Query updateRequestQuery =
                        em.createNativeQuery(
                                "UPDATE parent_requests pr "
                                        + "INNER JOIN final_plans fp "
                                        + "ON pr.id = fp.parent_request_id "
                                        + "SET pr.request_status = 'CONFIRMED' "
                                        + "WHERE fp.id = :planId"
                        );

                updateRequestQuery.setParameter(
                        "planId",
                        planId
                );

                updateRequestQuery.executeUpdate();
            }

            Set<Long> oldOptionIds =
                    new HashSet<Long>(
                            oldOptionMap.values()
                    );

            Set<Long> newOptionIds =
                    new HashSet<Long>(
                            planToNewOption.values()
                    );

            for (Long oldOptionId : oldOptionIds) {
                if (!newOptionIds.contains(oldOptionId)) {
                    updateOptionAvailable(
                            em,
                            oldOptionId,
                            true
                    );
                }
            }

            for (Long newOptionId : newOptionIds) {
                updateOptionAvailable(
                        em,
                        newOptionId,
                        false
                );
            }

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

    private Map<Long, Long> parseAssignments(String assignments) {
        Map<Long, Long> result =
                new HashMap<Long, Long>();

        String[] pairs =
                assignments.split(",");

        for (String pair : pairs) {
            if (pair == null
                    || pair.trim().isEmpty()) {

                continue;
            }

            String[] values =
                    pair.split(":");

            if (values.length != 2) {
                continue;
            }

            try {
                Long planId =
                        Long.valueOf(values[0].trim());

                Long optionId =
                        Long.valueOf(values[1].trim());

                result.put(planId, optionId);

            } catch (NumberFormatException e) {
                return new HashMap<Long, Long>();
            }
        }

        return result;
    }

    private Map<Long, Long> findCurrentOptionMap(
            EntityManager em,
            Set<Long> planIds) {

        Map<Long, Long> result =
                new HashMap<Long, Long>();

        if (planIds == null || planIds.isEmpty()) {
            return result;
        }

        Query query =
                em.createNativeQuery(
                        "SELECT id, selected_option_id "
                                + "FROM final_plans "
                                + "WHERE id IN (:ids)"
                );

        query.setParameter("ids", planIds);

        @SuppressWarnings("unchecked")
        List<Object[]> rows =
                query.getResultList();

        for (Object[] row : rows) {
            result.put(
                    ((Number) row[0]).longValue(),
                    ((Number) row[1]).longValue()
            );
        }

        return result;
    }

    private void updateOptionAvailable(
            EntityManager em,
            Long optionId,
            boolean available) {

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
    }

    public static class ScheduleChangeCell {

        private Long optionId;
        private String date;
        private String time;

        private Long planId;
        private Long parentRequestId;
        private String responseStatus;

        private String childName;
        private String className;
        private String parentName;

        private int manualCount;
        private String manualNames;

        public Long getOptionId() {
            return optionId;
        }

        public void setOptionId(Long optionId) {
            this.optionId = optionId;
        }

        public String getDate() {
            return date;
        }

        public void setDate(String date) {
            this.date = date;
        }

        public String getTime() {
            return time;
        }

        public void setTime(String time) {
            this.time = time;
        }

        public Long getPlanId() {
            return planId;
        }

        public void setPlanId(Long planId) {
            this.planId = planId;
        }

        public Long getParentRequestId() {
            return parentRequestId;
        }

        public void setParentRequestId(Long parentRequestId) {
            this.parentRequestId = parentRequestId;
        }

        public String getResponseStatus() {
            return responseStatus;
        }

        public void setResponseStatus(String responseStatus) {
            this.responseStatus = responseStatus;
        }

        public String getChildName() {
            return childName;
        }

        public void setChildName(String childName) {
            this.childName = childName;
        }

        public String getClassName() {
            return className;
        }

        public void setClassName(String className) {
            this.className = className;
        }

        public String getParentName() {
            return parentName;
        }

        public void setParentName(String parentName) {
            this.parentName = parentName;
        }

        public int getManualCount() {
            return manualCount;
        }

        public void setManualCount(int manualCount) {
            this.manualCount = manualCount;
        }

        public String getManualNames() {
            return manualNames;
        }

        public void setManualNames(String manualNames) {
            this.manualNames = manualNames;
        }

        public boolean isOccupied() {
            return planId != null;
        }

        public boolean getOccupied() {
            return planId != null;
        }

        public boolean isManualRequired() {
            return manualCount > 0;
        }

        public boolean getManualRequired() {
            return manualCount > 0;
        }
    }
}