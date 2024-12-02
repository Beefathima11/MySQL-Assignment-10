create database Teachers;
use Teachers;
-- Create the teachers table
CREATE TABLE teachers (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100),
    subject VARCHAR(50),
    experience INT,
    salary DECIMAL(10, 2)
);

-- Insert 8 rows into the teachers table
INSERT INTO teachers (name, subject, experience, salary) VALUES
('John Doe', 'Mathematics', 12, 50000),
('Jane Smith', 'Science', 8, 45000),
('Alice Johnson', 'English', 15, 60000),
('Mark Brown', 'History', 5, 40000),
('Emily Davis', 'Physics', 20, 75000),
('Michael Wilson', 'Biology', 10, 55000),
('Sarah Taylor', 'Chemistry', 3, 38000),
('David White', 'Geography', 7, 42000);

DELIMITER $$

CREATE TRIGGER before_insert_teacher
BEFORE INSERT ON teachers
FOR EACH ROW
BEGIN
    IF NEW.salary < 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Salary cannot be negative';
    END IF;
END $$

DELIMITER ;
CREATE TABLE teacher_log (
    teacher_id INT,           -- References ID of the teacher inserted
    action VARCHAR(50),       -- Action performed (e.g., INSERT, DELETE)
    timestamp DATETIME        -- Time the action occurred
);
-- Example entries
INSERT INTO teacher_log (teacher_id, action, timestamp) 
VALUES 
(1, 'INSERT', '2024-11-01 09:00:00'),
(2, 'INSERT', '2024-11-02 10:30:00'),
(3, 'DELETE', '2024-11-05 14:15:00'),
(4, 'INSERT', '2024-11-10 12:00:00'),
(3, 'INSERT', '2024-11-11 16:45:00'),
(5, 'DELETE', '2024-11-12 18:20:00'),
(6, 'INSERT', '2024-11-15 08:00:00'),
(7, 'DELETE', '2024-11-18 19:50:00');
-- Create the teacher_log table
CREATE TABLE teacher_log (
    teacher_id INT,
    action VARCHAR(50),
    timestamp DATETIME
);

DELIMITER $$

CREATE TRIGGER after_insert_teacher
AFTER INSERT ON teachers
FOR EACH ROW
BEGIN
    INSERT INTO teacher_log (teacher_id, action, timestamp)
    VALUES (NEW.id, 'INSERT', NOW());
END $$

DELIMITER ;
-- Valid insertion
INSERT INTO teachers (name, subject, experience, salary) 
VALUES ('Paul Green', 'Art', 4, 30000);
select * from teacher_log;

DELIMITER $$

CREATE TRIGGER before_delete_teacher
BEFORE DELETE ON teachers
FOR EACH ROW
BEGIN
    IF OLD.experience > 10 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Cannot delete a teacher with experience greater than 10 years';
    END IF;
END $$

DELIMITER ;
-- This will raise an error if the teacher has more than 10 years of experience
DELETE FROM teachers WHERE id = 1;

DELIMITER $$

CREATE TRIGGER after_delete_teacher
AFTER DELETE ON teachers
FOR EACH ROW
BEGIN
    INSERT INTO teacher_log (teacher_id, action, timestamp)
    VALUES (OLD.id, 'DELETE', NOW());
END $$

DELIMITER ;

-- Valid deletion
DELETE FROM teachers WHERE id = 4;
select * from teacher_log;