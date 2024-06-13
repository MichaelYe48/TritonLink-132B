CREATE TABLE Student (
    SSN VARCHAR(12) PRIMARY KEY,
    First_name VARCHAR(50),
    Middle_name VARCHAR(50),
    Last_name VARCHAR(50),
    Residency_status VARCHAR(20),
    Student_ID INT
);

CREATE TABLE Undergraduate_student (
    SSN VARCHAR(12) PRIMARY KEY,
    College VARCHAR(100),
    Major VARCHAR(100),
    Minor VARCHAR(100),
    "5_year_MS_program" BOOLEAN,
    FOREIGN KEY (SSN) REFERENCES Student(SSN)
);

CREATE TABLE Graduate_student (
    SSN VARCHAR(12) PRIMARY KEY,
    Department VARCHAR(100),
    FOREIGN KEY (SSN) REFERENCES Student(SSN)
);

CREATE TABLE Masters_student (
    SSN VARCHAR(12) PRIMARY KEY,
    "5_year_MS_program" BOOLEAN,
    FOREIGN KEY (SSN) REFERENCES Student(SSN)
);

CREATE TABLE Phd_student (
    SSN VARCHAR(12) PRIMARY KEY,
    FOREIGN KEY (SSN) REFERENCES Student(SSN)
);

CREATE TABLE Precandidacy (
    SSN VARCHAR(12) PRIMARY KEY,
    FOREIGN KEY (SSN) REFERENCES Student(SSN)
);

CREATE TABLE Category (
    Category_name VARCHAR(100) PRIMARY KEY,
    Minimum_average_grade FLOAT,
    Units INT
);

CREATE TABLE Degree (
    Degree_name VARCHAR(100),
    Degree_Type VARCHAR(50),
    University VARCHAR(100),
    Total_units INT,
    PRIMARY KEY (Degree_name, Degree_type), 
    CONSTRAINT unique_degree_info UNIQUE (Degree_name, Degree_Type, University) 
);

CREATE TABLE Department (
    Department_name VARCHAR(100) PRIMARY KEY
);

CREATE TABLE Candidates (
    SSN VARCHAR(12) PRIMARY KEY,
    Advisors VARCHAR(150),
    Thesis_commitee VARCHAR(150),
    FOREIGN KEY (SSN) REFERENCES Student(SSN)
);

CREATE TABLE Probation (
    SSN VARCHAR(12),
    Reason VARCHAR(200),
    Start_Quarter VARCHAR(50),
    End_Quarter VARCHAR(50),
    Start_Year INT,
    End_Year INT,
    PRIMARY KEY (SSN, Start_Quarter, End_Quarter, Start_Year, End_Year),
    FOREIGN KEY (SSN) REFERENCES Student(SSN)
);

CREATE TABLE Dates (
    Start_Quarter VARCHAR(50),
    End_Quarter VARCHAR(50),
    Start_Year INT,
    End_Year INT,
    PRIMARY KEY (Start_Quarter, End_Quarter, Start_Year, End_Year)
);

CREATE TABLE Course (
    Course_number INT PRIMARY KEY,
    Course_consent VARCHAR(20),
    Grade_type VARCHAR(20),
    Lab BOOLEAN,
    Units INT,
    Prerequisites VARCHAR(200),
    CONSTRAINT unique_course_number UNIQUE (Course_number)
);

CREATE TABLE Class (
    Course_number INT,
    Title VARCHAR(100),
    Quarter VARCHAR(50),
    Year INT,
    PRIMARY KEY (Course_number, Title, Quarter, Year),
    FOREIGN KEY (Course_number) REFERENCES Course(Course_number)
);

CREATE TABLE Section (
    Section_id INT PRIMARY KEY,
    Enroll_limit INT,
    Number_enrolled INT
);

CREATE TABLE Meeting (
    Section_id INT,
    Meeting_type VARCHAR(50),
    Location VARCHAR(100),
    Mandatory BOOLEAN,
    Meeting_frequency VARCHAR(50),
    Start_date DATE,
    End_date DATE,
    Day VARCHAR(50),
    Start_time TIME,
    End_time TIME,
    PRIMARY KEY (Section_id, Start_date, Start_time),
    FOREIGN KEY (Section_id) REFERENCES Section(Section_id)
);

CREATE TABLE Faculty (
    First_name VARCHAR(50),
    Middle_name VARCHAR(50),
    Last_name VARCHAR(50),
    Title VARCHAR(100),
    PRIMARY KEY (First_name, Middle_name, Last_name)
);

CREATE TABLE Account_information (
    SSN VARCHAR(12) PRIMARY KEY,
    Street VARCHAR(100),
    City VARCHAR(100),
    State VARCHAR(50),
    Zip_code VARCHAR(20),
    Financial_aid FLOAT,
    Tuition_fees FLOAT,
    Account_balance FLOAT,
    Payment_history VARCHAR(200),
    Outstanding_charges FLOAT,
    Transaction_history VARCHAR(200),
    FOREIGN KEY (SSN) REFERENCES Student(SSN)
);

