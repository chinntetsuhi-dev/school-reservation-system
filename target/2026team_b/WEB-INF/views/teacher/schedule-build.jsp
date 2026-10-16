<%@ page contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@ taglib prefix="c"
           uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="ja">
<head>
    <meta charset="UTF-8">
    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>日程作成</title>

    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/css/style-premium.css?v=20261001b">

    <style>
        .teacher-hero {
            margin-bottom: 24px;
        }

        .teacher-table-wrap {
            overflow-x: auto;
        }

        .teacher-glass-card {
            position: relative;
        }

        .teacher-glass-card::after {
            content: "";
            position: absolute;
            right: -54px;
            top: -58px;
            width: 160px;
            height: 160px;
            border-radius: 999px;
            background: radial-gradient(circle, rgba(56, 189, 248, 0.18), transparent 68%);
            pointer-events: none;
        }

        .teacher-glass-card > * {
            position: relative;
        }

        .teacher-action-area {
            margin-top: 22px;
            display: flex;
            gap: 10px;
            flex-wrap: wrap;
        }

        .teacher-form-grid {
            display: grid;
            gap: 18px;
            max-width: 720px;
        }

        .teacher-form-grid textarea,
        .teacher-form-grid select,
        .teacher-form-grid input[type="text"] {
            max-width: none;
        }

        .teacher-soft-note {
            color: #64748b;
            line-height: 1.8;
            font-weight: 700;
        }

        .teacher-list-card {
            margin-bottom: 14px;
            padding: 16px;
            border-radius: 18px;
            background: rgba(255, 255, 255, 0.70);
            border: 1px solid rgba(255, 255, 255, 0.75);
            box-shadow: 0 10px 24px rgba(45, 80, 130, 0.10);
        }
    </style>

</head>
<body>

<div class="content wide-content premium-page">
    <div class="premium-topbar">
        <div class="premium-user-pill">
            <span class="premium-user-avatar">👨‍🏫</span>
            <c:choose>
                <c:when test="${not empty sessionScope.loginUser.displayName}">
                    <c:out value="${sessionScope.loginUser.displayName}" /> 先生
                </c:when>
                <c:when test="${not empty sessionScope.user.displayName}">
                    <c:out value="${sessionScope.user.displayName}" /> 先生
                </c:when>
                <c:otherwise>
                    先生
                </c:otherwise>
            </c:choose>
        </div>
    </div>

    <div class="premium-hero-row">
        <div class="premium-hero-icon">🗓️</div>
        <div>
            <div class="premium-breadcrumb">日程設定　&gt;　日程作成</div>
            <h1 class="premium-title">日程作成</h1>
            <p class="premium-subtitle">
                保護者からの希望提出状況を確認し、一括自動振り分けを実行します。<br>
                同じ第1希望が重なった場合は、手動確認対象として表示します。
            </p>
        </div>
    </div>

    <div class="premium-stats">
        <div class="premium-stat premium-stat-blue">
            <div class="premium-stat-icon">👥</div>
            <div class="premium-stat-label">全保護者数</div>
            <div class="premium-stat-value">${summary.totalParentCount}<small>名</small></div>
        </div>
        <div class="premium-stat premium-stat-green">
            <div class="premium-stat-icon">✓</div>
            <div class="premium-stat-label">提出済み</div>
            <div class="premium-stat-value">${summary.submittedParentCount}<small>名</small></div>
        </div>
        <div class="premium-stat premium-stat-pink">
            <div class="premium-stat-icon">○</div>
            <div class="premium-stat-label">未提出</div>
            <div class="premium-stat-value"><span id="statUnsubmitted">0</span><small>名</small></div>
        </div>
        <div class="premium-stat premium-stat-orange">
            <div class="premium-stat-icon">⚠</div>
            <div class="premium-stat-label">手動確認必要</div>
            <div class="premium-stat-value">${manualCount}<small>名</small></div>
        </div>
    </div>

    <div class="card teacher-glass-card schedule-main-card">

        <h2 class="card-title">
            現在の提出状況（1年A組）
        </h2>

        <div class="submit-summary">

            <p class="submit-count">
                提出済み児童数：

                <span class="count-num">
                    ${summary.submittedParentCount}
                </span>

                / ${summary.totalParentCount} 名
            </p>

            <c:set var="progressMax"
       value="${summary.totalParentCount}" />

