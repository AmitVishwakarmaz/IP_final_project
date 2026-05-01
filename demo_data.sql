-- ============================================================
--  DEMO TEST DATA for Complaint Filing System
--  Database: tcet_IP
--  Run this in MySQL Workbench after deploying the app
-- ============================================================

USE tcet_IP;

-- ────────────────────────────────────────────────────────────────
--  TABLE: users
--  Columns: id (AUTO), username, password, role
-- ────────────────────────────────────────────────────────────────

INSERT INTO users (username, password, role) VALUES
('admin',     'admin123',    'admin'),
('amit',      'amit123',     'user'),
('priya',     'priya123',    'user'),
('rahul',     'rahul123',    'user'),
('sneha',     'sneha123',    'user'),
('manish',    'manish123',   'user');


-- ────────────────────────────────────────────────────────────────
--  TABLE: complaint
--  Columns: id (AUTO), name, email, subject, description,
--           category, priority, status, username, created_at
-- ────────────────────────────────────────────────────────────────

INSERT INTO complaint (name, email, subject, description, category, priority, status, username, created_at) VALUES

-- ── amit's complaints ───────────────────────────────────────────
('Amit Vishwakarma', 'amit@tcet.ac.in',  'WiFi not working in Lab 3',
 'The WiFi router in Computer Lab 3 has been down for 2 days. Students are unable to access online resources during practical sessions.',
 'IT Support', 'High', 'Pending', 'amit', '2026-01-10 09:30:00'),

('Amit Vishwakarma', 'amit@tcet.ac.in',  'Broken chair in Room 401',
 'Several chairs in Room 401 are broken and pose a safety risk. At least 5 chairs need immediate replacement.',
 'Infrastructure', 'Medium', 'Resolved', 'amit', '2026-01-18 14:20:00'),

('Amit Vishwakarma', 'amit@tcet.ac.in',  'Incorrect marks in DBMS',
 'My internal assessment marks for DBMS show 18/30 but I scored 25/30. Please verify with the answer sheet.',
 'Academic', 'High', 'In Progress', 'amit', '2026-02-05 11:00:00'),

-- ── priya's complaints ─────────────────────────────────────────
('Priya Sharma', 'priya@tcet.ac.in',  'Hostel water supply issue',
 'Hot water supply in Girls Hostel Block B is not available after 7 PM. This has been a recurring issue for 2 weeks.',
 'Hostel', 'High', 'Pending', 'priya', '2026-02-12 08:45:00'),

('Priya Sharma', 'priya@tcet.ac.in',  'Late fee charged incorrectly',
 'I paid my semester fees on time but was charged a late fee of Rs. 500. Attaching the payment receipt as proof.',
 'Administrative', 'Medium', 'Resolved', 'priya', '2026-01-25 16:10:00'),

('Priya Sharma', 'priya@tcet.ac.in',  'Bus route 5 delay',
 'Bus number 5 (Thane route) consistently arrives 30 minutes late every morning. This causes students to miss the first lecture.',
 'Transport', 'Medium', 'In Progress', 'priya', '2026-03-01 07:50:00'),

-- ── rahul's complaints ─────────────────────────────────────────
('Rahul Patil', 'rahul@tcet.ac.in',  'Projector not working in Room 302',
 'The projector in Room 302 has not been functioning since last week. Faculty are unable to conduct presentations.',
 'IT Support', 'High', 'Pending', 'rahul', '2026-02-20 10:30:00'),

('Rahul Patil', 'rahul@tcet.ac.in',  'Library book shortage',
 'The library has only 2 copies of the prescribed textbook for Operating Systems for over 120 students. Need more copies.',
 'Academic', 'Low', 'Pending', 'rahul', '2026-03-05 13:15:00'),

('Rahul Patil', 'rahul@tcet.ac.in',  'Canteen food quality',
 'Food quality in the canteen has deteriorated. Multiple students reported stale food items during lunch hour last week.',
 'General', 'Medium', 'Rejected', 'rahul', '2026-02-08 12:40:00'),

-- ── sneha's complaints ─────────────────────────────────────────
('Sneha Desai', 'sneha@tcet.ac.in',  'ERP portal login failure',
 'Unable to login to the college ERP portal since yesterday. Getting "Invalid credentials" error despite correct password.',
 'IT Support', 'High', 'Resolved', 'sneha', '2026-03-10 09:00:00'),

('Sneha Desai', 'sneha@tcet.ac.in',  'Hostel room maintenance',
 'The ceiling fan in Room 204 of the hostel is making a loud noise and wobbles excessively. Needs urgent repair.',
 'Hostel', 'Medium', 'Pending', 'sneha', '2026-03-08 18:30:00'),

('Sneha Desai', 'sneha@tcet.ac.in',  'Scholarship form deadline',
 'The last date for scholarship form submission was not communicated properly. Many students missed the deadline.',
 'Administrative', 'Low', 'Rejected', 'sneha', '2026-01-30 15:45:00'),

-- ── manish's complaints ────────────────────────────────────────
('Manish Gupta', 'manish@tcet.ac.in',  'Parking lot flooding',
 'The two-wheeler parking area near Gate 2 gets completely flooded during rain. Multiple vehicles were damaged last time.',
 'Infrastructure', 'High', 'In Progress', 'manish', '2026-02-15 16:00:00'),

('Manish Gupta', 'manish@tcet.ac.in',  'Lab equipment outdated',
 'The oscilloscopes in Electronics Lab are outdated (10+ years old) and give inaccurate readings. Need replacement.',
 'Academic', 'Medium', 'Pending', 'manish', '2026-03-12 11:20:00'),

('Manish Gupta', 'manish@tcet.ac.in',  'General suggestion – more events',
 'It would be great to have more technical workshops and hackathons organized by the college on weekends.',
 'Other', 'Low', 'Resolved', 'manish', '2026-02-28 14:00:00');