CREATE TABLE Advises (
    SSN VARCHAR(12),
    First_Name VARCHAR(50),
    Middle_Name VARCHAR(50),
    Last_Name VARCHAR(50),
    PRIMARY KEY (SSN, First_Name, Middle_Name, Last_Name),
    FOREIGN KEY (SSN) REFERENCES Candidates(SSN),
    FOREIGN KEY (First_Name, Middle_Name, Last_Name) REFERENCES Faculty(First_name, Middle_name, Last_name)
);

-- CREATE TABLE Is_On_Probation (
--     SSN VARCHAR(10),
--     Probation_Start_Quarter VARCHAR(50),
--     Probation_End_Quarter VARCHAR(50),
--     Probation_Start_Year INT,
--     Probation_End_Year INT,
--     PRIMARY KEY (SSN, Probation_Start_Quarter, Probation_End_Quarter, Probation_Start_Year, Probation_End_Year),
--     FOREIGN KEY (SSN) REFERENCES Student(SSN)
-- );

CREATE TABLE Dates_Attended (
    SSN VARCHAR(12),
    Start_Quarter VARCHAR(50),
    End_Quarter VARCHAR(50),
    Start_Year INT,
    End_Year INT,
    PRIMARY KEY (SSN, Start_Quarter, End_Quarter, Start_Year, End_Year),
    FOREIGN KEY (SSN) REFERENCES Student(SSN)
);

CREATE TABLE Student_Account_Information (
    SSN VARCHAR(12),
    Street VARCHAR(100),
    City VARCHAR(100),
    State VARCHAR(50),
    Zip_code VARCHAR(20),
    PRIMARY KEY (SSN),
    FOREIGN KEY (SSN) REFERENCES Student(SSN)
);

CREATE TABLE Enrolled_In (
    SSN VARCHAR(12),
    Course_Number INT,
    Title VARCHAR(100),
    Section_id INT,
    Quarter VARCHAR(50),
    Year INT,
    Taken BOOLEAN,
    Grade_Achieved VARCHAR(10),
    PRIMARY KEY (SSN, Course_Number, Title, Section_id, Quarter),
    FOREIGN KEY (SSN) REFERENCES Student(SSN),
    FOREIGN KEY (Course_number) REFERENCES Course(Course_number),
    FOREIGN KEY (Section_id) REFERENCES Section(Section_id),
    FOREIGN KEY (Course_number, Title, Quarter, Year) REFERENCES Class(Course_number, Title, Quarter, Year)
);


CREATE TABLE Offered_As (
    Course_Number INT,
    Year INT,
    Title VARCHAR(100),
    Quarter VARCHAR(50),
    PRIMARY KEY (Course_Number, Year, Title, Quarter),
    FOREIGN KEY (Course_Number) REFERENCES Course(Course_number)
);

CREATE TABLE Concentration (
    Degree_Type VARCHAR(50),
    Degree_Name VARCHAR(100),
    University VARCHAR(100),
    Course_Number INT,
    Concentration_Name VARCHAR(100),
    Minimum_GPA INT,
    Units INT,
    PRIMARY KEY (Degree_Type, University, Course_Number, Concentration_Name),
    FOREIGN KEY (Degree_name, Degree_Type, University) REFERENCES Degree(Degree_name, Degree_Type, University),
    FOREIGN KEY (Course_Number) REFERENCES Course(Course_number)
);

CREATE TABLE Has_Degree (
    SSN VARCHAR(12),
    Degree_Type VARCHAR(50),
    Degree_name VARCHAR(100),
    University VARCHAR(100),
    FOREIGN KEY (SSN) REFERENCES Student(SSN),
    FOREIGN KEY (Degree_name, Degree_Type, University) REFERENCES Degree(Degree_name, Degree_Type, University)
);


CREATE TABLE Given_By (
    Degree_Type VARCHAR(50),
    Degree_Name VARCHAR(100),
    University VARCHAR(100),
    Department_Name VARCHAR(100),
    PRIMARY KEY (Degree_Type, Degree_Name, University, Department_Name),
    FOREIGN KEY (Degree_Type, Degree_Name, University) REFERENCES Degree(Degree_Type, Degree_Name, University),
    FOREIGN KEY (Department_Name) REFERENCES Department(Department_name)
);

CREATE TABLE Consists_of_Sections (
    Section_ID INT,
    Course_number INT, 
    Year INT,
    Title VARCHAR(100),
    Quarter VARCHAR(50),
    PRIMARY KEY (Section_ID, Course_number, Year, Title, Quarter),
    FOREIGN KEY (Section_ID) REFERENCES Section(Section_id),
    FOREIGN KEY (Course_number, Title, Quarter, Year) REFERENCES Class(Course_number, Title, Quarter, Year)
);

CREATE TABLE Belongs_Under (
    Course_Number INT,
    Department_Name VARCHAR(100),
    PRIMARY KEY (Course_Number, Department_Name),
    FOREIGN KEY (Course_Number) REFERENCES Course(Course_number),
    FOREIGN KEY (Department_Name) REFERENCES Department(Department_name)
);

CREATE TABLE Courses_In_Category (
    Course_Number INT,
    Category_Name VARCHAR(100),
    PRIMARY KEY (Course_Number, Category_Name),
    FOREIGN KEY (Course_Number) REFERENCES Course(Course_number),
    FOREIGN KEY (Category_Name) REFERENCES Category(Category_Name)
);

