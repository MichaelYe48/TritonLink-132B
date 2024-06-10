SELECT co.Concentration_Name, cl.Title
FROM Enrolled_In e  
JOIN Class cl ON e.Course_Number = cl.Course_number AND e.Title = cl.Title AND e.Quarter = cl.Quarter AND e.Year = cl.Year  
JOIN Concentration co ON e.Course_Number = co.Course_Number  
JOIN Course c ON c.Course_Number = co.Course_Number  
WHERE e.SSN = ? AND e.Taken = True AND co.Degree_Name = ? AND NOT e.Grade_Achieved = 'I';