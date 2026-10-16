<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="ja">
<head>
    <meta charset="UTF-8">
    <title>チャットルーム一覧</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style-premium.css?v=20261001b">

    <style>
        .chat-rooms-shell {
            min-height: 100vh;
        }

        .chat-rooms-hero {
            margin-bottom: 24px;
        }

        .rooms-toolbar {
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 14px;
            margin-bottom: 18px;
        }

        .rooms-toolbar-title {
            margin: 0;
            color: #ffffff;
            font-size: 22px;
            font-weight: 900;
            letter-spacing: -0.03em;
        }

        .rooms-toolbar-note {
            color: rgba(222, 239, 255, 0.76);
            font-size: 13px;
            font-weight: 700;
        }

        .room-list {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(286px, 1fr));
            gap: 18px;
        }

        .room-card {
            position: relative;
            display: block;
            min-height: 198px;
            padding: 22px;
            border-radius: 28px;
            color: #ffffff;
            text-decoration: none;
            background:
                linear-gradient(135deg, rgba(56, 189, 248, 0.20), rgba(99, 102, 241, 0.16)),
                rgba(255, 255, 255, 0.10);
            border: 1px solid rgba(181, 225, 255, 0.34);
            box-shadow:
                0 22px 54px rgba(3, 13, 35, 0.26),
                inset 0 1px 0 rgba(255, 255, 255, 0.22);
            overflow: hidden;
            backdrop-filter: blur(24px) saturate(150%);
            -webkit-backdrop-filter: blur(24px) saturate(150%);
            transition:
                transform 0.18s ease,
                box-shadow 0.18s ease,
                border-color 0.18s ease,
                background 0.18s ease;
        }

        .room-card:hover {
            transform: translateY(-5px);
            border-color: rgba(217, 245, 255, 0.72);
            background:
                linear-gradient(135deg, rgba(56, 189, 248, 0.30), rgba(154, 116, 255, 0.24)),
                rgba(255, 255, 255, 0.14);
            box-shadow:
                0 30px 72px rgba(3, 13, 35, 0.34),
                0 0 30px rgba(76, 190, 255, 0.28),
                inset 0 1px 0 rgba(255, 255, 255, 0.34);
        }

        .room-card::after {
            content: "";
            position: absolute;
            right: -56px;
            top: -58px;
            width: 168px;
            height: 168px;
            border-radius: 999px;
            background:
                radial-gradient(circle, rgba(53, 230, 255, 0.26), transparent 67%);
            pointer-events: none;
        }

        .room-card::before {
            content: "CHAT";
            position: absolute;
            right: 20px;
            bottom: 18px;
            color: rgba(255, 255, 255, 0.16);
            font-size: 34px;
            font-weight: 900;
            letter-spacing: 0.10em;
            pointer-events: none;
        }

        .room-icon {
            position: relative;
            width: 52px;
            height: 52px;
            margin-bottom: 14px;
            border-radius: 18px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 24px;
            background:
                linear-gradient(135deg, rgba(33, 200, 255, 0.58), rgba(166, 103, 255, 0.62));
            box-shadow:
                0 0 24px rgba(76, 190, 255, 0.30),
                inset 0 1px 0 rgba(255, 255, 255, 0.32);
        }

        .room-name {
            position: relative;
            margin-bottom: 8px;
            color: #ffffff;
            font-size: 20px;
            font-weight: 900;
            letter-spacing: -0.03em;
            text-shadow: 0 2px 16px rgba(35, 177, 255, 0.22);
        }

        .room-info {
            position: relative;
            color: rgba(222, 239, 255, 0.82);
            font-size: 14px;
            font-weight: 800;
            margin-bottom: 12px;
        }

        .last-message {
            position: relative;
            margin-top: 12px;
            padding: 12px 13px;
            border-radius: 18px;
            min-height: 58px;
            color: rgba(245, 251, 255, 0.90);
            font-size: 14px;
            line-height: 1.65;
            background: rgba(7, 24, 56, 0.24);
            border: 1px solid rgba(181, 225, 255, 0.24);
            box-shadow: inset 0 1px 0 rgba(255,255,255,0.10);
        }

        .empty {
            padding: 28px;
            color: rgba(222, 239, 255, 0.82);
            background: rgba(255, 255, 255, 0.10);
            border: 1px dashed rgba(181, 225, 255, 0.38);
            border-radius: 24px;
            font-weight: 800;
            text-align: center;
        }

        .error {
            color: #ffe4e9;
            background: rgba(255, 111, 140, 0.20);
            border: 1px solid rgba(255, 170, 190, 0.52);
            padding: 14px 16px;
            border-radius: 18px;
            margin-bottom: 18px;
            font-weight: 800;
        }

        .back {
            margin-top: 22px;
        }

        .back a {
            display: inline-block;
            padding: 10px 16px;
            border-radius: 16px;
            color: #ffffff;
            background: rgba(255, 255, 255, 0.12);
            border: 1px solid rgba(181, 225, 255, 0.38);
            text-decoration: none;
            font-weight: 850;
            box-shadow:
                inset 0 1px 0 rgba(255,255,255,0.18),
                0 10px 24px rgba(0,0,0,0.18);
        }

        .back a:hover {
            background: rgba(76, 190, 255, 0.18);
        }

        @media (max-width: 800px) {
            .rooms-toolbar {
                align-items: flex-start;
                flex-direction: column;
            }
        }
    </style>
