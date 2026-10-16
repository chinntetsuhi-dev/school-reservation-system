USE interview_db;

SET FOREIGN_KEY_CHECKS = 0;

DELETE FROM parent_request_options;
DELETE FROM final_plans;
DELETE FROM parent_requests;
DELETE FROM reservation_options;

SET FOREIGN_KEY_CHECKS = 1;

INSERT INTO reservation_options
(option_date, option_time, available_flag)
VALUES
('2026-07-06', '12:20', TRUE),
('2026-07-06', '13:00', TRUE),
('2026-07-06', '14:20', TRUE),
('2026-07-06', '15:00', TRUE),
('2026-07-06', '15:40', TRUE),
('2026-07-06', '16:20', TRUE),
('2026-07-06', '17:00', TRUE),
('2026-07-06', '17:40', TRUE),

('2026-07-07', '12:20', TRUE),
('2026-07-07', '13:00', TRUE),
('2026-07-07', '14:20', TRUE),
('2026-07-07', '15:00', TRUE),
('2026-07-07', '15:40', TRUE),
('2026-07-07', '16:20', TRUE),
('2026-07-07', '17:00', TRUE),
('2026-07-07', '17:40', TRUE),

('2026-07-08', '12:20', TRUE),
('2026-07-08', '13:00', TRUE),
('2026-07-08', '14:20', TRUE),
('2026-07-08', '15:00', TRUE),
('2026-07-08', '15:40', TRUE),
('2026-07-08', '16:20', TRUE),
('2026-07-08', '17:00', TRUE),
('2026-07-08', '17:40', TRUE),

('2026-07-09', '12:20', TRUE),
('2026-07-09', '13:00', TRUE),
('2026-07-09', '14:20', TRUE),
('2026-07-09', '15:00', TRUE),
('2026-07-09', '15:40', TRUE),
('2026-07-09', '16:20', TRUE),
('2026-07-09', '17:00', TRUE),
('2026-07-09', '17:40', TRUE),

('2026-07-10', '12:20', TRUE),
('2026-07-10', '13:00', TRUE),
('2026-07-10', '14:20', TRUE),
('2026-07-10', '15:00', TRUE),
('2026-07-10', '15:40', TRUE),
('2026-07-10', '16:20', TRUE),
('2026-07-10', '17:00', TRUE),
('2026-07-10', '17:40', TRUE);

SELECT
    option_date,
    option_time,
    available_flag
FROM reservation_options
ORDER BY
    option_date,
    FIELD(
        option_time,
        '12:20',
        '13:00',
        '14:20',
        '15:00',
        '15:40',
        '16:20',
        '17:00',
        '17:40'
    );