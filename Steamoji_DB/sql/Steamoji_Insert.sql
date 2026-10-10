/* =====================================================================
   Steamoji - Private Tutors Company Database
   Script:  Steamoji_Insert.sql
   DBMS:    Microsoft SQL Server

   NOTE ON MySQL COMPATIBILITY: All INSERT INTO ... VALUES statements
   below are standard ANSI SQL and run unchanged on MySQL. Date/time
   literals are written as 'YYYY-MM-DD' and 'HH:MM' strings, which both
   MS SQL Server and MySQL implicitly convert to DATE/TIME. Because
   Contract.ContractID and Payment.PaymentID are IDENTITY columns, SQL
   Server generates them automatically in insertion order starting at 1
   (i.e., the first Contract inserted becomes ContractID = 1, and so on);
   this script relies on that fact when inserting Contract_Session and
   Payment rows. (In MySQL the equivalent AUTO_INCREMENT column behaves
   the same way.)
   ===================================================================== */

USE Steamoji;
GO

INSERT INTO Tutor VALUES ('T0001', 'John', 'Reyes', '1985-03-12', 'MSc Mathematics');
INSERT INTO Tutor VALUES ('T0002', 'Amara', 'Chen', '1990-07-22', 'PhD Physics');
INSERT INTO Tutor VALUES ('T0003', 'Diego', 'Alvarez', '1978-11-05', 'BSc Computer Science');

INSERT INTO Tutor_Specialty VALUES ('T0001', 'Math');
INSERT INTO Tutor_Specialty VALUES ('T0001', 'Physics');
INSERT INTO Tutor_Specialty VALUES ('T0002', 'Physics');
INSERT INTO Tutor_Specialty VALUES ('T0002', 'Chemistry');
INSERT INTO Tutor_Specialty VALUES ('T0003', 'Programming');
INSERT INTO Tutor_Specialty VALUES ('T0003', 'Math');


INSERT INTO Course VALUES ('C0001', 'Algebra 1', 300.00, 40);
INSERT INTO Course VALUES ('C0002', 'Algebra 2', 350.00, 40);
INSERT INTO Course VALUES ('C0003', 'Calculus 1', 400.00, 45);
INSERT INTO Course VALUES ('C0004', 'Calculus 2', 450.00, 45);
INSERT INTO Course VALUES ('C0005', 'Intro to Programming', 380.00, 50);
INSERT INTO Course VALUES ('C0006', 'Data Structures', 420.00, 50);
INSERT INTO Course VALUES ('C0007', 'Physics 1', 400.00, 45);


INSERT INTO Course_Requires_Course VALUES ('C0002', 'C0001'); -- Algebra 2 requires Algebra 1
INSERT INTO Course_Requires_Course VALUES ('C0003', 'C0002'); -- Calculus 1 requires Algebra 2
INSERT INTO Course_Requires_Course VALUES ('C0004', 'C0003'); -- Calculus 2 requires Calculus 1
INSERT INTO Course_Requires_Course VALUES ('C0006', 'C0005'); -- Data Structures requires Intro to Programming


INSERT INTO Student VALUES ('S0001', 'Emma', 'Liu', 'High School', 'Lincoln High School', '2009-05-14', '12 Oak St', 'Vancouver', 'BC', 'V5K0A1', '604-555-1111', 1);
INSERT INTO Student VALUES ('S0002', 'Liam', 'Liu', 'Elementary', 'Sunnyvale Elementary', '2012-08-22', '12 Oak St', 'Vancouver', 'BC', 'V5K0A1', '604-555-1111', 1);
INSERT INTO Student VALUES ('S0003', 'Olivia', 'Smith', 'College', 'Langara College', '2003-01-30', '88 Maple Ave', 'Burnaby', 'BC', 'V3J1K2', '604-555-2222', 0);
INSERT INTO Student VALUES ('S0004', 'Noah', 'Patel', 'University', 'Simon Fraser University', '2001-09-09', '45 Birch Rd', 'Surrey', 'BC', 'V4N2P3', '604-555-3333', 0);
INSERT INTO Student VALUES ('S0005', 'Sophia', 'Kim', 'High School', 'Central High', '2008-12-01', '77 Cedar Ln', 'Richmond', 'BC', 'V6Y1G4', '604-555-4444', 1);


INSERT INTO Guardian VALUES ('G0001', 'Maria Liu', '604-555-1112');
INSERT INTO Guardian VALUES ('G0002', 'David Liu', '604-555-1113');
INSERT INTO Guardian VALUES ('G0003', 'Grace Kim', '604-555-4445');
INSERT INTO Guardian VALUES ('G0004', 'Wendy Liu', '604-555-1114');

