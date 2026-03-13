-- ============================================================
--  Complaint Filing System – Database Script
--  Database: tcet_IP
-- ============================================================

-- If the table doesn't exist yet, create it fresh:
CREATE TABLE IF NOT EXISTS complaint (
    id          INT AUTO_INCREMENT PRIMARY KEY,
    name        VARCHAR(100)  NOT NULL,
    email       VARCHAR(150)  NOT NULL,
    subject     VARCHAR(200)  NOT NULL,
    description TEXT          NOT NULL,
    category    VARCHAR(50)   NOT NULL DEFAULT 'Other',
    priority    VARCHAR(20)   NOT NULL DEFAULT 'Medium',
    status      VARCHAR(30)   NOT NULL DEFAULT 'Pending',
    username    VARCHAR(100)  NOT NULL,
    created_at  TIMESTAMP     NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- ============================================================
--  If the table ALREADY EXISTS and you only need the new columns:
--  (Run only the lines for columns that are missing)
-- ============================================================

-- NOTE: The user already ran this ALTER; included for reference only.
-- ALTER TABLE complaint
--   ADD COLUMN category   VARCHAR(50)  NOT NULL DEFAULT 'Other'  AFTER description,
--   ADD COLUMN priority   VARCHAR(20)  NOT NULL DEFAULT 'Medium' AFTER category,
--   ADD COLUMN created_at TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP AFTER priority;

-- Extend status column to support all 4 values (if it was limited before):
ALTER TABLE complaint MODIFY COLUMN status VARCHAR(30) NOT NULL DEFAULT 'Pending';

-- ============================================================
--  Useful analytics queries (run manually to verify data)
-- ============================================================

-- Total complaints
SELECT COUNT(*) AS total FROM complaint;

-- Count by category
SELECT category, COUNT(*) AS total
FROM complaint
GROUP BY category
ORDER BY total DESC;

-- Count by status
SELECT status, COUNT(*) AS total
FROM complaint
GROUP BY status;

-- Count by priority
SELECT priority, COUNT(*) AS total
FROM complaint
GROUP BY priority
ORDER BY FIELD(priority, 'High', 'Medium', 'Low');

-- Monthly trend (last 6 months)
SELECT
    DATE_FORMAT(created_at, '%b %Y') AS month,
    COUNT(*) AS total
FROM complaint
WHERE created_at >= DATE_SUB(NOW(), INTERVAL 6 MONTH)
GROUP BY DATE_FORMAT(created_at, '%Y-%m')
ORDER BY DATE_FORMAT(created_at, '%Y-%m') ASC;

-- Complaints per user
SELECT username, COUNT(*) AS complaints
FROM complaint
GROUP BY username
ORDER BY complaints DESC;

-- High-priority pending complaints
SELECT id, name, subject, category, created_at
FROM complaint
WHERE priority = 'High' AND status = 'Pending'
ORDER BY created_at ASC;
