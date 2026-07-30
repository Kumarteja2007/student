CREATE DATABASE student_login;
USE student_login;

CREATE TABLE students(
    id INT AUTO_INCREMENT PRIMARY KEY,
    student_id VARCHAR(20) UNIQUE,
    full_name VARCHAR(100),
    username VARCHAR(50) UNIQUE NOT NULL,
    email_id VARCHAR(60),
    mobile VARCHAR(15),
    degree VARCHAR(30),
    degree_period VARCHAR(20),
    department VARCHAR(100),
    section VARCHAR(10),
    semester INT,
    father_name VARCHAR(100),
    father_mobile VARCHAR(15),
    mother_name VARCHAR(100),
    mother_mobile VARCHAR(15),
    parent_email VARCHAR(100),
    password VARCHAR(255) NOT NULL
);

CREATE TABLE marks(
    id INT AUTO_INCREMENT PRIMARY KEY,
    student_id VARCHAR(20),
    semester INT,
    subject VARCHAR(100),
    mid1 INT,
    mid2 INT,
    internal_marks INT,
    final_exam INT,
    FOREIGN KEY(student_id) REFERENCES students(student_id)
);

CREATE TABLE attendance(
    id INT AUTO_INCREMENT PRIMARY KEY,
    student_id VARCHAR(20) NOT NULL,
    subject VARCHAR(100) NOT NULL,
    classes_present INT DEFAULT 0,
    total_classes INT DEFAULT 0,
    FOREIGN KEY(student_id) REFERENCES students(student_id)
);

CREATE TABLE timetable(
    id INT AUTO_INCREMENT PRIMARY KEY,
    semester INT,
    day_name VARCHAR(20),
    period1 VARCHAR(100),
    period2 VARCHAR(100),
    period3 VARCHAR(100),
    period4 VARCHAR(100),
    period5 VARCHAR(100),
    period6 VARCHAR(100)
);

CREATE TABLE course_materials(
    id INT AUTO_INCREMENT PRIMARY KEY,
    subject VARCHAR(100),
    file_name VARCHAR(255),
    file_path VARCHAR(255),
    uploaded_on TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE notifications(
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(150),
    message TEXT,
    posted_on TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);