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
        .student-facility-hero {
            margin-bottom: 24px;
        }

        .facility-table-wrap {
            overflow-x: auto;
        }

        .facility-table {
            min-width: 760px;
        }

        .facility-name-text {
            font-weight: 900;
            color: #0f172a;
        }

        .facility-note {
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
    <section class="ui-hero student-facility-hero">
        <div>
            <p class="badge">FACILITIES</p>
            <h1 class="ui-hero-title">施設情報</h1>
            <p class="ui-hero-text">
                利用対象施設の情報を確認できます。<br>
                日付・時間・予約状態を一覧で表示します。
            </p>
        </div>

        <img class="ui-hero-image"
             src="${pageContext.request.contextPath}/images/ui/schedule-hero-illustration.png"
             alt="施設情報イメージ">
    </section>

    <div class="card">
        <h2 class="card-title">利用対象施設一覧</h2>
        <p class="facility-note">
            予約候補として登録されている施設・日時の状態です。
        </p>

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
                    <td class="facility-name-text"><%= opt.getFacilityName() %></td>
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
    <a href="${pageContext.request.contextPath}/student/home">ホーム</a>
    <a href="${pageContext.request.contextPath}/student/status">状態確認</a>
    <a href="${pageContext.request.contextPath}/account">アカウント</a>
</div>
</body>
</html>