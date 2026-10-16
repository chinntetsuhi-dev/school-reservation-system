package com.example.interviewsystem.controller;

import com.example.interviewsystem.dao.JpaUtil;
import com.example.interviewsystem.model.User;
import com.example.interviewsystem.websocket.ChatBroadcaster;

import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.persistence.EntityManager;
import javax.persistence.Query;
import javax.servlet.http.HttpSession;

import java.util.ArrayList;
import java.util.List;

@Controller
public class ChatController {

    /*
     * 教師側チャットルーム一覧
     * 保護者の場合は自分のチャットルームへ自動遷移します。
     */
    @GetMapping({
            "/chat/rooms",
            "/teacher/chat",
            "/teacher/chat/rooms"
    })
    public String rooms(
            Model model,
            HttpSession session) {

        User loginUser = getLoginUser(session);

        if (loginUser == null) {
            return "redirect:/login";
        }

        if (isParent(loginUser)) {
            Long roomId = findParentRoomId(loginUser.getId());

            if (roomId == null) {
                model.addAttribute(
                        "errorMessage",
                        "チャットルームが見つかりません。"
                );
                return "chat/rooms";
            }

            return "redirect:/chat/room/" + roomId;
        }

        List<ChatRoomView> rooms =
                findRooms(loginUser);

        model.addAttribute("rooms", rooms);
        model.addAttribute("loginUser", loginUser);

        return "chat/rooms";
    }

    /*
     * チャット画面
     */
    @GetMapping({
            "/chat/room/{roomId}",
            "/chat/{roomId}"
    })
    public String room(
            @PathVariable("roomId") Long roomId,
            Model model,
            HttpSession session) {

        User loginUser = getLoginUser(session);

        if (loginUser == null) {
            return "redirect:/login";
        }

        if (!canAccessRoom(roomId, loginUser)) {
            return "redirect:/login";
        }

        ChatRoomView room =
                findRoomById(roomId);

        if (room == null) {
            return "redirect:/chat/rooms";
        }

        List<ChatMessageView> messages =
                findMessages(roomId, loginUser.getId());

        model.addAttribute("room", room);
        model.addAttribute("messages", messages);
        model.addAttribute("loginUser", loginUser);

        if (isParent(loginUser)) {
            model.addAttribute("backUrl", "/parent/home");
            model.addAttribute("backLabel", "保護者メニューへ戻る");
        } else if (isTeacher(loginUser)) {
            model.addAttribute("backUrl", "/chat/rooms");
            model.addAttribute("backLabel", "チャットルーム一覧へ戻る");
        } else {
            model.addAttribute("backUrl", "/account");
            model.addAttribute("backLabel", "アカウントへ戻る");
        }

        return "chat/room";
    }

    /*
     * Ajax用：メッセージ一覧部分だけ返す
     */
    @GetMapping({
            "/chat/room/{roomId}/messages",
            "/chat/{roomId}/messages"
    })
    public String messages(
            @PathVariable("roomId") Long roomId,
            Model model,
            HttpSession session) {

        User loginUser = getLoginUser(session);

        if (loginUser == null) {
            return "chat/messages";
        }

        if (!canAccessRoom(roomId, loginUser)) {
            return "chat/messages";
        }

        List<ChatMessageView> messages =
                findMessages(roomId, loginUser.getId());

        model.addAttribute("messages", messages);
        model.addAttribute("loginUser", loginUser);

        return "chat/messages";
    }

    /*
     * メッセージ送信
     */
    @PostMapping({
            "/chat/room/{roomId}/send",
            "/chat/{roomId}/send"
    })
    @ResponseBody
    public ResponseEntity<String> send(
            @PathVariable("roomId") Long roomId,
            @RequestParam(value = "message", required = false) String message,
            HttpSession session) {

        User loginUser = getLoginUser(session);

        if (loginUser == null) {
            return ResponseEntity
                    .status(401)
                    .body("LOGIN_REQUIRED");
        }

        if (!canAccessRoom(roomId, loginUser)) {
            return ResponseEntity
                    .status(403)
                    .body("FORBIDDEN");
        }

        if (message == null || message.trim().isEmpty()) {
            return ResponseEntity
                    .badRequest()
                    .body("EMPTY_MESSAGE");
        }

        insertMessage(
                roomId,
                loginUser.getId(),
                message.trim()
        );

        ChatBroadcaster.broadcastRoom(
                roomId,
                "updateChat:" + roomId
        );

        return ResponseEntity.ok("OK");
    }