CREATE TABLE Composed_Of (
    Category_Name VARCHAR(100),
    Degree_Type VARCHAR(50),
    Degree_Name VARCHAR(100),
    University VARCHAR(100),
    PRIMARY KEY (Category_Name, Degree_Type, Degree_Name, University),
    FOREIGN KEY (Degree_Type, Degree_Name, University) REFERENCES Degree(Degree_Type, Degree_Name, University),
    FOREIGN KEY (Category_Name) REFERENCES Category(Category_name)
);

CREATE TABLE Works_Under (
    Department_Name VARCHAR(100),
    First_Name VARCHAR(50),
    Middle_Name VARCHAR(50),
    Last_Name VARCHAR(50),
    PRIMARY KEY (Department_Name, First_Name, Middle_Name, Last_Name),
    FOREIGN KEY (Department_Name) REFERENCES Department(Department_name),
    FOREIGN KEY (First_Name, Middle_Name, Last_Name) REFERENCES Faculty(First_name, Middle_name, Last_name)
);

CREATE TABLE Studies_Under (
    SSN VARCHAR(12),
    Department_Name VARCHAR(100),
    PRIMARY KEY (SSN, Department_Name),
    FOREIGN KEY (SSN) REFERENCES Student(SSN),
    FOREIGN KEY (Department_Name) REFERENCES Department(Department_name)
);

CREATE TABLE Has_Meeting (
    Section_ID INT,
    Start_Time TIME,
    End_Time TIME,
    PRIMARY KEY (Section_ID, Start_Time),
    FOREIGN KEY (Section_ID) REFERENCES Section(Section_id)
);

CREATE TABLE Taught_By (
    Section_ID INT,
    First_Name VARCHAR(50),
    Middle_Name VARCHAR(50),
    Last_Name VARCHAR(50),
    PRIMARY KEY (Section_ID, First_Name, Middle_Name, Last_Name),
    FOREIGN KEY (Section_ID) REFERENCES Section(Section_id),
    FOREIGN KEY (First_Name, Middle_Name, Last_Name) REFERENCES Faculty(First_name, Middle_name, Last_name)
);

CREATE TABLE Thesis_Committee (
    SSN VARCHAR(12),
    Thesis_Id INT,
    First_Name VARCHAR(50),
    Middle_Name VARCHAR(50),
    Last_Name VARCHAR(50),
    PRIMARY KEY (SSN, Thesis_Id, First_Name, Middle_Name, Last_Name),
    FOREIGN KEY (SSN) REFERENCES Student(SSN),
    FOREIGN KEY (First_Name, Middle_Name, Last_Name) REFERENCES Faculty(First_name, Middle_name, Last_name)
);

CREATE TABLE Is_Waitlisted (
    SSN VARCHAR(12),
    Section_ID INT,
    PRIMARY KEY (SSN, Section_ID),
    FOREIGN KEY (SSN) REFERENCES Student(SSN),
    FOREIGN KEY (Section_ID) REFERENCES Section(Section_id)
);

create table GRADE_CONVERSION(
            LETTER_GRADE CHAR(2) NOT NULL,
            NUMBER_GRADE DECIMAL(2,1)
);

-- Create trigger function
CREATE OR REPLACE FUNCTION check_enrollment_limit()
RETURNS TRIGGER AS $$
DECLARE
    current_enrollment INT;
    enrollment_limit INT;
BEGIN
    -- Get the current number of enrolled students for the section
    SELECT Number_enrolled INTO current_enrollment
    FROM Section
    WHERE Section_id = NEW.Section_id;

    -- Get the enrollment limit for the section
    SELECT Enroll_limit INTO enrollment_limit
    FROM Section
    WHERE Section_id = NEW.Section_id;

    -- Check if the enrollment limit has been reached
    IF current_enrollment >= enrollment_limit THEN
        RAISE EXCEPTION 'Enrollment limit of % for section % has been reached. Cannot enroll more students.',
                        enrollment_limit, NEW.Section_id;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- create trigger for enrolled_in
CREATE TRIGGER trigger_check_enrollment_limit
BEFORE INSERT ON Enrolled_In
FOR EACH ROW
EXECUTE FUNCTION check_enrollment_limit();

-- trigger function for incrementing count
CREATE OR REPLACE FUNCTION increment_enrollment_count()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE Section
    SET Number_enrolled = Number_enrolled + 1
    WHERE Section_id = NEW.Section_id;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- creating trigger for insert
CREATE TRIGGER trigger_increment_enrollment_count
AFTER INSERT ON Enrolled_In
FOR EACH ROW
EXECUTE FUNCTION increment_enrollment_count();

-- creating trigger function for decrement
CREATE OR REPLACE FUNCTION decrement_enrollment_count()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE Section
    SET Number_enrolled = Number_enrolled - 1
    WHERE Section_id = OLD.Section_id;
    RETURN OLD;
END;
$$ LANGUAGE plpgsql;

-- create trigger for delete
CREATE TRIGGER trigger_decrement_enrollment_count
AFTER DELETE ON Enrolled_In
FOR EACH ROW
EXECUTE FUNCTION decrement_enrollment_count();

