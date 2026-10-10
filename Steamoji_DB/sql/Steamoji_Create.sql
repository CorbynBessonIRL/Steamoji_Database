/* =====================================================================
   Steamoji - Private Tutors Company Database
   Script:  Steamoji_Create.sql
   DBMS:    Microsoft SQL Server 
   =====================================================================

   NOTE ON MySQL COMPATIBILITY:
   This script is written and tested on MS SQL Server. If it is ported
   to MySQL, the following statements/features must be changed:
     1) IDENTITY(1,1) is MS SQL Server syntax used below on
        Contract.ContractID and Payment.PaymentID to auto-generate a
        surrogate key. MySQL does not support IDENTITY; the equivalent
        keyword in MySQL is AUTO_INCREMENT (placed after the data type,
        e.g. "ContractID INT AUTO_INCREMENT").
     2) BIT is used below for the Student.IsMinor flag. MS SQL Server's
        BIT type stores 0/1. MySQL does not have BIT(1) behaving the
        same way by default; the closest equivalent in MySQL is
        TINYINT(1) or BOOLEAN (BOOLEAN is just an alias for TINYINT(1)
        in MySQL).
     3) CHECK constraints (used throughout this script, e.g. on Fee,
        Amount, EndDate, EndTime, SessionDay) are always enforced by
        MS SQL Server. In MySQL, CHECK constraints are parsed but were
        silently IGNORED before MySQL 8.0.16; they are only enforced
        from MySQL 8.0.16 onward. On an older MySQL server, invalid
        data could be inserted even though a CHECK exists.
     4) GO is a batch separator understood by SQL Server Management
        Studio (SSMS)/sqlcmd; it is NOT a T-SQL keyword and MySQL has no
        equivalent at all. Statements in MySQL are separated only by
        semicolons.
     5) CREATE DATABASE / USE syntax below is standard on both DBMSs and
        does not need to change.
   Everything else in this script (CREATE TABLE, PRIMARY KEY, FOREIGN
   KEY, and the data types CHAR/VARCHAR/DATE/TIME/DECIMAL/SMALLINT/INT)
   is standard SQL and works the same way on MySQL.
   ===================================================================== */

CREATE DATABASE Steamoji;
GO
USE Steamoji;
GO


CREATE TABLE Tutor (
    TutorID        CHAR(5)      NOT NULL,
    FirstName      VARCHAR(20)  NOT NULL,
    LastName       VARCHAR(20)  NOT NULL,
    DateOfBirth    DATE         NOT NULL,
    HighestDegree  VARCHAR(30)  NOT NULL,
    PRIMARY KEY (TutorID)
);
GO


CREATE TABLE Course (
    CourseID    CHAR(5)       NOT NULL,
    CourseName  VARCHAR(50)   NOT NULL,
    Fee         DECIMAL(8,2)  NOT NULL,
    TotalHours  SMALLINT      NOT NULL,
    PRIMARY KEY (CourseID),
    CHECK (Fee > 0),
    CHECK (TotalHours > 0)
);
GO


CREATE TABLE Student (
    StudentID       CHAR(5)      NOT NULL,
    FirstName       VARCHAR(20)  NOT NULL,
    LastName        VARCHAR(20)  NOT NULL,
    EducationLevel  VARCHAR(20)  NOT NULL,
    SchoolName      VARCHAR(50)  NOT NULL,
    DateOfBirth     DATE         NOT NULL,
    Street          VARCHAR(40)  NOT NULL,
    City            VARCHAR(25)  NOT NULL,
    State           VARCHAR(25)  NOT NULL,
    Zip             VARCHAR(10)  NOT NULL,
    Phone           CHAR(12)     NOT NULL,
    IsMinor         BIT          NOT NULL,
    PRIMARY KEY (StudentID),
    CHECK (EducationLevel IN ('Elementary','High School','College','University'))
);
GO


CREATE TABLE Guardian (
    GuardianID    CHAR(5)      NOT NULL,
    GuardianName  VARCHAR(40)  NOT NULL,
    Phone         CHAR(12)     NOT NULL,
    PRIMARY KEY (GuardianID)
);
GO

CREATE TABLE Contract (
    ContractID  INT IDENTITY(1,1) NOT NULL,
    StartDate   DATE  NOT NULL,
    EndDate     DATE  NOT NULL,
    StudentID   CHAR(5) NOT NULL,
    TutorID     CHAR(5) NOT NULL,
    CourseID    CHAR(5) NOT NULL,
    PRIMARY KEY (ContractID),
    FOREIGN KEY (StudentID) REFERENCES Student(StudentID),
    FOREIGN KEY (TutorID) REFERENCES Tutor(TutorID),
    FOREIGN KEY (CourseID) REFERENCES Course(CourseID),
    CHECK (EndDate > StartDate)
);
GO


CREATE TABLE MinorStudent (
    StudentID                  CHAR(5) NOT NULL,
    EmergencyContactGuardianID CHAR(5) NOT NULL,
    PRIMARY KEY (StudentID),
    FOREIGN KEY (StudentID) REFERENCES Student(StudentID),
    FOREIGN KEY (EmergencyContactGuardianID) REFERENCES Guardian(GuardianID),
    UNIQUE (EmergencyContactGuardianID)
);
GO

CREATE TABLE Tutor_Specialty (
    TutorID   CHAR(5)     NOT NULL,
    Specialty VARCHAR(30) NOT NULL,
    PRIMARY KEY (TutorID, Specialty),
    FOREIGN KEY (TutorID) REFERENCES Tutor(TutorID) ON DELETE CASCADE
);
GO


CREATE TABLE Course_Requires_Course (
    CourseID       CHAR(5) NOT NULL,
    PrereqCourseID CHAR(5) NOT NULL,
    PRIMARY KEY (CourseID, PrereqCourseID),
    FOREIGN KEY (CourseID) REFERENCES Course(CourseID),
    FOREIGN KEY (PrereqCourseID) REFERENCES Course(CourseID),
    CHECK (CourseID <> PrereqCourseID)
);
GO

CREATE TABLE Guardian_Responsible_MinorStudent (
    GuardianID            CHAR(5)     NOT NULL,
    StudentID             CHAR(5)     NOT NULL,
    RelationshipToStudent VARCHAR(20) NOT NULL,
    PRIMARY KEY (GuardianID, StudentID),
    FOREIGN KEY (GuardianID) REFERENCES Guardian(GuardianID),
    FOREIGN KEY (StudentID) REFERENCES MinorStudent(StudentID)
);
GO

CREATE TABLE Contract_Session (
    ContractID  INT         NOT NULL,
    SessionDay  VARCHAR(10) NOT NULL,
    StartTime   TIME        NOT NULL,
    EndTime     TIME        NOT NULL,
    PRIMARY KEY (ContractID, SessionDay),
    FOREIGN KEY (ContractID) REFERENCES Contract(ContractID) ON DELETE CASCADE,
    CHECK (SessionDay IN ('Monday','Tuesday','Wednesday','Thursday','Friday','Saturday','Sunday')),
    CHECK (EndTime > StartTime)
);
GO

CREATE TABLE Payment (
    PaymentID   INT IDENTITY(1,1) NOT NULL,
    Amount      DECIMAL(8,2) NOT NULL,
    PaymentDate DATE         NOT NULL,
    ContractID  INT          NOT NULL,
    PRIMARY KEY (PaymentID),
    FOREIGN KEY (ContractID) REFERENCES Contract(ContractID),
    CHECK (Amount > 0)
);
GO
