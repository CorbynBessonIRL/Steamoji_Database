/* =====================================================================
   Steamoji - Private Tutors Company Database
   Script:  Steamoji_Queries.sql
   DBMS:    Microsoft SQL Server

   This feature does not work on MySQL:
     - String concatenation with '+' (Q1, Q4, Q5, Q18); MySQL uses
       CONCAT(a, b) instead.
     - GETDATE() (Q16); MySQL uses CURDATE() / NOW() instead.
     - DATEADD(MONTH, 1, x) (Q15); MySQL uses DATE_ADD(x, INTERVAL 1 MONTH).
     - ISNULL(x, 0) (Q18); MySQL uses IFNULL(x, 0) instead.
     - The NATURAL JOIN keyword itself (Q4); MS SQL Server has no such
       keyword at all, so Q4 uses an explicit JOIN...ON on the matching
       columns to produce the same result that keyword would on MySQL.
   Everything else (INNER/LEFT/RIGHT/CROSS JOIN, GROUP BY, HAVING,
   subqueries, CREATE VIEW, UPDATE, DELETE) is standard SQL and works
   the same way on MySQL.
   ===================================================================== */

USE Steamoji;
GO

-- =====================================================================
-- Query 1. [JOIN: INNER] Display a readable roster of every contract:
-- which student is paired with which tutor for which course. An INNER
-- JOIN is correct here because a contract missing its student, tutor,
-- or course would not be a meaningful row to show.
-- =====================================================================
SELECT
    c.ContractID,
    s.FirstName + ' ' + s.LastName AS StudentName,
    t.FirstName + ' ' + t.LastName AS TutorName,
    co.CourseName,
    c.StartDate,
    c.EndDate
FROM Contract c
INNER JOIN Student s ON c.StudentID = s.StudentID
INNER JOIN Tutor t ON c.TutorID = t.TutorID
INNER JOIN Course co ON c.CourseID = co.CourseID
ORDER BY c.ContractID;
GO

-- =====================================================================
-- Query 2. [JOIN: LEFT] Show every tutor's current contract count,
-- including tutors who have zero contracts right now (an INNER JOIN
-- would hide them, but management needs to see exactly these tutors
-- to know who has room to take on new students).
-- =====================================================================
SELECT
    t.TutorID,
    t.FirstName,
    t.LastName,
    COUNT(c.ContractID) AS NumberOfContracts
FROM Tutor t
LEFT JOIN Contract c ON t.TutorID = c.TutorID
GROUP BY t.TutorID, t.FirstName, t.LastName
ORDER BY NumberOfContracts DESC;
GO

-- =====================================================================
-- Query 3. [JOIN: RIGHT] Show how many times each course has ever been
-- contracted, including courses that have never been picked by a
-- student (useful for deciding which course offerings need marketing).
-- =====================================================================
SELECT
    co.CourseID,
    co.CourseName,
    COUNT(c.ContractID) AS TimesContracted
FROM Contract c
RIGHT JOIN Course co ON c.CourseID = co.CourseID
GROUP BY co.CourseID, co.CourseName
ORDER BY TimesContracted ASC;
GO

-- =====================================================================
-- Query 4. [JOIN: NATURAL] For every guardian, list each minor student
-- they are responsible for and their relationship label. MS SQL Server
-- has no NATURAL JOIN keyword, so the same-named join columns
-- (GuardianID, StudentID) are matched explicitly with ON to produce the
-- identical result a NATURAL JOIN would; MySQL could use the literal
-- NATURAL JOIN keyword instead.
-- =====================================================================
SELECT
    g.GuardianID,
    g.GuardianName,
    g.Phone,
    s.StudentID,
    s.FirstName + ' ' + s.LastName AS StudentName,
    gr.RelationshipToStudent
FROM Guardian g
JOIN Guardian_Responsible_MinorStudent gr ON g.GuardianID = gr.GuardianID
JOIN Student s ON gr.StudentID = s.StudentID
ORDER BY g.GuardianName, StudentName;
GO

-- =====================================================================
-- Query 5. [JOIN: CROSS / Cartesian Product] Generate a blank Tutor x
-- Course staffing worksheet -- every possible tutor/course pairing --
-- for office staff to manually mark which tutors could be trained or
-- certified to teach which additional courses.
-- =====================================================================
SELECT
    t.TutorID,
    t.FirstName + ' ' + t.LastName AS TutorName,
    co.CourseID,
    co.CourseName
FROM Tutor t
CROSS JOIN Course co
ORDER BY t.TutorID, co.CourseID;
GO

-- =====================================================================
-- Query 6. [Aggregate: SUM] Total revenue collected so far, per tutor.
-- =====================================================================
SELECT
    t.TutorID,
    t.FirstName,
    t.LastName,
    SUM(p.Amount) AS TotalRevenue
FROM Tutor t
JOIN Contract c ON t.TutorID = c.TutorID
JOIN Payment p ON c.ContractID = p.ContractID
GROUP BY t.TutorID, t.FirstName, t.LastName
ORDER BY TotalRevenue DESC;
GO

-- =====================================================================
-- Query 7. [Aggregate: AVG] Average course fee, but only among courses
-- that have at least one prerequisite (the more "advanced" courses),
-- to see if advanced courses are priced noticeably higher on average.
-- =====================================================================
SELECT AVG(Fee) AS AvgFeeOfCoursesWithPrerequisite
FROM Course
WHERE CourseID IN (SELECT CourseID FROM Course_Requires_Course);
GO

-- =====================================================================
-- Query 8. [Aggregate: MIN] Identify Steamoji's least expensive course
-- (e.g., to feature as a budget-friendly option in a promotion).
-- =====================================================================
SELECT CourseID, CourseName, Fee
FROM Course
WHERE Fee = (SELECT MIN(Fee) FROM Course);
GO

