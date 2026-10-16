<%@ page contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.example.interviewsystem.model.Notice" %>

<!DOCTYPE html>
<html lang="ja">
<head>
    <meta charset="UTF-8">
    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>ホーム</title>

    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/css/style-premium.css?v=20261001b">

    <style>
        .parent-home-hero {
            margin-bottom: 24px;
        }

        .notice-list-glass {
            display: grid;
            gap: 16px;
        }

        .notice-item {
            position: relative;
            overflow: hidden;
        }

        .notice-item::after {
            content: "";
            position: absolute;
            right: -42px;
            top: -48px;
            width: 130px;
            height: 130px;
            border-radius: 999px;
            background: radial-gradient(circle, rgba(56, 189, 248, 0.16), transparent 68%);
            pointer-events: none;
        }

        .notice-item h3,
        .notice-item p {
            position: relative;
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

    <section class="ui-hero parent-home-hero">
        <div>
            <p class="badge">PARENT HOME</p>
            <h1 class="ui-hero-title">ホーム</h1>
            <p class="ui-hero-text">
                保護者用ホーム画面です。<br>
                先生からの公開中のお知らせを確認できます。
            </p>
        </div>

        <img class="ui-hero-image"
             src="${pageContext.request.contextPath}/images/ui/schedule-hero-illustration.png"
             alt="保護者ホームイメージ">
    </section>

    <%
        List<Notice> notices =
                (List<Notice>)
                        request.getAttribute("notices");
    %>

    <div class="card">

        <h2 class="card-title">公開中のお知らせ</h2>

        <div class="notice-list-glass">
            <%
                if (notices != null
                        && !notices.isEmpty()) {

                    for (Notice notice : notices) {
            %>

            <div class="notice-item">

                <h3>
                    <%= notice.getTitle() %>
                </h3>

                <p>
                    <%= notice.getContent() %>
                </p>
            </div>

            <%
                    }
                } else {
            %>

            <div class="empty">
                現在、公開中のお知らせはありません。
            </div>

            <%
                }
            %>
        </div>
    </div>
</div>

<div class="sidebar">

    <h2>メニュー</h2>

    <a class="active"
       href="${pageContext.request.contextPath}/parent/home">
        ホーム
    </a>

    <a href="${pageContext.request.contextPath}/parent/reservation">
        面談希望提出
    </a>

    <a href="${pageContext.request.contextPath}/parent/schedule">
        確定日程確認
    </a>

    <a href="${pageContext.request.contextPath}/chat/rooms">
        チャット
    </a>

    <a href="${pageContext.request.contextPath}/account">
        アカウント
    </a>
</div>

</body>
</html>