CREATE TABLE CPQG AS
SELECT 
    e.Course_Number AS Course_Number,
    TRIM(CONCAT_WS(' ', t.First_Name, t.Middle_Name, t.Last_Name)) AS Professor_Name,
    e.Quarter,
    e.Year,
    SUM(CASE WHEN e.Grade_Achieved LIKE 'A%' THEN 1 ELSE 0 END) AS A,
    SUM(CASE WHEN e.Grade_Achieved LIKE 'B%' THEN 1 ELSE 0 END) AS B,
    SUM(CASE WHEN e.Grade_Achieved LIKE 'C%' THEN 1 ELSE 0 END) AS C,
    SUM(CASE WHEN e.Grade_Achieved LIKE 'D%' THEN 1 ELSE 0 END) AS D,
    SUM(CASE WHEN e.Grade_Achieved NOT LIKE 'A%' 
                   AND e.Grade_Achieved NOT LIKE 'B%' 
                   AND e.Grade_Achieved NOT LIKE 'C%' 
                   AND e.Grade_Achieved NOT LIKE 'D%' THEN 1 ELSE 0 END) AS Other
FROM 
    Enrolled_In e
JOIN 
    Taught_By t ON e.Section_id = t.Section_ID
GROUP BY 
    e.Course_Number, Professor_Name, e.Quarter, e.Year;

CREATE TABLE CPG AS
SELECT 
    e.Course_Number AS Course_Number,
    TRIM(CONCAT_WS(' ', t.First_Name, t.Middle_Name, t.Last_Name)) AS Professor_Name,
    SUM(CASE WHEN e.Grade_Achieved LIKE 'A%' THEN 1 ELSE 0 END) AS A,
    SUM(CASE WHEN e.Grade_Achieved LIKE 'B%' THEN 1 ELSE 0 END) AS B,
    SUM(CASE WHEN e.Grade_Achieved LIKE 'C%' THEN 1 ELSE 0 END) AS C,
    SUM(CASE WHEN e.Grade_Achieved LIKE 'D%' THEN 1 ELSE 0 END) AS D,
    SUM(CASE WHEN e.Grade_Achieved NOT LIKE 'A%' 
                   AND e.Grade_Achieved NOT LIKE 'B%' 
                   AND e.Grade_Achieved NOT LIKE 'C%' 
                   AND e.Grade_Achieved NOT LIKE 'D%' THEN 1 ELSE 0 END) AS Other
FROM 
    Enrolled_In e
JOIN 
    Taught_By t ON e.Section_id = t.Section_ID
WHERE NOT (e.Quarter = 'Spring' AND e.Year = 2018)
GROUP BY 
    e.Course_Number, Professor_Name;

-- Trigger for updating CPQG table
CREATE OR REPLACE FUNCTION update_CPQG()
RETURNS TRIGGER AS
$$
BEGIN
    -- Check if the inserted grade matches A, B, C, D or Other
    IF NEW.Grade_Achieved LIKE 'A%' THEN
        UPDATE CPQG
        SET A = A + 1
        WHERE Course_Number = NEW.Course_Number
        AND Professor_Name = (SELECT TRIM(CONCAT_WS(' ', First_Name, Middle_Name, Last_Name)) FROM Taught_By WHERE Section_ID = NEW.Section_ID)
        AND Quarter = NEW.Quarter
        AND Year = NEW.Year;
    ELSIF NEW.Grade_Achieved LIKE 'B%' THEN
        UPDATE CPQG
        SET B = B + 1
        WHERE Course_Number = NEW.Course_Number
        AND Professor_Name = (SELECT TRIM(CONCAT_WS(' ', First_Name, Middle_Name, Last_Name)) FROM Taught_By WHERE Section_ID = NEW.Section_ID)
        AND Quarter = NEW.Quarter
        AND Year = NEW.Year;
    ELSIF NEW.Grade_Achieved LIKE 'C%' THEN
        UPDATE CPQG
        SET C = C + 1
        WHERE Course_Number = NEW.Course_Number
        AND Professor_Name = (SELECT TRIM(CONCAT_WS(' ', First_Name, Middle_Name, Last_Name)) FROM Taught_By WHERE Section_ID = NEW.Section_ID)
        AND Quarter = NEW.Quarter
        AND Year = NEW.Year;
    ELSIF NEW.Grade_Achieved LIKE 'D%' THEN
        UPDATE CPQG
        SET D = D + 1
        WHERE Course_Number = NEW.Course_Number
        AND Professor_Name = (SELECT TRIM(CONCAT_WS(' ', First_Name, Middle_Name, Last_Name)) FROM Taught_By WHERE Section_ID = NEW.Section_ID)
        AND Quarter = NEW.Quarter
        AND Year = NEW.Year;
    ELSE
        UPDATE CPQG
        SET Other = Other + 1
        WHERE Course_Number = NEW.Course_Number
        AND Professor_Name = (SELECT TRIM(CONCAT_WS(' ', First_Name, Middle_Name, Last_Name)) FROM Taught_By WHERE Section_ID = NEW.Section_ID)
        AND Quarter = NEW.Quarter
        AND Year = NEW.Year;
    END IF;
    
    RETURN NEW;
END;
$$
LANGUAGE plpgsql;

