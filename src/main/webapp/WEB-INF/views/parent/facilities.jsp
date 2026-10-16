<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.example.interviewsystem.model.ReservationOption" %>
<!DOCTYPE html>
<html lang="ja">
<head>
    <meta charset="UTF-8">
    <title>施設情報</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style-premium.css?v=20261001b">

    <style>
        .facility-hero {
            margin-bottom: 24px;
        }

        .facility-table-wrap {
            overflow-x: auto;
        }

        .facility-table {
            min-width: 760px;
        }

        .facility-name {
            font-weight: 900;
            color: #0f172a;
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
    <section class="ui-hero facility-hero">
        <div>
            <p class="badge">FACILITIES</p>
            <h1 class="ui-hero-title">施設情報</h1>
            <p class="ui-hero-text">
                予約可能な施設情報を確認できます。<br>
                利用可能な時間と状態を一覧で表示します。
            </p>
        </div>

        <img class="ui-hero-image"
             src="${pageContext.request.contextPath}/images/ui/schedule-hero-illustration.png"
             alt="施設情報イメージ">
    </section>

    <div class="card">
        <h2 class="card-title">予約可能な施設一覧</h2>

        <%
            List<ReservationOption> options = (List<ReservationOption>) request.getAttribute("reservationOptions");
            if (options != null && !options.isEmpty()) {
        %>

        <div class="facility-table-wrap">
            <table class="facility-table">
                <thead>
                <tr>
                    <th>施設名</th>
                    <th>日付</th>
                    <th>時間</th>
                    <th>状態</th>
                </tr>
                </thead>

                <tbody>
                <%
                    for (ReservationOption opt : options) {
                %>
                <tr>
                    <td class="facility-name"><%= opt.getFacilityName() %></td>
                    <td><%= opt.getDate() %></td>
                    <td><%= opt.getTime() %></td>
                    <td>
                        <span class="status <%= opt.isAvailable() ? "status-confirmed" : "status-resubmitted" %>">
                            <%= opt.isAvailable() ? "利用可能" : "予約済み" %>
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

        <div class="empty">施設情報がありません。</div>

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
    <a href="${pageContext.request.contextPath}/parent/chat">チャット</a>
    <a href="${pageContext.request.contextPath}/account">アカウント</a>
</div>
</body>
</html>