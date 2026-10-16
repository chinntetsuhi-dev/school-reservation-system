USE 2026team_b;

SET FOREIGN_KEY_CHECKS = 0;

DROP TABLE IF EXISTS chat_messages;
DROP TABLE IF EXISTS chat_rooms;
DROP TABLE IF EXISTS final_plans;
DROP TABLE IF EXISTS parent_request_options;
DROP TABLE IF EXISTS parent_requests;
DROP TABLE IF EXISTS notices;
DROP TABLE IF EXISTS reservation_options;
DROP TABLE IF EXISTS parent_children;
DROP TABLE IF EXISTS users;

SET FOREIGN_KEY_CHECKS = 1;

CREATE TABLE users (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    login_id VARCHAR(20) NOT NULL UNIQUE,
    password VARCHAR(100) NOT NULL,
    role VARCHAR(20) NOT NULL,
    display_name VARCHAR(100) NOT NULL,
    class_name VARCHAR(50)
);

CREATE TABLE parent_children (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    parent_user_id BIGINT NOT NULL,
    child_user_id BIGINT NOT NULL,
    sibling_group VARCHAR(50),
    has_sibling_flag TINYINT(1) NOT NULL DEFAULT 0,

    FOREIGN KEY (parent_user_id)
        REFERENCES users(id),

    FOREIGN KEY (child_user_id)
        REFERENCES users(id)
);

CREATE TABLE reservation_options (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    option_date DATE NOT NULL,
    option_time VARCHAR(50) NOT NULL,
    available_flag TINYINT(1) NOT NULL DEFAULT 1,

    UNIQUE KEY uk_reservation_option (
        option_date,
        option_time
    )
);

CREATE TABLE parent_requests (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    parent_user_id BIGINT NOT NULL,
    child_user_id BIGINT,
    child_name VARCHAR(100) NOT NULL,
    comment TEXT,
    request_status VARCHAR(30)
        NOT NULL DEFAULT 'SUBMITTED',
    created_at TIMESTAMP
        DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (parent_user_id)
        REFERENCES users(id),

    FOREIGN KEY (child_user_id)
        REFERENCES users(id)
);

CREATE TABLE parent_request_options (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    parent_request_id BIGINT NOT NULL,
    reservation_option_id BIGINT NOT NULL,
    priority INT NOT NULL,

    FOREIGN KEY (parent_request_id)
        REFERENCES parent_requests(id),

    FOREIGN KEY (reservation_option_id)
        REFERENCES reservation_options(id)
);

CREATE TABLE final_plans (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    parent_request_id BIGINT NOT NULL,
    selected_option_id BIGINT NOT NULL,
    teacher_comment TEXT,
    response_status VARCHAR(30)
        NOT NULL DEFAULT 'PARENT_CONFIRMING',

    FOREIGN KEY (parent_request_id)
        REFERENCES parent_requests(id),

    FOREIGN KEY (selected_option_id)
        REFERENCES reservation_options(id)
);

CREATE TABLE notices (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(200) NOT NULL,
    content TEXT NOT NULL,
    active_flag TINYINT(1) NOT NULL DEFAULT 1,
    target_role VARCHAR(30) NOT NULL DEFAULT 'ALL'
);

CREATE TABLE chat_rooms (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    room_name VARCHAR(100) NOT NULL,
    teacher_user_id BIGINT NOT NULL,
    parent_user_id BIGINT NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'OPEN',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (teacher_user_id)
        REFERENCES users(id),

    FOREIGN KEY (parent_user_id)
        REFERENCES users(id)
);

CREATE TABLE chat_messages (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    room_id BIGINT NOT NULL,
    sender_user_id BIGINT NOT NULL,
    message TEXT NOT NULL,
    sent_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (room_id)
        REFERENCES chat_rooms(id),

    FOREIGN KEY (sender_user_id)
        REFERENCES users(id)
);

INSERT INTO users
(login_id, password, role, display_name, class_name)
VALUES
('T1', '1234', 'TEACHER', 'XX先生', '1年A組'),