INSERT INTO MinorStudent VALUES ('S0001', 'G0001');
INSERT INTO MinorStudent VALUES ('S0002', 'G0002');
INSERT INTO MinorStudent VALUES ('S0005', 'G0003');


INSERT INTO Guardian_Responsible_MinorStudent VALUES ('G0001', 'S0001', 'Mother');
INSERT INTO Guardian_Responsible_MinorStudent VALUES ('G0001', 'S0002', 'Mother');
INSERT INTO Guardian_Responsible_MinorStudent VALUES ('G0002', 'S0001', 'Father');
INSERT INTO Guardian_Responsible_MinorStudent VALUES ('G0002', 'S0002', 'Father');
INSERT INTO Guardian_Responsible_MinorStudent VALUES ('G0003', 'S0005', 'Mother');
INSERT INTO Guardian_Responsible_MinorStudent VALUES ('G0004', 'S0002', 'Aunt');


INSERT INTO Contract (StartDate, EndDate, StudentID, TutorID, CourseID) VALUES ('2026-01-05', '2026-06-30', 'S0001', 'T0001', 'C0001'); -- ContractID 1
INSERT INTO Contract (StartDate, EndDate, StudentID, TutorID, CourseID) VALUES ('2026-07-01', '2026-12-15', 'S0001', 'T0001', 'C0002'); -- ContractID 2
INSERT INTO Contract (StartDate, EndDate, StudentID, TutorID, CourseID) VALUES ('2026-02-01', '2026-07-01', 'S0002', 'T0003', 'C0005'); -- ContractID 3
INSERT INTO Contract (StartDate, EndDate, StudentID, TutorID, CourseID) VALUES ('2026-01-15', '2026-06-15', 'S0003', 'T0002', 'C0007'); -- ContractID 4
INSERT INTO Contract (StartDate, EndDate, StudentID, TutorID, CourseID) VALUES ('2026-01-10', '2026-05-10', 'S0004', 'T0003', 'C0006'); -- ContractID 5
INSERT INTO Contract (StartDate, EndDate, StudentID, TutorID, CourseID) VALUES ('2026-03-01', '2026-08-01', 'S0005', 'T0001', 'C0003'); -- ContractID 6


INSERT INTO Contract_Session VALUES (1, 'Monday',    '16:00', '17:00');
INSERT INTO Contract_Session VALUES (1, 'Wednesday', '16:00', '17:00');
INSERT INTO Contract_Session VALUES (2, 'Tuesday',   '16:00', '17:00');
INSERT INTO Contract_Session VALUES (3, 'Thursday',  '15:00', '16:30');
INSERT INTO Contract_Session VALUES (4, 'Monday',    '10:00', '11:30');
INSERT INTO Contract_Session VALUES (4, 'Friday',    '10:00', '11:30');
INSERT INTO Contract_Session VALUES (5, 'Wednesday', '18:00', '19:30');
INSERT INTO Contract_Session VALUES (6, 'Saturday',  '09:00', '10:30');
INSERT INTO Contract_Session VALUES (6, 'Sunday',    '09:00', '10:30');

INSERT INTO Payment (Amount, PaymentDate, ContractID) VALUES (150.00, '2026-01-05', 1);
INSERT INTO Payment (Amount, PaymentDate, ContractID) VALUES (150.00, '2026-04-01', 1);
INSERT INTO Payment (Amount, PaymentDate, ContractID) VALUES (350.00, '2026-07-01', 2);
INSERT INTO Payment (Amount, PaymentDate, ContractID) VALUES (190.00, '2026-02-01', 3);
INSERT INTO Payment (Amount, PaymentDate, ContractID) VALUES (190.00, '2026-05-01', 3);
INSERT INTO Payment (Amount, PaymentDate, ContractID) VALUES (250.00, '2026-01-15', 4); -- partial payment; $150 of the $400 course fee is still owed (used by Queries 17-18)
INSERT INTO Payment (Amount, PaymentDate, ContractID) VALUES (210.00, '2026-01-10', 5);
INSERT INTO Payment (Amount, PaymentDate, ContractID) VALUES (210.00, '2026-03-10', 5);
INSERT INTO Payment (Amount, PaymentDate, ContractID) VALUES (400.00, '2026-03-01', 6); -- corrected: was mistakenly entered as 450.00, which overpaid the $400 course fee for C0003
GO