-- Trigger for updating CPQG table upon deletion
CREATE OR REPLACE FUNCTION decrement_CPQG()
RETURNS TRIGGER AS
$$
BEGIN
    -- Check if the deleted grade matches A, B, C, D or Other
    IF OLD.Grade_Achieved LIKE 'A%' THEN
        UPDATE CPQG
        SET A = A - 1
        WHERE Course_Number = OLD.Course_Number
        AND Professor_Name = (SELECT TRIM(CONCAT_WS(' ', First_Name, Middle_Name, Last_Name)) FROM Taught_By WHERE Section_ID = OLD.Section_ID)
        AND Quarter = OLD.Quarter
        AND Year = OLD.Year;
    ELSIF OLD.Grade_Achieved LIKE 'B%' THEN
        UPDATE CPQG
        SET B = B - 1
        WHERE Course_Number = OLD.Course_Number
        AND Professor_Name = (SELECT TRIM(CONCAT_WS(' ', First_Name, Middle_Name, Last_Name)) FROM Taught_By WHERE Section_ID = OLD.Section_ID)
        AND Quarter = OLD.Quarter
        AND Year = OLD.Year;
    ELSIF OLD.Grade_Achieved LIKE 'C%' THEN
        UPDATE CPQG
        SET C = C - 1
        WHERE Course_Number = OLD.Course_Number
        AND Professor_Name = (SELECT TRIM(CONCAT_WS(' ', First_Name, Middle_Name, Last_Name)) FROM Taught_By WHERE Section_ID = OLD.Section_ID)
        AND Quarter = OLD.Quarter
        AND Year = OLD.Year;
    ELSIF OLD.Grade_Achieved LIKE 'D%' THEN
        UPDATE CPQG
        SET D = D - 1
        WHERE Course_Number = OLD.Course_Number
        AND Professor_Name = (SELECT TRIM(CONCAT_WS(' ', First_Name, Middle_Name, Last_Name)) FROM Taught_By WHERE Section_ID = OLD.Section_ID)
        AND Quarter = OLD.Quarter
        AND Year = OLD.Year;
    ELSE
        UPDATE CPQG
        SET Other = Other - 1
        WHERE Course_Number = OLD.Course_Number
        AND Professor_Name = (SELECT TRIM(CONCAT_WS(' ', First_Name, Middle_Name, Last_Name)) FROM Taught_By WHERE Section_ID = OLD.Section_ID)
        AND Quarter = OLD.Quarter
        AND Year = OLD.Year;
    END IF;
    
    RETURN OLD;
END;
$$
LANGUAGE plpgsql;

-- Trigger for updating CPG table upon deletion
CREATE OR REPLACE FUNCTION decrement_CPG()
RETURNS TRIGGER AS
$$
BEGIN
    -- Check if the deleted grade matches A, B, C, D or Other
    IF OLD.Grade_Achieved LIKE 'A%' THEN
        UPDATE CPG
        SET A = A - 1
        WHERE Course_Number = OLD.Course_Number
        AND Professor_Name = (SELECT TRIM(CONCAT_WS(' ', First_Name, Middle_Name, Last_Name)) FROM Taught_By WHERE Section_ID = OLD.Section_ID);
    ELSIF OLD.Grade_Achieved LIKE 'B%' THEN
        UPDATE CPG
        SET B = B - 1
        WHERE Course_Number = OLD.Course_Number
        AND Professor_Name = (SELECT TRIM(CONCAT_WS(' ', First_Name, Middle_Name, Last_Name)) FROM Taught_By WHERE Section_ID = OLD.Section_ID);
    ELSIF OLD.Grade_Achieved LIKE 'C%' THEN
        UPDATE CPG
        SET C = C - 1
        WHERE Course_Number = OLD.Course_Number
        AND Professor_Name = (SELECT TRIM(CONCAT_WS(' ', First_Name, Middle_Name, Last_Name)) FROM Taught_By WHERE Section_ID = OLD.Section_ID);
    ELSIF OLD.Grade_Achieved LIKE 'D%' THEN
        UPDATE CPG
        SET D = D - 1
        WHERE Course_Number = OLD.Course_Number
        AND Professor_Name = (SELECT TRIM(CONCAT_WS(' ', First_Name, Middle_Name, Last_Name)) FROM Taught_By WHERE Section_ID = OLD.Section_ID);
    ELSE
        UPDATE CPG
        SET Other = Other - 1
        WHERE Course_Number = OLD.Course_Number
        AND Professor_Name = (SELECT TRIM(CONCAT_WS(' ', First_Name, Middle_Name, Last_Name)) FROM Taught_By WHERE Section_ID = OLD.Section_ID);
    END IF;
    
    RETURN OLD;
END;
$$
LANGUAGE plpgsql;

-- Trigger definition for CPQG table (Deletion)
CREATE TRIGGER decrement_CPQG_trigger
AFTER DELETE ON Enrolled_In
FOR EACH ROW
EXECUTE FUNCTION decrement_CPQG();

-- Trigger definition for CPG table (Deletion)
CREATE TRIGGER decrement_CPG_trigger
AFTER DELETE ON Enrolled_In
FOR EACH ROW
EXECUTE FUNCTION decrement_CPG();

