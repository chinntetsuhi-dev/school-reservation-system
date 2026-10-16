<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="ja">
<head>
    <meta charset="UTF-8">
    <title>施設選択</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style-premium.css?v=20261001b">

    <style>
        .facility-content {
            margin-right: 0;
            max-width: 980px;
            margin-left: auto;
            margin-right: auto;
            padding: 44px 28px;
        }

        .facility-option-list {
            display: grid;
            gap: 10px;
            margin-top: 14px;
        }

        .facility-option {
            display: flex;
            align-items: center;
            gap: 10px;
            padding: 14px 16px;
            border-radius: 18px;
            background: rgba(255, 255, 255, 0.70);
            border: 1px solid rgba(203, 213, 225, 0.72);
            box-shadow: 0 8px 18px rgba(45, 80, 130, 0.08);
            cursor: pointer;
            transition: transform 0.18s ease, box-shadow 0.18s ease, background 0.18s ease;
        }

        .facility-option:hover {
            transform: translateY(-2px);
            background: rgba(239, 246, 255, 0.88);
            box-shadow: 0 16px 30px rgba(45, 80, 130, 0.12);
        }

        .facility-option input {
            width: auto;
        }

        .facility-submit-row {
            margin-top: 20px;
        }

        .facility-submit-row input[type="submit"] {
            display: inline-block;
            padding: 11px 18px;
            border: none;
            border-radius: 14px;
            background: linear-gradient(135deg, #38bdf8, #6366f1);
            color: white;
            font-size: 14px;
            font-weight: 800;
            cursor: pointer;
            box-shadow: 0 12px 24px rgba(37, 99, 235, 0.20);
        }
    </style>
</head>
<body>

<div class="content facility-content">
    <section class="ui-hero">
        <div>
            <p class="badge">FACILITY</p>
            <h1 class="ui-hero-title">施設選択（保護者）</h1>
            <p class="ui-hero-text">
                利用可能な施設・時間を選択し、必要に応じて備考を入力してください。
            </p>
        </div>

        <img class="ui-hero-image"
             src="${pageContext.request.contextPath}/images/ui/schedule-hero-illustration.png"
             alt="施設選択イメージ">
    </section>

    <div class="card top-space">
        <form action="/submit-request" method="post">
            <div class="form-row">
                <label>お子様の名前：</label>
                <input type="text" name="childName"/>
            </div>

            <h3 class="card-title">利用可能な施設・時間</h3>

            <div class="facility-option-list">
                <c:forEach var="opt" items="${options}">
                    <label class="facility-option">
                        <input type="checkbox" name="selectedOptions"
                               value="${opt.facilityName} ${opt.date} ${opt.time}"/>
                        <span>
                            ${opt.facilityName} / ${opt.date} / ${opt.time}
                        </span>
                    </label>
                </c:forEach>
            </div>

            <div class="form-row top-space">
                <label>備考：</label>
                <textarea name="note"></textarea>
            </div>

            <div class="facility-submit-row">
                <input type="submit" value="送信"/>
            </div>
        </form>
    </div>
</div>

</body>
</html>