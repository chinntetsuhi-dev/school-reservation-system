<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="ja">
<head>
    <meta charset="UTF-8">
    <title>チャット</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style-premium.css?v=20261001b">

    <style>
        .chat-hero {
            margin-bottom: 24px;
        }

        .chat-window {
            display: flex;
            flex-direction: column;
            height: 660px;
            overflow: hidden;
            border-radius: 28px;
            background: rgba(255, 255, 255, 0.58);
            border: 1px solid rgba(255, 255, 255, 0.78);
            box-shadow:
                0 24px 60px rgba(45, 80, 130, 0.16),
                inset 0 1px 0 rgba(255, 255, 255, 0.80);
            backdrop-filter: blur(26px) saturate(145%);
            -webkit-backdrop-filter: blur(26px) saturate(145%);
        }

        .chat-room-header {
            padding: 20px 24px;
            border-bottom: 1px solid rgba(203, 213, 225, 0.55);
            background: rgba(255, 255, 255, 0.44);
        }

        .chat-room-name {
            margin: 0;
            font-size: 22px;
            font-weight: 900;
            color: #0f172a;
        }

        .chat-log {
            flex: 1;
            height: 500px;
            overflow-y: auto;
            padding: 22px;
            background:
                radial-gradient(circle at 15% 12%, rgba(56, 189, 248, 0.10), transparent 28%),
                linear-gradient(135deg, rgba(239, 246, 255, 0.58), rgba(255, 255, 255, 0.26));
        }

        .chat-message {
            position: relative;
            max-width: 74%;
            margin-bottom: 15px;
            padding: 13px 15px;
            border-radius: 20px;
            background: rgba(255, 255, 255, 0.82);
            border: 1px solid rgba(226, 232, 240, 0.82);
            box-shadow: 0 10px 24px rgba(45, 80, 130, 0.10);
            animation: chatFade 0.25s ease both;
        }

        @keyframes chatFade {
            from {
                opacity: 0;
                transform: translateY(8px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .chat-message-name {
            font-weight: 900;
            margin-bottom: 6px;
            color: #0f172a;
        }

        .chat-message-text {
            margin-bottom: 7px;
            white-space: pre-wrap;
            line-height: 1.75;
            color: #1f2937;
        }

        .chat-message-time {
            font-size: 12px;
            color: #64748b;
            text-align: right;
        }

        .chat-form-area {
            padding: 18px 20px;
            border-top: 1px solid rgba(203, 213, 225, 0.55);
            background: rgba(255, 255, 255, 0.64);
        }

        .chat-form-area form {
            margin-top: 0 !important;
        }

        .chat-form-area textarea {
            width: 100% !important;
            max-width: none;
            min-height: 104px;
        }

        .chat-actions {
            margin-top: 12px;
            display: flex;
            gap: 10px;
            flex-wrap: wrap;
            justify-content: flex-end;
        }
    </style>

    <script>
        window.addEventListener("load", function () {
            var messageBox = document.getElementById("messageBox");

            setInterval(function () {
                if (messageBox && messageBox.value.trim().length === 0) {
                    location.reload();
                }
            }, 5000);
        });
    </script>
</head>

<body>

<div class="content wide-content">
    <section class="ui-hero chat-hero">
        <div>
            <p class="badge">CHAT</p>
            <h1 class="ui-hero-title">チャット</h1>
            <p class="ui-hero-text">
                ${room.roomName}
            </p>
        </div>

        <img class="ui-hero-image"
             src="${pageContext.request.contextPath}/images/ui/schedule-hero-illustration.png"
             alt="チャットイメージ">
    </section>

    <div class="chat-window">
        <div class="chat-room-header">
            <h2 class="chat-room-name">${room.roomName}</h2>
        </div>

        <div class="chat-log">
            <c:forEach var="msg" items="${messages}">
                <div class="chat-message">
                    <div class="chat-message-name">
                        ${msg.senderName}
                    </div>

                    <div class="chat-message-text">
                        ${msg.message}
                    </div>

                    <div class="chat-message-time">
                        ${msg.sentAt}
                    </div>
                </div>
            </c:forEach>

            <c:if test="${empty messages}">
                <div class="empty">まだメッセージはありません。</div>
            </c:if>
        </div>

        <div class="chat-form-area">
            <form action="${pageContext.request.contextPath}/chat/send"
                  method="post">

                <input type="hidden" name="roomId" value="${room.id}">

                <textarea
                        id="messageBox"
                        name="message"
                        rows="4"
                        placeholder="メッセージを入力してください"
                        required></textarea>

                <div class="chat-actions">
                    <button type="submit" class="btn-primary">送信</button>

                    <button type="button"
                            class="btn-secondary"
                            onclick="location.href='${pageContext.request.contextPath}/chat/rooms'">
                        ルーム一覧へ戻る
                    </button>
                </div>
            </form>
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