-- Trigger for updating CPG table
CREATE OR REPLACE FUNCTION update_CPG()
RETURNS TRIGGER AS
$$
BEGIN
    -- Check if the inserted grade matches A, B, C, D or Other
    IF NEW.Grade_Achieved LIKE 'A%' THEN
        UPDATE CPG
        SET A = A + 1
        WHERE Course_Number = NEW.Course_Number
        AND Professor_Name = (SELECT TRIM(CONCAT_WS(' ', First_Name, Middle_Name, Last_Name)) FROM Taught_By WHERE Section_ID = NEW.Section_ID);
    ELSIF NEW.Grade_Achieved LIKE 'B%' THEN
        UPDATE CPG
        SET B = B + 1
        WHERE Course_Number = NEW.Course_Number
        AND Professor_Name = (SELECT TRIM(CONCAT_WS(' ', First_Name, Middle_Name, Last_Name)) FROM Taught_By WHERE Section_ID = NEW.Section_ID);
    ELSIF NEW.Grade_Achieved LIKE 'C%' THEN
        UPDATE CPG
        SET C = C + 1
        WHERE Course_Number = NEW.Course_Number
        AND Professor_Name = (SELECT TRIM(CONCAT_WS(' ', First_Name, Middle_Name, Last_Name)) FROM Taught_By WHERE Section_ID = NEW.Section_ID);
    ELSIF NEW.Grade_Achieved LIKE 'D%' THEN
        UPDATE CPG
        SET D = D + 1
        WHERE Course_Number = NEW.Course_Number
        AND Professor_Name = (SELECT TRIM(CONCAT_WS(' ', First_Name, Middle_Name, Last_Name)) FROM Taught_By WHERE Section_ID = NEW.Section_ID);
    ELSE
        UPDATE CPG
        SET Other = Other + 1
        WHERE Course_Number = NEW.Course_Number
        AND Professor_Name = (SELECT TRIM(CONCAT_WS(' ', First_Name, Middle_Name, Last_Name)) FROM Taught_By WHERE Section_ID = NEW.Section_ID);
    END IF;
    
    RETURN NEW;
END;
$$
LANGUAGE plpgsql;

-- Trigger definition for CPQG table
CREATE TRIGGER update_CPQG_trigger
AFTER INSERT ON Enrolled_In
FOR EACH ROW
EXECUTE FUNCTION update_CPQG();

-- Trigger definition for CPG table
CREATE TRIGGER update_CPG_trigger
AFTER INSERT ON Enrolled_In
FOR EACH ROW
EXECUTE FUNCTION update_CPG();

-- Trigger for updating CPQG table
CREATE OR REPLACE FUNCTION update_CPQG()
RETURNS TRIGGER AS
$$
BEGIN
    -- Check if the inserted grade matches A, B, C, D or Other
    IF NEW.Grade_Achieved LIKE 'A%' THEN
        UPDATE CPQG
        SET A = A + 1
        WHERE Course_Number = NEW.Course_Number
        AND Professor_Name = (SELECT TRIM(CONCAT_WS(' ', First_Name, Middle_Name, Last_Name)) FROM Taught_By WHERE Section_ID = NEW.Section_ID)
        AND Quarter = NEW.Quarter
        AND Year = NEW.Year;
    ELSIF NEW.Grade_Achieved LIKE 'B%' THEN
        UPDATE CPQG
        SET B = B + 1
        WHERE Course_Number = NEW.Course_Number
        AND Professor_Name = (SELECT TRIM(CONCAT_WS(' ', First_Name, Middle_Name, Last_Name)) FROM Taught_By WHERE Section_ID = NEW.Section_ID)
        AND Quarter = NEW.Quarter
        AND Year = NEW.Year;
    ELSIF NEW.Grade_Achieved LIKE 'C%' THEN
        UPDATE CPQG
        SET C = C + 1
        WHERE Course_Number = NEW.Course_Number
        AND Professor_Name = (SELECT TRIM(CONCAT_WS(' ', First_Name, Middle_Name, Last_Name)) FROM Taught_By WHERE Section_ID = NEW.Section_ID)
        AND Quarter = NEW.Quarter
        AND Year = NEW.Year;
    ELSIF NEW.Grade_Achieved LIKE 'D%' THEN
        UPDATE CPQG
        SET D = D + 1
        WHERE Course_Number = NEW.Course_Number
        AND Professor_Name = (SELECT TRIM(CONCAT_WS(' ', First_Name, Middle_Name, Last_Name)) FROM Taught_By WHERE Section_ID = NEW.Section_ID)
        AND Quarter = NEW.Quarter
        AND Year = NEW.Year;
    ELSE
        UPDATE CPQG
        SET Other = Other + 1
        WHERE Course_Number = NEW.Course_Number
        AND Professor_Name = (SELECT TRIM(CONCAT_WS(' ', First_Name, Middle_Name, Last_Name)) FROM Taught_By WHERE Section_ID = NEW.Section_ID)
        AND Quarter = NEW.Quarter
        AND Year = NEW.Year;
    END IF;
    
    RETURN NEW;
END;
$$
LANGUAGE plpgsql;

