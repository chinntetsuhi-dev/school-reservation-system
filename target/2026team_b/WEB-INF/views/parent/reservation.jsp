<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.time.LocalDate" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="java.util.Locale" %>
<%@ page import="com.example.interviewsystem.model.ReservationOption" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%
    Map<String, ReservationOption> optionMap =
            (Map<String, ReservationOption>)
                    request.getAttribute("optionMap");

    boolean multipleChildren =
            Boolean.TRUE.equals(
                    request.getAttribute("multipleChildren")
            );

    DateTimeFormatter dateFormatter =
            DateTimeFormatter.ofPattern(
                    "M/d（E）",
                    Locale.JAPANESE
            );
%>

<c:set var="commonMarkText" value="〇" />

<c:if test="${multipleChildren}">
    <c:set var="commonMarkText" value="★" />
</c:if>

<!DOCTYPE html>
<html lang="ja">
<head>
    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>面談希望日時の提出</title>

    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/css/style-premium.css?v=20261001b">

    <style>
        .reservation-hero {
            margin-bottom: 24px;
        }

        .reservation-guide-card {
            display: grid;
            grid-template-columns: minmax(0, 1fr) auto;
            gap: 18px;
            align-items: center;
            background:
                linear-gradient(135deg, rgba(255, 255, 255, 0.15), rgba(70, 131, 207, 0.17));
        }

        .reservation-guide-main h2 {
            margin-bottom: 8px;
        }

        .reservation-guide-card p {
            color: rgba(229, 244, 255, 0.82);
            font-weight: 750;
        }

        .reservation-period-badge {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            min-width: 150px;
            padding: 12px 16px;
            border-radius: 999px;
            color: #ffffff;
            background:
                linear-gradient(135deg, rgba(33, 200, 255, 0.52), rgba(154, 116, 255, 0.58));
            border: 1px solid rgba(219, 246, 255, 0.58);
            font-weight: 950;
            white-space: nowrap;
            box-shadow:
                0 0 24px rgba(95, 125, 255, 0.26),
                inset 0 1px 0 rgba(255, 255, 255, 0.24);
        }

        .selectable-grid {
            background: rgba(8, 34, 76, 0.30);
            border-color: rgba(181, 225, 255, 0.35);
            box-shadow:
                0 20px 54px rgba(0, 16, 44, 0.28),
                inset 0 1px 0 rgba(255,255,255,0.15);
        }

        .selectable-grid th {
            color: #f5fbff;
            background:
                linear-gradient(180deg, rgba(54, 116, 190, 0.62), rgba(31, 82, 150, 0.46));
            border-color: rgba(181, 225, 255, 0.26);
            text-shadow: 0 1px 12px rgba(53, 230, 255, 0.18);
        }

        .selectable-grid td {
            transition:
                transform 0.16s ease,
                box-shadow 0.16s ease,
                background 0.16s ease;
            background: rgba(12, 42, 90, 0.30);
            border-color: rgba(181, 225, 255, 0.23);
        }

        .selectable-grid .time-label {
            color: #e8f7ff;
            background:
                linear-gradient(135deg, rgba(22, 67, 129, 0.62), rgba(18, 51, 101, 0.58));
        }

        .choice-slot.slot-available {
            color: #dff9ff;
            background:
                linear-gradient(135deg, rgba(60, 154, 255, 0.34), rgba(83, 217, 255, 0.16));
            text-shadow: 0 0 16px rgba(101, 224, 255, 0.60);
        }

        .choice-slot.slot-available:hover {
            transform: translateY(-1px);
            box-shadow:
                inset 0 0 0 2px rgba(112, 241, 255, 0.48),
                0 0 18px rgba(80, 197, 255, 0.28);
        }

        .slot-choice-1,
        .slot-choice-2,
        .slot-choice-3 {
            color: #ffffff !important;
            box-shadow:
                inset 0 0 0 1px rgba(255,255,255,0.35),
                0 0 24px rgba(88, 179, 255, 0.34);
        }

        .slot-choice-1 {
            background:
                linear-gradient(135deg, #21c8ff, #536dff) !important;
        }

        .slot-choice-2 {
            background:
                linear-gradient(135deg, #70f1c4, #38bdf8) !important;
        }

        .slot-choice-3 {
            background:
                linear-gradient(135deg, #ff91cf, #9a74ff) !important;
        }

        .grid-slot.slot-unavailable,
        .slot-closed {
            color: rgba(220, 239, 255, 0.34);
            background:
                repeating-linear-gradient(
                    135deg,
                    rgba(255, 255, 255, 0.08),
                    rgba(255, 255, 255, 0.08) 8px,
                    rgba(255, 255, 255, 0.03) 8px,
                    rgba(255, 255, 255, 0.03) 16px
                );
        }

        .child-tabs {
            border-bottom-color: rgba(181, 225, 255, 0.25);
        }

        .child-tab {
            border-radius: 18px;
            color: rgba(232, 246, 255, 0.78);
            background: rgba(255, 255, 255, 0.10);
            border: 1px solid rgba(181, 225, 255, 0.22);
            box-shadow: inset 0 1px 0 rgba(255,255,255,0.13);
        }

        .child-tab:hover {
            color: #ffffff;
            background: rgba(76, 190, 255, 0.18);
        }

        .child-tab.active {
            color: #ffffff;
            background:
                linear-gradient(135deg, rgba(33, 200, 255, 0.62), rgba(154, 116, 255, 0.68));
            border-color: rgba(224, 247, 255, 0.56);
            box-shadow:
                0 0 24px rgba(95, 125, 255, 0.34),
                inset 0 1px 0 rgba(255,255,255,0.25);
        }

        .child-meta {
            color: rgba(234, 249, 255, 0.86);
        }

        .selection-summary {
            color: #eaf9ff;
            background:
                linear-gradient(135deg, rgba(33, 200, 255, 0.16), rgba(154, 116, 255, 0.14));
            border: 1px solid rgba(181, 225, 255, 0.30);
            box-shadow: inset 0 1px 0 rgba(255,255,255,0.14);
        }

        .submitted-request {
            background:
                linear-gradient(135deg, rgba(255, 255, 255, 0.14), rgba(61, 122, 200, 0.15));
            border: 1px solid rgba(181, 225, 255, 0.32);
            box-shadow: 0 14px 32px rgba(0, 16, 44, 0.18);
        }

        .submitted-request-header strong {
            font-size: 18px;
            color: #ffffff;
        }

        .submitted-request p {
            color: rgba(232, 246, 255, 0.82);
        }

        .request-confirm-form {
            margin-top: 12px;
        }

        label {
            color: rgba(232, 246, 255, 0.86);
        }

        textarea[name="comments"] {
            max-width: none;
            color: #eff9ff;
            background: rgba(7, 26, 58, 0.34);
            border-color: rgba(181, 225, 255, 0.35);
        }

        textarea[name="comments"]::placeholder {
            color: rgba(220, 239, 255, 0.58);
        }

        @media (max-width: 800px) {
            .reservation-guide-card {
                grid-template-columns: 1fr;
            }
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

<body data-common-mark="${commonMarkText}">

<div class="content wide-content">

    <section class="ui-hero reservation-hero">
        <div>
            <p class="badge">RESERVATION REQUEST</p>
            <h1 class="ui-hero-title">面談希望日時の提出</h1>
            <p class="ui-hero-text">
                お子様ごとに、青い枠をクリックして第1〜第3希望を選んでください。<br>
                クリックした順番が①、②、③になります。
            </p>
        </div>

        <img class="ui-hero-image"
             src="${pageContext.request.contextPath}/images/ui/schedule-hero-illustration.png"
             alt="面談希望提出イメージ">
    </section>

    <c:if test="${not empty errorMessage}">
        <div class="error-message">
            ${errorMessage}
        </div>
    </c:if>

    <div class="card reservation-guide-card">

        <div class="reservation-guide-main">
            <h2 class="card-title">
                受付期間
            </h2>

            <p class="no-bottom-margin">
                2026年6月1日（月）〜2026年6月26日（金）
            </p>

            <p class="small-note">
                現在は期間外でも提出できます。
            </p>
        </div>

        <div class="reservation-period-badge">
            希望は3つ選択
        </div>
    </div>

    <c:choose>

        <c:when test="${not empty childrenToSubmit}">

            <form id="requestForm"
                  method="post"
                  action="${pageContext.request.contextPath}/parent/submit-requests"
                  onsubmit="return validateAllSelections();">

                <div class="card">

                    <div class="child-tabs">

                        <c:forEach var="child"
                                   items="${childrenToSubmit}"
                                   varStatus="loop">

                            <button type="button"
                                    class="child-tab ${loop.first ? 'active' : ''}"
                                    data-child-id="${child.childUserId}">

                                ${child.childName}
                            </button>
                        </c:forEach>
                    </div>

                    <c:if test="${multipleChildren}">

                        <p class="page-subtitle common-note">
                            ★は、登録されているお子様が
                            共通して選べる時間です。
                        </p>
                    </c:if>

                    <c:forEach var="child"
                               items="${childrenToSubmit}"
                               varStatus="childLoop">

                        <section class="child-panel ${childLoop.first ? 'active' : ''}"
                                 data-child-id="${child.childUserId}"
                                 data-child-name="${child.childName}">

                            <input type="hidden"
                                   name="childUserIds"
                                   value="${child.childUserId}">

                            <input type="hidden"
                                   name="firstOptionIds"
                                   class="choice-input choice-1">

                            <input type="hidden"
                                   name="secondOptionIds"
                                   class="choice-input choice-2">

                            <input type="hidden"
                                   name="thirdOptionIds"
                                   class="choice-input choice-3">

                            <p class="child-meta">
                                ${child.className}　
                                ${child.childName}
                            </p>

                            <div class="table-scroll">

                                <table class="schedule-grid selectable-grid">

                                    <thead>
                                    <tr>
                                        <th class="time-label"></th>

                                        <c:forEach var="date"
                                                   items="${dates}">

                                            <%
                                                String headerDate =
                                                        (String)
                                                                pageContext.getAttribute(
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
                                                                    pageContext.getAttribute(
                                                                            "date"
                                                                    );

                                                    String cellTime =
                                                            (String)
                                                                    pageContext.getAttribute(
                                                                            "time"
                                                                    );

                                                    ReservationOption option =
                                                            optionMap.get(
                                                                    cellDate
                                                                            + "_"
                                                                            + cellTime
                                                            );

                                                    boolean available =
                                                            option != null
                                                                    && option.isAvailable();
                                                %>

                                                <td class="grid-slot choice-slot <%= available ? "slot-available" : "slot-unavailable" %>"
                                                    <% if (available) { %>
                                                    data-option-id="<%= option.getId() %>"
                                                    data-label="<%= option.getDisplayLabel() %>"
                                                    <% } %>>

                                                    <%= available
                                                            ? (multipleChildren ? "★" : "〇")
                                                            : "×" %>
                                                </td>
                                            </c:forEach>
                                        </tr>
                                    </c:forEach>

                                    </tbody>
                                </table>
                            </div>

                            <p class="selection-summary">
                                第1希望：未選択 ／
                                第2希望：未選択 ／
                                第3希望：未選択
                            </p>

                            <label>コメント（任意）</label>

                            <textarea name="comments"
                                      rows="2"
                                      placeholder="例：兄弟と同じ日にしていただけると助かります"></textarea>
                        </section>
                    </c:forEach>

                    <div class="submit-area">

                        <button type="submit"
                                class="btn-primary">

                            この内容で提出する
                        </button>
                    </div>
                </div>
            </form>
        </c:when>

        <c:otherwise>

            <div class="card">

                <div class="empty">
                    登録されているすべてのお子様について、
                    希望を提出済みです。
                </div>
            </div>
        </c:otherwise>
    </c:choose>

    <div class="card">

        <h2 class="card-title">
            提出済みの希望
        </h2>

        <c:forEach var="requestItem"
                   items="${parentRequests}">

            <div class="submitted-request">

                <div class="submitted-request-header">

                    <strong>
                        ${requestItem.childName}
                    </strong>

                    <span class="status ${requestItem.manualRequired ? 'status-resubmitted' : 'status-submitted'}">
                        ${requestItem.requestStatusLabel}
                    </span>
                </div>

                <p>
                    第1希望：
                    ${requestItem.firstOption.displayLabel}
                </p>

                <p>
                    第2希望：
                    ${requestItem.secondOption.displayLabel}
                </p>

                <p>
                    第3希望：
                    ${requestItem.thirdOption.displayLabel}
                </p>

                <c:if test="${not empty requestItem.comment}">
                    <p>
                        コメント：
                        ${requestItem.comment}
                    </p>
                </c:if>

                <c:if test="${requestItem.requestStatus == 'WAITING_PARENT' || requestItem.requestStatus == 'PARENT_CONFIRMING'}">

                    <form class="request-confirm-form"
                          action="${pageContext.request.contextPath}/parent/confirm-reservation"
                          method="post">

                        <input type="hidden"
                               name="requestId"
                               value="${requestItem.id}">

                        <button type="submit"
                                class="btn-primary">

                            この日程で確定する
                        </button>
                    </form>
                </c:if>
            </div>
        </c:forEach>

        <c:if test="${empty parentRequests}">

            <div class="empty">
                提出済みの希望はありません。
            </div>
        </c:if>
    </div>
</div>

<div class="sidebar">

    <h2>メニュー</h2>

    <a href="${pageContext.request.contextPath}/parent/home">
        ホーム
    </a>

    <a class="active"
       href="${pageContext.request.contextPath}/parent/reservation">

        面談希望提出
    </a>

    <a href="${pageContext.request.contextPath}/parent/schedule">
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
    const commonMark =
        document.body.dataset.commonMark;

    const selections = {};

    document
        .querySelectorAll('.child-panel')
        .forEach(function (panel) {

            selections[panel.dataset.childId] = [];
        });

    document
        .querySelectorAll('.child-tab')
        .forEach(function (tab) {

            tab.addEventListener(
                'click',
                function () {

                    const childId =
                        this.dataset.childId;

                    document
                        .querySelectorAll('.child-tab')
                        .forEach(function (targetTab) {

                            targetTab.classList.toggle(
                                'active',
                                targetTab === tab
                            );
                        });

                    document
                        .querySelectorAll('.child-panel')
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

    document
        .querySelectorAll(
            '.choice-slot.slot-available'
        )
        .forEach(function (slot) {

            slot.addEventListener(
                'click',
                function () {

                    const panel =
                        this.closest('.child-panel');

                    const childId =
                        panel.dataset.childId;

                    const optionId =
                        this.dataset.optionId;

                    const selected =
                        selections[childId];

                    const currentIndex =
                        selected.indexOf(optionId);

                    if (currentIndex >= 0) {

                        selected.splice(
                            currentIndex,
                            1
                        );

                    } else if (selected.length < 3) {

                        selected.push(optionId);

                    } else {

                        alert(
                            '第1希望〜第3希望は3つまでです。'
                            + '選択を解除してから選び直してください。'
                        );

                        return;
                    }

                    renderSelections(panel);
                }
            );
        });

    function renderSelections(panel) {

        const childId =
            panel.dataset.childId;

        const selected =
            selections[childId];

        const marks = [
            '①',
            '②',
            '③'
        ];

        const labels = [
            '第1希望',
            '第2希望',
            '第3希望'
        ];

        panel
            .querySelectorAll(
                '.choice-slot.slot-available'
            )
            .forEach(function (slot) {

                slot.classList.remove(
                    'slot-choice-1',
                    'slot-choice-2',
                    'slot-choice-3'
                );

                slot.textContent =
                    commonMark;
            });

        const summary =
            labels.map(
                function (label, index) {

                    const optionId =
                        selected[index];

                    const slot =
                        optionId
                            ? panel.querySelector(
                                '[data-option-id="'
                                + optionId
                                + '"]'
                            )
                            : null;

                    if (slot) {

                        slot.classList.add(
                            'slot-choice-'
                            + (index + 1)
                        );

                        slot.textContent =
                            marks[index];
                    }

                    return label
                        + '：'
                        + (slot
                            ? slot.dataset.label
                            : '未選択');
                }
            );

        panel.querySelector(
            '.choice-1'
        ).value = selected[0] || '';

        panel.querySelector(
            '.choice-2'
        ).value = selected[1] || '';

        panel.querySelector(
            '.choice-3'
        ).value = selected[2] || '';

        panel.querySelector(
            '.selection-summary'
        ).textContent =
            summary.join(' ／ ');
    }

    function validateAllSelections() {

        const panels =
            document.querySelectorAll(
                '.child-panel'
            );

        for (const panel of panels) {

            const childId =
                panel.dataset.childId;

            if (selections[childId].length !== 3) {

                alert(
                    panel.dataset.childName
                    + 'さんの第1〜第3希望を'
                    + 'すべて選択してください。'
                );

                panel.classList.add('active');

                document
                    .querySelectorAll(
                        '.child-panel'
                    )
                    .forEach(function (otherPanel) {

                        if (otherPanel !== panel) {

                            otherPanel
                                .classList
                                .remove('active');
                        }
                    });

                document
                    .querySelectorAll(
                        '.child-tab'
                    )
                    .forEach(function (tab) {

                        tab.classList.toggle(
                            'active',
                            tab.dataset.childId
                                === childId
                        );
                    });

                return false;
            }
        }

        return true;
    }
</script>

</body>
</html>