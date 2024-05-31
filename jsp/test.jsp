SELECT co.Concentration_Name,    
        c.Course_Number,    
        CONCAT(cl.Quarter, ' ', cl.Year) AS Next_Offered    
 FROM Concentration co    
 JOIN Course c ON co.Course_Number = c.Course_Number    
 JOIN Class cl ON c.Course_Number = cl.Course_number    
 WHERE co.Degree_Name = 'MS Computer Science'    
   AND Year = 2018 A
   AND NOT EXISTS (    
       SELECT 1    
       FROM Enrolled_In e    
       WHERE e.SSN = '4'    
         AND e.Course_Number = c.Course_Number    
   );  