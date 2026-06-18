-- ============================================================
-- LIBRARY MANAGEMENT SYSTEM - MySQL Workbench Project
-- ============================================================

-- ============================================================
-- 1. CREATE DATABASE
-- ============================================================
DROP DATABASE IF EXISTS library_management;
CREATE DATABASE library_management;
USE library_management;

-- ============================================================
-- 2. CREATE TABLES (5 related tables)
-- ============================================================

CREATE TABLE Members (
    member_id INT PRIMARY KEY AUTO_INCREMENT,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE,
    phone VARCHAR(20),
    join_date DATE
);

CREATE TABLE Authors (
    author_id INT PRIMARY KEY AUTO_INCREMENT,
    author_name VARCHAR(100) NOT NULL,
    country VARCHAR(50)
);

CREATE TABLE Books (
    book_id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(150) NOT NULL,
    author_id INT,
    genre VARCHAR(50),
    total_copies INT DEFAULT 1,
    available_copies INT DEFAULT 1,
    FOREIGN KEY (author_id) REFERENCES Authors(author_id)
);

CREATE TABLE Staff (
    staff_id INT PRIMARY KEY AUTO_INCREMENT,
    staff_name VARCHAR(100) NOT NULL,
    designation VARCHAR(50),
    salary DECIMAL(10,2)
);

CREATE TABLE Loans (
    loan_id INT PRIMARY KEY AUTO_INCREMENT,
    book_id INT,
    member_id INT,
    staff_id INT,
    loan_date DATE,
    return_date DATE,
    status VARCHAR(20) DEFAULT 'Issued',
    FOREIGN KEY (book_id) REFERENCES Books(book_id),
    FOREIGN KEY (member_id) REFERENCES Members(member_id),
    FOREIGN KEY (staff_id) REFERENCES Staff(staff_id)
);

-- ============================================================
-- 3. INSERT SAMPLE RECORDS
-- ============================================================

INSERT INTO Members (full_name, email, phone, join_date) VALUES
('Ali Raza', 'ali.raza@email.com', '03001234567', '2024-01-10'),
('Sara Khan', 'sara.khan@email.com', '03007654321', '2024-02-15'),
('Bilal Ahmed', 'bilal.ahmed@email.com', '03009998888', '2024-03-05'),
('Ayesha Noor', 'ayesha.noor@email.com', '03004445555', '2024-04-20'),
('Hamza Tariq', 'hamza.tariq@email.com', '03002223333', '2024-05-12');

INSERT INTO Authors (author_name, country) VALUES
('J.K. Rowling', 'UK'),
('George Orwell', 'UK'),
('Paulo Coelho', 'Brazil'),
('Agatha Christie', 'UK'),
('Khaled Hosseini', 'USA');

INSERT INTO Books (title, author_id, genre, total_copies, available_copies) VALUES
('Harry Potter and the Sorcerer''s Stone', 1, 'Fantasy', 5, 5),
('1984', 2, 'Dystopian', 4, 4),
('The Alchemist', 3, 'Fiction', 6, 6),
('Murder on the Orient Express', 4, 'Mystery', 3, 3),
('The Kite Runner', 5, 'Drama', 4, 4);

INSERT INTO Staff (staff_name, designation, salary) VALUES
('Imran Sheikh', 'Librarian', 45000.00),
('Nadia Iqbal', 'Assistant Librarian', 32000.00),
('Usman Farooq', 'Library Clerk', 25000.00);

INSERT INTO Loans (book_id, member_id, staff_id, loan_date, return_date, status) VALUES
(1, 1, 1, '2025-01-05', '2025-01-19', 'Returned'),
(2, 2, 2, '2025-01-10', NULL, 'Issued'),
(3, 3, 1, '2025-02-01', '2025-02-15', 'Returned'),
(4, 4, 3, '2025-02-10', NULL, 'Issued'),
(5, 5, 2, '2025-03-01', NULL, 'Issued');

-- ============================================================
-- SHOW ALL TABLES (run after creation/insertion)
-- ============================================================
SHOW TABLES;

