<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="ja">
<head>
    <meta charset="UTF-8">
    <title>アカウント情報</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style-premium.css?v=20261001b">

    <style>
        .account-hero {
            margin-bottom: 24px;
        }

        .account-layout {
            display: grid;
            grid-template-columns: minmax(0, 1.05fr) minmax(320px, 0.95fr);
            gap: 22px;
        }

        .account-profile-head {
            display: flex;
            align-items: center;
            gap: 18px;
            margin-bottom: 20px;
        }

        .account-avatar {
            width: 74px;
            height: 74px;
            border-radius: 26px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #ffffff;
            font-size: 30px;
            font-weight: 900;
            background: linear-gradient(135deg, #38bdf8, #6366f1);
            box-shadow: 0 20px 44px rgba(37, 99, 235, 0.24);
        }

        .account-main-name {
            margin: 0 0 6px;
            font-size: 28px;
            font-weight: 900;
            color: #0f172a;
            letter-spacing: -0.04em;
        }

        .account-main-role {
            color: #64748b;
            font-weight: 800;
        }

        .account-table th {
            width: 170px;
            white-space: nowrap;
        }

        .account-side-card {
            min-height: 100%;
        }

        .account-logout-card {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 16px;
        }

        .account-logout-card p {
            margin: 0;
            color: #64748b;
            line-height: 1.7;
        }

        @media (max-width: 1000px) {
            .account-layout {
                grid-template-columns: 1fr;
            }

            .account-logout-card {
                align-items: flex-start;
                flex-direction: column;
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


        /* Premium root pages */
        .account-main-name,
        .account-table th,
        .account-table td,
        .login-panel h2,
        .login-brand h1 {
            color: #ffffff !important;
        }

        .account-main-role,
        .account-logout-card p,
        .login-panel-sub,
        .login-help,
        .login-help p,
        .login-brand p {
            color: rgba(222, 239, 255, 0.78) !important;
        }

        .account-avatar {
            background: linear-gradient(135deg, #21c8ff, #6468ff, #ff91cf) !important;
            box-shadow: 0 0 34px rgba(76, 190, 255, 0.42) !important;
        }

        .login-shell {
            background:
                radial-gradient(circle at 18% 16%, rgba(255, 145, 207, 0.22), transparent 30%),
                radial-gradient(circle at 78% 20%, rgba(53, 230, 255, 0.20), transparent 34%),
                linear-gradient(115deg, rgba(5, 20, 45, 0.84), rgba(12, 45, 90, 0.64)),
                url("${pageContext.request.contextPath}/images/ui/sakura-glass-bg.png") !important;
            background-size: auto, auto, auto, cover !important;
            background-position: center !important;
        }

        .login-brand,
        .login-panel {
            background: linear-gradient(135deg, rgba(255,255,255,0.16), rgba(62,127,207,0.16)) !important;
            border: 1px solid rgba(181,225,255,0.34) !important;
            box-shadow: 0 24px 70px rgba(3,13,35,0.38), inset 0 1px 0 rgba(255,255,255,0.22) !important;
            backdrop-filter: blur(26px) saturate(150%) !important;
            -webkit-backdrop-filter: blur(26px) saturate(150%) !important;
        }

        .login-brand-kicker {
            color: #e7fbff !important;
            background: rgba(46, 173, 255, 0.24) !important;
            border: 1px solid rgba(163, 230, 255, 0.42);
        }

        .login-hero-image {
            opacity: 0.82;
            filter: saturate(118%) brightness(1.05) drop-shadow(0 22px 34px rgba(56,189,248,0.28));
            -webkit-mask-image: radial-gradient(ellipse at center, #000 0%, #000 48%, rgba(0,0,0,0.45) 72%, transparent 100%);
            mask-image: radial-gradient(ellipse at center, #000 0%, #000 48%, rgba(0,0,0,0.45) 72%, transparent 100%);
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
    <section class="ui-hero account-hero">
        <div>
            <p class="badge">ACCOUNT</p>
            <h1 class="ui-hero-title">アカウント情報</h1>
            <p class="ui-hero-text">
                現在ログインしているユーザー情報を表示します。<br>
                利用者種別や関連情報を確認できます。
            </p>
        </div>

        <img class="ui-hero-image"
             src="${pageContext.request.contextPath}/images/ui/schedule-hero-illustration.png"
             alt="アカウント情報イメージ">
    </section>

    <div class="account-layout">
        <div class="card">
            <div class="account-profile-head">
                <div class="account-avatar">
                    <c:choose>
                        <c:when test="${sessionScope.loginRole == 'TEACHER'}">T</c:when>
                        <c:when test="${sessionScope.loginRole == 'PARENT'}">P</c:when>
                        <c:when test="${sessionScope.loginRole == 'STUDENT'}">S</c:when>
                        <c:otherwise>U</c:otherwise>
                    </c:choose>
                </div>

                <div>
                    <h2 class="account-main-name">${user.displayName}</h2>
                    <div class="account-main-role">
                        ${user.roleLabel}（${user.role}）
                    </div>
                </div>
            </div>

            <h2 class="card-title">ログイン情報</h2>

            <table class="table account-table">
                <tr>
                    <th>ユーザーID</th>
                    <td>${user.loginId}</td>
                </tr>
                <tr>
                    <th>表示名</th>
                    <td>${user.displayName}</td>
                </tr>
                <tr>
                    <th>権限</th>
                    <td>${user.roleLabel}（${user.role}）</td>
                </tr>
                <c:if test="${not empty user.className}">
                    <tr>
                        <th>クラス</th>
                        <td>${user.className}</td>
                    </tr>
                </c:if>
                <tr>
                    <th>ログイン状態</th>
                    <td>
                        <span class="status status-confirmed">ログイン中</span>
                    </td>
                </tr>
            </table>
        </div>

        <div>
            <c:if test="${sessionScope.loginRole == 'PARENT'}">
                <div class="card account-side-card">
                    <h2 class="card-title">子ども情報</h2>

                    <table class="table">
                        <thead>
                        <tr>
                            <th>生徒ID</th>
                            <th>生徒名</th>
                            <th>クラス</th>
                            <th>兄弟情報</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:forEach var="child" items="${children}">
                            <tr>
                                <td>${child.childLoginId}</td>
                                <td>${child.childName}</td>
                                <td>${child.className}</td>
                                <td>
                                    <c:choose>
                                        <c:when test="${child.hasSibling}">
                                            <span class="status status-resubmitted">兄弟あり</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="status status-confirmed">兄弟なし</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                            </tr>
                        </c:forEach>
                        </tbody>
                    </table>
                </div>
            </c:if>

            <c:if test="${sessionScope.loginRole == 'STUDENT'}">
                <div class="card account-side-card">
                    <h2 class="card-title">保護者情報</h2>

                    <table class="table">
                        <tr>
                            <th>保護者ID</th>
                            <td>${parent.loginId}</td>
                        </tr>
                        <tr>
                            <th>保護者名</th>
                            <td>${parent.displayName}</td>
                        </tr>
                    </table>
                </div>
            </c:if>

            <div class="card account-logout-card">
                <div>
                    <h2 class="card-title">ログアウト</h2>
                    <p>
                        作業を終了する場合は、ログアウトしてください。
                    </p>
                </div>

                <form action="${pageContext.request.contextPath}/logout" method="get">
                    <button type="submit" class="btn-secondary">ログアウト</button>
                </form>
            </div>
        </div>
    </div>
</div>

<div class="sidebar">
    <h2>メニュー</h2>

    <c:if test="${sessionScope.loginRole == 'TEACHER'}">
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

        <a href="${pageContext.request.contextPath}/teacher/schedule">
            日程確認
        </a>

        <a href="${pageContext.request.contextPath}/chat/rooms">
            チャット
        </a>

        <a class="active" href="${pageContext.request.contextPath}/account">
            アカウント
        </a>
    </c:if>

    <c:if test="${sessionScope.loginRole == 'PARENT'}">
        <a href="${pageContext.request.contextPath}/parent/home">ホーム</a>
        <a href="${pageContext.request.contextPath}/parent/schedule">日程確認</a>
        <a href="${pageContext.request.contextPath}/parent/reservation">面談希望提出</a>
        <a href="${pageContext.request.contextPath}/chat/rooms">チャット</a>
        <a class="active" href="${pageContext.request.contextPath}/account">アカウント</a>
    </c:if>

    <c:if test="${sessionScope.loginRole == 'STUDENT'}">
        <a href="${pageContext.request.contextPath}/student/home">ホーム</a>
        <a href="${pageContext.request.contextPath}/student/status">予約状況</a>
        <a class="active" href="${pageContext.request.contextPath}/account">アカウント</a>
    </c:if>
</div>

</body>
</html>