-- Trigger for updating CPQG table upon grade change
CREATE OR REPLACE FUNCTION update_CPQG_on_grade_change()
RETURNS TRIGGER AS
$$
BEGIN
    -- Decrement the old grade
    IF OLD.Grade_Achieved LIKE 'A%' THEN
        UPDATE CPQG
        SET A = A - 1
        WHERE Course_Number = OLD.Course_Number
        AND Professor_Name = (SELECT TRIM(CONCAT_WS(' ', First_Name, Middle_Name, Last_Name)) FROM Taught_By WHERE Section_ID = OLD.Section_ID)
        AND Quarter = OLD.Quarter
        AND Year = OLD.Year;
    ELSIF OLD.Grade_Achieved LIKE 'B%' THEN
        UPDATE CPQG
        SET B = B - 1
        WHERE Course_Number = OLD.Course_Number
        AND Professor_Name = (SELECT TRIM(CONCAT_WS(' ', First_Name, Middle_Name, Last_Name)) FROM Taught_By WHERE Section_ID = OLD.Section_ID)
        AND Quarter = OLD.Quarter
        AND Year = OLD.Year;
    ELSIF OLD.Grade_Achieved LIKE 'C%' THEN
        UPDATE CPQG
        SET C = C - 1
        WHERE Course_Number = OLD.Course_Number
        AND Professor_Name = (SELECT TRIM(CONCAT_WS(' ', First_Name, Middle_Name, Last_Name)) FROM Taught_By WHERE Section_ID = OLD.Section_ID)
        AND Quarter = OLD.Quarter
        AND Year = OLD.Year;
    ELSIF OLD.Grade_Achieved LIKE 'D%' THEN
        UPDATE CPQG
        SET D = D - 1
        WHERE Course_Number = OLD.Course_Number
        AND Professor_Name = (SELECT TRIM(CONCAT_WS(' ', First_Name, Middle_Name, Last_Name)) FROM Taught_By WHERE Section_ID = OLD.Section_ID)
        AND Quarter = OLD.Quarter
        AND Year = OLD.Year;
    ELSE
        UPDATE CPQG
        SET Other = Other - 1
        WHERE Course_Number = OLD.Course_Number
        AND Professor_Name = (SELECT TRIM(CONCAT_WS(' ', First_Name, Middle_Name, Last_Name)) FROM Taught_By WHERE Section_ID = OLD.Section_ID)
        AND Quarter = OLD.Quarter
        AND Year = OLD.Year;
    END IF;

    -- Increment the new grade
    IF NEW.Grade_Achieved LIKE 'A%' THEN
        UPDATE CPQG
        SET A = A + 1
        WHERE Course_Number = NEW.Course_Number
        AND Professor_Name = (SELECT TRIM(CONCAT_WS(' ', First_Name, Middle_Name, Last_Name)) FROM Taught_By WHERE Section_ID = NEW.Section_ID)
        AND Quarter = NEW.Quarter
        AND Year = NEW.Year;
    ELSIF NEW.Grade_Achieved LIKE 'B%' THEN
        UPDATE CPQG
        SET B = B + 1
        WHERE Course_Number = NEW.Course_Number
        AND Professor_Name = (SELECT TRIM(CONCAT_WS(' ', First_Name, Middle_Name, Last_Name)) FROM Taught_By WHERE Section_ID = NEW.Section_ID)
        AND Quarter = NEW.Quarter
        AND Year = NEW.Year;
    ELSIF NEW.Grade_Achieved LIKE 'C%' THEN
        UPDATE CPQG
        SET C = C + 1
        WHERE Course_Number = NEW.Course_Number
        AND Professor_Name = (SELECT TRIM(CONCAT_WS(' ', First_Name, Middle_Name, Last_Name)) FROM Taught_By WHERE Section_ID = NEW.Section_ID)
        AND Quarter = NEW.Quarter
        AND Year = NEW.Year;
    ELSIF NEW.Grade_Achieved LIKE 'D%' THEN
        UPDATE CPQG
        SET D = D + 1
        WHERE Course_Number = NEW.Course_Number
        AND Professor_Name = (SELECT TRIM(CONCAT_WS(' ', First_Name, Middle_Name, Last_Name)) FROM Taught_By WHERE Section_ID = NEW.Section_ID)
        AND Quarter = NEW.Quarter
        AND Year = NEW.Year;
    ELSE
        UPDATE CPQG
        SET Other = Other + 1
        WHERE Course_Number = NEW.Course_Number
        AND Professor_Name = (SELECT TRIM(CONCAT_WS(' ', First_Name, Middle_Name, Last_Name)) FROM Taught_By WHERE Section_ID = NEW.Section_ID)
        AND Quarter = NEW.Quarter
        AND Year = NEW.Year;
    END IF;
    
    RETURN NEW;
END;
$$
LANGUAGE plpgsql;

