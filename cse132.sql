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

CREATE TRIGGER trigger_check_enrollment_limit
BEFORE INSERT ON Enrolled_In
FOR EACH ROW
EXECUTE FUNCTION check_enrollment_limit();


CREATE OR REPLACE FUNCTION increment_enrollment_count()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE Section
    SET Number_enrolled = Number_enrolled + 1
    WHERE Section_id = NEW.Section_id;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_increment_enrollment_count
AFTER INSERT ON Enrolled_In
FOR EACH ROW
EXECUTE FUNCTION increment_enrollment_count();

CREATE OR REPLACE FUNCTION decrement_enrollment_count()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE Section
    SET Number_enrolled = Number_enrolled - 1
    WHERE Section_id = OLD.Section_id;
    RETURN OLD;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_decrement_enrollment_count
AFTER DELETE ON Enrolled_In
FOR EACH ROW
EXECUTE FUNCTION decrement_enrollment_count();
