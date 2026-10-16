<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="ja">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>ログイン</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style-premium.css?v=20261001b">

    <style>
        body {
            overflow: hidden;
        }

        .premium-login-page {
            position: relative;
            min-height: 100vh;
            display: grid;
            grid-template-columns: minmax(420px, 1fr) minmax(420px, 560px);
            align-items: center;
            gap: 56px;
            padding: 54px 7vw;
            color: #ffffff;
            background:
                radial-gradient(circle at 18% 16%, rgba(166, 103, 255, 0.34), transparent 30%),
                radial-gradient(circle at 78% 18%, rgba(33, 200, 255, 0.32), transparent 34%),
                linear-gradient(115deg, rgba(5, 20, 45, 0.92), rgba(12, 44, 92, 0.58)),
                url("${pageContext.request.contextPath}/images/ui/sakura-glass-bg.png");
            background-size: auto, auto, auto, cover;
            background-position: center;
            isolation: isolate;
        }

        .premium-login-page::before {
            content: "";
            position: absolute;
            inset: 0;
            z-index: -2;
            background:
                linear-gradient(90deg, rgba(4, 16, 43, 0.76), rgba(13, 49, 101, 0.36), rgba(255, 255, 255, 0.12)),
                radial-gradient(circle at 82% 80%, rgba(112, 241, 196, 0.15), transparent 28%);
        }

        .premium-login-page::after {
            content: "";
            position: absolute;
            right: 8%;
            bottom: 8%;
            width: 460px;
            height: 460px;
            border-radius: 999px;
            background: rgba(76, 190, 255, 0.18);
            filter: blur(62px);
            z-index: -1;
            pointer-events: none;
            animation: loginGlowMove 9s ease-in-out infinite;
        }

        @keyframes loginGlowMove {
            0%, 100% {
                transform: translate3d(0, 0, 0) scale(1);
            }
            50% {
                transform: translate3d(-30px, -18px, 0) scale(1.08);
            }
        }

        .login-showcase {
            position: relative;
            min-height: 540px;
            display: flex;
            flex-direction: column;
            justify-content: center;
            padding: 36px 0;
        }

        .login-system-label {
            display: inline-flex;
            align-items: center;
            width: fit-content;
            gap: 10px;
            margin-bottom: 24px;
            padding: 9px 15px;
            border-radius: 999px;
            color: rgba(225, 244, 255, 0.94);
            background: rgba(255, 255, 255, 0.13);
            border: 1px solid rgba(181, 225, 255, 0.38);
            box-shadow:
                inset 0 1px 0 rgba(255,255,255,0.22),
                0 14px 34px rgba(3, 13, 35, 0.20);
            backdrop-filter: blur(18px);
            -webkit-backdrop-filter: blur(18px);
            font-size: 13px;
            font-weight: 900;
            letter-spacing: 0.12em;
        }

        .login-system-label::before {
            content: "✿";
            color: #ffd6ef;
            text-shadow: 0 0 16px rgba(255, 145, 207, 0.80);
            font-size: 18px;
            letter-spacing: 0;
        }

        .login-showcase h1 {
            margin: 0;
            color: #ffffff;
            font-size: clamp(38px, 5vw, 66px);
            line-height: 1.08;
            font-weight: 950;
            letter-spacing: -0.07em;
            text-shadow:
                0 0 28px rgba(76, 190, 255, 0.24),
                0 8px 28px rgba(0, 0, 0, 0.28);
        }

        .login-showcase-sub {
            margin: 16px 0 0;
            color: rgba(222, 239, 255, 0.82);
            font-size: 13px;
            font-weight: 850;
            letter-spacing: 0.22em;
        }

        .login-copy {
            margin: 34px 0 0;
            color: rgba(245, 251, 255, 0.92);
            font-size: 23px;
            line-height: 1.75;
            font-weight: 850;
            text-shadow: 0 3px 18px rgba(0, 0, 0, 0.32);
        }

        .login-visual-orbit {
            position: absolute;
            right: 0;
            bottom: 0;
            width: min(480px, 54vw);
            height: min(320px, 34vw);
            opacity: 0.80;
            pointer-events: none;
        }

        .login-visual-orbit::before,
        .login-visual-orbit::after {
            content: "";
            position: absolute;
            border-radius: 34px;
            border: 1px solid rgba(181, 225, 255, 0.34);
            background: rgba(255, 255, 255, 0.10);
            box-shadow:
                0 0 38px rgba(76, 190, 255, 0.22),
                inset 0 1px 0 rgba(255,255,255,0.18);
            backdrop-filter: blur(16px);
            -webkit-backdrop-filter: blur(16px);
        }

        .login-visual-orbit::before {
            width: 220px;
            height: 150px;
            right: 80px;
            bottom: 32px;
            transform: rotate(-7deg);
        }

        .login-visual-orbit::after {
            width: 150px;
            height: 92px;
            right: 10px;
            bottom: 126px;
            transform: rotate(9deg);
        }

        .floating-chip {
            position: absolute;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            min-width: 96px;
            min-height: 44px;
            padding: 9px 14px;
            border-radius: 18px;
            color: #ffffff;
            background: linear-gradient(135deg, rgba(33, 200, 255, 0.50), rgba(166, 103, 255, 0.42));
            border: 1px solid rgba(224, 247, 255, 0.46);
            box-shadow: 0 0 26px rgba(76, 190, 255, 0.25);
            font-size: 13px;
            font-weight: 900;
            animation: chipFloat 7s ease-in-out infinite;
        }

        .floating-chip.chip-one {
            right: 238px;
            bottom: 206px;
        }

        .floating-chip.chip-two {
            right: 110px;
            bottom: 78px;
            animation-delay: -2s;
        }

        .floating-chip.chip-three {
            right: 0;
            bottom: 24px;
            animation-delay: -4s;
        }

        @keyframes chipFloat {
            0%, 100% {
                transform: translateY(0);
            }
            50% {
                transform: translateY(-12px);
            }
        }

        .login-panel {
            position: relative;
            width: 100%;
            max-width: 460px;
            justify-self: end;
            padding: 40px 38px 36px;
            border-radius: 34px;
            color: #ffffff;
            background:
                linear-gradient(135deg, rgba(255, 255, 255, 0.18), rgba(62, 127, 207, 0.20));
            border: 1px solid rgba(213, 239, 255, 0.45);
            box-shadow:
                0 32px 90px rgba(3, 13, 35, 0.42),
                inset 0 1px 0 rgba(255, 255, 255, 0.26);
            backdrop-filter: blur(30px) saturate(155%);
            -webkit-backdrop-filter: blur(30px) saturate(155%);
            overflow: hidden;
        }

        .login-panel::before {
            content: "";
            position: absolute;
            right: -80px;
            top: -80px;
            width: 230px;
            height: 230px;
            border-radius: 999px;
            background: radial-gradient(circle, rgba(255, 145, 207, 0.25), transparent 68%);
            pointer-events: none;
        }

        .login-panel::after {
            content: "";
            position: absolute;
            left: -70px;
            bottom: -70px;
            width: 220px;
            height: 220px;
            border-radius: 999px;
            background: radial-gradient(circle, rgba(53, 230, 255, 0.18), transparent 70%);
            pointer-events: none;
        }

        .login-flower {
            position: relative;
            width: 54px;
            height: 54px;
            margin: 0 auto 16px;
            display: flex;
            align-items: center;
            justify-content: center;
            border-radius: 999px;
            color: #ffe4f3;
            background: radial-gradient(circle, rgba(255, 145, 207, 0.46), rgba(69, 139, 255, 0.22));
            box-shadow: 0 0 32px rgba(255, 145, 207, 0.40);
            font-size: 28px;
            z-index: 1;
        }

        .login-panel h2 {
            position: relative;
            z-index: 1;
            margin: 0 0 8px;
            color: #ffffff;
            text-align: center;
            font-size: 30px;
            font-weight: 950;
            letter-spacing: -0.04em;
            text-shadow: 0 0 20px rgba(76, 190, 255, 0.22);
        }

        .login-panel-sub {
            position: relative;
            z-index: 1;
            margin: 0 0 28px;
            color: rgba(222, 239, 255, 0.78);
            text-align: center;
            line-height: 1.7;
            font-size: 13px;
            font-weight: 700;
        }

        .login-panel form {
            position: relative;
            z-index: 1;
        }

        .login-panel .form-group {
            margin-bottom: 16px;
        }

        .login-panel label {
            color: rgba(245, 251, 255, 0.92);
            font-size: 13px;
            font-weight: 850;
        }

        .login-panel input[type="text"],
        .login-panel input[type="password"] {
            max-width: none;
            height: 48px;
            color: #ffffff;
            background: rgba(4, 22, 52, 0.28);
            border: 1px solid rgba(181, 225, 255, 0.36);
            border-radius: 16px;
            box-shadow:
                inset 0 1px 0 rgba(255, 255, 255, 0.14),
                0 10px 24px rgba(3, 13, 35, 0.12);
        }

        .login-panel input::placeholder {
            color: rgba(222, 239, 255, 0.52);
        }

        .login-panel input:focus {
            border-color: rgba(126, 231, 255, 0.86);
            background: rgba(6, 28, 62, 0.38);
            box-shadow:
                0 0 0 4px rgba(53, 230, 255, 0.14),
                0 0 24px rgba(76, 190, 255, 0.18);
        }

        .login-button {
            width: 100%;
            height: 52px;
            margin-top: 8px;
            border-radius: 18px;
            background: linear-gradient(135deg, #21c8ff, #6468ff, #c175ff);
            box-shadow:
                0 0 28px rgba(95, 125, 255, 0.46),
                0 16px 32px rgba(3, 13, 35, 0.24),
                inset 0 1px 0 rgba(255, 255, 255, 0.34);
            font-size: 15px;
            letter-spacing: 0.08em;
        }

        .login-button::after {
            content: "→";
            margin-left: 12px;
            font-size: 18px;
        }

        .login-separator {
            position: relative;
            z-index: 1;
            display: flex;
            align-items: center;
            gap: 12px;
            margin: 26px 0 18px;
            color: rgba(222, 239, 255, 0.70);
            font-size: 12px;
            font-weight: 850;
        }

        .login-separator::before,
        .login-separator::after {
            content: "";
            height: 1px;
            flex: 1;
            background: rgba(181, 225, 255, 0.30);
        }

        .role-preview-row {
            position: relative;
            z-index: 1;
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 12px;
        }

        .role-preview {
            min-height: 78px;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            gap: 7px;
            border-radius: 18px;
            border: 1px solid rgba(224, 247, 255, 0.34);
            color: #ffffff;
            background: rgba(255, 255, 255, 0.12);
            box-shadow:
                inset 0 1px 0 rgba(255,255,255,0.18),
                0 10px 24px rgba(3, 13, 35, 0.16);
            font-size: 12px;
            font-weight: 900;
        }

        .role-preview span {
            font-size: 24px;
        }

        .role-preview.teacher {
            background: linear-gradient(135deg, rgba(33, 200, 255, 0.34), rgba(100, 104, 255, 0.26));
        }

        .role-preview.parent {
            background: linear-gradient(135deg, rgba(193, 117, 255, 0.34), rgba(255, 145, 207, 0.22));
        }

        .role-preview.student {
            background: linear-gradient(135deg, rgba(112, 241, 196, 0.28), rgba(33, 200, 255, 0.20));
        }

        .login-error {
            position: relative;
            z-index: 1;
            margin-top: 16px;
            padding: 12px 14px;
            border-radius: 15px;
            color: #ffe6ec;
            background: rgba(255, 111, 140, 0.22);
            border: 1px solid rgba(255, 173, 190, 0.55);
            font-weight: 850;
            font-size: 14px;
        }

        .login-help {
            position: relative;
            z-index: 1;
            margin-top: 20px;
            padding: 13px 14px;
            border-radius: 16px;
            color: rgba(222, 239, 255, 0.72);
            background: rgba(4, 22, 52, 0.18);
            border: 1px solid rgba(181, 225, 255, 0.20);
            font-size: 12px;
            line-height: 1.7;
        }

        .login-help p {
            margin: 3px 0;
        }

        @media (max-width: 1050px) {
            body {
                overflow: auto;
            }

            .premium-login-page {
                grid-template-columns: 1fr;
                gap: 28px;
                padding: 32px;
            }

            .login-showcase {
                min-height: auto;
                padding: 14px 0 0;
            }

            .login-visual-orbit {
                display: none;
            }

            .login-panel {
                justify-self: center;
            }
        }

        @media (max-width: 620px) {
            .premium-login-page {
                padding: 18px;
            }

            .login-panel {
                padding: 30px 22px;
                border-radius: 26px;
            }

            .role-preview-row {
                grid-template-columns: 1fr;
            }
        }


        /* Compact demo account hint: top-left, away from the login card */
        .login-help {
            position: absolute;
            top: 26px;
            left: 34px;
            z-index: 4;
            width: auto;
            max-width: 360px;
            margin: 0;
            padding: 10px 14px;
            display: flex;
            align-items: center;
            gap: 10px;
            border-radius: 999px;
            color: rgba(235, 248, 255, 0.88);
            background: rgba(5, 22, 52, 0.28);
            border: 1px solid rgba(181, 225, 255, 0.32);
            box-shadow:
                0 12px 30px rgba(3, 13, 35, 0.20),
                inset 0 1px 0 rgba(255, 255, 255, 0.18);
            backdrop-filter: blur(18px) saturate(145%);
            -webkit-backdrop-filter: blur(18px) saturate(145%);
            font-size: 11px;
            line-height: 1.5;
            letter-spacing: 0.02em;
        }

        .login-help::before {
            content: "ID";
            display: inline-flex;
            align-items: center;
            justify-content: center;
            min-width: 30px;
            height: 30px;
            border-radius: 999px;
            color: #ffffff;
            background: linear-gradient(135deg, rgba(33, 200, 255, 0.70), rgba(166, 103, 255, 0.64));
            box-shadow: 0 0 18px rgba(76, 190, 255, 0.34);
            font-size: 10px;
            font-weight: 950;
        }

        .login-help p {
            margin: 0;
            white-space: nowrap;
        }

        @media (max-width: 1050px) {
            .login-help {
                position: relative;
                top: auto;
                left: auto;
                margin: 0 0 4px;
                justify-self: center;
                flex-wrap: wrap;
                justify-content: center;
                border-radius: 18px;
            }

            .login-help p {
                white-space: normal;
            }
        }

    </style>
</head>

<body>

<div class="premium-login-page">
    <div class="login-help">
        <p>教員：T1 / 1234</p>
        <p>保護者：PA, PB / 1234</p>
        <p>生徒：S01 / 1234</p>
    </div>

    <section class="login-showcase">
        <div class="login-system-label">2026GroupB</div>

        <h1>
            学校面談予約システム
        </h1>

        <div class="login-showcase-sub">
            SCHOOL INTERVIEW SCHEDULING
        </div>

        <p class="login-copy">
            一人ひとりの対話が、<br>
            明日の学びにつながる。
        </p>

        <div class="login-visual-orbit">
            <div class="floating-chip chip-one">日程管理</div>
            <div class="floating-chip chip-two">チャット</div>
            <div class="floating-chip chip-three">確認</div>
        </div>
    </section>

    <section class="login-panel">
        <div class="login-flower">✿</div>

        <h2>ログイン</h2>
        <p class="login-panel-sub">
            アカウント情報を入力してください。
        </p>

        <form action="${pageContext.request.contextPath}/login" method="post">
            <div class="form-group">
                <label>ユーザーID</label>
                <input type="text"
                       name="loginId"
                       placeholder="例：T1 / PA / S01"
                       required>
            </div>

            <div class="form-group">
                <label>パスワード</label>
                <input type="password"
                       name="password"
                       required>
            </div>

            <button type="submit" class="login-button">
                ログイン
            </button>
        </form>

        <div class="login-separator">または</div>

        <div class="role-preview-row">
            <div class="role-preview teacher">
                <span>🎓</span>
                教員
            </div>
            <div class="role-preview parent">
                <span>👪</span>
                保護者
            </div>
            <div class="role-preview student">
                <span>👤</span>
                学生
            </div>
        </div>

        <c:if test="${not empty error}">
            <div class="login-error">
                <c:out value="${error}" />
            </div>
        </c:if>

    </section>
</div>

</body>
</html>
