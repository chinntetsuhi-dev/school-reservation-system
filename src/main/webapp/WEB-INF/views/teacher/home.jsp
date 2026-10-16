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

    <title>教員ホーム</title>

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

        .notice-card-header {
            position: relative;
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 18px;
            margin-bottom: 22px;
        }

        .notice-card-header h2 {
            margin: 0;
        }

        .notice-create-button {
            position: relative;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            min-width: 138px;
            padding: 13px 20px;
            border-radius: 18px;
            color: #ffffff !important;
            text-decoration: none;
            font-size: 15px;
            font-weight: 900;
            letter-spacing: 0.03em;
            background: linear-gradient(135deg, #21c8ff, #6468ff, #a667ff);
            border: 1px solid rgba(224, 247, 255, 0.56);
            box-shadow:
                0 0 24px rgba(95, 125, 255, 0.42),
                0 16px 34px rgba(3, 13, 35, 0.22),
                inset 0 1px 0 rgba(255, 255, 255, 0.32);
            transition:
                transform 0.18s ease,
                box-shadow 0.18s ease,
                background 0.18s ease;
        }

        .notice-create-button::before {
            content: "+";
            display: inline-flex;
            align-items: center;
            justify-content: center;
            width: 24px;
            height: 24px;
            border-radius: 999px;
            background: rgba(255, 255, 255, 0.20);
            box-shadow: inset 0 1px 0 rgba(255,255,255,0.26);
            font-size: 18px;
            line-height: 1;
        }

        .notice-create-button:hover {
            transform: translateY(-2px);
            background: linear-gradient(135deg, #25d8ff, #7b61ff, #c175ff);
            box-shadow:
                0 0 34px rgba(107, 128, 255, 0.62),
                0 20px 42px rgba(3, 13, 35, 0.28);
        }

        @media (max-width: 760px) {
            .notice-card-header {
                align-items: flex-start;
                flex-direction: column;
            }
        }
    </style>

</head>
<body>

<div class="content wide-content">

    <section class="ui-hero teacher-hero">
        <div>
            <p class="badge">TEACHER HOME</p>
            <h1 class="ui-hero-title">ホーム</h1>
            <p class="ui-hero-text">
                お知らせの一覧を確認できます。<br>保護者・児童に表示する連絡を管理します。
            </p>
        </div>

        <img class="ui-hero-image"
             src="${pageContext.request.contextPath}/images/ui/schedule-hero-illustration.png"
             alt="ホームイメージ">
    </section>

    <div class="card teacher-glass-card">

        <div class="notice-card-header">
            <h2>お知らせ一覧</h2>

            <a class="notice-create-button"
               href="${pageContext.request.contextPath}/teacher/notices/form">
                新規作成
            </a>
        </div>

        <div class="table-scroll">

            <table class="table">

                <thead>
                <tr>
                    <th>タイトル</th>
                    <th>本文</th>
                    <th>公開対象</th>
                    <th>状態</th>
                    <th>操作</th>
                </tr>
                </thead>

                <tbody>

                <c:forEach var="notice"
                           items="${notices}">

                    <tr>
                        <td>${notice.title}</td>
                        <td>${notice.content}</td>
                        <td>${notice.targetRoleLabel}</td>

                        <td>
                            <span class="status status-confirmed">
                                ${notice.statusLabel}
                            </span>
                        </td>

                        <td>
                            <div class="notice-actions">

                                <form action="${pageContext.request.contextPath}/teacher/notices/form"
                                      method="get">

                                    <input type="hidden"
                                           name="id"
                                           value="${notice.id}">

                                    <button type="submit"
                                            class="notice-btn notice-btn-edit">

                                        編集
                                    </button>
                                </form>

                                <form action="${pageContext.request.contextPath}/teacher/notices/toggle"
                                      method="post">

                                    <input type="hidden"
                                           name="id"
                                           value="${notice.id}">

                                    <button type="submit"
                                            class="notice-btn notice-btn-toggle">

                                        公開切替
                                    </button>
                                </form>

                                <form action="${pageContext.request.contextPath}/teacher/notices/delete"
                                      method="post">

                                    <input type="hidden"
                                           name="id"
                                           value="${notice.id}">

                                    <button type="submit"
                                            class="notice-btn notice-btn-delete">

                                        削除
                                    </button>
                                </form>
                            </div>
                        </td>
                    </tr>
                </c:forEach>

                <c:if test="${empty notices}">
                    <tr>
                        <td colspan="5">
                            現在、お知らせはありません。
                        </td>
                    </tr>
                </c:if>

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