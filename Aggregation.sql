-----------------------Step 1:
Create database Aggregation
use Aggregation;

CREATE TABLE Instructors (
InstructorID INT PRIMARY KEY,
FullName VARCHAR(100),
Email VARCHAR(100),
JoinDate DATE
);
CREATE TABLE Categories (
CategoryID INT PRIMARY KEY,
CategoryName VARCHAR(50)
);
CREATE TABLE Courses (
CourseID INT PRIMARY KEY,
Title VARCHAR(100),
InstructorID INT,
CategoryID INT,
Price DECIMAL(6,2),
PublishDate DATE,
FOREIGN KEY (InstructorID) REFERENCES Instructors(InstructorID),
FOREIGN KEY (CategoryID) REFERENCES Categories(CategoryID)
);
CREATE TABLE Students (
StudentID INT PRIMARY KEY,
FullName VARCHAR(100),
Email VARCHAR(100),
JoinDate DATE
);
CREATE TABLE Enrollments (
EnrollmentID INT PRIMARY KEY,
StudentID INT,
CourseID INT,
EnrollDate DATE,
CompletionPercent INT,
Rating INT CHECK (Rating BETWEEN 1 AND 5),
FOREIGN KEY (StudentID) REFERENCES Students(StudentID),
FOREIGN KEY (CourseID) REFERENCES Courses(CourseID)
);
-----------------------Step 2:
INSERT INTO Instructors VALUES
(1, 'Sarah Ahmed', 'sarah@learnhub.com', '2023-01-10'),
(2, 'Mohammed Al-Busaidi', 'mo@learnhub.com', '2023-05-21');
select* from Instructors 

INSERT INTO Categories VALUES
(1, 'Web Development'),
(2, 'Data Science'),
(3, 'Business');
select* from Categories

INSERT INTO Courses VALUES
(101, 'HTML & CSS Basics', 1, 1, 29.99, '2023-02-01'),
(102, 'Python for Data Analysis', 2, 2, 49.99, '2023-03-15'),
(103, 'Excel for Business', 2, 3, 19.99, '2023-04-10'),
(104, 'JavaScript Advanced', 1, 1, 39.99, '2023-05-01');
select* from Courses

INSERT INTO Students VALUES
(201, 'Ali Salim', 'ali@student.com', '2023-04-01'),
(202, 'Layla Nasser', 'layla@student.com', '2023-04-05'),
(203, 'Ahmed Said', 'ahmed@student.com', '2023-04-10');
select* from Students

INSERT INTO Enrollments VALUES
(1, 201, 101, '2023-04-10', 100, 5),
(2, 202, 102, '2023-04-15', 80, 4),
(3, 203, 101, '2023-04-20', 90, 4),
(4, 201, 102, '2023-04-22', 50, 3),
(5, 202, 103, '2023-04-25', 70, 4),
(6, 203, 104, '2023-04-28', 30, 2),
(7, 201, 104, '2023-05-01', 60, 3);
select* from Enrollments
-----------------------Part 1:
SELECT Title, Price
FROM Courses;

SELECT FullName, JoinDate
FROM Students;

SELECT EnrollmentID, CompletionPercent, Rating
FROM Enrollments;

SELECT COUNT(*) AS InstructorCount
FROM Instructors
WHERE YEAR(JoinDate) = 2023;

SELECT COUNT(*) AS StudentCount
FROM Students
WHERE YEAR(JoinDate) = 2023
  AND MONTH(JoinDate) = 4;
-----------------------Part 2:
SELECT COUNT(*) AS TotalStudents
FROM Students;

SELECT COUNT(*) AS TotalEnrollments
FROM Enrollments;

SELECT CourseID, AVG(Rating) AS AverageRating
FROM Enrollments
GROUP BY CourseID;

SELECT InstructorID, COUNT(*) AS CourseCount
FROM Courses
GROUP BY InstructorID;

SELECT CategoryID, COUNT(*) AS CourseCount
FROM Courses
GROUP BY CategoryID;

SELECT CourseID, COUNT(StudentID) AS StudentCount
FROM Enrollments
GROUP BY CourseID;

SELECT CategoryID, AVG(Price) AS AveragePrice
FROM Courses
GROUP BY CategoryID;