<c:if test="${progressMax == 0}">
    <c:set var="progressMax" value="1" />
</c:if>

<progress class="submit-progress"
          value="${summary.submittedParentCount}"
          max="${progressMax}">
</progress>

            <c:if test="${manualCount > 0}">
                <p class="manual-summary">
                    手動確認必要：${manualCount} 名
                </p>
            </c:if>
        </div>

        <div class="table-scroll">

            <table class="request-table">

                <thead>
                <tr>
                    <th>出席番号</th>
                    <th>児童名</th>
                    <th>提出時刻</th>
                    <th>状態</th>
                    <th>第1希望</th>
                    <th>第2希望</th>
                    <th>第3希望</th>
                    <th>コメント</th>
                </tr>
                </thead>

                <tbody>

                <c:forEach var="row"
                           items="${submissionRows}"
                           varStatus="loop">

                    <tr>
                        <td class="cell-center">
                            ${loop.count}
                        </td>

                        <td>${row.childName}</td>

                        <td class="${empty row.id
                                ? 'text-muted-cell'
                                : ''}">

                            ${empty row.id
                                ? '-'
                                : row.createdAt}
                        </td>

                        <td>
                            <c:choose>

                                <c:when test="${empty row.id}">
                                    <span class="text-danger">
                                        未提出
                                    </span>
                                </c:when>

                                <c:when test="${row.manualRequired}">
                                    <a class="manual-link"
                                       href="${pageContext.request.contextPath}/teacher/requests?optionId=${row.firstOption.id}">

                                        手動確認必要
                                    </a>
                                </c:when>

                                <c:otherwise>
                                    <span class="status status-submitted">
                                        ${row.requestStatusLabel}
                                    </span>
                                </c:otherwise>

                            </c:choose>
                        </td>

                        <td>
                            ${empty row.firstOption
                                ? '-'
                                : row.firstOption.displayLabel}
                        </td>

                        <td>
                            ${empty row.secondOption
                                ? '-'
                                : row.secondOption.displayLabel}
                        </td>

                        <td>
                            ${empty row.thirdOption
                                ? '-'
                                : row.thirdOption.displayLabel}
                        </td>

                        <td>${row.comment}</td>
                    </tr>
                </c:forEach>

                </tbody>
            </table>
        </div>

        <div class="action-footer">

            <form method="post"
                  action="${pageContext.request.contextPath}/teacher/schedule-build/auto"
                  onsubmit="return confirm('一括自動振り分けを実行しますか？');">

                <button type="submit"
                        class="btn-primary">
                    一括振り分けを実行
                </button>
            </form>
        </div>
    </div>
</div>

<div class="sidebar">

    <h2>メニュー</h2>

    <a href="${pageContext.request.contextPath}/teacher/home">
        ホーム
    </a>

    <a href="${pageContext.request.contextPath}/teacher/slots">
        日程設定
    </a>

    <a class="active"
       href="${pageContext.request.contextPath}/teacher/schedule-build">
        日程作成
    </a>

    <a href="${pageContext.request.contextPath}/teacher/schedule-change">
        日程変更
    </a>

    <a href="${pageContext.request.contextPath}/teacher/schedule">
        日程確認
    </a>

    <a href="${pageContext.request.contextPath}/chat/rooms">
        チャット
    </a>

    <a href="${pageContext.request.contextPath}/account">
        アカウント
    </a>
</div>

<script>
(function () {
    var target = document.getElementById('statUnsubmitted');
    if (target) {
        var total = Number('${summary.totalParentCount}');
        var submitted = Number('${summary.submittedParentCount}');
        if (!isNaN(total) && !isNaN(submitted)) {
            target.innerText = Math.max(total - submitted, 0);
        }
    }
})();
</script>

</body>
</html>