</head>
<body>

<div class="content wide-content chat-rooms-shell">

    <section class="ui-hero chat-rooms-hero">
        <div>
            <p class="badge">CHAT ROOMS</p>
            <h1 class="ui-hero-title">チャットルーム一覧</h1>
            <p class="ui-hero-text">
                保護者・先生とのチャットルームを選択してください。<br>
                最新メッセージもここで確認できます。
            </p>
        </div>

        <img class="ui-hero-image"
             src="${pageContext.request.contextPath}/images/ui/schedule-hero-illustration.png"
             alt="チャットルーム一覧イメージ">
    </section>

    <div class="card">
        <div class="rooms-toolbar">
            <div>
                <h2 class="rooms-toolbar-title">ルーム一覧</h2>
                <div class="rooms-toolbar-note">
                    連絡したい相手のルームを開いてください。
                </div>
            </div>
        </div>

        <c:if test="${not empty errorMessage}">
            <div class="error">
                <c:out value="${errorMessage}" />
            </div>
        </c:if>

        <c:choose>
            <c:when test="${empty rooms}">
                <div class="empty">
                    チャットルームがありません。
                </div>
            </c:when>

            <c:otherwise>
                <div class="room-list">
                    <c:forEach var="room" items="${rooms}">
                        <a class="room-card"
                           href="${pageContext.request.contextPath}/chat/room/${room.id}">

                            <div class="room-icon">💬</div>

                            <div class="room-name">
                                <c:choose>
                                    <c:when test="${not empty room.roomName}">
                                        <c:out value="${room.roomName}" />
                                    </c:when>
                                    <c:otherwise>
                                        チャットルーム
                                    </c:otherwise>
                                </c:choose>
                            </div>

                            <div class="room-info">
                                保護者：
                                <c:choose>
                                    <c:when test="${not empty room.parentName}">
                                        <c:out value="${room.parentName}" />
                                    </c:when>
                                    <c:otherwise>
                                        -
                                    </c:otherwise>
                                </c:choose>
                            </div>

                            <div class="last-message">
                                <c:choose>
                                    <c:when test="${not empty room.lastMessage}">
                                        最新：
                                        <c:out value="${room.lastMessage}" />
                                        <c:if test="${not empty room.lastSentAt}">
                                            （<c:out value="${room.lastSentAt}" />）
                                        </c:if>
                                    </c:when>
                                    <c:otherwise>
                                        まだメッセージはありません。
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </a>
                    </c:forEach>
                </div>
            </c:otherwise>
        </c:choose>

        <div class="back">
            <c:choose>
                <c:when test="${sessionScope.loginRole == 'PARENT'}">
                    <a href="${pageContext.request.contextPath}/parent/home">保護者メニューへ戻る</a>
                </c:when>
                <c:when test="${sessionScope.loginRole == 'STUDENT'}">
                    <a href="${pageContext.request.contextPath}/student/home">学生メニューへ戻る</a>
                </c:when>
                <c:otherwise>
                    <a href="${pageContext.request.contextPath}/teacher/home">教師メニューへ戻る</a>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</div>

<div class="sidebar">
    <h2>メニュー</h2>

    <c:if test="${sessionScope.loginRole == 'TEACHER'}">
        <a href="${pageContext.request.contextPath}/teacher/home">
            ホーム
        </a>

        <a href="${pageContext.request.contextPath}/teacher/slots">
            日程設定
        </a>

        <a href="${pageContext.request.contextPath}/teacher/schedule-build">
            日程作成
        </a>

        <a href="${pageContext.request.contextPath}/teacher/schedule-change">
            日程変更
        </a>

        <a href="${pageContext.request.contextPath}/teacher/schedule">
            日程確認
        </a>

        <a class="active" href="${pageContext.request.contextPath}/chat/rooms">
            チャット
        </a>

        <a href="${pageContext.request.contextPath}/account">
            アカウント
        </a>
    </c:if>

    <c:if test="${sessionScope.loginRole == 'PARENT'}">
        <a href="${pageContext.request.contextPath}/parent/home">ホーム</a>
        <a href="${pageContext.request.contextPath}/parent/schedule">日程確認</a>
        <a href="${pageContext.request.contextPath}/parent/reservation">面談希望提出</a>
        <a class="active" href="${pageContext.request.contextPath}/chat/rooms">チャット</a>
        <a href="${pageContext.request.contextPath}/account">アカウント</a>
    </c:if>

    <c:if test="${sessionScope.loginRole == 'STUDENT'}">
        <a href="${pageContext.request.contextPath}/student/home">ホーム</a>
        <a href="${pageContext.request.contextPath}/student/status">予約状況</a>
        <a class="active" href="${pageContext.request.contextPath}/chat/rooms">チャット</a>
        <a href="${pageContext.request.contextPath}/account">アカウント</a>
    </c:if>
</div>

</body>
</html>