SELECT MAX(Price) AS MaxCoursePrice
FROM Courses;

SELECT CourseID,
       MIN(Rating) AS MinRating,
       MAX(Rating) AS MaxRating,
       AVG(Rating) AS AvgRating
FROM Enrollments
GROUP BY CourseID;

SELECT COUNT(*) AS FiveStarRatings
FROM Enrollments
WHERE Rating = 5;
-----------------------Part 3:
SELECT MONTH(EnrollDate) AS EnrollMonth,
       COUNT(*) AS EnrollmentCount
FROM Enrollments
GROUP BY MONTH(EnrollDate)

SELECT AVG(Price) AS AverageCoursePrice
FROM Courses;

SELECT MONTH(JoinDate) AS JoinMonth,
       COUNT(*) AS StudentCount
FROM Students
GROUP BY MONTH(JoinDate);

SELECT Rating, COUNT(*) AS RatingCount
FROM Enrollments
GROUP BY Rating;

SELECT CourseID
FROM Enrollments
GROUP BY CourseID
HAVING MAX(Rating) < 5;

SELECT COUNT(*) AS CoursesAbove30
FROM Courses
WHERE Price > 30;

SELECT AVG(CompletionPercent) AS AvgCompletion
FROM Enrollments;

SELECT TOP 1 CourseID, AVG(Rating) AS AvgRating
FROM Enrollments
GROUP BY CourseID
ORDER BY AvgRating ASC;

SELECT c.Title,
       COUNT(e.EnrollmentID) AS TotalEnrollments,
       AVG(e.Rating) AS AvgRating,
       AVG(e.CompletionPercent) AS AvgCompletion
FROM Courses c
JOIN Enrollments e ON c.CourseID = e.CourseID
GROUP BY c.Title;

SELECT c.Title, AVG(e.Rating) AS AvgRating
FROM Courses c
JOIN Enrollments e ON c.CourseID = e.CourseID
GROUP BY c.Title
HAVING AVG(e.Rating) >= 4;
-----------------------Part 4:
SELECT c.Title,
       i.FullName AS InstructorName,
       COUNT(e.EnrollmentID) AS TotalEnrollments
FROM Courses c
JOIN Instructors i ON c.InstructorID = i.InstructorID
LEFT JOIN Enrollments e ON c.CourseID = e.CourseID
GROUP BY c.Title, i.FullName;

SELECT cat.CategoryName,
       COUNT(c.CourseID) AS TotalCourses,
       AVG(c.Price) AS AvgPrice
FROM Categories cat
LEFT JOIN Courses c ON cat.CategoryID = c.CategoryID
GROUP BY cat.CategoryName;

SELECT i.FullName,
       AVG(e.Rating) AS AvgRating
FROM Instructors i
JOIN Courses c ON i.InstructorID = c.InstructorID
JOIN Enrollments e ON c.CourseID = e.CourseID
GROUP BY i.FullName;

SELECT s.FullName,
       COUNT(e.CourseID) AS TotalCourses
FROM Students s
JOIN Enrollments e ON s.StudentID = e.StudentID
GROUP BY s.FullName;

SELECT cat.CategoryName,
       COUNT(e.EnrollmentID) AS TotalEnrollments
FROM Categories cat
JOIN Courses c ON cat.CategoryID = c.CategoryID
JOIN Enrollments e ON c.CourseID = e.CourseID
GROUP BY cat.CategoryName;

SELECT i.FullName,
       SUM(c.Price) AS TotalRevenue
FROM Instructors i
JOIN Courses c ON i.InstructorID = c.InstructorID
JOIN Enrollments e ON c.CourseID = e.CourseID
GROUP BY i.FullName;

SELECT c.Title,
       (SUM(CASE WHEN e.CompletionPercent = 100 THEN 1 ELSE 0 END) * 100.0
       / COUNT(e.EnrollmentID)) AS Completion100Percent
FROM Courses c
JOIN Enrollments e ON c.CourseID = e.CourseID
GROUP BY c.Title;
-----------------------Part 5:
SELECT c.Title,
       COUNT(e.EnrollmentID) AS TotalEnrollments
