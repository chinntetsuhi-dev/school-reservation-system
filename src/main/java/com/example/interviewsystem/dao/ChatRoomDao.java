package com.example.interviewsystem.dao;

import com.example.interviewsystem.model.ChatRoom;

import javax.persistence.EntityManager;
import javax.persistence.Query;
import java.util.ArrayList;
import java.util.List;

public class ChatRoomDao {

    public List<ChatRoom> findAll() {
        EntityManager em = null;

        try {
            em = JpaUtil.createEntityManager();

            Query query = em.createNativeQuery(
                    "SELECT cr.id, cr.room_name, cr.parent_user_id, u.display_name, cr.status " +
                    "FROM chat_rooms cr " +
                    "JOIN users u ON cr.parent_user_id = u.id " +
                    "ORDER BY cr.id ASC"
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

    public List<ChatRoom> findByParentUserId(Long parentUserId) {
        EntityManager em = null;

        try {
            em = JpaUtil.createEntityManager();

            Query query = em.createNativeQuery(
                    "SELECT cr.id, cr.room_name, cr.parent_user_id, u.display_name, cr.status " +
                    "FROM chat_rooms cr " +
                    "JOIN users u ON cr.parent_user_id = u.id " +
                    "WHERE cr.parent_user_id = :parentUserId " +
                    "ORDER BY cr.id ASC"
            );

            query.setParameter("parentUserId", parentUserId);

            @SuppressWarnings("unchecked")
            List<Object[]> rows = query.getResultList();

            return convertRows(rows);

        } finally {
            if (em != null && em.isOpen()) {
                em.close();
            }
        }
    }

    public List<ChatRoom> findByChildUserId(Long childUserId) {
        EntityManager em = null;

        try {
            em = JpaUtil.createEntityManager();

            Query query = em.createNativeQuery(
                    "SELECT cr.id, cr.room_name, cr.parent_user_id, p.display_name, cr.status " +
                    "FROM parent_children pc " +
                    "JOIN chat_rooms cr ON pc.parent_user_id = cr.parent_user_id " +
                    "JOIN users p ON cr.parent_user_id = p.id " +
                    "WHERE pc.child_user_id = :childUserId " +
                    "ORDER BY cr.id ASC"
            );

            query.setParameter("childUserId", childUserId);

            @SuppressWarnings("unchecked")
            List<Object[]> rows = query.getResultList();

            return convertRows(rows);

        } finally {
            if (em != null && em.isOpen()) {
                em.close();
            }
        }
    }

    public ChatRoom findById(Long id) {
        EntityManager em = null;

        try {
            em = JpaUtil.createEntityManager();

            Query query = em.createNativeQuery(
                    "SELECT cr.id, cr.room_name, cr.parent_user_id, u.display_name, cr.status " +
                    "FROM chat_rooms cr " +
                    "JOIN users u ON cr.parent_user_id = u.id " +
                    "WHERE cr.id = :id"
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

    public boolean canAccessRoom(Long roomId, Long loginUserId, String role) {
        if ("TEACHER".equals(role)) {
            return true;
        }

        ChatRoom room = findById(roomId);

        if (room == null) {
            return false;
        }

        if ("PARENT".equals(role)) {
            return room.getParentUserId().equals(loginUserId);
        }

        if ("STUDENT".equals(role)) {
            List<ChatRoom> rooms = findByChildUserId(loginUserId);

            for (ChatRoom r : rooms) {
                if (r.getId().equals(roomId)) {
                    return true;
                }
            }
        }

        return false;
    }

    private List<ChatRoom> convertRows(List<Object[]> rows) {
        List<ChatRoom> result = new ArrayList<>();

        for (Object[] row : rows) {
            result.add(new ChatRoom(
                    ((Number) row[0]).longValue(),
                    (String) row[1],
                    ((Number) row[2]).longValue(),
                    (String) row[3],
                    (String) row[4]
            ));
        }

        return result;
    }
}