package com.example.interviewsystem.dao;

import com.example.interviewsystem.model.ChatMessage;

import javax.persistence.EntityManager;
import javax.persistence.Query;
import java.util.ArrayList;
import java.util.List;

public class ChatMessageDao {

    public List<ChatMessage> findByRoomId(Long roomId) {
        EntityManager em = null;

        try {
            em = JpaUtil.createEntityManager();

            Query query = em.createNativeQuery(
                    "SELECT cm.id, cm.room_id, u.display_name, cm.message, " +
                    "DATE_FORMAT(cm.sent_at, '%Y-%m-%d %H:%i:%s') " +
                    "FROM chat_messages cm " +
                    "JOIN users u ON cm.sender_user_id = u.id " +
                    "WHERE cm.room_id = :roomId " +
                    "ORDER BY cm.sent_at ASC"
            );

            query.setParameter("roomId", roomId);

            @SuppressWarnings("unchecked")
            List<Object[]> rows = query.getResultList();

            List<ChatMessage> result = new ArrayList<>();

            for (Object[] row : rows) {
                ChatMessage msg = new ChatMessage();

                msg.setId(((Number) row[0]).longValue());
                msg.setRoomId(((Number) row[1]).longValue());
                msg.setSenderName((String) row[2]);
                msg.setMessage((String) row[3]);
                msg.setSentAt((String) row[4]);

                result.add(msg);
            }

            return result;

        } finally {
            if (em != null && em.isOpen()) {
                em.close();
            }
        }
    }

    public void insert(Long roomId, Long senderUserId, String message) {
        EntityManager em = null;

        try {
            em = JpaUtil.createEntityManager();
            em.getTransaction().begin();

            Query query = em.createNativeQuery(
                    "INSERT INTO chat_messages (room_id, sender_user_id, message) " +
                    "VALUES (:roomId, :senderUserId, :message)"
            );

            query.setParameter("roomId", roomId);
            query.setParameter("senderUserId", senderUserId);
            query.setParameter("message", message);
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
}