SELECT AVG(CASE  
WHEN Grade_Achieved = 'A+' THEN 4.3  
WHEN Grade_Achieved = 'A' THEN 4.0  
WHEN Grade_Achieved = 'A-' THEN 3.7  
WHEN Grade_Achieved = 'B' THEN 3.3  
WHEN Grade_Achieved = 'B' THEN 3.0  
WHEN Grade_Achieved = 'B-' THEN 2.7  
WHEN Grade_Achieved = 'C' THEN 2.3  
WHEN Grade_Achieved = 'C' THEN 2.0  
WHEN Grade_Achieved = 'C-' THEN 1.7  
WHEN Grade_Achieved = 'D' THEN 1.3  
WHEN Grade_Achieved = 'D' THEN 1.0  
WHEN Grade_Achieved = 'D-' THEN 0.7  
ELSE 0.0 END) AS GPA  
FROM Enrolled_In e  
JOIN Taught_By t ON e.Section_id = t.Section_ID  
WHERE e.Course_Number = 1 AND t.First_Name = 'Alan' AND t.Middle_Name = '' AND t.Last_Name = 'Turing' AND (e.Grade_Achieved LIKE 'A%'  
OR e.Grade_Achieved LIKE 'B%'  
OR e.Grade_Achieved LIKE 'C%'  
OR e.Grade_Achieved LIKE 'D%') ;