<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="ja">
<head>
    <meta charset="UTF-8">
    <title>チャット</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style-premium.css?v=20261001b">

    <style>
        .chat-page-hero {
            margin-bottom: 24px;
        }

        .chat-shell {
            position: relative;
            display: grid;
            grid-template-columns: minmax(0, 1fr);
            gap: 18px;
        }

        .chat-layout {
            display: flex;
            flex-direction: column;
            height: 675px;
            border-radius: 30px;
            background:
                linear-gradient(135deg, rgba(255, 255, 255, 0.15), rgba(49, 112, 190, 0.18));
            border: 1px solid rgba(181, 225, 255, 0.38);
            box-shadow:
                0 26px 72px rgba(0, 18, 48, 0.34),
                inset 0 1px 0 rgba(255, 255, 255, 0.22);
            overflow: hidden;
            backdrop-filter: blur(26px) saturate(150%);
            -webkit-backdrop-filter: blur(26px) saturate(150%);
        }

        .chat-header {
            position: relative;
            padding: 22px 26px;
            background:
                linear-gradient(135deg, rgba(26, 83, 150, 0.58), rgba(255, 255, 255, 0.12));
            border-bottom: 1px solid rgba(181, 225, 255, 0.34);
            overflow: hidden;
        }

        .chat-header::before {
            content: "";
            position: absolute;
            inset: 0;
            background:
                radial-gradient(circle at 18% 18%, rgba(91, 213, 255, 0.24), transparent 32%),
                radial-gradient(circle at 88% 18%, rgba(255, 145, 207, 0.16), transparent 34%);
            pointer-events: none;
        }

        .chat-header::after {
            content: "";
            position: absolute;
            right: -54px;
            top: -70px;
            width: 190px;
            height: 190px;
            border-radius: 999px;
            background: radial-gradient(circle, rgba(53, 230, 255, 0.24), transparent 68%);
            pointer-events: none;
        }

        .chat-title {
            position: relative;
            z-index: 1;
            font-size: 25px;
            font-weight: 950;
            margin: 0;
            color: #ffffff;
            letter-spacing: -0.03em;
            text-shadow: 0 2px 18px rgba(53, 230, 255, 0.26);
        }

        .chat-subtitle {
            position: relative;
            z-index: 1;
            display: inline-flex;
            align-items: center;
            gap: 6px;
            margin-top: 9px;
            padding: 6px 11px;
            border-radius: 999px;
            font-size: 13px;
            color: rgba(231, 246, 255, 0.86);
            background: rgba(255, 255, 255, 0.12);
            border: 1px solid rgba(181, 225, 255, 0.24);
            font-weight: 850;
        }

        .chat-messages {
            flex: 1;
            overflow-y: auto;
            padding: 22px;
            background:
                radial-gradient(circle at 12% 10%, rgba(56, 189, 248, 0.13), transparent 28%),
                radial-gradient(circle at 88% 72%, rgba(139, 92, 246, 0.12), transparent 32%),
                linear-gradient(135deg, rgba(4, 19, 47, 0.52), rgba(21, 70, 130, 0.28));
        }

        .chat-messages::-webkit-scrollbar {
            width: 10px;
        }

        .chat-messages::-webkit-scrollbar-track {
            background: rgba(255, 255, 255, 0.08);
        }

        .chat-messages::-webkit-scrollbar-thumb {
            border-radius: 999px;
            background:
                linear-gradient(180deg, rgba(76, 190, 255, 0.72), rgba(154, 116, 255, 0.66));
        }

        .chat-send-area {
            padding: 18px 20px;
            border-top: 1px solid rgba(181, 225, 255, 0.32);
            background:
                linear-gradient(135deg, rgba(255, 255, 255, 0.16), rgba(28, 83, 148, 0.26));
        }

        .chat-form {
            display: flex;
            gap: 12px;
            align-items: stretch;
        }

        .chat-form textarea {
            flex: 1;
            max-width: none;
            height: 68px;
            min-height: 68px;
            resize: none;
            padding: 13px 15px;
            font-size: 14px;
            font-family: sans-serif;
            color: #eff9ff;
            border: 1px solid rgba(181, 225, 255, 0.38);
            border-radius: 18px;
            background: rgba(7, 26, 58, 0.38);
            outline: none;
            box-shadow: inset 0 1px 0 rgba(255,255,255,0.16);
            transition:
                border-color 0.18s ease,
                box-shadow 0.18s ease,
                background 0.18s ease;
        }

        .chat-form textarea::placeholder {
            color: rgba(220, 239, 255, 0.60);
        }

        .chat-form textarea:focus {
            border-color: rgba(112, 241, 255, 0.82);
            background: rgba(9, 36, 78, 0.54);
            box-shadow:
                0 0 0 4px rgba(53, 230, 255, 0.12),
                0 0 24px rgba(53, 230, 255, 0.20);
        }

        .chat-form button {
            width: 118px;
            border-radius: 18px;
        }

        .chat-status {
            margin-top: 11px;
            font-size: 13px;
            color: rgba(222, 239, 255, 0.78);
            font-weight: 850;
        }

        .chat-status::before {
            content: "";
            display: inline-block;
            width: 8px;
            height: 8px;
            margin-right: 7px;
            border-radius: 999px;
            background: #70f1c4;
            box-shadow: 0 0 14px rgba(112, 241, 196, 0.80);
            vertical-align: middle;
        }

        .chat-error {
            color: #ffd6df;
        }

        .chat-error::before {
            background: #ff6f8c;
            box-shadow: 0 0 14px rgba(255, 111, 140, 0.72);
        }

        .chat-back-card {
            display: flex;
            justify-content: flex-start;
            align-items: center;
            padding: 18px 20px;
        }

        @media (max-width: 800px) {
            .chat-layout {
                height: 600px;
                border-radius: 24px;
            }

            .chat-form {
                flex-direction: column;
            }

            .chat-form button {
                width: 100%;
            }
        }
    </style>
