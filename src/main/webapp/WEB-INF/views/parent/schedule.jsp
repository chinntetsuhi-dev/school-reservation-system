<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.time.LocalDate" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="java.util.Locale" %>
<%@ page import="com.example.interviewsystem.model.ChildInfo" %>
<%@ page import="com.example.interviewsystem.model.ScheduleStatus" %>
<%@ page import="com.example.interviewsystem.model.ReservationOption" %>
<%@ taglib prefix="c"
           uri="http://java.sun.com/jsp/jstl/core" %>

<%
    Map<String, ScheduleStatus> scheduleMap =
            (Map<String, ScheduleStatus>)
                    request.getAttribute("scheduleMap");

    Map<Long, ReservationOption>
            confirmedOptionsByChildId =
            (Map<Long, ReservationOption>)
                    request.getAttribute(
                            "confirmedOptionsByChildId"
                    );

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

    <title>確定日程確認</title>

    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/css/style-premium.css?v=20261001b">

    <style>
        .schedule-hero {
            margin-bottom: 24px;
        }

        .schedule-status-card {
            margin-top: 18px;
        }

        .result-grid .result-cell {
            border-radius: 14px;
            min-height: 58px;
            transition:
                transform 0.16s ease,
                box-shadow 0.16s ease,
                background 0.16s ease;
        }

        .result-grid .result-cell:hover {
            transform: translateY(-1px);
        }

        .my-child-note {
            border: 1px solid rgba(147, 197, 253, 0.72);
            box-shadow: 0 10px 22px rgba(37, 99, 235, 0.10);
        }

        .pending-note {
            border-color: rgba(203, 213, 225, 0.78);
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

    <section class="ui-hero schedule-hero">
        <div>
            <p class="badge">FIXED SCHEDULE</p>
            <h1 class="ui-hero-title">確定日程確認</h1>
            <p class="ui-hero-text">
                確定した面談スケジュールを確認できます。<br>
                お子様ごとにタブを切り替えて確認してください。
            </p>
        </div>

        <img class="ui-hero-image"
             src="${pageContext.request.contextPath}/images/ui/schedule-hero-illustration.png"
             alt="確定日程確認イメージ">
    </section>

    <div class="card schedule-status-card">

        <div class="child-tabs">

            <c:forEach var="child"
                       items="${children}"
                       varStatus="loop">

                <button type="button"
                        class="child-tab ${loop.first
                            ? 'active'
                            : ''}"
                        data-child-id="${child.childUserId}">

                    ${child.childName}
                </button>
            </c:forEach>
        </div>

        <c:forEach var="child"
                   items="${children}"
                   varStatus="childLoop">

            <section class="child-panel
                ${childLoop.first
                    ? 'active'
                    : ''}"
                     data-child-id="${child.childUserId}">

                <h2 class="card-title">
                    ${child.className}の面談スケジュール
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
                                            .getAttribute(
                                                    "date"
                                            );
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
                                                .getAttribute(
                                                        "date"
                                                );

                                        String cellTime =
                                                (String)
                                                pageContext
                                                .getAttribute(
                                                        "time"
                                                );

                                        ScheduleStatus status =
                                                scheduleMap.get(
                                                        cellDate
                                                                + "_"
                                                                + cellTime
                                                );

                                        boolean confirmed =
                                                status != null
                                                        && status
                                                        .isConfirmed();
                                    %>

                                    <td>
                                        <div class="result-cell
                                            <%= confirmed
                                                ? "slot-fixed"
                                                : "slot-fixed-empty" %>">

                                            <%= confirmed
                                                    ? status
                                                    .getChildName()
                                                    : "" %>
                                        </div>
                                    </td>
                                </c:forEach>
                            </tr>
                        </c:forEach>

                        </tbody>
                    </table>
                </div>

                <%
                    ChildInfo currentChild =
                            (ChildInfo)
                                    pageContext
                                    .getAttribute("child");

                    ReservationOption confirmedOption =
                            confirmedOptionsByChildId.get(
                                    currentChild
                                    .getChildUserId()
                            );
                %>

                <% if (confirmedOption != null) { %>

                <p class="my-child-note">

                    <%= currentChild.getChildName() %>
                    さんの面談は

                    <%= confirmedOption
                            .getDisplayLabel() %>

                    です。
                </p>

                <% } else { %>

                <p class="my-child-note pending-note">

                    <%= currentChild.getChildName() %>
                    さんの面談日程は、
                    まだ確定していません。
                </p>

                <% } %>
            </section>
        </c:forEach>

        <c:if test="${empty children}">

            <div class="empty">
                登録されているお子様がいません。
            </div>
        </c:if>
    </div>
</div>

<div class="sidebar">

    <h2>メニュー</h2>

    <a href="${pageContext.request.contextPath}/parent/home">
        ホーム
    </a>

    <a href="${pageContext.request.contextPath}/parent/reservation">
        面談希望提出
    </a>

    <a class="active"
       href="${pageContext.request.contextPath}/parent/schedule">
        確定日程確認
    </a>

    <a href="${pageContext.request.contextPath}/chat/rooms">
        チャット
    </a>

    <a href="${pageContext.request.contextPath}/account">
        アカウント
    </a>
</div>

<script>
    document
        .querySelectorAll('.child-tab')
        .forEach(function (tab) {

            tab.addEventListener(
                'click',
                function () {

                    const childId =
                        this.dataset.childId;

                    document
                        .querySelectorAll(
                            '.child-tab'
                        )
                        .forEach(function (targetTab) {

                            targetTab.classList.toggle(
                                'active',
                                targetTab === tab
                            );
                        });

                    document
                        .querySelectorAll(
                            '.child-panel'
                        )
                        .forEach(function (panel) {

                            panel.classList.toggle(
                                'active',
                                panel.dataset.childId
                                    === childId
                            );
                        });
                }
            );
        });
</script>

</body>
</html>