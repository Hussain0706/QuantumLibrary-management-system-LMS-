-- ══════════════════════════════════════════════════════════
--  QuantumLibrary — Update member passwords
--  These are BCrypt(10) hashes generated for the passwords below
-- ══════════════════════════════════════════════════════════

-- Saddam BKR → password: 2003
UPDATE users
SET password = '$2a$10$slfrGgVsCpFG9ByJmS5Sd.dWMNkApJtSmjSV.Rb30/fRE9NwLOoqe'
WHERE email = 'shaiksaddambkr711@gmail.com';

-- Asaduddin → password: 2001
UPDATE users
SET password = '$2a$10$8K1p/a0dclxbNZjRsyD9iev/CuiB8Y/JJTpVrj6Nl/q5WbZYvVi7O'
WHERE email = 'dudekulaasaduddin210@gmail.com';

-- Hussain → password: 2004
UPDATE users
SET password = '$2a$10$4N7hOumYZS0B6yFB8FVfmeXP8JZWV7B9mDdWXJCb2V1F8cM4mfNHW'
WHERE email = 'hussain0706w@gmail.com';

-- Rizwan → password: 2002
UPDATE users
SET password = '$2a$10$YQgfOQ7DVfsCWVr7T9yfle2mQJL0V5wXmJbdRm.gIGWqt/l4I1b.C'
WHERE email = 'Shaikmohammedshaikrizwan@gmail.com';

-- Verify
SELECT id, name, email, role FROM users;