</head>

<body>

<div class="content wide-content">
    <section class="ui-hero chat-page-hero">
        <div>
            <p class="badge">REALTIME CHAT</p>
            <h1 class="ui-hero-title">チャット</h1>
            <p class="ui-hero-text">
                教師と保護者の間でメッセージをやり取りします。<br>
                送信後、相手側の画面にも自動で反映されます。
            </p>
        </div>

        <img class="ui-hero-image"
             src="${pageContext.request.contextPath}/images/ui/schedule-hero-illustration.png"
             alt="チャットイメージ">
    </section>

    <div class="chat-shell">
        <div class="card no-bottom-margin">
            <div class="chat-layout">

                <div class="chat-header">
                    <p class="chat-title">
                        <c:choose>
                            <c:when test="${not empty room.roomName}">
                                <c:out value="${room.roomName}" />
                            </c:when>
                            <c:otherwise>
                                チャットルーム
                            </c:otherwise>
                        </c:choose>
                    </p>

                    <div class="chat-subtitle">
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
                </div>

                <div id="messages" class="chat-messages">
                    <jsp:include page="messages.jsp" />
                </div>

                <div class="chat-send-area">
                    <form id="sendForm" class="chat-form">
                        <textarea id="messageInput"
                                  name="message"
                                  placeholder="メッセージを入力してください"></textarea>

                        <button id="sendButton"
                                type="submit"
                                class="btn-primary">
                            送信
                        </button>
                    </form>

                    <div id="connectionStatus" class="chat-status">
                        接続準備中...
                    </div>
                </div>
            </div>
        </div>

        <div class="card chat-back-card">
            <a class="btn-secondary"
               href="${pageContext.request.contextPath}${backUrl}">
                <c:out value="${backLabel}" />
            </a>
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
        <a href="${pageContext.request.contextPath}/parent/home">
            ホーム
        </a>

        <a href="${pageContext.request.contextPath}/parent/schedule">
            日程確認
        </a>

        <a href="${pageContext.request.contextPath}/parent/reservation">
            面談希望提出
        </a>

        <a class="active" href="${pageContext.request.contextPath}/chat/rooms">
            チャット
        </a>

        <a href="${pageContext.request.contextPath}/account">
            アカウント
        </a>
    </c:if>

    <c:if test="${sessionScope.loginRole == 'STUDENT'}">
        <a href="${pageContext.request.contextPath}/student/home">
            ホーム
        </a>

        <a href="${pageContext.request.contextPath}/student/status">
            予約状況
        </a>

        <a href="${pageContext.request.contextPath}/account">
            アカウント
        </a>
    </c:if>
