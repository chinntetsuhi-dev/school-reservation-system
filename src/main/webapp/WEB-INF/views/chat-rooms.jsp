<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="ja">
<head>
    <meta charset="UTF-8">
    <title>チャットルーム</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style-premium.css?v=20261001b">

    <style>
        .chatrooms-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(270px, 1fr));
            gap: 18px;
        }

        .chatroom-card {
            position: relative;
            padding: 22px;
            border-radius: 24px;
            background: rgba(255, 255, 255, 0.68);
            border: 1px solid rgba(255, 255, 255, 0.75);
            box-shadow: 0 14px 32px rgba(45, 80, 130, 0.12);
            overflow: hidden;
            transition: transform 0.18s ease, box-shadow 0.18s ease;
        }

        .chatroom-card:hover {
            transform: translateY(-3px);
            box-shadow: 0 24px 48px rgba(45, 80, 130, 0.16);
        }

        .chatroom-card::after {
            content: "";
            position: absolute;
            right: -48px;
            top: -48px;
            width: 140px;
            height: 140px;
            border-radius: 999px;
            background: radial-gradient(circle, rgba(56, 189, 248, 0.22), transparent 68%);
        }

        .chatroom-name {
            position: relative;
            margin: 0 0 10px;
            font-size: 21px;
            font-weight: 900;
            color: #0f172a;
        }

        .chatroom-meta {
            position: relative;
            color: #64748b;
            line-height: 1.8;
            font-weight: 700;
            margin-bottom: 18px;
        }

        .chatroom-card form {
            position: relative;
            margin: 0;
        }

        .chatroom-table-wrap {
            overflow-x: auto;
        }

        .chatroom-table {
            min-width: 760px;
        }

        .chatroom-action-form {
            margin: 0;
        }

        .empty-room {
            grid-column: 1 / -1;
        }
    </style>
</head>
<body>

<div class="content wide-content">
    <section class="ui-hero">
        <div>
            <p class="badge">CHAT ROOMS</p>
            <h1 class="ui-hero-title">チャットルーム</h1>
            <p class="ui-hero-text">
                保護者ごとのチャットルームを表示します。<br>
                面談に関する確認事項を共有できます。
            </p>
        </div>

        <img class="ui-hero-image"
             src="${pageContext.request.contextPath}/images/ui/schedule-hero-illustration.png"
             alt="チャットルームイメージ">
    </section>

    <div class="card top-space">
        <div class="card-header-row">
            <div>
                <h2 class="card-title">チャットルーム一覧</h2>
                <p class="small-note">
                    入室ボタンから各保護者とのチャットを開きます。
                </p>
            </div>
        </div>

        <div class="chatrooms-grid">
            <c:forEach var="room" items="${chatRooms}">
                <div class="chatroom-card">
                    <h3 class="chatroom-name">${room.roomName}</h3>

                    <div class="chatroom-meta">
                        保護者：${room.parentName}<br>
                        状態：
                        <span class="status status-confirmed">${room.statusLabel}</span>
                    </div>

                    <form action="${pageContext.request.contextPath}/chat/room" method="get">
                        <input type="hidden" name="roomId" value="${room.id}">
                        <button type="submit" class="btn-primary">入室</button>
                    </form>
                </div>
            </c:forEach>

            <c:if test="${empty chatRooms}">
                <div class="empty empty-room">
                    利用可能なチャットルームはありません。
                </div>
            </c:if>
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
        <a href="${pageContext.request.contextPath}/account">アカウント</a>
    </c:if>
</div>

</body>
</html>