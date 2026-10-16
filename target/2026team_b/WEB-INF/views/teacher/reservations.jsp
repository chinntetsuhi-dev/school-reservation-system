<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.example.interviewsystem.model.ParentRequest" %>
<%@ page import="com.example.interviewsystem.model.FinalPlan" %>
<%@ page import="com.example.interviewsystem.model.ReservationOption" %>
<!DOCTYPE html>
<html lang="ja">
<head>
    <meta charset="UTF-8">
    <title>予約管理</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style-premium.css?v=20261001b">

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
    

        /* =========================================================
           Premium Teacher Pages v3
           既存のform/action/name/JSTL/JavaScriptは変更せず、視覚だけを強化
           ========================================================= */
        .teacher-hero {
            margin-bottom: 28px !important;
        }

        .teacher-hero .badge {
            letter-spacing: 0.18em;
        }

        .teacher-glass-card {
            position: relative;
            overflow: hidden;
            border-radius: 30px !important;
            background:
                linear-gradient(145deg, rgba(12, 47, 97, 0.72), rgba(48, 105, 180, 0.24)),
                linear-gradient(180deg, rgba(255, 255, 255, 0.12), rgba(255, 255, 255, 0.04)) !important;
            border: 1px solid rgba(181, 225, 255, 0.38) !important;
            box-shadow:
                0 26px 72px rgba(2, 10, 31, 0.36),
                inset 0 1px 0 rgba(255, 255, 255, 0.22) !important;
            backdrop-filter: blur(28px) saturate(155%) !important;
            -webkit-backdrop-filter: blur(28px) saturate(155%) !important;
        }

        .teacher-glass-card::before {
            content: "";
            position: absolute;
            inset: 0;
            background:
                radial-gradient(circle at 88% 8%, rgba(85, 183, 255, 0.24), transparent 26%),
                radial-gradient(circle at 8% 86%, rgba(255, 145, 207, 0.13), transparent 30%);
            pointer-events: none;
        }

        .teacher-glass-card::after {
            content: "";
            position: absolute;
            right: -80px;
            top: -92px;
            width: 240px;
            height: 240px;
            border-radius: 999px;
            background: radial-gradient(circle, rgba(111, 231, 255, 0.22), transparent 64%);
            filter: blur(2px);
            pointer-events: none;
        }

        .teacher-glass-card > * {
            position: relative;
            z-index: 1;
        }

        .teacher-table-wrap {
            overflow-x: auto;
            border-radius: 24px;
            border: 1px solid rgba(181, 225, 255, 0.24);
            background: rgba(7, 24, 56, 0.26);
            box-shadow: inset 0 1px 0 rgba(255,255,255,0.12);
        }

        .teacher-table-wrap table,
        .teacher-glass-card table {
            border-radius: 24px !important;
            background: transparent !important;
            border: none !important;
            box-shadow: none !important;
            overflow: hidden;
        }

        .teacher-table-wrap th,
        .teacher-glass-card th {
            color: rgba(236, 248, 255, 0.96) !important;
            background:
                linear-gradient(180deg, rgba(76, 190, 255, 0.28), rgba(40, 89, 154, 0.28)) !important;
            border-color: rgba(181, 225, 255, 0.22) !important;
            font-weight: 900;
            letter-spacing: 0.03em;
        }

        .teacher-table-wrap td,
        .teacher-glass-card td {
            color: rgba(245, 251, 255, 0.92) !important;
            background: rgba(8, 31, 70, 0.26) !important;
            border-color: rgba(181, 225, 255, 0.16) !important;
        }

        .teacher-table-wrap tbody tr:hover td,
        .teacher-glass-card tbody tr:hover td {
            background: rgba(72, 157, 238, 0.22) !important;
        }

        .teacher-action-area,
        .actions-inline,
        .notice-actions {
            display: flex;
            gap: 10px;
            flex-wrap: wrap;
            align-items: center;
        }

        .teacher-action-area form,
        .actions-inline form,
        .notice-actions form {
            margin: 0;
        }

        .teacher-soft-note,
        .small-note {
            color: rgba(222, 239, 255, 0.78) !important;
            line-height: 1.8;
            font-weight: 700;
        }

        .teacher-list-card,
        .family-block,
        .submitted-request,
        .notice-item {
            border-radius: 24px !important;
            background:
                linear-gradient(135deg, rgba(255,255,255,0.14), rgba(70, 143, 225, 0.12)) !important;
            border: 1px solid rgba(181, 225, 255, 0.28) !important;
            box-shadow:
                0 16px 42px rgba(2, 10, 31, 0.22),
                inset 0 1px 0 rgba(255,255,255,0.14) !important;
            color: rgba(245, 251, 255, 0.92) !important;
        }

        .family-header {
            color: #ffffff !important;
            background:
                linear-gradient(135deg, rgba(33, 200, 255, 0.28), rgba(154, 116, 255, 0.28)) !important;
            border-bottom: 1px solid rgba(181, 225, 255, 0.24) !important;
            font-weight: 900;
        }

        .sibling-badge,
        .recommend-box {
            background: rgba(255, 194, 117, 0.16) !important;
            color: #ffe6bf !important;
            border: 1px solid rgba(255, 194, 117, 0.34) !important;
        }

        .request-form textarea,
        .request-form select,
        .teacher-form-grid textarea,
        .teacher-form-grid select,
        .teacher-form-grid input[type="text"] {
            max-width: none !important;
            background: rgba(255, 255, 255, 0.90) !important;
            color: #102033 !important;
        }

        .teacher-form-grid label,
        .request-form label {
            color: rgba(245, 251, 255, 0.92) !important;
            font-weight: 900;
        }

        .notice-btn,
        .notice-btn-edit,
        .notice-btn-toggle,
        .notice-btn-delete {
            border-radius: 14px !important;
            border: 1px solid rgba(224, 247, 255, 0.38) !important;
            box-shadow: 0 0 18px rgba(76, 190, 255, 0.20), inset 0 1px 0 rgba(255,255,255,0.20) !important;
        }

        .notice-btn-edit,
        .notice-btn-toggle {
            background: linear-gradient(135deg, rgba(85, 183, 255, 0.82), rgba(154, 116, 255, 0.78)) !important;
        }

        .notice-btn-delete,
        .btn-danger {
            background: linear-gradient(135deg, #ff6f8c, #ef4444) !important;
        }

        .empty {
            color: rgba(222, 239, 255, 0.78) !important;
            background: rgba(255, 255, 255, 0.08) !important;
            border: 1px dashed rgba(181, 225, 255, 0.34) !important;
        }

        .status {
            box-shadow: inset 0 1px 0 rgba(255,255,255,0.20);
        }

        .status-confirmed {
            color: #d7fff1 !important;
            background: rgba(112, 241, 196, 0.18) !important;
            border: 1px solid rgba(112, 241, 196, 0.34);
        }

        .status-submitted,
        .status-parent-confirming,
        .status-teacher-adjusting {
            color: #e5f8ff !important;
            background: rgba(85, 183, 255, 0.18) !important;
            border: 1px solid rgba(85, 183, 255, 0.34);
        }

        .status-resubmitted {
            color: #ffe2e9 !important;
            background: rgba(255, 111, 140, 0.18) !important;
            border: 1px solid rgba(255, 111, 140, 0.34);
        }

        .slot-available,
        .grid-slot.slot-available {
            background: rgba(85, 183, 255, 0.22) !important;
            color: #eaffff !important;
            box-shadow: inset 0 0 0 1px rgba(111, 231, 255, 0.42);
        }

        .slot-unavailable,
        .grid-slot.slot-unavailable {
            background: rgba(255, 255, 255, 0.08) !important;
            color: rgba(222, 239, 255, 0.48) !important;
        }

        .setting-slot:hover {
            filter: brightness(1.18);
        }

        @media (max-width: 900px) {
            .teacher-action-area,
            .actions-inline,
            .notice-actions {
                align-items: stretch;
                flex-direction: column;
            }

            .teacher-action-area > *,
            .actions-inline > *,
            .notice-actions > * {
                width: 100%;
            }
        }

    </style>

</head>
<body>
<div class="content">
    <h1 class="page-title">予約管理</h1>
    <p class="page-subtitle">先生が確定案を確認・管理するページです。</p>

    <%
        List<ParentRequest> requests = (List<ParentRequest>) request.getAttribute("parentRequests");
        List<FinalPlan> finalPlans = (List<FinalPlan>) request.getAttribute("finalPlans");
        List<ReservationOption> options = (List<ReservationOption>) request.getAttribute("reservationOptions");
    %>

    <div class="card teacher-glass-card teacher-premium-panel">
        <h2>確定案一覧</h2>

        <table class="table">
            <thead>
            <tr>
                <th>保護者</th>
                <th>お子様</th>
                <th>確定内容</th>
                <th>先生コメント</th>
                <th>状態</th>
                <th>操作</th>
            </tr>
            </thead>
            <tbody>
            <%
                if (finalPlans != null && !finalPlans.isEmpty()) {
                    for (FinalPlan plan : finalPlans) {
                        ParentRequest matchedRequest = null;
                        ReservationOption matchedOption = null;

                        if (requests != null) {
                            for (ParentRequest req : requests) {
                                if (req.getId().equals(plan.getParentRequestId())) {
                                    matchedRequest = req;
                                    break;
                                }
                            }
                        }

                        if (options != null) {
                            for (ReservationOption opt : options) {
                                if (opt.getId().equals(plan.getSelectedOptionId())) {
                                    matchedOption = opt;
                                    break;
                                }
                            }
                        }

                        String statusClass = "status-submitted";
                        if ("PARENT_CONFIRMING".equals(plan.getResponseStatus())) statusClass = "status-parent-confirming";
                        if ("CONFIRMED".equals(plan.getResponseStatus())) statusClass = "status-confirmed";
                        if ("RESUBMITTED".equals(plan.getResponseStatus())) statusClass = "status-resubmitted";
                        if ("CANCELLED".equals(plan.getResponseStatus())) statusClass = "status-resubmitted";
            %>
            <tr>
                <td><%= matchedRequest != null ? matchedRequest.getParentUsername() : "" %></td>
                <td><%= matchedRequest != null ? matchedRequest.getChildName() : "" %></td>
                <td>
                    <%= matchedOption != null ? matchedOption.getFacilityName() : "" %> /
                    <%= matchedOption != null ? matchedOption.getDate() : "" %> /
                    <%= matchedOption != null ? matchedOption.getTime() : "" %>
                </td>
                <td><%= plan.getTeacherComment() != null ? plan.getTeacherComment() : "" %></td>
                <td>
                    <span class="status <%= statusClass %>"><%= plan.getResponseStatusLabel() %></span>
                </td>
                <td>
                    <form action="${pageContext.request.contextPath}/teacher/cancel-reservation" method="post" style="display:inline;">
                        <input type="hidden" name="requestId" value="<%= plan.getParentRequestId() %>">
                        <button type="submit" class="btn-secondary">予約を取消</button>
                    </form>
                </td>
            </tr>
            <%
                    }
                } else {
            %>
            <tr>
                <td colspan="6">現在、確定案はありません。</td>
            </tr>
            <%
                }
            %>
            </tbody>
        </table>
        </div>
    </div>
</div>

<div class="sidebar">
    <h2>メニュー</h2>
    <a class="active"
       href="${pageContext.request.contextPath}/teacher/home">
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

    <a href="${pageContext.request.contextPath}/chat/rooms">
        チャット
    </a>

    <a href="${pageContext.request.contextPath}/account">
        アカウント
    </a>
</div>
</body>
</html>