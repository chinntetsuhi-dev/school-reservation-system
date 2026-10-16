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
        .parent-chat-hero {
            margin-bottom: 24px;
        }

        .chat-room-table-wrap {
            overflow-x: auto;
        }

        .chat-room-table {
            min-width: 620px;
        }

        .chat-room-name {
            font-weight: 900;
            color: #0f172a;
        }

        .chat-room-card-note {
            color: #64748b;
            font-size: 14px;
            line-height: 1.8;
            margin-bottom: 18px;
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


        /* Premium parent pages */
        .chat-room-name,
        .facility-name,
        .notice-item h3,
        .request-info-card h3,
        .request-info-card strong,
        .submitted-request h3,
        .reservation-guide-main h2,
        .child-meta,
        .schedule-status-card h3 {
            color: #ffffff !important;
        }

        .chat-room-card-note,
        .facility-note,
        .notice-item p,
        .request-info-card p,
        .request-info-card li,
        .reservation-guide-main p,
        .common-note,
        .selection-summary,
        .submit-count,
        .submitted-request p {
            color: rgba(222, 239, 255, 0.78) !important;
        }

        .notice-item,
        .request-info-card,
        .submitted-request,
        .reservation-guide-card,
        .schedule-status-card {
            background: linear-gradient(135deg, rgba(255,255,255,0.13), rgba(62,127,207,0.14)) !important;
            border: 1px solid rgba(181,225,255,0.30) !important;
            box-shadow: 0 18px 45px rgba(3,13,35,0.24), inset 0 1px 0 rgba(255,255,255,0.18) !important;
        }

        .facility-table td,
        .chat-room-table td,
        .request-info-card td,
        .schedule-grid td,
        .result-grid td {
            color: rgba(244, 251, 255, 0.92) !important;
        }

        .facility-table th,
        .chat-room-table th,
        .schedule-grid th,
        .result-grid th {
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
    <section class="ui-hero parent-chat-hero">
        <div>
            <p class="badge">PARENT CHAT</p>
            <h1 class="ui-hero-title">チャット</h1>
            <p class="ui-hero-text">
                現在利用可能なチャットルーム一覧です。<br>
                面談に関する連絡を確認できます。
            </p>
        </div>

        <img class="ui-hero-image"
             src="${pageContext.request.contextPath}/images/ui/schedule-hero-illustration.png"
             alt="チャットイメージ">
    </section>

    <div class="card">
        <h2 class="card-title">チャットルーム一覧</h2>
        <p class="chat-room-card-note">
            利用可能なチャットルームの状態を確認できます。
        </p>

        <%
            List<ChatRoom> chatRooms = (List<ChatRoom>) request.getAttribute("chatRooms");
            if (chatRooms != null && !chatRooms.isEmpty()) {
        %>

        <div class="chat-room-table-wrap">
            <table class="chat-room-table">
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
                    <td class="chat-room-name"><%= room.getRoomName() %></td>
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

        <div class="empty">チャットルームはまだありません。</div>

        <%
            }
        %>
    </div>
</div>

<div class="sidebar">
    <h2>メニュー</h2>
    <a href="${pageContext.request.contextPath}/parent/home">ホーム</a>
    <a href="${pageContext.request.contextPath}/parent/schedule">日程確認</a>
    <a href="${pageContext.request.contextPath}/parent/reservation">面談希望提出</a>
    <a class="active" href="${pageContext.request.contextPath}/parent/chat">チャット</a>
    <a href="${pageContext.request.contextPath}/account">アカウント</a>
</div>
</body>
</html>