SELECT * FROM Members;
SELECT * FROM Authors;
SELECT * FROM Books;
SELECT * FROM Staff;
SELECT * FROM Loans;

-- ============================================================
-- 4. LOGIN MANAGEMENT (at least 3 logins)
-- ============================================================

CREATE USER 'login_admin'@'localhost' IDENTIFIED BY 'Admin@123';
CREATE USER 'login_librarian'@'localhost' IDENTIFIED BY 'Lib@123';
CREATE USER 'login_clerk'@'localhost' IDENTIFIED BY 'Clerk@123';

-- Change password of one login
ALTER USER 'login_clerk'@'localhost' IDENTIFIED BY 'NewClerk@456';

-- Disable a login (lock account)
ALTER USER 'login_clerk'@'localhost' ACCOUNT LOCK;

-- Enable (unlock) the login again
ALTER USER 'login_clerk'@'localhost' ACCOUNT UNLOCK;

-- ============================================================
-- 5. USER MANAGEMENT (connect logins/users with database)
-- ============================================================
-- In MySQL, the CREATE USER above already acts as both login and user.
-- Grant basic connection/usage rights to the database:

GRANT USAGE ON library_management.* TO 'login_admin'@'localhost';
GRANT USAGE ON library_management.* TO 'login_librarian'@'localhost';
GRANT USAGE ON library_management.* TO 'login_clerk'@'localhost';

-- ============================================================
-- 6. ROLE MANAGEMENT (at least 2 custom roles)
-- ============================================================

CREATE ROLE 'admin_role';
CREATE ROLE 'readonly_role';

-- Assign users to roles
GRANT 'admin_role' TO 'login_admin'@'localhost';
GRANT 'readonly_role' TO 'login_librarian'@'localhost';
GRANT 'readonly_role' TO 'login_clerk'@'localhost';

SET DEFAULT ROLE ALL TO 'login_admin'@'localhost';
SET DEFAULT ROLE ALL TO 'login_librarian'@'localhost';
SET DEFAULT ROLE ALL TO 'login_clerk'@'localhost';

-- ============================================================
-- 7. PERMISSION MANAGEMENT
-- ============================================================

-- Grant full permissions to admin_role
GRANT ALL PRIVILEGES ON library_management.* TO 'admin_role';

-- Grant read-only (SELECT) permission to readonly_role
GRANT SELECT ON library_management.* TO 'readonly_role';

-- Additionally grant INSERT on Loans table to librarian directly
GRANT INSERT, UPDATE ON library_management.Loans TO 'login_librarian'@'localhost';

FLUSH PRIVILEGES;

-- Revoke at least one permission (remove librarian's UPDATE right)
REVOKE UPDATE ON library_management.Loans FROM 'login_librarian'@'localhost';

-- Demonstrate allowed and denied access (run while logged in as that user):
-- As login_librarian -> allowed:
--   SELECT * FROM library_management.Books;
-- As login_librarian -> denied (after revoke):
--   UPDATE library_management.Loans SET status='Returned' WHERE loan_id=2;
-- As login_clerk -> denied (no write access, readonly_role only):
--   INSERT INTO library_management.Members (full_name) VALUES ('Test User');

-- Check granted privileges
SHOW GRANTS FOR 'login_admin'@'localhost';
SHOW GRANTS FOR 'login_librarian'@'localhost';
SHOW GRANTS FOR 'login_clerk'@'localhost';

-- ============================================================
-- 8. BACKUP AND RECOVERY
-- ============================================================

-- Take a full backup (run this in terminal/command line, NOT inside Workbench query tab):
-- mysqldump -u root -p library_management > library_management_backup.sql

-- Delete some records (simulate data loss)
DELETE FROM Loans WHERE loan_id = 5;
DELETE FROM Members WHERE member_id = 5;

-- Verify deletion
SELECT * FROM Loans;
SELECT * FROM Members;

-- Restore database from backup (run this in terminal/command line):
-- mysql -u root -p library_management < library_management_backup.sql

-- ============================================================
-- END OF SCRIPT
-- ============================================================
