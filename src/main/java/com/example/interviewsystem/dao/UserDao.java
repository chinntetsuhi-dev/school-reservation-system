package com.example.interviewsystem.dao;

import com.example.interviewsystem.model.ChildInfo;
import com.example.interviewsystem.model.User;

import javax.persistence.EntityManager;
import javax.persistence.Query;
import java.util.ArrayList;
import java.util.List;

public class UserDao {

    public User findByLoginIdAndPassword(String loginId, String password) {
        EntityManager em = null;

        try {
            em = JpaUtil.createEntityManager();

            Query query = em.createNativeQuery(
                    "SELECT id, login_id, password, role, display_name, class_name " +
                    "FROM users " +
                    "WHERE login_id = :loginId AND password = :password"
            );

            query.setParameter("loginId", loginId);
            query.setParameter("password", password);

            @SuppressWarnings("unchecked")
            List<Object[]> rows = query.getResultList();

            if (rows.isEmpty()) {
                return null;
            }

            return convertUser(rows.get(0));

        } finally {
            if (em != null && em.isOpen()) {
                em.close();
            }
        }
    }

    public User findById(Long id) {
        EntityManager em = null;

        try {
            em = JpaUtil.createEntityManager();

            Query query = em.createNativeQuery(
                    "SELECT id, login_id, password, role, display_name, class_name " +
                    "FROM users WHERE id = :id"
            );

            query.setParameter("id", id);

            @SuppressWarnings("unchecked")
            List<Object[]> rows = query.getResultList();

            if (rows.isEmpty()) {
                return null;
            }

            return convertUser(rows.get(0));

        } finally {
            if (em != null && em.isOpen()) {
                em.close();
            }
        }
    }

    public List<ChildInfo> findChildrenByParentId(Long parentUserId) {
        EntityManager em = null;

        try {
            em = JpaUtil.createEntityManager();

            Query query = em.createNativeQuery(
                    "SELECT c.id, c.login_id, c.display_name, c.class_name, pc.has_sibling_flag, pc.sibling_group " +
                    "FROM parent_children pc " +
                    "JOIN users c ON pc.child_user_id = c.id " +
                    "WHERE pc.parent_user_id = :parentUserId " +
                    "ORDER BY c.login_id"
            );

            query.setParameter("parentUserId", parentUserId);

            @SuppressWarnings("unchecked")
            List<Object[]> rows = query.getResultList();

            List<ChildInfo> result = new ArrayList<>();

            for (Object[] row : rows) {
                result.add(new ChildInfo(
                        ((Number) row[0]).longValue(),
                        (String) row[1],
                        (String) row[2],
                        (String) row[3],
                        toBoolean(row[4]),
                        (String) row[5]
                ));
            }

            return result;

        } finally {
            if (em != null && em.isOpen()) {
                em.close();
            }
        }
    }

    public User findParentByChildId(Long childUserId) {
        EntityManager em = null;

        try {
            em = JpaUtil.createEntityManager();

            Query query = em.createNativeQuery(
                    "SELECT p.id, p.login_id, p.password, p.role, p.display_name, p.class_name " +
                    "FROM parent_children pc " +
                    "JOIN users p ON pc.parent_user_id = p.id " +
                    "WHERE pc.child_user_id = :childUserId"
            );

            query.setParameter("childUserId", childUserId);

            @SuppressWarnings("unchecked")
            List<Object[]> rows = query.getResultList();

            if (rows.isEmpty()) {
                return null;
            }

            return convertUser(rows.get(0));

        } finally {
            if (em != null && em.isOpen()) {
                em.close();
            }
        }
    }

    private User convertUser(Object[] row) {
        return new User(
                ((Number) row[0]).longValue(),
                (String) row[1],
                (String) row[2],
                (String) row[3],
                (String) row[4],
                (String) row[5]
        );
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