    private User getLoginUser(HttpSession session) {
        Object user = session.getAttribute("loginUser");

        if (user instanceof User) {
            return (User) user;
        }

        user = session.getAttribute("user");

        if (user instanceof User) {
            return (User) user;
        }

        Object userIdObject = session.getAttribute("loginUserId");

        if (userIdObject == null) {
            userIdObject = session.getAttribute("userId");
        }

        if (userIdObject instanceof Number) {
            return findUserById(
                    ((Number) userIdObject).longValue()
            );
        }

        if (userIdObject instanceof String) {
            try {
                return findUserById(
                        Long.valueOf((String) userIdObject)
                );
            } catch (NumberFormatException e) {
                // 何もしない
            }
        }

        Object loginIdObject = session.getAttribute("loginId");

        if (loginIdObject instanceof String) {
            return findUserByLoginId((String) loginIdObject);
        }

        return null;
    }

    private User findUserById(Long userId) {
        if (userId == null) {
            return null;
        }

        EntityManager em = null;

        try {
            em = JpaUtil.createEntityManager();

            Query query =
                    em.createNativeQuery(
                            "SELECT id, login_id, password, role, display_name, class_name "
                                    + "FROM users "
                                    + "WHERE id = :id"
                    );

            query.setParameter("id", userId);

            @SuppressWarnings("unchecked")
            List<Object[]> rows =
                    query.getResultList();

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

    private User findUserByLoginId(String loginId) {
        if (loginId == null || loginId.trim().isEmpty()) {
            return null;
        }

        EntityManager em = null;

        try {
            em = JpaUtil.createEntityManager();

            Query query =
                    em.createNativeQuery(
                            "SELECT id, login_id, password, role, display_name, class_name "
                                    + "FROM users "
                                    + "WHERE login_id = :loginId"
                    );

            query.setParameter("loginId", loginId);

            @SuppressWarnings("unchecked")
            List<Object[]> rows =
                    query.getResultList();

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
        User user = new User();

        user.setId(((Number) row[0]).longValue());
        user.setLoginId((String) row[1]);
        user.setPassword((String) row[2]);
        user.setRole((String) row[3]);
        user.setDisplayName((String) row[4]);
        user.setClassName((String) row[5]);

        return user;
    }

    private boolean isTeacher(User user) {
        return user != null
                && user.getRole() != null
                && "TEACHER".equalsIgnoreCase(user.getRole());
    }

    private boolean isParent(User user) {
        return user != null
                && user.getRole() != null
                && "PARENT".equalsIgnoreCase(user.getRole());
    }

    private boolean canAccessRoom(
            Long roomId,
            User user) {

        if (roomId == null || user == null) {
            return false;
        }

        EntityManager em = null;

        try {
            em = JpaUtil.createEntityManager();

            String sql =
                    "SELECT COUNT(*) "
                            + "FROM chat_rooms "
                            + "WHERE id = :roomId ";

            if (isTeacher(user)) {
                sql += "AND teacher_user_id = :userId ";
            } else if (isParent(user)) {
                sql += "AND parent_user_id = :userId ";
            } else {
                return false;
            }

            Query query =
                    em.createNativeQuery(sql);

            query.setParameter("roomId", roomId);
            query.setParameter("userId", user.getId());

            Number count =
                    (Number) query.getSingleResult();

            return count.intValue() > 0;

        } finally {
            if (em != null && em.isOpen()) {
                em.close();
            }
        }
    }

    private Long findParentRoomId(Long parentUserId) {
        if (parentUserId == null) {
            return null;
        }

        EntityManager em = null;

        try {
            em = JpaUtil.createEntityManager();

            Query query =
                    em.createNativeQuery(
                            "SELECT id "
                                    + "FROM chat_rooms "
                                    + "WHERE parent_user_id = :parentUserId "
                                    + "ORDER BY id ASC "
                                    + "LIMIT 1"
                    );

            query.setParameter(
                    "parentUserId",
                    parentUserId
            );

            @SuppressWarnings("unchecked")
            List<Object> rows =
                    query.getResultList();

            if (rows.isEmpty()) {
                return null;
            }

            return ((Number) rows.get(0)).longValue();

        } finally {
            if (em != null && em.isOpen()) {
                em.close();
            }
        }
    }

    private List<ChatRoomView> findRooms(User loginUser) {
        EntityManager em = null;

        try {
            em = JpaUtil.createEntityManager();

            String sql =
                    "SELECT cr.id, "
                            + "cr.room_name, "
                            + "cr.status, "
                            + "pu.display_name, "
                            + "(SELECT cm.message "
                            + " FROM chat_messages cm "
                            + " WHERE cm.room_id = cr.id "
                            + " ORDER BY cm.sent_at DESC, cm.id DESC "
                            + " LIMIT 1), "
                            + "(SELECT DATE_FORMAT(cm.sent_at, '%Y-%m-%d %H:%i') "
                            + " FROM chat_messages cm "
                            + " WHERE cm.room_id = cr.id "
                            + " ORDER BY cm.sent_at DESC, cm.id DESC "
                            + " LIMIT 1) "
                            + "FROM chat_rooms cr "
                            + "LEFT JOIN users pu "
                            + "ON cr.parent_user_id = pu.id "
                            + "WHERE 1 = 1 ";

            if (isTeacher(loginUser)) {
                sql += "AND cr.teacher_user_id = :userId ";
            } else if (isParent(loginUser)) {
                sql += "AND cr.parent_user_id = :userId ";
            } else {
                return new ArrayList<ChatRoomView>();
            }

            sql += "ORDER BY cr.id ASC";

            Query query =
                    em.createNativeQuery(sql);

            query.setParameter(
                    "userId",
                    loginUser.getId()
            );

            @SuppressWarnings("unchecked")
            List<Object[]> rows =
                    query.getResultList();

            List<ChatRoomView> result =
                    new ArrayList<ChatRoomView>();

            for (Object[] row : rows) {
                ChatRoomView room =
                        new ChatRoomView();

                room.setId(
                        ((Number) row[0]).longValue()
                );
                room.setRoomName(
                        (String) row[1]
                );
                room.setStatus(
                        (String) row[2]
                );
                room.setParentName(
                        (String) row[3]
                );
                room.setLastMessage(
                        (String) row[4]
                );
                room.setLastSentAt(
                        (String) row[5]
                );

                result.add(room);
            }

            return result;

        } finally {
            if (em != null && em.isOpen()) {
                em.close();
            }
        }
    }

    private ChatRoomView findRoomById(Long roomId) {
        EntityManager em = null;

        try {
            em = JpaUtil.createEntityManager();

            Query query =
                    em.createNativeQuery(
                            "SELECT cr.id, "
                                    + "cr.room_name, "
                                    + "cr.status, "
                                    + "pu.display_name "
                                    + "FROM chat_rooms cr "
                                    + "LEFT JOIN users pu "
                                    + "ON cr.parent_user_id = pu.id "
                                    + "WHERE cr.id = :roomId"
                    );

            query.setParameter("roomId", roomId);

            @SuppressWarnings("unchecked")
            List<Object[]> rows =
                    query.getResultList();

            if (rows.isEmpty()) {
                return null;
            }

            Object[] row = rows.get(0);

            ChatRoomView room =
                    new ChatRoomView();

            room.setId(
                    ((Number) row[0]).longValue()
            );
            room.setRoomName(
                    (String) row[1]
            );
            room.setStatus(
                    (String) row[2]
            );
            room.setParentName(
                    (String) row[3]
            );

            return room;

        } finally {
            if (em != null && em.isOpen()) {
                em.close();
            }
        }
    }

    private List<ChatMessageView> findMessages(
            Long roomId,
            Long loginUserId) {

        EntityManager em = null;

        try {
            em = JpaUtil.createEntityManager();

            Query query =
                    em.createNativeQuery(
                            "SELECT cm.id, "
                                    + "cm.sender_user_id, "
                                    + "u.display_name, "
                                    + "u.role, "
                                    + "cm.message, "
                                    + "DATE_FORMAT(cm.sent_at, '%Y-%m-%d %H:%i') "
                                    + "FROM chat_messages cm "
                                    + "LEFT JOIN users u "
                                    + "ON cm.sender_user_id = u.id "
                                    + "WHERE cm.room_id = :roomId "
                                    + "ORDER BY cm.sent_at ASC, cm.id ASC"
                    );

            query.setParameter("roomId", roomId);

            @SuppressWarnings("unchecked")
            List<Object[]> rows =
                    query.getResultList();

            List<ChatMessageView> result =
                    new ArrayList<ChatMessageView>();

            for (Object[] row : rows) {
                ChatMessageView message =
                        new ChatMessageView();

                Long senderUserId =
                        ((Number) row[1]).longValue();

                message.setId(
                        ((Number) row[0]).longValue()
                );
                message.setSenderUserId(
                        senderUserId
                );
                message.setSenderName(
                        (String) row[2]
                );
                message.setSenderRole(
                        (String) row[3]
                );
                message.setMessage(
                        (String) row[4]
                );
                message.setSentAt(
                        (String) row[5]
                );
                message.setMine(
                        loginUserId != null
                                && loginUserId.equals(senderUserId)
                );

                result.add(message);
            }

            return result;

        } finally {
            if (em != null && em.isOpen()) {
                em.close();
            }
        }
    }

    private void insertMessage(
            Long roomId,
            Long senderUserId,
            String message) {

        EntityManager em = null;

        try {
            em = JpaUtil.createEntityManager();
            em.getTransaction().begin();

            Query query =
                    em.createNativeQuery(
                            "INSERT INTO chat_messages "
                                    + "(room_id, sender_user_id, message, sent_at) "
                                    + "VALUES "
                                    + "(:roomId, :senderUserId, :message, NOW())"
                    );

            query.setParameter("roomId", roomId);
            query.setParameter("senderUserId", senderUserId);
            query.setParameter("message", message);

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

    public static class ChatRoomView {

        private Long id;
        private String roomName;
        private String status;
        private String parentName;
        private String lastMessage;
        private String lastSentAt;

        public Long getId() {
            return id;
        }

        public void setId(Long id) {
            this.id = id;
        }

        public String getRoomName() {
            return roomName;
        }

        public void setRoomName(String roomName) {
            this.roomName = roomName;
        }

        public String getStatus() {
            return status;
        }

        public void setStatus(String status) {
            this.status = status;
        }

        public String getParentName() {
            return parentName;
        }

        public void setParentName(String parentName) {
            this.parentName = parentName;
        }

        public String getLastMessage() {
            return lastMessage;
        }

        public void setLastMessage(String lastMessage) {
            this.lastMessage = lastMessage;
        }

        public String getLastSentAt() {
            return lastSentAt;
        }

        public void setLastSentAt(String lastSentAt) {
            this.lastSentAt = lastSentAt;
        }
    }

    public static class ChatMessageView {

        private Long id;
        private Long senderUserId;
        private String senderName;
        private String senderRole;
        private String message;
        private String sentAt;
        private boolean mine;

        public Long getId() {
            return id;
        }

        public void setId(Long id) {
            this.id = id;
        }

        public Long getSenderUserId() {
            return senderUserId;
        }

        public void setSenderUserId(Long senderUserId) {
            this.senderUserId = senderUserId;
        }

        public String getSenderName() {
            return senderName;
        }

        public void setSenderName(String senderName) {
            this.senderName = senderName;
        }

        public String getSenderRole() {
            return senderRole;
        }

        public void setSenderRole(String senderRole) {
            this.senderRole = senderRole;
        }

        public String getMessage() {
            return message;
        }

        public void setMessage(String message) {
            this.message = message;
        }

        public String getSentAt() {
            return sentAt;
        }

        public void setSentAt(String sentAt) {
            this.sentAt = sentAt;
        }

        public boolean isMine() {
            return mine;
        }

        public boolean getMine() {
            return mine;
        }

        public void setMine(boolean mine) {
            this.mine = mine;
        }
    }
}