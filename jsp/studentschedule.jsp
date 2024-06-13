<%@ page language="java" import="java.sql.*,java.util.*" %>
<html>
<head>
    <title>Check Schedule Conflicts</title>
</head>
<body>
    <table>
        <td>
            <jsp:include page="menu.html" />
        </td>
        <td>
            <%
                String jdbcUrl = "jdbc:postgresql://localhost:5432/cse132";
                String username = "dylanolivares";
                String password = "dylanolivares";

                String currentQuarter = "Spring";
                int currentYear = 2018;

                Connection connection = null;
                PreparedStatement pstmtStudents = null;
                ResultSet rsStudents = null;
                PreparedStatement pstmtConflicts = null;
                ResultSet rsConflicts = null;

                try {
                    // Load the PostgreSQL JDBC driver class
                    Class.forName("org.postgresql.Driver");

                    // Create a connection to the database
                    connection = DriverManager.getConnection(jdbcUrl, username, password);

                    // Query to get all students enrolled in the current quarter
                    String studentsQuery = "SELECT SSN, First_name, Middle_name, Last_name FROM Student WHERE SSN IN (SELECT SSN FROM Enrolled_In WHERE Quarter = ? AND Year = ?)";
                    pstmtStudents = connection.prepareStatement(studentsQuery);
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
                        String conflictsQuery = "WITH CurrentStudentSections AS ( " +
                        "    SELECT e.Course_Number, e.Title, e.Quarter, e.Year, cos.Section_ID, " +
                        "           m.Meeting_type, m.Location, m.Day, m.Start_time, m.End_time " +
                        "    FROM Enrolled_In e " +
                        "    JOIN Meeting m ON e.Section_id = m.Section_id " +
                        "    JOIN Consists_of_Sections cos ON e.Course_Number = cos.Course_number AND e.Title = cos.Title AND e.Quarter = cos.Quarter AND e.Year = cos.Year " +
                        "    WHERE e.SSN = ? " +
                        "      AND e.Quarter = ? " +
                        "      AND e.Year = ? " +
                        "), " +
                        "ConflictingClasses AS ( " +
                        "    SELECT cc.Course_number, cc.Title, cs.Section_ID AS Conflict_Section_ID, m.Meeting_type, m.Location, m.Day, m.Start_time, m.End_time " +
                        "    FROM Class cc " +
                        "    JOIN Consists_of_Sections cs ON cc.Course_number = cs.Course_number " +
                        "    JOIN Meeting m ON cs.Section_ID = m.Section_ID " +
                        "    WHERE cc.Quarter = ? " +
                        "      AND cc.Year = ? " +
                        "      AND EXISTS ( " +
                        "          SELECT 1 " +
                        "          FROM CurrentStudentSections css " +
                        "          JOIN Meeting cm ON css.Section_id = cm.Section_ID " +
                        "          WHERE css.Day = m.Day " +
                        "            AND ( " +
                        "                (cm.Start_time, cm.End_time) OVERLAPS (m.Start_time, m.End_time) " +
                        "                OR (m.Start_time, m.End_time) OVERLAPS (cm.Start_time, cm.End_time) " +
                        "            ) " +
                        "      ) " +
                        "      AND NOT EXISTS ( " +
                        "          SELECT 1 " +
                        "          FROM CurrentStudentSections css " +
                        "          WHERE css.Course_Number = cc.Course_number " +
                        "            AND css.Title = cc.Title " +
                        "      ) " +
                        ") " +
                        "SELECT css.Course_Number AS Current_Course, css.Title AS Current_Title, " +
                        "       css.Section_id AS Current_Section_ID, " +
                        "       cc.Course_number AS Conflict_Course, cc.Title AS Conflict_Title, " +
                        "       cc.Conflict_Section_ID, " +
                        "       m.Meeting_type AS Conflict_Meeting_type, m.Location AS Conflict_Location, " +
                        "       m.Day AS Conflict_Day, m.Start_time AS Conflict_Start_time, m.End_time AS Conflict_End_time " +
                        "FROM CurrentStudentSections css " +
                        "JOIN Consists_of_Sections cs ON css.Course_Number = cs.Course_number " +
                        "JOIN Meeting cm ON cs.Section_ID = cm.Section_ID " +
                        "JOIN ConflictingClasses cc ON cm.Day = cc.Day " +
                        "JOIN Meeting m ON cc.Conflict_Section_ID = m.Section_ID " +
                        "WHERE (cm.Start_time, cm.End_time) OVERLAPS (m.Start_time, m.End_time) " +
                        "   OR (m.Start_time, m.End_time) OVERLAPS (cm.Start_time, cm.End_time)";

                        pstmtConflicts = connection.prepareStatement(conflictsQuery);
                        pstmtConflicts.setString(1, studentSSN);
                        pstmtConflicts.setString(2, currentQuarter);
                        pstmtConflicts.setInt(3, currentYear);
                        pstmtConflicts.setString(4, currentQuarter);
                        pstmtConflicts.setInt(5, currentYear);
                        rsConflicts = pstmtConflicts.executeQuery();

                        // Set to track processed conflicts
                        Set<String> processedConflicts = new HashSet<>();
            %>
            <table border="1">
                <tr>
                    <th>Current Course</th>
                    <th>Current Section ID</th>
                    <th>Conflict Course</th>
                    <th>Conflict Section ID</th>
                    <th>Conflict Meeting Type</th>
                    <th>Conflict Location</th>
                    <th>Conflict Day</th>
                    <th>Conflict Start Time</th>
                    <th>Conflict End Time</th>
                </tr>
                <%
                        while (rsConflicts.next()) {
                            String currentCourse = rsConflicts.getString("Current_Course");
                            String currentTitle = rsConflicts.getString("Current_Title");
                            String currentSectionID = rsConflicts.getString("Current_Section_ID");
                            String conflictCourse = rsConflicts.getString("Conflict_Course");
                            String conflictTitle = rsConflicts.getString("Conflict_Title");
                            String conflictSectionID = rsConflicts.getString("Conflict_Section_ID");
                            String conflictMeetingType = rsConflicts.getString("Conflict_Meeting_type");
                            String conflictLocation = rsConflicts.getString("Conflict_Location");
                            String conflictDay = rsConflicts.getString("Conflict_Day");
                            String conflictStartTime = rsConflicts.getString("Conflict_Start_time");
                            String conflictEndTime = rsConflicts.getString("Conflict_End_time");

                            out.println("<tr>");
                            out.println("<td>" + currentCourse + " - " + currentTitle + "</td>");
                            out.println("<td>" + currentSectionID + "</td>");
                            out.println("<td>" + conflictCourse + " - " + conflictTitle + "</td>");
                            out.println("<td>" + conflictSectionID + "</td>");
                            out.println("<td>" + conflictMeetingType + "</td>");
                            out.println("<td>" + conflictLocation + "</td>");
                            out.println("<td>" + conflictDay + "</td>");
                            out.println("<td>" + conflictStartTime + "</td>");
                            out.println("<td>" + conflictEndTime + "</td>");
                            out.println("</tr>");
                        }
                %>
            </table>
            <%
                    }

                    // Close resources
                    if (rsStudents != null) rsStudents.close();
                    if (rsConflicts != null) rsConflicts.close();
                    if (pstmtStudents != null) pstmtStudents.close();
                    if (pstmtConflicts != null) pstmtConflicts.close();
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