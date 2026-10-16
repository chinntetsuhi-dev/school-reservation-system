<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%@ page import="java.util.List" %>

<%@ page import="com.example.interviewsystem.model.ParentRequest" %>

<%@ page import="com.example.interviewsystem.model.FinalPlan" %>

<%@ page import="com.example.interviewsystem.model.ReservationOption" %>

<!DOCTYPE html>

<html lang="ja">

<head>

    <meta charset="UTF-8">

    <title>状態確認</title>

    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style-premium.css?v=20261001b">



    <style>

        .student-status-hero {

            margin-bottom: 24px;

        }



        .status-request-list {

            display: grid;

            gap: 18px;

        }



        .status-request-card {

            position: relative;

            padding: 22px;

            border-radius: 24px;

            background: rgba(255, 255, 255, 0.70);

            border: 1px solid rgba(255, 255, 255, 0.75);

            box-shadow: 0 14px 32px rgba(45, 80, 130, 0.10);

            overflow: hidden;

        }



        .status-request-card::after {

            content: "";

            position: absolute;

            right: -50px;

            top: -56px;

            width: 150px;

            height: 150px;

            border-radius: 999px;

            background: radial-gradient(circle, rgba(56, 189, 248, 0.18), transparent 68%);

            pointer-events: none;

        }



        .status-request-card h3,

        .status-request-card p,

        .status-request-card div {

            position: relative;

        }



        .status-request-card h3 {

            margin: 0 0 14px;

            color: #0f172a;

            font-size: 21px;

            font-weight: 900;

            letter-spacing: -0.03em;

        }



        .option-badge-area {

            display: flex;

            flex-wrap: wrap;

            gap: 6px;

            margin-top: 8px;

        }



        .teacher-choice-box {

            margin-top: 14px;

            padding: 14px 16px;

            border-radius: 18px;

            color: #1e3a8a;

            background: rgba(219, 234, 254, 0.84);

            border: 1px solid rgba(147, 197, 253, 0.72);

            line-height: 1.8;

        }



        .confirmed-notice-box {

            margin-top: 12px;

            padding: 14px 16px;

            border-radius: 18px;

            color: #166534;

            background: rgba(220, 252, 231, 0.86);

            border: 1px solid rgba(134, 239, 172, 0.72);

            line-height: 1.8;

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





        /* Premium student pages */

        .room-name-text,

        .facility-name-text,

        .student-notice-card h3,

        .status-request-card h3,

        .status-request-card strong,

        .teacher-choice-box strong,

        .confirmed-notice-box strong {

            color: #ffffff !important;

        }



        .student-chat-note,

        .facility-note,

        .student-notice-card p,

        .status-request-card p,

        .status-request-card div,

        .teacher-choice-box,

        .confirmed-notice-box {

            color: rgba(222, 239, 255, 0.78) !important;

        }



        .student-notice-card,

        .status-request-card,

        .teacher-choice-box,

        .confirmed-notice-box {

            background: linear-gradient(135deg, rgba(255,255,255,0.13), rgba(62,127,207,0.14)) !important;

            border: 1px solid rgba(181,225,255,0.30) !important;

            box-shadow: 0 18px 45px rgba(3,13,35,0.24), inset 0 1px 0 rgba(255,255,255,0.18) !important;

        }



        .chat-table td,

        .facility-table td {

            color: rgba(244, 251, 255, 0.92) !important;

        }



        .chat-table th,

        .facility-table th {

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

    <section class="ui-hero student-status-hero">

        <div>

            <p class="badge">STATUS</p>

            <h1 class="ui-hero-title">状態確認</h1>

            <p class="ui-hero-text">

                現在の予約進行状態を確認できます。<br>

                希望内容、確定状況、先生が選択した候補を表示します。

            </p>

        </div>



        <img class="ui-hero-image"

             src="${pageContext.request.contextPath}/images/ui/schedule-hero-illustration.png"

             alt="状態確認イメージ">

    </section>



    <%

        List<ParentRequest> requests = (List<ParentRequest>) request.getAttribute("parentRequests");

        List<ReservationOption> options = (List<ReservationOption>) request.getAttribute("reservationOptions");

        List<FinalPlan> finalPlans = (List<FinalPlan>) request.getAttribute("finalPlans");

    %>



    <div class="card">

        <h2 class="card-title">予約進行状態</h2>



        <div class="status-request-list">

            <%

                if (requests != null && !requests.isEmpty()) {

                    for (ParentRequest req : requests) {

            %>



            <div class="status-request-card">

                <h3>お子様：<%= req.getChildName() %></h3>



                <%

                    String rawStatus = req.getRequestStatus();

                    String statusText = req.getRequestStatusLabel();

                    String statusClass = "status-submitted";



                    if ("TEACHER_ADJUSTING".equals(rawStatus)) {

                        statusClass = "status-teacher-adjusting";

                    } else if ("PARENT_CONFIRMING".equals(rawStatus)) {

                        statusClass = "status-parent-confirming";

                    } else if ("CONFIRMED".equals(rawStatus)) {

                        statusClass = "status-confirmed";

                    } else if ("RESUBMITTED".equals(rawStatus)) {

                        statusClass = "status-resubmitted";

                    } else if ("CANCELLED".equals(rawStatus)) {

                        statusClass = "status-resubmitted";

                    }

                %>



                <p>

                    現在の状態：

                    <span class="status <%= statusClass %>">

                        <%= statusText %>

                    </span>

                </p>



                <% if ("CONFIRMED".equals(rawStatus)) { %>

                <div class="confirmed-notice-box">

                    <strong>通知</strong><br>

                    この予約は確定済みです。生徒側での操作はできません。

                </div>

                <% } %>



                <p><strong>希望内容</strong></p>

                <div class="option-badge-area">
                    <span class="muted">
                        希望日時は保護者画面で提出された内容をもとに管理されています。
                    </span>
                </div>



                <%

                    if (finalPlans != null) {

                        for (FinalPlan plan : finalPlans) {

                            if (plan.getParentRequestId().equals(req.getId())) {

                                ReservationOption matchedOption = null;

                                if (options != null) {
                                    for (ReservationOption opt : options) {
                                        if (opt.getId().equals(plan.getSelectedOptionId())) {
                                            matchedOption = opt;
                                            break;
                                        }
                                    }
                                }

                %>



                <div class="teacher-choice-box">

                    <strong>先生が選択した候補</strong><br>

                    <%= matchedOption != null ? matchedOption.getFacilityName() : "" %> /

                    <%= matchedOption != null ? matchedOption.getDate() : "" %> /

                    <%= matchedOption != null ? matchedOption.getTime() : "" %>

                </div>



                <%

                            }

                        }

                    }

                %>

            </div>



            <%

                    }

                } else {

            %>



            <div class="empty">現在確認できる予約情報はありません。</div>



            <%

                }

            %>

        </div>

    </div>

</div>



<div class="sidebar">

    <h2>メニュー</h2>

    <a href="${pageContext.request.contextPath}/student/home">ホーム</a>

    <a class="active" href="${pageContext.request.contextPath}/student/status">状態確認</a>

    <a href="${pageContext.request.contextPath}/account">アカウント</a>

</div>

</body>

</html>