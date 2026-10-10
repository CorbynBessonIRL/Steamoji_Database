/* =====================================================================
   Steamoji - Private Tutors Company Database
   Script:  Steamoji_Drop.sql
   DBMS:    Microsoft SQL Server 

   NOTE ON MySQL COMPATIBILITY: DROP TABLE and DROP DATABASE syntax
   below is standard ANSI SQL and is identical in MySQL. The only
   MS-SQL-Server-only element is the "GO" batch separator, which has
   no equivalent/is not needed in MySQL (see Steamoji_Create.sql for a
   full explanation).
   ===================================================================== */

USE Steamoji;
GO

DROP TABLE Payment;
DROP TABLE Contract_Session;
DROP TABLE Guardian_Responsible_MinorStudent;
DROP TABLE Course_Requires_Course;
DROP TABLE Tutor_Specialty;
DROP TABLE MinorStudent;
DROP TABLE Contract;
DROP TABLE Guardian;
DROP TABLE Student;
DROP TABLE Course;
DROP TABLE Tutor;
GO

USE master;
GO
DROP DATABASE Steamoji;
GO