FROM Courses c
JOIN Enrollments e ON c.CourseID = e.CourseID
GROUP BY c.Title
HAVING COUNT(e.EnrollmentID) > 2;

SELECT i.FullName,
       AVG(e.Rating) AS AvgRating
FROM Instructors i
JOIN Courses c ON i.InstructorID = c.InstructorID
JOIN Enrollments e ON c.CourseID = e.CourseID
GROUP BY i.FullName
HAVING AVG(e.Rating) > 4;

SELECT c.Title,
       AVG(e.CompletionPercent) AS AvgCompletion
FROM Courses c
JOIN Enrollments e ON c.CourseID = e.CourseID
GROUP BY c.Title
HAVING AVG(e.CompletionPercent) < 60;

SELECT cat.CategoryName,
       COUNT(c.CourseID) AS TotalCourses
FROM Categories cat
JOIN Courses c ON cat.CategoryID = c.CategoryID
GROUP BY cat.CategoryName
HAVING COUNT(c.CourseID) > 1;

SELECT s.FullName,
       COUNT(e.CourseID) AS TotalCourses
FROM Students s
JOIN Enrollments e ON s.StudentID = e.StudentID
GROUP BY s.FullName
HAVING COUNT(e.CourseID) >= 2;
-----------------------Part 6:
SELECT TOP 1 c.Title,
       AVG(e.Rating) AS AvgRating
FROM Courses c
JOIN Enrollments e ON c.CourseID = e.CourseID
GROUP BY c.Title
ORDER BY AvgRating DESC;

SELECT TOP 1 i.FullName,
       AVG(e.Rating) AS AvgRating
FROM Instructors i
JOIN Courses c ON i.InstructorID = c.InstructorID
JOIN Enrollments e ON c.CourseID = e.CourseID
GROUP BY i.FullName
ORDER BY AvgRating DESC;

SELECT TOP 1 cat.CategoryName,
       SUM(c.Price) AS TotalRevenue
FROM Categories cat
JOIN Courses c ON cat.CategoryID = c.CategoryID
JOIN Enrollments e ON c.CourseID = e.CourseID
GROUP BY cat.CategoryName
ORDER BY TotalRevenue DESC;

SELECT c.Title, c.Price, AVG(e.Rating) AS AvgRating
FROM Courses c
JOIN Enrollments e ON c.CourseID = e.CourseID
GROUP BY c.Title, c.Price
ORDER BY c.Price DESC;
-----------There is no relationship between them (price and the rating).

SELECT c.Title, c.Price, AVG(e.CompletionPercent) AS AvgCompletion
FROM Courses c
JOIN Enrollments e ON c.CourseID = e.CourseID
GROUP BY c.Title, c.Price
ORDER BY c.Price ASC;
------------------- Lower-priced courses are easier to complete.

-------------------Final Challenge:
SELECT TOP 3 c.Title,
       SUM(c.Price) AS Revenue
FROM Courses c
JOIN Enrollments e ON c.CourseID = e.CourseID
GROUP BY c.Title
ORDER BY Revenue DESC;

SELECT TOP 1 i.FullName,
       COUNT(e.EnrollmentID) AS TotalEnrollments
FROM Instructors i
JOIN Courses c ON i.InstructorID = c.InstructorID
JOIN Enrollments e ON c.CourseID = e.CourseID
GROUP BY i.FullName
ORDER BY TotalEnrollments DESC;

SELECT TOP 1 c.Title,
       AVG(e.CompletionPercent) AS AvgCompletion
FROM Courses c
JOIN Enrollments e ON c.CourseID = e.CourseID
GROUP BY c.Title
ORDER BY AvgCompletion ASC;

SELECT TOP 1 cat.CategoryName,
       AVG(e.Rating) AS AvgRating
FROM Categories cat
JOIN Courses c ON cat.CategoryID = c.CategoryID
JOIN Enrollments e ON c.CourseID = e.CourseID
GROUP BY cat.CategoryName
ORDER BY AvgRating DESC;

SELECT TOP 1 s.FullName,
       COUNT(e.CourseID) AS TotalCourses
FROM Students s
JOIN Enrollments e ON s.StudentID = e.StudentID
GROUP BY s.FullName
ORDER BY TotalCourses DESC;

