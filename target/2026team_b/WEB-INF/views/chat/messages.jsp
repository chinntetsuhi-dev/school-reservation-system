<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<style>
    .message-row {
        display: flex;
        margin-bottom: 14px;
        animation: premiumMessageAppear 0.24s ease both;
    }

    @keyframes premiumMessageAppear {
        from {
            opacity: 0;
            transform: translateY(8px) scale(0.985);
        }
        to {
            opacity: 1;
            transform: translateY(0) scale(1);
        }
    }

    .message-row.mine {
        justify-content: flex-end;
    }

    .message-row.other {
        justify-content: flex-start;
    }

    .message-box {
        position: relative;
        max-width: 72%;
        padding: 13px 15px;
        border-radius: 20px;
        color: #eaf7ff;
        background:
            linear-gradient(135deg, rgba(255, 255, 255, 0.18), rgba(77, 149, 225, 0.18));
        border: 1px solid rgba(181, 225, 255, 0.36);
        box-shadow:
            0 12px 26px rgba(0, 18, 48, 0.20),
            inset 0 1px 0 rgba(255, 255, 255, 0.22);
        backdrop-filter: blur(18px) saturate(145%);
        -webkit-backdrop-filter: blur(18px) saturate(145%);
        overflow: hidden;
    }

    .message-box::before {
        content: "";
        position: absolute;
        inset: 0;
        background:
            radial-gradient(circle at 14% 12%, rgba(255, 255, 255, 0.22), transparent 34%),
            radial-gradient(circle at 90% 88%, rgba(53, 230, 255, 0.14), transparent 32%);
        pointer-events: none;
    }

    .message-row.mine .message-box {
        color: #09234c;
        background:
            linear-gradient(135deg, rgba(200, 232, 255, 0.96), rgba(154, 224, 255, 0.90));
        border-color: rgba(213, 246, 255, 0.80);
        box-shadow:
            0 14px 30px rgba(40, 170, 255, 0.22),
            0 0 22px rgba(73, 204, 255, 0.16);
    }

    .message-row.other .message-box {
        background:
            linear-gradient(135deg, rgba(255, 255, 255, 0.19), rgba(88, 120, 195, 0.18));
    }

    .message-meta {
        position: relative;
        z-index: 1;
        font-size: 12px;
        color: rgba(225, 241, 255, 0.74);
        margin-bottom: 6px;
        font-weight: 850;
        letter-spacing: 0.02em;
    }

    .message-row.mine .message-meta {
        color: #1e5ba5;
    }

    .message-text {
        position: relative;
        z-index: 1;
        font-size: 14px;
        line-height: 1.75;
        white-space: pre-wrap;
        word-break: break-word;
    }

    .empty-message {
        color: rgba(229, 244, 255, 0.82);
        text-align: center;
        padding: 56px 20px;
        border-radius: 24px;
        background:
            linear-gradient(135deg, rgba(255, 255, 255, 0.14), rgba(71, 129, 207, 0.16));
        border: 1px dashed rgba(181, 225, 255, 0.44);
        font-weight: 850;
        box-shadow: inset 0 1px 0 rgba(255,255,255,0.16);
    }

    .empty-message::before {
        content: "✦";
        display: block;
        margin-bottom: 9px;
        color: #85f4ff;
        font-size: 26px;
        text-shadow: 0 0 20px rgba(117, 231, 255, 0.65);
    }
</style>

<c:choose>
    <c:when test="${empty messages}">
        <div class="empty-message">
            まだメッセージはありません。
        </div>
    </c:when>

    <c:otherwise>
        <c:forEach var="message" items="${messages}">
            <c:choose>
                <c:when test="${message.mine}">
                    <div class="message-row mine">
                </c:when>
                <c:otherwise>
                    <div class="message-row other">
                </c:otherwise>
            </c:choose>

                <div class="message-box">
                    <div class="message-meta">
                        <c:out value="${message.senderName}" />
                        ・
                        <c:out value="${message.sentAt}" />
                    </div>

                    <div class="message-text">
                        <c:out value="${message.message}" />
                    </div>
                </div>
            </div>
        </c:forEach>
    </c:otherwise>
</c:choose>