-- Trigger for updating CPG table upon grade change
CREATE OR REPLACE FUNCTION update_CPG_on_grade_change()
RETURNS TRIGGER AS
$$
BEGIN
    -- Decrement the old grade
    IF OLD.Grade_Achieved LIKE 'A%' THEN
        UPDATE CPG
        SET A = A - 1
        WHERE Course_Number = OLD.Course_Number
        AND Professor_Name = (SELECT TRIM(CONCAT_WS(' ', First_Name, Middle_Name, Last_Name)) FROM Taught_By WHERE Section_ID = OLD.Section_ID);
    ELSIF OLD.Grade_Achieved LIKE 'B%' THEN
        UPDATE CPG
        SET B = B - 1
        WHERE Course_Number = OLD.Course_Number
        AND Professor_Name = (SELECT TRIM(CONCAT_WS(' ', First_Name, Middle_Name, Last_Name)) FROM Taught_By WHERE Section_ID = OLD.Section_ID);
    ELSIF OLD.Grade_Achieved LIKE 'C%' THEN
        UPDATE CPG
        SET C = C - 1
        WHERE Course_Number = OLD.Course_Number
        AND Professor_Name = (SELECT TRIM(CONCAT_WS(' ', First_Name, Middle_Name, Last_Name)) FROM Taught_By WHERE Section_ID = OLD.Section_ID);
    ELSIF OLD.Grade_Achieved LIKE 'D%' THEN
        UPDATE CPG
        SET D = D - 1
        WHERE Course_Number = OLD.Course_Number
        AND Professor_Name = (SELECT TRIM(CONCAT_WS(' ', First_Name, Middle_Name, Last_Name)) FROM Taught_By WHERE Section_ID = OLD.Section_ID);
    ELSE
        UPDATE CPG
        SET Other = Other - 1
        WHERE Course_Number = OLD.Course_Number
        AND Professor_Name = (SELECT TRIM(CONCAT_WS(' ', First_Name, Middle_Name, Last_Name)) FROM Taught_By WHERE Section_ID = OLD.Section_ID);
    END IF;

    -- Increment the new grade
    IF NEW.Grade_Achieved LIKE 'A%' THEN
        UPDATE CPG
        SET A = A + 1
        WHERE Course_Number = NEW.Course_Number
        AND Professor_Name = (SELECT TRIM(CONCAT_WS(' ', First_Name, Middle_Name, Last_Name)) FROM Taught_By WHERE Section_ID = NEW.Section_ID);
    ELSIF NEW.Grade_Achieved LIKE 'B%' THEN
        UPDATE CPG
        SET B = B + 1
        WHERE Course_Number = NEW.Course_Number
        AND Professor_Name = (SELECT TRIM(CONCAT_WS(' ', First_Name, Middle_Name, Last_Name)) FROM Taught_By WHERE Section_ID = NEW.Section_ID);
    ELSIF NEW.Grade_Achieved LIKE 'C%' THEN
        UPDATE CPG
        SET C = C + 1
        WHERE Course_Number = NEW.Course_Number
        AND Professor_Name = (SELECT TRIM(CONCAT_WS(' ', First_Name, Middle_Name, Last_Name)) FROM Taught_By WHERE Section_ID = NEW.Section_ID);
    ELSIF NEW.Grade_Achieved LIKE 'D%' THEN
        UPDATE CPG
        SET D = D + 1
        WHERE Course_Number = NEW.Course_Number
        AND Professor_Name = (SELECT TRIM(CONCAT_WS(' ', First_Name, Middle_Name, Last_Name)) FROM Taught_By WHERE Section_ID = NEW.Section_ID);
    ELSE
        UPDATE CPG
        SET Other = Other + 1
        WHERE Course_Number = NEW.Course_Number
        AND Professor_Name = (SELECT TRIM(CONCAT_WS(' ', First_Name, Middle_Name, Last_Name)) FROM Taught_By WHERE Section_ID = NEW.Section_ID);
    END IF;
    
    RETURN NEW;
END;
$$
LANGUAGE plpgsql;

-- Trigger definition for CPQG table (Update on Grade Change)
CREATE TRIGGER update_CPQG_on_grade_change_trigger
AFTER UPDATE OF Grade_Achieved ON Enrolled_In
FOR EACH ROW
EXECUTE FUNCTION update_CPQG_on_grade_change();

-- Trigger definition for CPG table (Update on Grade Change)
CREATE TRIGGER update_CPG_on_grade_change_trigger
AFTER UPDATE OF Grade_Achieved ON Enrolled_In
FOR EACH ROW
EXECUTE FUNCTION update_CPG_on_grade_change();

CREATE OR REPLACE FUNCTION check_meeting_conflicts()
RETURNS TRIGGER AS $$
DECLARE
    meeting_record RECORD;
    conflict_exists BOOLEAN := FALSE;
BEGIN
    -- Check for time conflicts with other meetings of the same section
    FOR meeting_record IN 
        SELECT Start_time, End_time, Meeting_type, Day
        FROM Meeting
        WHERE Section_id = NEW.Section_id
        AND (NEW.Day LIKE '%' || Day || '%' OR Day LIKE '%' || NEW.Day || '%') -- Check for overlapping days
    LOOP
        -- Split the days into arrays for easier comparison
        DECLARE
            meeting_days TEXT[];
            new_days TEXT[];
        BEGIN
            meeting_days := string_to_array(meeting_record.Day, '|');
            new_days := string_to_array(NEW.Day, '|');

            -- Check for any overlapping days
            IF array_overlap(meeting_days, new_days) THEN
                -- Check for time overlap
                IF (NEW.Start_time, NEW.End_time) OVERLAPS (meeting_record.Start_time, meeting_record.End_time) THEN
                    conflict_exists := TRUE;
                    EXIT;
                END IF;
            END IF;
        END;
    END LOOP;

    IF conflict_exists THEN
        RAISE EXCEPTION 'Conflicting meeting time detected. Meetings should not overlap within the same section.';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_check_meeting_conflicts
BEFORE INSERT OR UPDATE ON Meeting
FOR EACH ROW
EXECUTE FUNCTION check_meeting_conflicts();