</div>

<script>
(function () {
    var contextPath = '${pageContext.request.contextPath}';
    var roomId = '${room.id}';

    var messagesElement = document.getElementById('messages');
    var form = document.getElementById('sendForm');
    var input = document.getElementById('messageInput');
    var button = document.getElementById('sendButton');
    var statusElement = document.getElementById('connectionStatus');

    function setStatus(text, error) {
        statusElement.innerText = text;

        if (error) {
            statusElement.classList.add('chat-error');
        } else {
            statusElement.classList.remove('chat-error');
        }
    }

    function scrollToBottom() {
        messagesElement.scrollTop = messagesElement.scrollHeight;
    }

    function refreshMessages() {
        var url =
                contextPath
                + '/chat/room/'
                + roomId
                + '/messages?t='
                + new Date().getTime();

        fetch(url, {
            method: 'GET',
            credentials: 'same-origin'
        })
        .then(function (response) {
            if (!response.ok) {
                throw new Error('HTTP ' + response.status);
            }
            return response.text();
        })
        .then(function (html) {
            messagesElement.innerHTML = html;
            scrollToBottom();
        })
        .catch(function (error) {
            setStatus('メッセージ更新に失敗しました：' + error.message, true);
        });
    }

    function connectWebSocket() {
        var protocol =
                window.location.protocol === 'https:'
                        ? 'wss://'
                        : 'ws://';

        var url =
                protocol
                + window.location.host
                + contextPath
                + '/ws/chat/'
                + roomId;

        var socket = new WebSocket(url);

        socket.onopen = function () {
            setStatus('リアルタイム接続中', false);
        };

        socket.onmessage = function (event) {
            if (event.data && event.data.indexOf('updateChat') === 0) {
                refreshMessages();
            }
        };

        socket.onclose = function () {
            setStatus('接続が切れました。再接続中...', true);

            setTimeout(function () {
                connectWebSocket();
            }, 3000);
        };

        socket.onerror = function () {
            setStatus('WebSocket接続エラー', true);
        };
    }

    form.addEventListener('submit', function (event) {
        event.preventDefault();

        var text = input.value;

        if (!text || text.trim().length === 0) {
            setStatus('メッセージを入力してください。', true);
            return;
        }

        button.disabled = true;
        button.innerText = '送信中...';

        var params =
                'message=' + encodeURIComponent(text);

        fetch(contextPath + '/chat/room/' + roomId + '/send', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8'
            },
            body: params,
            credentials: 'same-origin'
        })
        .then(function (response) {
            return response.text().then(function (body) {
                return {
                    ok: response.ok,
                    status: response.status,
                    body: body
                };
            });
        })
        .then(function (result) {
            if (!result.ok) {
                throw new Error(
                        'HTTP ' + result.status + ' / ' + result.body
                );
            }

            input.value = '';
            refreshMessages();
            setStatus('送信しました。リアルタイム接続中', false);
        })
        .catch(function (error) {
            setStatus('送信に失敗しました：' + error.message, true);
        })
        .then(function () {
            button.disabled = false;
            button.innerText = '送信';
            input.focus();
        });
    });

    input.addEventListener('keydown', function (event) {
        if (event.key === 'Enter' && !event.shiftKey) {
            event.preventDefault();

            if (typeof Event === 'function') {
                form.dispatchEvent(new Event('submit'));
            } else {
                var submitEvent = document.createEvent('Event');
                submitEvent.initEvent('submit', true, true);
                form.dispatchEvent(submitEvent);
            }
        }
    });

    refreshMessages();
    connectWebSocket();
})();
</script>

</body>
</html>