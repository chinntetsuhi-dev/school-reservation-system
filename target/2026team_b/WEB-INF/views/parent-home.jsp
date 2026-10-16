<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ja">
<head>
    <meta charset="UTF-8">
    <title>保護者ホーム</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style-premium.css?v=20261001b">

    <style>
        .legacy-page {
            max-width: 1180px;
            margin: 0 auto;
            padding: 42px 28px;
        }

        .legacy-grid {
            display: grid;
            grid-template-columns: minmax(0, 1.05fr) minmax(320px, 0.95fr);
            gap: 22px;
        }

        .slot-check-list {
            display: grid;
            gap: 10px;
            margin-top: 12px;
        }

        .slot-check-item {
            display: flex;
            align-items: center;
            gap: 10px;
            padding: 12px 14px;
            border-radius: 16px;
            background: rgba(255,255,255,0.70);
            border: 1px solid rgba(203,213,225,0.70);
            cursor: pointer;
            transition: transform 0.18s ease, background 0.18s ease;
        }

        .slot-check-item:hover {
            transform: translateY(-1px);
            background: rgba(239,246,255,0.86);
        }

        .request-list {
            margin: 0;
            padding: 0;
            list-style: none;
        }

        .request-list li {
            margin-bottom: 10px;
            padding: 14px 16px;
            border-radius: 16px;
            background: rgba(255,255,255,0.68);
            border: 1px solid rgba(203,213,225,0.68);
            line-height: 1.7;
        }

        .final-slot-box {
            margin-top: 10px;
            padding: 18px;
            border-radius: 18px;
            color: #1e3a8a;
            background: rgba(219,234,254,0.88);
            border: 1px solid rgba(147,197,253,0.72);
            font-size: 20px;
            font-weight: 900;
        }

        @media (max-width: 980px) {
            .legacy-grid {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>

<div class="legacy-page">
    <section class="ui-hero">
        <div>
            <p class="badge">PARENT HOME</p>
            <h1 class="ui-hero-title">保護者ホーム</h1>
            <p class="ui-hero-text">
                面談希望日時の提出、提出済みリクエスト、決定された面談時間を確認できます。
            </p>
        </div>

        <img class="ui-hero-image"
             src="${pageContext.request.contextPath}/images/ui/schedule-hero-illustration.png"
             alt="保護者ホームイメージ">
    </section>

    <div class="legacy-grid top-space">
        <div class="card">
            <h2 class="card-title">面談希望日時の提出</h2>

            <form action="${pageContext.request.contextPath}/submit-availability" method="post">
                <div class="form-row">
                    <label>お子様の氏名：</label>
                    <input type="text" name="childName" required>
                </div>

                <div class="form-row">
                    <label>希望日時：</label>

                    <div class="slot-check-list">
                        <c:forEach var="slot" items="${slots}">
                            <c:if test="${!slot.deleted}">
                                <label class="slot-check-item">
                                    <input type="checkbox" name="selectedSlotIds" value="${slot.id}">
                                    <span>${slot.date} ${slot.time}</span>
                                </label>
                            </c:if>
                        </c:forEach>
                    </div>
                </div>

                <div class="form-row">
                    <label>備考：</label>
                    <textarea name="comment" rows="4" cols="40"></textarea>
                </div>

                <button type="submit">送信</button>
            </form>
        </div>

        <div>
            <div class="card">
                <h2 class="card-title">提出済みリクエスト</h2>

                <ul class="request-list">
                    <c:forEach var="request" items="${parentRequests}">
                        <li>
                            お子様：${request.childName}
                            ／ 状態：${request.requestStatus}
                            <c:if test="${not empty request.comment}">
                                ／ 備考：${request.comment}
                            </c:if>
                        </li>
                    </c:forEach>
                </ul>

                <c:if test="${empty parentRequests}">
                    <div class="empty">
                        まだ提出済みリクエストはありません。
                    </div>
                </c:if>
            </div>

            <div class="card">
                <h2 class="card-title">決定された面談時間</h2>

                <c:if test="${not empty finalSlot}">
                    <div class="final-slot-box">
                        ${finalSlot}
                    </div>
                </c:if>

                <c:if test="${empty finalSlot}">
                    <div class="empty">
                        まだ面談時間は決定されていません。
                    </div>
                </c:if>
            </div>
        </div>
    </div>
</div>

</body>
</html>