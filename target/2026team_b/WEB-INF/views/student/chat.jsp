<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.example.interviewsystem.model.ChatRoom" %>
<!DOCTYPE html>
<html lang="ja">
<head>
    <meta charset="UTF-8">
    <title>チャット</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style-premium.css?v=20261001b">

    <style>
        .student-chat-hero {
            margin-bottom: 24px;
        }

        .chat-table-wrap {
            overflow-x: auto;
        }

        .chat-table {
            min-width: 620px;
        }

        .room-name-text {
            font-weight: 900;
            color: #0f172a;
        }

        .student-chat-note {
            margin-bottom: 18px;
            color: #64748b;
            line-height: 1.8;
            font-weight: 700;
        }
    

        /* Premium dark glass compatibility patch */
        .card p,
        .card li,
        .card td,
        .card th,
        .card label,
        .card strong {
            color: rgba(244, 251, 255, 0.92);
        }

        .card td {
            background: rgba(255, 255, 255, 0.045);
        }

        .card th {
            color: #e8f8ff;
            background: rgba(87, 177, 255, 0.16);
        }

        .card table {
            background: rgba(5, 24, 55, 0.18);
            border-color: rgba(181, 225, 255, 0.26);
        }

        .empty {
            color: rgba(232, 246, 255, 0.80);
            background: rgba(255, 255, 255, 0.08);
            border-color: rgba(181, 225, 255, 0.30);
        }


        /* Premium student pages */
        .room-name-text,
        .facility-name-text,
        .student-notice-card h3,
        .status-request-card h3,
        .status-request-card strong,
        .teacher-choice-box strong,
        .confirmed-notice-box strong {
            color: #ffffff !important;
        }

        .student-chat-note,
        .facility-note,
        .student-notice-card p,
        .status-request-card p,
        .status-request-card div,
        .teacher-choice-box,
        .confirmed-notice-box {
            color: rgba(222, 239, 255, 0.78) !important;
        }

        .student-notice-card,
        .status-request-card,
        .teacher-choice-box,
        .confirmed-notice-box {
            background: linear-gradient(135deg, rgba(255,255,255,0.13), rgba(62,127,207,0.14)) !important;
            border: 1px solid rgba(181,225,255,0.30) !important;
            box-shadow: 0 18px 45px rgba(3,13,35,0.24), inset 0 1px 0 rgba(255,255,255,0.18) !important;
        }

        .chat-table td,
        .facility-table td {
            color: rgba(244, 251, 255, 0.92) !important;
        }

        .chat-table th,
        .facility-table th {
            color: #e8f8ff !important;
            background: rgba(87, 177, 255, 0.16) !important;
        }


        .ui-hero-image {
            opacity: 0.78;
            mix-blend-mode: screen;
            filter: saturate(118%) brightness(1.08) drop-shadow(0 22px 34px rgba(56, 189, 248, 0.22));
            -webkit-mask-image: radial-gradient(ellipse at center, #000 0%, #000 46%, rgba(0,0,0,0.48) 70%, transparent 100%);
            mask-image: radial-gradient(ellipse at center, #000 0%, #000 46%, rgba(0,0,0,0.48) 70%, transparent 100%);
        }

        @media (max-width: 900px) {
            .ui-hero-image {
                mix-blend-mode: normal;
                -webkit-mask-image: none;
                mask-image: none;
            }
        }

    </style>
</head>
<body>

<div class="content wide-content">
    <section class="ui-hero student-chat-hero">
        <div>
            <p class="badge">STUDENT CHAT</p>
            <h1 class="ui-hero-title">チャット</h1>
            <p class="ui-hero-text">
                利用可能なチャットルームを確認できます。<br>
                必要な連絡内容がある場合は、チャット状況を確認してください。
            </p>
        </div>

        <img class="ui-hero-image"
             src="${pageContext.request.contextPath}/images/ui/schedule-hero-illustration.png"
             alt="チャットイメージ">
    </section>

    <div class="card">
        <h2 class="card-title">利用可能なチャットルーム</h2>
        <p class="student-chat-note">
            現在利用可能なチャットルームと状態を一覧で表示します。
        </p>

        <%
            List<ChatRoom> chatRooms = (List<ChatRoom>) request.getAttribute("chatRooms");
            if (chatRooms != null && !chatRooms.isEmpty()) {
        %>

        <div class="chat-table-wrap">
            <table class="chat-table">
                <thead>
                <tr>
                    <th>ルーム名</th>
                    <th>状態</th>
                </tr>
                </thead>

                <tbody>
                <%
                    for (ChatRoom room : chatRooms) {
                %>
                <tr>
                    <td class="room-name-text"><%= room.getRoomName() %></td>
                    <td>
                        <span class="status status-confirmed">
                            <%= room.getStatus() %>
                        </span>
                    </td>
                </tr>
                <%
                    }
                %>
                </tbody>
            </table>
        </div>

        <%
            } else {
        %>

        <div class="empty">現在利用可能なチャットルームはありません。</div>

        <%
            }
        %>
    </div>
</div>

<div class="sidebar">
    <h2>メニュー</h2>
    <a href="${pageContext.request.contextPath}/student/home">ホーム</a>
    <a href="${pageContext.request.contextPath}/student/status">状態確認</a>
    <a href="${pageContext.request.contextPath}/account">アカウント</a>
</div>
</body>
</html>