('PA', '1234', 'PARENT', 'PA保護者', NULL),
('PB', '1234', 'PARENT', 'PB保護者', NULL),
('PC', '1234', 'PARENT', 'PC保護者', NULL),
('PD', '1234', 'PARENT', 'PD保護者', NULL),
('PE', '1234', 'PARENT', 'PE保護者', NULL),
('PF', '1234', 'PARENT', 'PF保護者', NULL),
('PG', '1234', 'PARENT', 'PG保護者', NULL),
('PH', '1234', 'PARENT', 'PH保護者', NULL),
('PI', '1234', 'PARENT', 'PI保護者', NULL),
('PJ', '1234', 'PARENT', 'PJ保護者', NULL),
('PK', '1234', 'PARENT', 'PK保護者', NULL),
('PL', '1234', 'PARENT', 'PL保護者', NULL),
('PM', '1234', 'PARENT', 'PM保護者', NULL),
('PN', '1234', 'PARENT', 'PN保護者', NULL),
('PO', '1234', 'PARENT', 'PO保護者', NULL),
('PP', '1234', 'PARENT', 'PP保護者', NULL),
('PQ', '1234', 'PARENT', 'PQ保護者', NULL),
('PR', '1234', 'PARENT', 'PR保護者', NULL),
('PS', '1234', 'PARENT', 'PS保護者', NULL),
('PT', '1234', 'PARENT', 'PT保護者', NULL),
('PU', '1234', 'PARENT', 'PU保護者', NULL),
('PV', '1234', 'PARENT', 'PV保護者', NULL),
('PW', '1234', 'PARENT', 'PW保護者', NULL),
('PX', '1234', 'PARENT', 'PX保護者', NULL),
('PY', '1234', 'PARENT', 'PY保護者', NULL),
('PZ', '1234', 'PARENT', 'PZ保護者', NULL),

('S01', '1234', 'STUDENT', 'XX生徒01', '1年A組'),
('S02', '1234', 'STUDENT', 'XX生徒02', '1年A組'),
('S03', '1234', 'STUDENT', 'XX生徒03', '1年A組'),
('S04', '1234', 'STUDENT', 'XX生徒04', '1年A組'),
('S05', '1234', 'STUDENT', 'XX生徒05', '1年A組'),
('S06', '1234', 'STUDENT', 'XX生徒06', '1年A組'),
('S07', '1234', 'STUDENT', 'XX生徒07', '1年A組'),
('S08', '1234', 'STUDENT', 'XX生徒08', '1年A組'),
('S09', '1234', 'STUDENT', 'XX生徒09', '1年A組'),
('S10', '1234', 'STUDENT', 'XX生徒10', '1年A組'),
('S11', '1234', 'STUDENT', 'XX生徒11', '1年A組'),
('S12', '1234', 'STUDENT', 'XX生徒12', '1年A組'),
('S13', '1234', 'STUDENT', 'XX生徒13', '1年A組'),
('S14', '1234', 'STUDENT', 'XX生徒14', '1年A組'),
('S15', '1234', 'STUDENT', 'XX生徒15', '1年A組'),
('S16', '1234', 'STUDENT', 'XX生徒16', '1年A組'),
('S17', '1234', 'STUDENT', 'XX生徒17', '1年A組'),
('S18', '1234', 'STUDENT', 'XX生徒18', '1年A組'),
('S19', '1234', 'STUDENT', 'XX生徒19', '1年A組'),
('S20', '1234', 'STUDENT', 'XX生徒20', '1年A組'),
('S21', '1234', 'STUDENT', 'XX生徒21', '1年A組'),
('S22', '1234', 'STUDENT', 'XX生徒22', '1年A組'),
('S23', '1234', 'STUDENT', 'XX生徒23', '1年A組'),
('S24', '1234', 'STUDENT', 'XX生徒24', '1年A組'),
('S25', '1234', 'STUDENT', 'XX生徒25', '1年A組'),
('S26', '1234', 'STUDENT', 'XX生徒26', '1年A組'),
('S27', '1234', 'STUDENT', 'XX生徒27', '1年A組'),
('S28', '1234', 'STUDENT', 'XX生徒28', '1年A組'),
('S29', '1234', 'STUDENT', 'XX生徒29', '1年A組'),
('S30', '1234', 'STUDENT', 'XX生徒30', '1年A組'),
('S31', '1234', 'STUDENT', 'XX生徒31', '1年A組'),
('S32', '1234', 'STUDENT', 'XX生徒32', '1年A組');

INSERT INTO parent_children
(parent_user_id, child_user_id, sibling_group, has_sibling_flag)
VALUES
(2, 28, NULL, 0),
(3, 29, NULL, 0),
(4, 30, 'PC_FAMILY', 1),
(4, 31, 'PC_FAMILY', 1),
(5, 32, NULL, 0),
(6, 33, NULL, 0),
(7, 34, 'PF_FAMILY', 1),
(7, 35, 'PF_FAMILY', 1),
(8, 36, NULL, 0),
(9, 37, NULL, 0),
(10, 38, NULL, 0),
(11, 39, 'PJ_FAMILY', 1),
(11, 40, 'PJ_FAMILY', 1),
(12, 41, NULL, 0),
(13, 42, NULL, 0),
(14, 43, NULL, 0),
(15, 44, 'PN_FAMILY', 1),
(15, 45, 'PN_FAMILY', 1),
(16, 46, NULL, 0),
(17, 47, NULL, 0),
(18, 48, NULL, 0),
(19, 49, NULL, 0),
(20, 50, 'PS_FAMILY', 1),
(20, 51, 'PS_FAMILY', 1),
(21, 52, NULL, 0),
(22, 53, NULL, 0),
(23, 54, NULL, 0),
(24, 55, NULL, 0),
(25, 56, 'PX_FAMILY', 1),
(25, 57, 'PX_FAMILY', 1),
(26, 58, NULL, 0),
(27, 59, NULL, 0);

