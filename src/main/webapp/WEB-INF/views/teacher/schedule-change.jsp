<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="ja">
<head>
    <meta charset="UTF-8">
    <title>日程変更</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style-premium.css?v=20261001b">

    <style>
        .change-toolbar {
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 16px;
            margin-bottom: 18px;
        }

        .change-help {
            font-size: 14px;
            color: #64748b;
            line-height: 1.7;
        }

        .change-actions {
            display: flex;
            gap: 10px;
            align-items: center;
        }

        .manual-alert {
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 16px;
            padding: 14px 16px;
            border-radius: 14px;
            background: #fff1f2;
            color: #991b1b;
            border: 1px solid #fecdd3;
            margin-bottom: 16px;
        }

        .manual-alert-title {
            font-weight: 800;
            margin-bottom: 3px;
        }

        .manual-alert-text {
            font-size: 13px;
            color: #b91c1c;
        }

        .manual-alert-button {
            white-space: nowrap;
            text-decoration: none;
            border-radius: 10px;
            padding: 9px 14px;
            background: #dc2626;
            color: #ffffff;
            font-weight: 700;
            font-size: 13px;
        }

        .manual-alert-button:hover {
            background: #b91c1c;
        }

        .message-success {
            padding: 12px 16px;
            border-radius: 10px;
            background: #dcfce7;
            color: #166534;
            margin-bottom: 16px;
            font-weight: 600;
        }

        .message-error {
            padding: 12px 16px;
            border-radius: 10px;
            background: #fee2e2;
            color: #991b1b;
            margin-bottom: 16px;
            font-weight: 600;
        }

        .schedule-board {
            overflow-x: auto;
            border: 1px solid #dbe3ee;
            border-radius: 16px;
            background: #ffffff;
        }

        .schedule-table {
            width: 100%;
            min-width: 980px;
            border-collapse: separate;
            border-spacing: 0;
        }

        .schedule-table th {
            background: #f1f5f9;
            color: #0f172a;
            font-weight: 700;
            font-size: 14px;
            padding: 14px 10px;
            border-right: 1px solid #dbe3ee;
            border-bottom: 1px solid #dbe3ee;
            text-align: center;
            white-space: nowrap;
        }

        .schedule-table td {
            border-right: 1px solid #e2e8f0;
            border-bottom: 1px solid #e2e8f0;
            padding: 8px;
            height: 74px;
            background: #f8fafc;
            vertical-align: middle;
        }

        .schedule-table tr:last-child td {
            border-bottom: none;
        }

        .schedule-time {
            width: 110px;
            text-align: center;
            font-weight: 700;
            color: #334155;
            background: #f1f5f9 !important;
            white-space: nowrap;
        }

        .schedule-cell {
            min-width: 160px;
            transition:
                background 0.18s ease,
                box-shadow 0.18s ease,
                transform 0.18s ease;
        }

        .schedule-cell.cell-over {
            background: #e0f2fe;
            box-shadow: inset 0 0 0 2px #38bdf8;
        }

        .schedule-cell.cell-swap {
            background: #fef3c7;
            box-shadow: inset 0 0 0 2px #f59e0b;
        }

        .empty-slot {
            height: 52px;
            border: 1px dashed #cbd5e1;
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #94a3b8;
            font-size: 13px;
            background: rgba(255,255,255,0.65);
            transition: all 0.18s ease;
        }

        .schedule-card {
            position: relative;
            border-radius: 12px;
            padding: 10px 12px;
            background: linear-gradient(135deg, #dbeafe, #eef6ff);
            border: 1px solid #93c5fd;
            color: #0f172a;
            cursor: grab;
            box-shadow: 0 6px 14px rgba(37, 99, 235, 0.12);
            transition:
                transform 0.18s ease,
                box-shadow 0.18s ease,
                opacity 0.18s ease;
            user-select: none;
        }

        .schedule-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 20px rgba(37, 99, 235, 0.18);
        }

        .schedule-card.dragging {
            opacity: 0.45;
            transform: scale(0.96);
        }

        .schedule-card.moved {
            animation: movedPulse 0.45s ease;
        }

        @keyframes movedPulse {
            0% {
                transform: scale(0.96);
                box-shadow: 0 0 0 rgba(37, 99, 235, 0);
            }
            50% {
                transform: scale(1.03);
                box-shadow: 0 0 0 4px rgba(37, 99, 235, 0.18);
            }
            100% {
                transform: scale(1);
                box-shadow: 0 6px 14px rgba(37, 99, 235, 0.12);
            }
        }

        .student-name {
            font-weight: 800;
            font-size: 14px;
            margin-bottom: 4px;
        }

        .student-meta {
            font-size: 12px;
            color: #475569;
            line-height: 1.4;
        }

        .drag-mark {
            position: absolute;
            right: 10px;
            top: 8px;
            color: #2563eb;
            font-weight: 800;
            letter-spacing: 1px;
        }

        .changed-badge {
            display: none;
            margin-top: 6px;
            padding: 3px 7px;
            border-radius: 999px;
            background: #fef3c7;
            color: #92400e;
            font-size: 11px;
            font-weight: 700;
        }

        .schedule-card.changed .changed-badge {
            display: inline-block;
        }

        .manual-slot {
            border-radius: 12px;
            padding: 10px 12px;
            background: linear-gradient(135deg, #fee2e2, #fff1f2);
            border: 1px solid #fca5a5;
            color: #991b1b;
            box-shadow: 0 6px 14px rgba(220, 38, 38, 0.12);
        }

        .manual-slot-title {
            font-weight: 800;
            font-size: 13px;
            margin-bottom: 4px;
        }

        .manual-slot-meta {
            font-size: 12px;
            line-height: 1.4;
            color: #b91c1c;
            word-break: break-word;
        }

        .manual-slot-link {
            display: inline-block;
            margin-top: 7px;
            font-size: 11px;
            font-weight: 700;
            color: #ffffff;
            background: #dc2626;
            padding: 4px 8px;
            border-radius: 999px;
            text-decoration: none;
        }

        .manual-slot-link:hover {
            background: #b91c1c;
        }

        .manual-under-badge {
            margin-top: 7px;
            padding: 5px 8px;
            border-radius: 10px;
            background: #fee2e2;
            color: #991b1b;
            border: 1px solid #fca5a5;
            font-size: 11px;
            font-weight: 700;
        }

        .legend {
            display: flex;
            gap: 18px;
            flex-wrap: wrap;
            margin-top: 14px;
            font-size: 13px;
            color: #475569;
        }

        .legend-item {
            display: inline-flex;
            align-items: center;
            gap: 6px;
        }

        .legend-color {
            width: 18px;
            height: 12px;
            border-radius: 4px;
            display: inline-block;
        }

        .legend-blue {
            background: #bfdbfe;
        }

        .legend-red {
            background: #fecaca;
        }

        .legend-empty {
            background: #f8fafc;
            border: 1px dashed #94a3b8;
        }

        .save-note {
            font-size: 13px;
            color: #64748b;
            margin-top: 12px;
        }

        .btn-save {
            border: none;
            border-radius: 10px;
            padding: 11px 18px;
            background: #2563eb;
            color: #ffffff;
            font-weight: 700;
            cursor: pointer;
        }

        .btn-save:hover {
            background: #1d4ed8;
        }

        .btn-reset {
            border: 1px solid #cbd5e1;
            border-radius: 10px;
            padding: 10px 16px;
            background: #ffffff;
            color: #334155;
            font-weight: 700;
            cursor: pointer;
        }

        .btn-reset:hover {
            background: #f8fafc;
        }
    </style>

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

    <style>
        .schedule-board {
            background: rgba(255,255,255,0.58) !important;
            border: 1px solid rgba(255,255,255,0.76) !important;
            box-shadow: 0 18px 42px rgba(45,80,130,0.12);
            backdrop-filter: blur(18px);
            -webkit-backdrop-filter: blur(18px);
        }
        .schedule-table th {
            background: linear-gradient(180deg, rgba(239,246,255,0.96), rgba(219,234,254,0.90)) !important;
        }
        .schedule-table td {
            background: rgba(248,250,252,0.70) !important;
        }
        .schedule-card {
            border-radius: 16px !important;
            background: linear-gradient(135deg, rgba(219,234,254,0.96), rgba(224,242,254,0.88)) !important;
            box-shadow: 0 12px 26px rgba(37,99,235,0.14) !important;
        }
        .manual-slot {
            border-radius: 16px !important;
            background: linear-gradient(135deg, rgba(254,226,226,0.96), rgba(255,241,242,0.92)) !important;
        }
        .change-toolbar {
            padding: 4px;
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
        <div class="premium-hero-icon">📅</div>
        <div>
            <div class="premium-breadcrumb">日程設定　&gt;　日程変更</div>
            <h1 class="premium-title">日程変更</h1>
            <p class="premium-subtitle">
                確定済みの日程をドラッグして、空き枠へ移動、または他の日程と入れ替えできます。<br>
                保存ボタンを押すまでデータベースには反映されません。
            </p>
        </div>
    </div>

    <div class="premium-stats">
        <div class="premium-stat premium-stat-blue">
            <div class="premium-stat-icon">👥</div>
            <div class="premium-stat-label">確定済み日程</div>
            <div class="premium-stat-value"><span id="statConfirmed">0</span><small>件</small></div>
        </div>
        <div class="premium-stat premium-stat-green">
            <div class="premium-stat-icon">✓</div>
            <div class="premium-stat-label">変更済み</div>
            <div class="premium-stat-value"><span id="statChanged">0</span><small>件</small></div>
        </div>
        <div class="premium-stat premium-stat-pink">
            <div class="premium-stat-icon">＋</div>
            <div class="premium-stat-label">空き枠</div>
            <div class="premium-stat-value"><span id="statEmpty">0</span><small>枠</small></div>
        </div>
        <div class="premium-stat premium-stat-orange">
            <div class="premium-stat-icon">⚠</div>
            <div class="premium-stat-label">手動確認必要</div>
            <div class="premium-stat-value">${manualCount}<small>件</small></div>
        </div>
    </div>

    <c:if test="${not empty message}">
        <div class="message-success">
            <c:out value="${message}" />
        </div>
    </c:if>

    <c:if test="${not empty errorMessage}">
        <div class="message-error">
            <c:out value="${errorMessage}" />
        </div>
    </c:if>

    <c:if test="${manualCount > 0}">
        <div class="manual-alert">
            <div>
                <div class="manual-alert-title">
                    手動確認が必要な申請があります
                </div>
                <div class="manual-alert-text">
                    赤色の枠が手動確認対象です。日程作成画面から確認・確定してください。
                </div>
            </div>

            <a class="manual-alert-button"
               href="${pageContext.request.contextPath}/teacher/schedule-build">
                手動確認へ
            </a>
        </div>
    </c:if>

    <div class="card teacher-glass-card">
        <div class="change-toolbar">
            <div class="change-help">
                日程カードをドラッグしてください。<br>
                空き枠に置くと移動し、他のカードの上に置くと日程を入れ替えます。
                保存ボタンを押すまではデータベースには反映されません。
            </div>

            <div class="change-actions">
                <button type="button"
                        class="btn-reset"
                        onclick="window.location.href='${pageContext.request.contextPath}/teacher/schedule-change'">
                    変更を取り消す
                </button>

                <form id="saveForm"
                      action="${pageContext.request.contextPath}/teacher/schedule-change/save"
                      method="post">
                    <input type="hidden"
                           id="assignments"
                           name="assignments"
                           value="">

                    <button type="submit"
                            class="btn-save">
                        日程保存
                    </button>
                </form>
            </div>
        </div>

        <div class="schedule-board">
            <table class="schedule-table">
                <thead>
                <tr>
                    <th>時間</th>
                    <c:forEach var="date" items="${dates}">
                        <th>${date}</th>
                    </c:forEach>
                </tr>
                </thead>

                <tbody>
                <c:forEach var="time" items="${times}">
                    <tr>
                        <td class="schedule-time">
                            ${time}
                        </td>

                        <c:forEach var="date" items="${dates}">
                            <c:set var="key" value="${date}_${time}" />
                            <c:set var="cell" value="${cellMap[key]}" />

                            <td class="schedule-cell"
                                data-option-id="${cell.optionId}">

                                <c:choose>
                                    <c:when test="${cell.occupied}">
                                        <div class="schedule-card"
                                             draggable="true"
                                             data-plan-id="${cell.planId}"
                                             data-original-option-id="${cell.optionId}"
                                             data-current-option-id="${cell.optionId}">

                                            <div class="drag-mark">⋮</div>

                                            <div class="student-name">
                                                <c:out value="${cell.childName}" />
                                            </div>

                                            <div class="student-meta">
                                                <c:if test="${not empty cell.className}">
                                                    <c:out value="${cell.className}" />
                                                    <br>
                                                </c:if>

                                                保護者：
                                                <c:choose>
                                                    <c:when test="${not empty cell.parentName}">
                                                        <c:out value="${cell.parentName}" />
                                                    </c:when>
                                                    <c:otherwise>
                                                        -
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>

                                            <span class="changed-badge">
                                                変更あり
                                            </span>
                                        </div>

                                        <c:if test="${cell.manualRequired}">
                                            <div class="manual-under-badge">
                                                手動確認 ${cell.manualCount}名
                                            </div>
                                        </c:if>
                                    </c:when>

                                    <c:when test="${cell.manualRequired}">
                                        <div class="manual-slot">
                                            <div class="manual-slot-title">
                                                手動確認必要（${cell.manualCount}名）
                                            </div>

                                            <div class="manual-slot-meta">
                                                <c:choose>
                                                    <c:when test="${not empty cell.manualNames}">
                                                        <c:out value="${cell.manualNames}" />
                                                    </c:when>
                                                    <c:otherwise>
                                                        第1希望が重複しています
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>

                                            <a class="manual-slot-link"
                                               href="${pageContext.request.contextPath}/teacher/schedule-build">
                                                確認へ
                                            </a>
                                        </div>
                                    </c:when>

                                    <c:otherwise>
                                        <div class="empty-slot">
                                            空き
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                        </c:forEach>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </div>

        <div class="legend">
            <span class="legend-item">
                <span class="legend-color legend-blue"></span>
                確定済み日程
            </span>

            <span class="legend-item">
                <span class="legend-color legend-red"></span>
                手動確認必要
            </span>

            <span class="legend-item">
                <span class="legend-color legend-empty"></span>
                空き枠
            </span>
        </div>

        <div class="save-note">
            ※ ドラッグ後に「日程保存」を押すと、日程確認画面にも反映されます。
            手動確認の申請は日程作成画面で処理してください。
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

    <a class="active"
       href="${pageContext.request.contextPath}/teacher/schedule-change">
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
    var draggedCard = null;
    var sourceCell = null;

    var cells =
            document.querySelectorAll('.schedule-cell');

    var cards =
            document.querySelectorAll('.schedule-card');

    function clearCellHighlight() {
        for (var i = 0; i < cells.length; i++) {
            cells[i].classList.remove('cell-over');
            cells[i].classList.remove('cell-swap');
        }
    }

    function ensureEmptySlot(cell) {
        if (!cell.querySelector('.schedule-card')
                && !cell.querySelector('.manual-slot')
                && !cell.querySelector('.empty-slot')) {

            var empty =
                    document.createElement('div');

            empty.className = 'empty-slot';
            empty.innerText = '空き';

            cell.appendChild(empty);
        }
    }

    function removeEmptySlot(cell) {
        var empty =
                cell.querySelector('.empty-slot');

        if (empty) {
            cell.removeChild(empty);
        }
    }

    function markChanged(card) {
        if (!card) {
            return;
        }

        var original =
                card.getAttribute('data-original-option-id');

        var current =
                card.getAttribute('data-current-option-id');

        if (original !== current) {
            card.classList.add('changed');
        } else {
            card.classList.remove('changed');
        }
    }

    function animate(card) {
        if (!card) {
            return;
        }

        card.classList.remove('moved');

        setTimeout(function () {
            card.classList.add('moved');
        }, 10);
    }

    function bindCard(card) {
        card.addEventListener('dragstart', function (event) {
            draggedCard = card;
            sourceCell = card.closest('.schedule-cell');

            card.classList.add('dragging');

            event.dataTransfer.effectAllowed = 'move';
            event.dataTransfer.setData(
                    'text/plain',
                    card.getAttribute('data-plan-id')
            );
        });

        card.addEventListener('dragend', function () {
            card.classList.remove('dragging');
            draggedCard = null;
            sourceCell = null;
            clearCellHighlight();
        });
    }

    for (var i = 0; i < cards.length; i++) {
        bindCard(cards[i]);
    }

    for (var j = 0; j < cells.length; j++) {
        cells[j].addEventListener('dragover', function (event) {
            event.preventDefault();

            if (!draggedCard) {
                return;
            }

            clearCellHighlight();

            var targetCard =
                    this.querySelector('.schedule-card');

            if (targetCard && targetCard !== draggedCard) {
                this.classList.add('cell-swap');
            } else {
                this.classList.add('cell-over');
            }
        });

        cells[j].addEventListener('dragleave', function () {
            this.classList.remove('cell-over');
            this.classList.remove('cell-swap');
        });

        cells[j].addEventListener('drop', function (event) {
            event.preventDefault();

            if (!draggedCard || !sourceCell) {
                clearCellHighlight();
                return;
            }

            var targetCell = this;

            if (targetCell === sourceCell) {
                clearCellHighlight();
                return;
            }

            var targetOptionId =
                    targetCell.getAttribute('data-option-id');

            var sourceOptionId =
                    sourceCell.getAttribute('data-option-id');

            var targetCard =
                    targetCell.querySelector('.schedule-card');

            removeEmptySlot(targetCell);
            removeEmptySlot(sourceCell);

            if (targetCard && targetCard !== draggedCard) {
                sourceCell.appendChild(targetCard);

                targetCard.setAttribute(
                        'data-current-option-id',
                        sourceOptionId
                );

                markChanged(targetCard);
                animate(targetCard);
            } else {
                ensureEmptySlot(sourceCell);
            }

            targetCell.appendChild(draggedCard);

            draggedCard.setAttribute(
                    'data-current-option-id',
                    targetOptionId
            );

            markChanged(draggedCard);
            animate(draggedCard);

            ensureEmptySlot(sourceCell);
            clearCellHighlight();
        });
    }

    var saveForm =
            document.getElementById('saveForm');

    var assignmentsInput =
            document.getElementById('assignments');

    saveForm.addEventListener('submit', function () {
        var currentCards =
                document.querySelectorAll('.schedule-card');

        var assignments = [];

        for (var i = 0; i < currentCards.length; i++) {
            var card = currentCards[i];

            var cell =
                    card.closest('.schedule-cell');

            var planId =
                    card.getAttribute('data-plan-id');

            var optionId =
                    cell.getAttribute('data-option-id');

            card.setAttribute(
                    'data-current-option-id',
                    optionId
            );

            assignments.push(
                    planId + ':' + optionId
            );
        }

        assignmentsInput.value =
                assignments.join(',');
    });

    function updatePremiumStats() {
        var confirmedElement = document.getElementById('statConfirmed');
        var changedElement = document.getElementById('statChanged');
        var emptyElement = document.getElementById('statEmpty');

        if (confirmedElement) {
            confirmedElement.innerText = document.querySelectorAll('.schedule-card').length;
        }

        if (changedElement) {
            changedElement.innerText = document.querySelectorAll('.schedule-card.changed').length;
        }

        if (emptyElement) {
            emptyElement.innerText = document.querySelectorAll('.empty-slot').length;
        }
    }

    var originalMarkChanged = markChanged;
    markChanged = function (card) {
        originalMarkChanged(card);
        updatePremiumStats();
    };

    updatePremiumStats();
})();
</script>

</body>
</html>