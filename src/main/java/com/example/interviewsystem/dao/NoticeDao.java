package com.example.interviewsystem.dao;

import com.example.interviewsystem.model.Notice;

import javax.persistence.EntityManager;
import javax.persistence.Query;
import java.util.ArrayList;
import java.util.List;

public class NoticeDao {

    public List<Notice> findAll() {
        EntityManager em = null;

        try {
            em = JpaUtil.createEntityManager();

            Query query = em.createNativeQuery(
                    "SELECT id, title, content, active_flag, target_role " +
                    "FROM notices ORDER BY id DESC"
            );

            @SuppressWarnings("unchecked")
            List<Object[]> rows = query.getResultList();

            return convertRows(rows);

        } finally {
            if (em != null && em.isOpen()) {
                em.close();
            }
        }
    }

    public List<Notice> findActiveForRole(String role) {
        EntityManager em = null;

        try {
            em = JpaUtil.createEntityManager();

            Query query = em.createNativeQuery(
                    "SELECT id, title, content, active_flag, target_role " +
                    "FROM notices " +
                    "WHERE active_flag = 1 " +
                    "AND (target_role = 'ALL' OR target_role = :role) " +
                    "ORDER BY id DESC"
            );

            query.setParameter("role", role);

            @SuppressWarnings("unchecked")
            List<Object[]> rows = query.getResultList();

            return convertRows(rows);

        } finally {
            if (em != null && em.isOpen()) {
                em.close();
            }
        }
    }

    public Notice findById(Long id) {
        EntityManager em = null;

        try {
            em = JpaUtil.createEntityManager();

            Query query = em.createNativeQuery(
                    "SELECT id, title, content, active_flag, target_role " +
                    "FROM notices WHERE id = :id"
            );

            query.setParameter("id", id);

            @SuppressWarnings("unchecked")
            List<Object[]> rows = query.getResultList();

            if (rows.isEmpty()) {
                return null;
            }

            return convertRows(rows).get(0);

        } finally {
            if (em != null && em.isOpen()) {
                em.close();
            }
        }
    }

    public void insert(String title, String content, boolean active, String targetRole) {
        EntityManager em = null;

        try {
            em = JpaUtil.createEntityManager();
            em.getTransaction().begin();

            Query query = em.createNativeQuery(
                    "INSERT INTO notices (title, content, active_flag, target_role) " +
                    "VALUES (:title, :content, :active, :targetRole)"
            );

            query.setParameter("title", title);
            query.setParameter("content", content);
            query.setParameter("active", active);
            query.setParameter("targetRole", targetRole);
            query.executeUpdate();

            em.getTransaction().commit();

        } finally {
            if (em != null && em.isOpen()) {
                em.close();
            }
        }
    }

    public void update(Long id, String title, String content, boolean active, String targetRole) {
        EntityManager em = null;

        try {
            em = JpaUtil.createEntityManager();
            em.getTransaction().begin();

            Query query = em.createNativeQuery(
                    "UPDATE notices " +
                    "SET title = :title, content = :content, active_flag = :active, target_role = :targetRole " +
                    "WHERE id = :id"
            );

            query.setParameter("title", title);
            query.setParameter("content", content);
            query.setParameter("active", active);
            query.setParameter("targetRole", targetRole);
            query.setParameter("id", id);
            query.executeUpdate();

            em.getTransaction().commit();

        } finally {
            if (em != null && em.isOpen()) {
                em.close();
            }
        }
    }

    public void toggle(Long id) {
        Notice notice = findById(id);

        if (notice == null) {
            return;
        }

        EntityManager em = null;

        try {
            em = JpaUtil.createEntityManager();
            em.getTransaction().begin();

            Query query = em.createNativeQuery(
                    "UPDATE notices SET active_flag = :active WHERE id = :id"
            );

            query.setParameter("active", !notice.isActive());
            query.setParameter("id", id);
            query.executeUpdate();

            em.getTransaction().commit();

        } finally {
            if (em != null && em.isOpen()) {
                em.close();
            }
        }
    }

    public void delete(Long id) {
        EntityManager em = null;

        try {
            em = JpaUtil.createEntityManager();
            em.getTransaction().begin();

            Query query = em.createNativeQuery(
                    "DELETE FROM notices WHERE id = :id"
            );

            query.setParameter("id", id);
            query.executeUpdate();

            em.getTransaction().commit();

        } finally {
            if (em != null && em.isOpen()) {
                em.close();
            }
        }
    }

    private List<Notice> convertRows(List<Object[]> rows) {
        List<Notice> result = new ArrayList<>();

        for (Object[] row : rows) {
            result.add(new Notice(
                    ((Number) row[0]).longValue(),
                    (String) row[1],
                    (String) row[2],
                    toBoolean(row[3]),
                    (String) row[4]
            ));
        }

        return result;
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
}