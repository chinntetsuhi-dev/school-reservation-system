<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ja">
<head>
    <meta charset="UTF-8">
    <title>学生ホーム</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style-premium.css?v=20261001b">

    <style>
        .student-page {
            max-width: 980px;
            margin: 0 auto;
            padding: 42px 28px;
        }

        .student-final-slot {
            margin-top: 12px;
            padding: 20px;
            border-radius: 20px;
            color: #581c87;
            background:
                linear-gradient(135deg, rgba(237,233,254,0.92), rgba(219,234,254,0.86));
            border: 1px solid rgba(196,181,253,0.72);
            font-size: 22px;
            font-weight: 900;
            box-shadow: 0 14px 32px rgba(88, 28, 135, 0.10);
        }
    </style>
</head>
<body>

<div class="student-page">
    <section class="ui-hero">
        <div>
            <p class="badge">STUDENT HOME</p>
            <h1 class="ui-hero-title">学生ホーム</h1>
            <p class="ui-hero-text">
                ログインに成功しました。<br>
                決定された三者面談の時間を確認できます。
            </p>
        </div>

        <img class="ui-hero-image"
             src="${pageContext.request.contextPath}/images/ui/schedule-hero-illustration.png"
             alt="学生ホームイメージ">
    </section>

    <div class="card top-space">
        <h2 class="card-title">決定された面談時間</h2>

        <c:if test="${not empty finalSlot}">
            <div class="student-final-slot">
                ${finalSlot}
            </div>
        </c:if>

        <c:if test="${empty finalSlot}">
            <div class="empty">
                まだ面談時間は決定されていません。
            </div>
        </c:if>
    </div>
</div>

</body>
</html>