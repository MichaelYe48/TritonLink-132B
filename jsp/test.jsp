SELECT *   
FROM Enrolled_In e, Taught_By t
WHERE e.Section_id = t.Section_ID AND 
e.Course_Number = 1 AND t.First_Name = 'A' AND t.Middle_Name = 'A' AND t.Last_Name = 'A'  ;