-- =====================================================================
-- Query 9. [Aggregate: MAX] Identify the single largest payment ever
-- received (e.g., for the bookkeeper to spot-check large transactions).
-- =====================================================================
SELECT PaymentID, Amount, PaymentDate, ContractID
FROM Payment
WHERE Amount = (SELECT MAX(Amount) FROM Payment);
GO

-- =====================================================================
-- Query 10. [Aggregate: COUNT] Show how many weekly sessions are
-- scheduled on each day of the week, across all contracts, to help
-- staff see which weekday is busiest for room/scheduling planning.
-- =====================================================================
SELECT
    SessionDay,
    COUNT(*) AS NumberOfSessions
FROM Contract_Session
GROUP BY SessionDay
ORDER BY NumberOfSessions DESC;
GO

-- =====================================================================
-- Query 11. [Nested query, non-correlated, IN] List the students who
-- are currently enrolled in a course that itself requires a
-- prerequisite (i.e., students taking an "advanced" course).
-- =====================================================================
SELECT
    s.StudentID,
    s.FirstName,
    s.LastName,
    c.CourseID
FROM Student s
JOIN Contract c ON s.StudentID = c.StudentID
WHERE c.CourseID IN (SELECT CourseID FROM Course_Requires_Course);
GO

-- =====================================================================
-- Query 12. [Nested query, correlated, NOT EXISTS] List guardians who
-- are NOT the designated emergency contact for any minor student --
-- these are "secondary" guardians on file (e.g., an aunt/uncle who
-- helps out) who staff may want to prompt to confirm their details.
-- =====================================================================
SELECT g.GuardianID, g.GuardianName
FROM Guardian g
WHERE NOT EXISTS (
    SELECT *
    FROM MinorStudent ms
    WHERE ms.EmergencyContactGuardianID = g.GuardianID
);
GO

-- =====================================================================
-- Query 13. [Nested query, scalar subquery] List courses priced above
-- the average fee of all courses.
-- =====================================================================
SELECT CourseID, CourseName, Fee
FROM Course
WHERE Fee > (SELECT AVG(Fee) FROM Course)
ORDER BY Fee DESC;
GO

-- =====================================================================
-- Query 14. [UPDATE + Nested query] Courses that have never attracted
-- a single contract may be mispriced or under-marketed; as a pricing
-- experiment, raise the fee of every such course by 10%.
-- =====================================================================
UPDATE Course
SET Fee = Fee * 1.10
WHERE CourseID NOT IN (SELECT CourseID FROM Contract);
GO

-- =====================================================================
-- Query 15. [UPDATE] A student has decided to extend their tutoring
-- engagement by one month -- push Contract 3's end date out by a month.
-- (MySQL equivalent of DATEADD: DATE_ADD(EndDate, INTERVAL 1 MONTH))
-- =====================================================================
UPDATE Contract
SET EndDate = DATEADD(MONTH, 1, EndDate)
WHERE ContractID = 3;
GO

-- =====================================================================
-- Query 16. [DELETE + Nested query] Housekeeping: once a contract has
-- ended, its weekly meeting-time slots are no longer needed, so remove
-- them to keep the scheduling table clean. (Result depends on the
-- current date when this script is actually run, since it compares
-- against GETDATE(); MySQL equivalent: CURDATE().)
-- =====================================================================
DELETE FROM Contract_Session
WHERE ContractID IN (
    SELECT ContractID FROM Contract WHERE EndDate < GETDATE()
);
GO

-- =====================================================================
-- Query 17. [DELETE] Tutor T0002 has decided to stop offering
-- Chemistry tutoring; remove that specialty from their profile.
-- =====================================================================
DELETE FROM Tutor_Specialty
WHERE TutorID = 'T0002' AND Specialty = 'Chemistry';
GO

-- =====================================================================
-- Query 18. [VIEW] Create a reusable view that calculates, for every
-- contract, how much of the course fee is still owed (an "accounts
-- receivable" report), then use it to list only contracts that still
-- have a balance outstanding.
-- (MySQL equivalent of ISNULL: IFNULL)
-- =====================================================================
CREATE VIEW ContractBalance AS
SELECT
    c.ContractID,
    s.FirstName + ' ' + s.LastName AS StudentName,
    co.CourseName,
    co.Fee,
    ISNULL(SUM(p.Amount), 0) AS AmountPaid,
    co.Fee - ISNULL(SUM(p.Amount), 0) AS BalanceOwed
FROM Contract c
JOIN Student s ON c.StudentID = s.StudentID
JOIN Course co ON c.CourseID = co.CourseID
LEFT JOIN Payment p ON c.ContractID = p.ContractID
GROUP BY c.ContractID, s.FirstName, s.LastName, co.CourseName, co.Fee;
GO

SELECT *
FROM ContractBalance
WHERE BalanceOwed > 0
ORDER BY BalanceOwed DESC;
GO

-- =====================================================================
-- Query 19. [Using a view again + Aggregate: SUM] Using the view
-- above, show the single total amount Steamoji is still owed across
-- all contracts company-wide.
-- =====================================================================
SELECT SUM(BalanceOwed) AS TotalOutstandingBalance
FROM ContractBalance;
GO

-- =====================================================================
-- Query 20. [Self-JOIN] For every course that has a prerequisite, show
-- the course's name next to the name of the prerequisite it requires
-- (a human-readable view of the recursive prerequisite relationship).
-- =====================================================================
SELECT
    co.CourseName AS Course,
    pre.CourseName AS PrerequisiteCourse
FROM Course_Requires_Course crc
JOIN Course co ON crc.CourseID = co.CourseID
JOIN Course pre ON crc.PrereqCourseID = pre.CourseID
ORDER BY co.CourseName;
GO
