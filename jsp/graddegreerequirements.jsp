<%@ page language="java" import="java.sql.*,java.util.*" %>
<%
    String jdbcUrl = "jdbc:postgresql://localhost:5432/cse132";
    String username = "dylanolivares";
    String password = "dylanolivares";

    String studentSSN = request.getParameter("StudentSSN");
    String degreeName = request.getParameter("DegreeName");

    Connection connection = null;
    Statement statement = null;
    ResultSet rsDegree = null;
    ResultSet rsStudentUnits = null;
    ResultSet rsStudentCourses = null;
    ResultSet rsRemainingCourses = null;

    // Grade to GPA conversion map
    Map<String, Double> gradeToGPA = new HashMap<String, Double>() {{
        put("A", 4.0);
        put("A-", 3.7);
        put("B+", 3.3);
        put("B", 3.0);
        put("B-", 2.7);
        put("C+", 2.3);
        put("C", 2.0);
        put("C-", 1.7);
        put("D+", 1.3);
        put("D", 1.0);
        put("F", 0.0);
    }};

    try {
        // Load the PostgreSQL JDBC driver class
        Class.forName("org.postgresql.Driver");

        // Create a connection to the database
        connection = DriverManager.getConnection(jdbcUrl, username, password);

        // Create the statement
        statement = connection.createStatement();

        // Query to get the degree requirements
        String degreeQuery = "SELECT co.Concentration_Name, co.Units, c.Course_Number " +
                             "FROM Concentration co " +
                             "JOIN Course c ON c.Course_Number = co.Course_Number " +
                             "WHERE co.Degree_Name = ?";
        PreparedStatement pstmtDegree = connection.prepareStatement(degreeQuery);
        pstmtDegree.setString(1, degreeName);
        rsDegree = pstmtDegree.executeQuery();

        // Query to get the total units the student has taken that count towards the degree
        String studentUnitsQuery = "SELECT SUM(c.Units) AS TotalUnits, co.Concentration_Name " +
                                   "FROM Enrolled_In e " +
                                   "JOIN Class cl ON e.Course_Number = cl.Course_number AND e.Title = cl.Title AND e.Quarter = cl.Quarter AND e.Year = cl.Year " +
                                   "JOIN Concentration co ON e.Course_Number = co.Course_Number " +
                                   "JOIN Course c ON c.Course_Number = co.Course_Number " +
                                   "WHERE e.SSN = ? AND e.Taken = True AND co.Degree_Name = ? AND NOT e.Grade_Achieved = 'I' " +
                                   "GROUP BY co.Concentration_Name";
        PreparedStatement pstmtStudentUnits = connection.prepareStatement(studentUnitsQuery);
        pstmtStudentUnits.setString(1, studentSSN);
        pstmtStudentUnits.setString(2, degreeName);
        rsStudentUnits = pstmtStudentUnits.executeQuery();

        // Query to get all courses taken for GPA calculation
        String studentCourses = "SELECT e.Grade_Achieved, co.Concentration_Name, c.Units, co.Minimum_GPA " +
                                "FROM Enrolled_In e " +
                                "JOIN Class cl ON e.Course_Number = cl.Course_number AND e.Title = cl.Title AND e.Quarter = cl.Quarter AND e.Year = cl.Year " +
                                "JOIN Concentration co ON e.Course_Number = co.Course_Number " +
                                "JOIN Course c ON c.Course_Number = co.Course_Number " +
                                "WHERE e.SSN = ? AND co.Degree_Name = ? AND e.Grade_Achieved NOT IN ('I', 'S', 'U')";
        // Create a scrollable ResultSet
        PreparedStatement pstmtStudentCourses = connection.prepareStatement(studentCourses, ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
        pstmtStudentCourses.setString(1, studentSSN);
        pstmtStudentCourses.setString(2, degreeName);
        rsStudentCourses = pstmtStudentCourses.executeQuery();

        // Calculate remaining units for each category
        Map<String, Integer> graddegreeRequirements = new HashMap<>();
        while (rsDegree.next()) {
            graddegreeRequirements.put(rsDegree.getString("Concentration_Name"), rsDegree.getInt("Units"));
        }

        Map<String, Integer> studentUnits = new HashMap<>();
        while (rsStudentUnits.next()) {
            studentUnits.put(rsStudentUnits.getString("Concentration_Name"), rsStudentUnits.getInt("TotalUnits"));
        }

        Map<String, Integer> min_GPA = new HashMap<>();
        while (rsStudentCourses.next()) {
            min_GPA.put(rsStudentCourses.getString("Concentration_Name"), rsStudentCourses.getInt("Minimum_GPA"));
        }

        // Initialize maps to track GPA calculation
        Map<String, Double> studentGPA = new HashMap<>();
        Map<String, Double> studentNumClasses = new HashMap<>();

        // Reset cursor to the beginning
        rsStudentCourses.beforeFirst();
        while (rsStudentCourses.next()) {
            String concentrationName = rsStudentCourses.getString("Concentration_Name");
            String gradeAchieved = rsStudentCourses.getString("Grade_Achieved");
            int units = rsStudentCourses.getInt("Units");

            Double gpaValue = gradeToGPA.get(gradeAchieved);
            if (gpaValue != null) {
                studentGPA.put(concentrationName, studentGPA.getOrDefault(concentrationName, 0.0) + gpaValue * units);
                studentNumClasses.put(concentrationName, studentNumClasses.getOrDefault(concentrationName, 0.0) + units);
            }
        }

        // Query to get remaining courses and the next time they are offered after SPRING 2018
        String remainingCoursesQuery = 
        "SELECT Concentration_Name, " +
        "       Course_Number, " +
        "       Next_Offered " +
        "FROM ( " +
        "    SELECT co.Concentration_Name, " +
        "           c.Course_Number, " +
        "           CONCAT(cl.Quarter, ' ', cl.Year) AS Next_Offered, " +
        "           ROW_NUMBER() OVER (PARTITION BY co.Concentration_Name, c.Course_Number ORDER BY cl.Year, " +
        "                              CASE " +
        "                                  WHEN cl.Quarter = 'Winter' THEN 1 " +
        "                                  WHEN cl.Quarter = 'Spring' THEN 2 " +
        "                                  WHEN cl.Quarter = 'Summer' THEN 3 " +
        "                                  WHEN cl.Quarter = 'Fall' THEN 4 " +
        "                              END) AS rn " +
        "    FROM Concentration co " +
        "    JOIN Course c ON co.Course_Number = c.Course_Number " +
        "    JOIN Class cl ON c.Course_Number = cl.Course_number " +
        "    WHERE co.Degree_Name = ? " +
        "      AND (cl.Year > 2018 OR (cl.Year = 2018 AND cl.Quarter IN ('Summer', 'Fall', 'Winter'))) " +
        "      AND NOT EXISTS ( " +
        "          SELECT 1 " +
        "          FROM Enrolled_In e " +
        "          WHERE e.SSN = ? " +
        "            AND e.Course_Number = c.Course_Number " +
        "      ) " +
        ") sub " +
        "WHERE rn = 1";
    


        PreparedStatement pstmtRemainingCourses = connection.prepareStatement(remainingCoursesQuery);
        pstmtRemainingCourses.setString(1, degreeName);
        pstmtRemainingCourses.setString(2, studentSSN);
        rsRemainingCourses = pstmtRemainingCourses.executeQuery();

        // Display remaining requirements and GPA
%>
<table border="1">
    <tr>
        <th>Concentrations</th>
        <th>GPA</th>
        <th>Units Remaining</th>
    </tr>
    <%
        int totalRemaining = 0;
        for (String concentration : graddegreeRequirements.keySet()) {
            int requiredUnits = graddegreeRequirements.get(concentration);
            int unitsTaken = studentUnits.getOrDefault(concentration, 0);
            Double totalGPA = studentGPA.get(concentration);
            Double totalClasses = studentNumClasses.get(concentration);

            int remainingUnits = requiredUnits - unitsTaken > 0 ? requiredUnits - unitsTaken : 0;
            if (totalGPA != null && totalClasses != null) {
                double gpa = totalGPA / totalClasses;
                if (remainingUnits == 0 && gpa >= min_GPA.getOrDefault(concentration, 0)) {
    %>
    <tr>
        <td>Completed <%= concentration %></td>
        <td>with GPA of <%= gpa %></td>
        <td>0</td>
    </tr>
    <%
                }
                else {
    %>
    <tr>
        <td>Uncomplete <%= concentration %></td>
        <td>current GPA <%= gpa %></td>
        <td><%= remainingUnits %></td>
    </tr>
    <%
                }
            }
            totalRemaining += remainingUnits;
        }
    %>
    <tr><td colspan="2">Total remaining units: <%= totalRemaining %></td></tr>
</table>

<h2>Remaining Courses</h2>
<table border="1">
    <tr>
        <th>Concentration</th>
        <th>Course Number</th>
        <th>Next Offered</th>
    </tr>
    <%
        while (rsRemainingCourses.next()) {
    %>
    <tr>
        <td><%= rsRemainingCourses.getString("Concentration_Name") %></td>
        <td><%= rsRemainingCourses.getString("Course_Number") %></td>
        <td><%= rsRemainingCourses.getString("Next_Offered") %></td>
    </tr>
    <%
        }
    %>
</table>

<%
        // Close resources
        if (rsDegree != null) rsDegree.close();
        if (rsStudentUnits != null) rsStudentUnits.close();
        if (rsStudentCourses != null) rsStudentCourses.close();
        if (rsRemainingCourses != null) rsRemainingCourses.close();
        if (statement != null) statement.close();
        if (connection != null) connection.close();
    } catch (SQLException sqle) {
        out.println("SQL Exception: " + sqle.getMessage());
        sqle.printStackTrace();
    } catch (ClassNotFoundException cnfe) {
        out.println("Class Not Found Exception: " + cnfe.getMessage());
        cnfe.printStackTrace();
    } catch (Exception e) {
        out.println("Exception: " + e.getMessage());
        e.printStackTrace();
    }
%>
