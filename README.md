# Library Management System (MySQL)

A relational database for a library system, designed and administered using MySQL Workbench as part of a Database Administration lab assignment. Covers schema design, role-based access control, user/login management, and backup and recovery.

## Database Design
- 5 normalized, related tables: Members, Authors, Books, Staff, Loans
- Foreign key constraints enforcing referential integrity (e.g. Books → Authors, Loans → Books/Members/Staff)
- Sample data inserted across all tables to simulate real library operations

## Database Administration Tasks
- **Login Management**: created multiple logins with distinct access levels, including password changes and account lock/unlock
- **User Management**: connected users to the database with appropriate access
- **Role Management**: created custom roles (admin, read-only) and assigned users based on job function
- **Permission Management**: granted and revoked privileges at the role and user level, with verification of allowed vs. denied queries
- **Backup & Recovery**: performed a full database backup using `mysqldump`, simulated data loss, and restored the database successfully

## Tools Used
- MySQL Workbench
- MySQL Server
- mysqldump / mysql CLI

## Files
- `library_management_system.sql` — full SQL script (schema, sample data, users, roles, permissions)
- `library_management_report.pdf` — full lab report detailing all tasks and results

## What I Learned
This project gave me practical experience with database administration beyond basic schema design, including implementing role-based access control (RBAC), managing user privileges, and performing backup and recovery procedures to ensure data integrity.
