<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ja">
<head>
    <meta charset="UTF-8">
    <title>先生ホーム</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style-premium.css?v=20261001b">

    <style>
        .teacher-page {
            max-width: 1280px;
            margin: 0 auto;
            padding: 42px 28px;
        }

        .teacher-grid {
            display: grid;
            grid-template-columns: minmax(0, 1fr) minmax(360px, 0.9fr);
            gap: 22px;
        }

        .slot-list,
        .request-list,
        .final-slot-list {
            margin: 0;
            padding: 0;
            list-style: none;
        }

        .slot-list li,
        .request-list li,
        .final-slot-item {
            margin-bottom: 10px;
            padding: 14px 16px;
            border-radius: 16px;
            background: rgba(255,255,255,0.70);
            border: 1px solid rgba(203,213,225,0.70);
            line-height: 1.8;
        }

        .slot-form {
            display: grid;
            gap: 16px;
        }

        .slot-form-row {
            display: grid;
            grid-template-columns: 90px minmax(0, 1fr);
            align-items: center;
            gap: 12px;
        }

        .slot-form-row input {
            max-width: none;
        }

        .final-slot-item {
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .final-slot-display {
            margin-top: 12px;
            padding: 20px;
            border-radius: 20px;
            color: #166534;
            background: rgba(220,252,231,0.90);
            border: 1px solid rgba(134,239,172,0.72);
            font-size: 22px;
            font-weight: 900;
        }

        @media (max-width: 1000px) {
            .teacher-grid {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>

<div class="teacher-page">
    <section class="ui-hero">
        <div>
            <p class="badge">TEACHER HOME</p>
            <h1 class="ui-hero-title">先生ホーム</h1>
            <p class="ui-hero-text">
                面談候補日時の登録、保護者の提出状況、最終面談時間の決定を行います。
            </p>
        </div>

        <img class="ui-hero-image"
             src="${pageContext.request.contextPath}/images/ui/schedule-hero-illustration.png"
             alt="先生ホームイメージ">
    </section>

    <div class="teacher-grid top-space">
        <div>
            <div class="card">
                <h2 class="card-title">面談候補日時の登録</h2>

                <form class="slot-form"
                      action="${pageContext.request.contextPath}/add-slot"
                      method="post">
                    <div class="slot-form-row">
                        <label>日付：</label>
                        <input type="date" name="date" required>
                    </div>

                    <div class="slot-form-row">
                        <label>時間：</label>
                        <input type="time" name="time" required>
                    </div>

                    <div>
                        <button type="submit">追加</button>
                    </div>
                </form>
            </div>

            <div class="card">
                <h2 class="card-title">登録済み候補日時</h2>

                <ul class="slot-list">
                    <c:forEach var="slot" items="${slots}">
                        <c:if test="${!slot.deleted}">
                            <li>${slot.date} ${slot.time}</li>
                        </c:if>
                    </c:forEach>
                </ul>

                <c:if test="${empty slots}">
                    <div class="empty">
                        まだ候補日時は登録されていません。
                    </div>
                </c:if>
            </div>
        </div>

        <div>
            <div class="card">
                <h2 class="card-title">保護者の提出状況</h2>

                <ul class="request-list">
                    <c:forEach var="request" items="${parentRequests}">
                        <li>
                            保護者：${request.parentUsername}
                            ／ お子様：${request.childName}
                            ／ 状態：${request.requestStatus}
                            <br>

                            希望時間：
                            <c:if test="${entry.key == request.parentUsername.concat(' / ').concat(request.childName)}">
                                <c:forEach var="selected" items="${entry.value}">
                                    ${selected}&nbsp;
                                </c:forEach>
                            </c:if>

                            <br>
                            備考：${request.comment}
                        </li>
                    </c:forEach>
                </ul>

                <c:if test="${empty parentRequests}">
                    <div class="empty">
                        まだ提出状況はありません。
                    </div>
                </c:if>
            </div>

            <div class="card">
                <h2 class="card-title">面談候補日時（最終決定）</h2>

                <form action="${pageContext.request.contextPath}/select-final-slot" method="post">
                    <ul class="final-slot-list">
                        <c:forEach var="slot" items="${slots}">
                            <c:if test="${!slot.deleted}">
                                <li class="final-slot-item">
                                    <input type="radio" name="finalSlot" value="${slot.date} ${slot.time}" required>
                                    <span>${slot.date} ${slot.time}</span>
                                </li>
                            </c:if>
                        </c:forEach>
                    </ul>

                    <button type="submit">最終決定</button>
                </form>
            </div>

            <div class="card">
                <h2 class="card-title">最終面談時間</h2>

                <c:if test="${not empty finalSlot}">
                    <div class="final-slot-display">
                        ${finalSlot}
                    </div>
                </c:if>

                <c:if test="${empty finalSlot}">
                    <div class="empty">
                        まだ最終面談時間は決定されていません。
                    </div>
                </c:if>
            </div>
        </div>
    </div>
</div>

</body>
</html>