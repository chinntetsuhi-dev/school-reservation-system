<%@ page contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.time.LocalDate" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="java.util.Locale" %>
<%@ page import="com.example.interviewsystem.model.ScheduleStatus" %>
<%@ taglib prefix="c"
           uri="http://java.sun.com/jsp/jstl/core" %>

<%
    Map<String, ScheduleStatus> scheduleMap =
            (Map<String, ScheduleStatus>)
                    request.getAttribute("scheduleMap");

    DateTimeFormatter dateFormatter =
            DateTimeFormatter.ofPattern(
                    "M/d（E）",
                    Locale.JAPANESE
            );
%>

<!DOCTYPE html>
<html lang="ja">
<head>
    <meta charset="UTF-8">
    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>日程確認</title>

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
        <div class="premium-hero-icon">📋</div>
        <div>
            <div class="premium-breadcrumb">日程設定　&gt;　日程確認</div>
            <h1 class="premium-title">日程確認</h1>
            <p class="premium-subtitle">
                確定して公開された面談スケジュールを確認できます。<br>
                公開後の最終確認用画面です。
            </p>
        </div>
    </div>

    <div class="premium-stats">
        <div class="premium-stat premium-stat-blue">
            <div class="premium-stat-icon">📅</div>
            <div class="premium-stat-label">表示日数</div>
            <div class="premium-stat-value"><span id="statDates">0</span><small>日</small></div>
        </div>
        <div class="premium-stat premium-stat-green">
            <div class="premium-stat-icon">✓</div>
            <div class="premium-stat-label">確定済み</div>
            <div class="premium-stat-value"><span id="statFixed">0</span><small>件</small></div>
        </div>
        <div class="premium-stat premium-stat-pink">
            <div class="premium-stat-icon">＋</div>
            <div class="premium-stat-label">空き枠</div>
            <div class="premium-stat-value"><span id="statBlank">0</span><small>枠</small></div>
        </div>
        <div class="premium-stat premium-stat-orange">
            <div class="premium-stat-icon">👁</div>
            <div class="premium-stat-label">確認画面</div>
            <div class="premium-stat-value">公開<small>版</small></div>
        </div>
    </div>

    <div class="card teacher-glass-card schedule-main-card">

        <h2 class="card-title">
            1年A組の面談スケジュール
        </h2>

        <div class="table-scroll">

            <table class="schedule-grid result-grid">

                <thead>
                <tr>
                    <th class="time-label"></th>

                    <c:forEach var="date"
                               items="${dates}">

                        <%
                            String headerDate =
                                    (String)
                                    pageContext
                                    .getAttribute("date");
                        %>

                        <th>
                            <%= LocalDate
                                    .parse(headerDate)
                                    .format(dateFormatter) %>
                        </th>
                    </c:forEach>
                </tr>
                </thead>

                <tbody>

                <c:forEach var="time"
                           items="${times}">

                    <tr>
                        <th class="time-label">
                            ${time}〜
                        </th>

                        <c:forEach var="date"
                                   items="${dates}">

                            <%
                                String cellDate =
                                        (String)
                                        pageContext
                                        .getAttribute("date");

                                String cellTime =
                                        (String)
                                        pageContext
                                        .getAttribute("time");

                                ScheduleStatus status =
                                        scheduleMap.get(
                                                cellDate
                                                        + "_"
                                                        + cellTime
                                        );

                                boolean confirmed =
                                        status != null
                                                && status.isConfirmed();
                            %>

                            <td>
                                <div class="result-cell
                                    <%= confirmed
                                        ? "slot-fixed"
                                        : "slot-fixed-empty" %>">

                                    <%= confirmed
                                            ? status.getChildName()
                                            : "" %>
                                </div>
                            </td>
                        </c:forEach>
                    </tr>
                </c:forEach>

                </tbody>
            </table>
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

    <a href="${pageContext.request.contextPath}/teacher/schedule-build">
        日程作成
    </a>

    <a href="${pageContext.request.contextPath}/teacher/schedule-change">
        日程変更
    </a>

    <a class="active"
       href="${pageContext.request.contextPath}/teacher/schedule">
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
    var dateTarget = document.getElementById('statDates');
    var fixedTarget = document.getElementById('statFixed');
    var blankTarget = document.getElementById('statBlank');
    var dateCount = document.querySelectorAll('.schedule-grid thead th').length - 1;
    var fixedCount = document.querySelectorAll('.result-cell.slot-fixed').length;
    var blankCount = document.querySelectorAll('.result-cell.slot-fixed-empty').length;

    if (dateTarget) { dateTarget.innerText = Math.max(dateCount, 0); }
    if (fixedTarget) { fixedTarget.innerText = fixedCount; }
    if (blankTarget) { blankTarget.innerText = blankCount; }
})();
</script>

</body>
</html>