<html>
<body>
    <table>
        <td>
            <jsp:include page="menu.html" />
        </td>
        <td>
<%@ page language="java" import="java.sql.*,java.util.*" %>
<%
    String jdbcUrl = "jdbc:postgresql://localhost:5432/cse132";
    String username = "dylanolivares";
    String password = "dylanolivares";

    String currentQuarter = "Spring";
    int currentYear = 2018;

    Connection connection = null;
    Statement statement = null;
    ResultSet rsStudents = null;
    ResultSet rsConflicts = null;

    try {
        // Load the PostgreSQL JDBC driver class
        Class.forName("org.postgresql.Driver");

        // Create a connection to the database
        connection = DriverManager.getConnection(jdbcUrl, username, password);

        // Query to get all students enrolled in the current quarter
        String studentsQuery = "SELECT SSN, First_name, Middle_name, Last_name FROM Student WHERE SSN IN (SELECT SSN FROM Enrolled_In WHERE Quarter = ? AND Year = ?)";
        PreparedStatement pstmtStudents = connection.prepareStatement(studentsQuery);
        pstmtStudents.setString(1, currentQuarter);
        pstmtStudents.setInt(2, currentYear);
        rsStudents = pstmtStudents.executeQuery();

        // Display the form to select a student
%>
<form method="post">
    <label for="studentSSN">Select Student:</label>
    <select id="studentSSN" name="studentSSN">
        <%
            while (rsStudents.next()) {
                String ssn = rsStudents.getString("SSN");
                String firstName = rsStudents.getString("First_name");
                String middleName = rsStudents.getString("Middle_name");
                String lastName = rsStudents.getString("Last_name");
        %>
        <option value="<%= ssn %>"><%= ssn %> - <%= firstName %> <%= middleName %> <%= lastName %></option>
        <%
            }
        %>
    </select>
    <input type="submit" value="Check Conflicts">
</form>

<%
        if (request.getMethod().equalsIgnoreCase("POST")) {
            String studentSSN = request.getParameter("studentSSN");

            // Query to find conflicting classes for the selected student
            String conflictsQuery = "SELECT c1.Title AS Current_Title, c1.Course_number AS Current_Course, " +
                                    "c2.Title AS Conflict_Title, c2.Course_number AS Conflict_Course " +
                                    "FROM Enrolled_In e1 " +
                                    "JOIN Class c1 ON e1.Course_Number = c1.Course_number AND e1.Title = c1.Title AND e1.Quarter = c1.Quarter AND e1.Year = c1.Year " +
                                    "JOIN Consists_of_Sections cos1 ON c1.Course_number = cos1.Course_number AND c1.Title = cos1.Title AND c1.Quarter = cos1.Quarter AND c1.Year = cos1.Year " +
                                    "JOIN Meeting m1 ON cos1.Section_ID = m1.Section_ID " +
                                    "JOIN Class c2 ON c2.Quarter = ? AND c2.Year = ? " +
                                    "JOIN Consists_of_Sections cos2 ON c2.Course_number = cos2.Course_number AND c2.Title = cos2.Title AND c2.Quarter = cos2.Quarter AND c2.Year = cos2.Year " +
                                    "JOIN Meeting m2 ON cos2.Section_ID = m2.Section_ID " +
                                    "WHERE e1.SSN = ? AND " +
                                    "((m1.Start_time, m1.End_time) OVERLAPS (m2.Start_time, m2.End_time))";
            PreparedStatement pstmtConflicts = connection.prepareStatement(conflictsQuery);
            pstmtConflicts.setString(1, currentQuarter);
            pstmtConflicts.setInt(2, currentYear);
            pstmtConflicts.setString(3, studentSSN);
            rsConflicts = pstmtConflicts.executeQuery();

            // Set to track processed conflicts
            Set<String> processedConflicts = new HashSet<>();
%>
<table border="1">
    <tr>
        <th>Current Class Title</th>
        <th>Current Course Number</th>
        <th>Conflicting Class Title</th>
        <th>Conflicting Course Number</th>
    </tr>
    <%
            while (rsConflicts.next()) {
                String currentTitle = rsConflicts.getString("Current_Title");
                String currentCourse = rsConflicts.getString("Current_Course");
                String conflictTitle = rsConflicts.getString("Conflict_Title");
                String conflictCourse = rsConflicts.getString("Conflict_Course");

                String conflictKey = currentTitle + "|" + currentCourse + "|" + conflictTitle + "|" + conflictCourse;

                if (!processedConflicts.contains(conflictKey)) {
                    processedConflicts.add(conflictKey);
    %>
    <tr>
        <td><%= currentTitle %></td>
        <td><%= currentCourse %></td>
        <td><%= conflictTitle %></td>
        <td><%= conflictCourse %></td>
    </tr>
    <%
                }
            }
    %>
</table>
<%
        }

        // Close resources
        if (rsStudents != null) rsStudents.close();
        if (rsConflicts != null) rsConflicts.close();
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
</td>
</table>
</body>
</html>