INSERT INTO reservation_options
(option_date, option_time, available_flag)
VALUES
('2026-07-06', '12:20', 1),
('2026-07-06', '13:00', 1),
('2026-07-06', '14:20', 1),
('2026-07-06', '15:00', 1),
('2026-07-06', '15:40', 1),
('2026-07-06', '16:20', 1),
('2026-07-06', '17:00', 1),
('2026-07-06', '17:40', 1),

('2026-07-07', '12:20', 1),
('2026-07-07', '13:00', 1),
('2026-07-07', '14:20', 1),
('2026-07-07', '15:00', 1),
('2026-07-07', '15:40', 1),
('2026-07-07', '16:20', 1),
('2026-07-07', '17:00', 1),
('2026-07-07', '17:40', 1),

('2026-07-08', '12:20', 1),
('2026-07-08', '13:00', 1),
('2026-07-08', '14:20', 1),
('2026-07-08', '15:00', 1),
('2026-07-08', '15:40', 1),
('2026-07-08', '16:20', 1),
('2026-07-08', '17:00', 1),
('2026-07-08', '17:40', 1),

('2026-07-09', '12:20', 1),
('2026-07-09', '13:00', 1),
('2026-07-09', '14:20', 1),
('2026-07-09', '15:00', 1),
('2026-07-09', '15:40', 1),
('2026-07-09', '16:20', 1),
('2026-07-09', '17:00', 1),
('2026-07-09', '17:40', 1),

('2026-07-10', '12:20', 1),
('2026-07-10', '13:00', 1),
('2026-07-10', '14:20', 1),
('2026-07-10', '15:00', 1),
('2026-07-10', '15:40', 1),
('2026-07-10', '16:20', 1),
('2026-07-10', '17:00', 1),
('2026-07-10', '17:40', 1);

INSERT INTO notices
(title, content, active_flag, target_role)
VALUES
(
    '三者面談のお知らせ',
    '三者面談の日程希望を提出してください。',
    1,
    'ALL'
),
(
    '提出期限について',
    '希望日時の提出期限は5月末までです。',
    1,
    'ALL'
);

INSERT INTO chat_rooms
(room_name, teacher_user_id, parent_user_id, status)
VALUES
('PA 保護者連絡ルーム', 1, 2, 'OPEN'),
('PB 保護者連絡ルーム', 1, 3, 'OPEN'),
('PC 保護者連絡ルーム', 1, 4, 'OPEN'),
('PD 保護者連絡ルーム', 1, 5, 'OPEN'),
('PE 保護者連絡ルーム', 1, 6, 'OPEN'),
('PF 保護者連絡ルーム', 1, 7, 'OPEN'),
('PG 保護者連絡ルーム', 1, 8, 'OPEN'),
('PH 保護者連絡ルーム', 1, 9, 'OPEN'),
('PI 保護者連絡ルーム', 1, 10, 'OPEN'),
('PJ 保護者連絡ルーム', 1, 11, 'OPEN'),
('PK 保護者連絡ルーム', 1, 12, 'OPEN'),
('PL 保護者連絡ルーム', 1, 13, 'OPEN'),
('PM 保護者連絡ルーム', 1, 14, 'OPEN'),
('PN 保護者連絡ルーム', 1, 15, 'OPEN'),
('PO 保護者連絡ルーム', 1, 16, 'OPEN'),
('PP 保護者連絡ルーム', 1, 17, 'OPEN'),
('PQ 保護者連絡ルーム', 1, 18, 'OPEN'),
('PR 保護者連絡ルーム', 1, 19, 'OPEN'),
('PS 保護者連絡ルーム', 1, 20, 'OPEN'),
('PT 保護者連絡ルーム', 1, 21, 'OPEN'),
('PU 保護者連絡ルーム', 1, 22, 'OPEN'),
('PV 保護者連絡ルーム', 1, 23, 'OPEN'),
('PW 保護者連絡ルーム', 1, 24, 'OPEN'),
('PX 保護者連絡ルーム', 1, 25, 'OPEN'),
('PY 保護者連絡ルーム', 1, 26, 'OPEN'),
('PZ 保護者連絡ルーム', 1, 27, 'OPEN');

SHOW TABLES;

SELECT COUNT(*) AS reservation_option_count
FROM reservation_options;

SELECT
    id,
    login_id,
    role,
    display_name,
    class_name
FROM users;