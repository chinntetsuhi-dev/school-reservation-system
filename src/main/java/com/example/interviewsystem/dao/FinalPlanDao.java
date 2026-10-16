package com.example.interviewsystem.dao;

import com.example.interviewsystem.model.FinalPlan;

import javax.persistence.EntityManager;
import javax.persistence.Query;
import java.util.ArrayList;
import java.util.List;

public class FinalPlanDao {

    public List<FinalPlan> findAll() {
        EntityManager em = null;

        try {
            em = JpaUtil.createEntityManager();

            Query query = em.createNativeQuery(
                    "SELECT id, parent_request_id, selected_option_id, teacher_comment, response_status " +
                    "FROM final_plans ORDER BY id DESC"
            );

            @SuppressWarnings("unchecked")
            List<Object[]> rows = query.getResultList();

            List<FinalPlan> result = new ArrayList<>();

            for (Object[] row : rows) {
                result.add(convert(row));
            }

            return result;

        } finally {
            if (em != null && em.isOpen()) {
                em.close();
            }
        }
    }

    public FinalPlan findByRequestId(Long requestId) {
        EntityManager em = null;

        try {
            em = JpaUtil.createEntityManager();

            Query query = em.createNativeQuery(
                    "SELECT id, parent_request_id, selected_option_id, teacher_comment, response_status " +
                    "FROM final_plans WHERE parent_request_id = :requestId"
            );

            query.setParameter("requestId", requestId);

            @SuppressWarnings("unchecked")
            List<Object[]> rows = query.getResultList();

            if (rows.isEmpty()) {
                return null;
            }

            return convert(rows.get(0));

        } finally {
            if (em != null && em.isOpen()) {
                em.close();
            }
        }
    }

    public void saveOrUpdate(Long requestId, Long selectedOptionId, String teacherComment) {
        FinalPlan existing = findByRequestId(requestId);

        EntityManager em = null;

        try {
            em = JpaUtil.createEntityManager();
            em.getTransaction().begin();

            if (existing == null) {
                Query query = em.createNativeQuery(
                        "INSERT INTO final_plans " +
                        "(parent_request_id, selected_option_id, teacher_comment, response_status) " +
                        "VALUES (:requestId, :selectedOptionId, :teacherComment, 'WAITING_PARENT')"
                );

                query.setParameter("requestId", requestId);
                query.setParameter("selectedOptionId", selectedOptionId);
                query.setParameter("teacherComment", teacherComment);
                query.executeUpdate();

            } else {
                Query query = em.createNativeQuery(
                        "UPDATE final_plans " +
                        "SET selected_option_id = :selectedOptionId, " +
                        "teacher_comment = :teacherComment, " +
                        "response_status = 'WAITING_PARENT' " +
                        "WHERE parent_request_id = :requestId"
                );

                query.setParameter("selectedOptionId", selectedOptionId);
                query.setParameter("teacherComment", teacherComment);
                query.setParameter("requestId", requestId);
                query.executeUpdate();
            }

            em.getTransaction().commit();

        } catch (RuntimeException e) {
            if (em != null && em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            throw e;

        } finally {
            if (em != null && em.isOpen()) {
                em.close();
            }
        }
    }

    public void updateResponseStatusByRequestId(Long requestId, String responseStatus) {
        EntityManager em = null;

        try {
            em = JpaUtil.createEntityManager();
            em.getTransaction().begin();

            Query query = em.createNativeQuery(
                    "UPDATE final_plans " +
                    "SET response_status = :responseStatus " +
                    "WHERE parent_request_id = :requestId"
            );

            query.setParameter("responseStatus", responseStatus);
            query.setParameter("requestId", requestId);
            query.executeUpdate();

            em.getTransaction().commit();

        } catch (RuntimeException e) {
            if (em != null && em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            throw e;

        } finally {
            if (em != null && em.isOpen()) {
                em.close();
            }
        }
    }

    public void deleteByRequestId(Long requestId) {
        EntityManager em = null;

        try {
            em = JpaUtil.createEntityManager();
            em.getTransaction().begin();

            Query query = em.createNativeQuery(
                    "DELETE FROM final_plans WHERE parent_request_id = :requestId"
            );

            query.setParameter("requestId", requestId);
            query.executeUpdate();

            em.getTransaction().commit();

        } catch (RuntimeException e) {
            if (em != null && em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            throw e;

        } finally {
            if (em != null && em.isOpen()) {
                em.close();
            }
        }
    }

    private FinalPlan convert(Object[] row) {
        return new FinalPlan(
                ((Number) row[0]).longValue(),
                ((Number) row[1]).longValue(),
                ((Number) row[2]).longValue(),
                (String) row[3],
                (String) row[4]
        );
    }
}