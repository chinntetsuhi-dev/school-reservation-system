<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.example.interviewsystem.model.ParentRequest" %>
<%@ page import="com.example.interviewsystem.model.ReservationOption" %>

<!DOCTYPE html>
<html lang="ja">
<head>
    <meta charset="UTF-8">
    <title>予約情報</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style-premium.css?v=20261001b">

    <style>
        .reservation-info-hero {
            margin-bottom: 24px;
        }

        .request-info-list {
            display: grid;
            gap: 16px;
        }

        .request-info-card {
            position: relative;
            padding: 20px;
            border-radius: 22px;
            background: rgba(255, 255, 255, 0.70);
            border: 1px solid rgba(255, 255, 255, 0.75);
            box-shadow: 0 14px 32px rgba(45, 80, 130, 0.10);
            overflow: hidden;
        }

        .request-info-card::after {
            content: "";
            position: absolute;
            right: -46px;
            top: -52px;
            width: 140px;
            height: 140px;
            border-radius: 999px;
            background: radial-gradient(circle, rgba(56, 189, 248, 0.18), transparent 68%);
            pointer-events: none;
        }

        .request-info-card p,
        .request-info-card ul {
            position: relative;
        }

        .request-info-card ul {
            margin: 10px 0 0;
            padding-left: 20px;
            line-height: 1.8;
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
    <section class="ui-hero reservation-info-hero">
        <div>
            <p class="badge">REQUEST INFO</p>
            <h1 class="ui-hero-title">予約情報</h1>
            <p class="ui-hero-text">
                提出した面談希望日時を確認できます。<br>
                第1希望から第3希望までの内容を表示します。
            </p>
        </div>

        <img class="ui-hero-image"
             src="${pageContext.request.contextPath}/images/ui/schedule-hero-illustration.png"
             alt="予約情報イメージ">
    </section>

    <%
        List<ParentRequest> requests =
                (List<ParentRequest>) request.getAttribute("parentRequests");
    %>

    <div class="card">
        <h2 class="card-title">提出済みの希望</h2>

        <div class="request-info-list">
            <%
                if (requests != null && !requests.isEmpty()) {
                    for (ParentRequest req : requests) {
            %>

            <div class="request-info-card">
                <p><strong>生徒名：</strong><%= req.getChildName() %></p>
                <p><strong>状態：</strong><%= req.getRequestStatusLabel() %></p>
                <p><strong>兄弟情報：</strong><%= req.getSiblingLabel() %></p>

                <p><strong>希望内容</strong></p>

                <ul>
                    <li>
                        第1希望：
                        <%
                            ReservationOption first = req.getFirstOption();
                            if (first != null) {
                        %>
                        <%= first.getDate() %> <%= first.getTime() %>
                        <%
                            } else {
                        %>
                        未選択
                        <%
                            }
                        %>
                    </li>

                    <li>
                        第2希望：
                        <%
                            ReservationOption second = req.getSecondOption();
                            if (second != null) {
                        %>
                        <%= second.getDate() %> <%= second.getTime() %>
                        <%
                            } else {
                        %>
                        未選択
                        <%
                            }
                        %>
                    </li>

                    <li>
                        第3希望：
                        <%
                            ReservationOption third = req.getThirdOption();
                            if (third != null) {
                        %>
                        <%= third.getDate() %> <%= third.getTime() %>
                        <%
                            } else {
                        %>
                        未選択
                        <%
                            }
                        %>
                    </li>
                </ul>

                <%
                    if (req.getComment() != null && !req.getComment().trim().isEmpty()) {
                %>
                <p><strong>コメント：</strong><%= req.getComment() %></p>
                <%
                    }
                %>
            </div>

            <%
                    }
                } else {
            %>

            <div class="empty">提出済みの希望はありません。</div>

            <%
                }
            %>
        </div>
    </div>
</div>

<div class="sidebar">
    <h2>メニュー</h2>
    <a href="${pageContext.request.contextPath}/parent/home">ホーム</a>
    <a href="${pageContext.request.contextPath}/parent/schedule">日程確認</a>
    <a href="${pageContext.request.contextPath}/parent/reservation">面談希望提出</a>
    <a href="${pageContext.request.contextPath}/chat/rooms">チャット</a>
    <a href="${pageContext.request.contextPath}/account">アカウント</a>
</div>

</body>
</html>