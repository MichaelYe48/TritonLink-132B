<%@ page language="java" import="java.sql.*, java.util.*, java.text.SimpleDateFormat" %>
<html>
<head>
    <title>Reports III: Decision Support</title>
</head>
<body>
    <table>
        <tr>
            <td>
                <jsp:include page="menu.html" />
            </td>
            <td>
                <h2>Reports III: Decision Support</h2>
                <form method="post">
                    <h3>Report 1: Grades Distribution for a Professor in a Quarter and Course</h3>
                    <label for="courseID">Course ID:</label>
                    <input type="text" id="courseID" name="courseID">
                    <label for="professor">Professor:</label>
                    <input type="text" id="professor" name="professor">
                    <label for="quarter">Quarter:</label>
                    <input type="text" id="quarter" name="quarter">
                    <label for="year">Year:</label>
                    <input type="text" id="year" name="year">
                    <input type="submit" value="Generate Report">
                </form>

                <form method="post">
                    <h3>Report 2: Grades Distribution for a Professor over the Years</h3>
                    <label for="courseID2">Course ID:</label>
                    <input type="text" id="courseID2" name="courseID2">
                    <label for="professor2">Professor:</label>
                    <input type="text" id="professor2" name="professor2">
                    <input type="submit" value="Generate Report">
                </form>

                <form method="post">
                    <h3>Report 3: Grades Distribution for a Course over the Years</h3>
                    <label for="courseID3">Course ID:</label>
                    <input type="text" id="courseID3" name="courseID3">
                    <input type="submit" value="Generate Report">
                </form>

                <form method="post">
                    <h3>Report 4: Grade Point Average for a Professor in a Course over the Years</h3>
                    <label for="courseID4">Course ID:</label>
                    <input type="text" id="courseID4" name="courseID4">
                    <label for="professor4">Professor:</label>
                    <input type="text" id="professor4" name="professor4">
                    <input type="submit" value="Generate Report">
                </form>

                <%
                    if (request.getMethod().equalsIgnoreCase("POST")) {
                        String jdbcUrl = "jdbc:postgresql://localhost:5432/cse132";
                        String username = "dylanolivares";
                        String password = "dylanolivares";
                        Connection connection = null;
                        PreparedStatement pstmt = null;
                        ResultSet rs = null;

                        try {
                            // Load the PostgreSQL JDBC driver class
                            Class.forName("org.postgresql.Driver");

                            // Create a connection to the database
                            connection = DriverManager.getConnection(jdbcUrl, username, password);

                            // Get parameters from the form
                            String courseID = request.getParameter("courseID");
                            String professor = request.getParameter("professor");
                            String quarter = request.getParameter("quarter");
                            String year = request.getParameter("year");

                            // Query to get grade distribution for a professor in a quarter and course
                            if (courseID != null && !courseID.isEmpty() && professor != null && !professor.isEmpty() && quarter != null && !quarter.isEmpty()) {
                                String query = "SELECT a, b, c, d, other " +
                                               "FROM CPQG " +
                                               "WHERE Course_Number = ? AND Quarter = ? AND Year = ? AND Professor_Name = ?";
                                pstmt = connection.prepareStatement(query);
                                pstmt.setInt(1, Integer.parseInt(courseID));
                                pstmt.setString(2, quarter);
                                pstmt.setInt(3, Integer.parseInt(year));
                                pstmt.setString(4, professor);

                                rs = pstmt.executeQuery();
                                if (rs.next()) {
                %>
                <h3>Report 1: Grades Distribution for Professor <%= professor %> in Quarter <%= quarter %> and Course ID <%= courseID %></h3>
                <table border="1">
                    <tr>
                        <th>Grade</th>
                        <th>Count</th>
                    </tr>
                    <tr>
                        <td>A</td>
                        <td><%= rs.getInt("a") %></td>
                    </tr>
                    <tr>
                        <td>B</td>
                        <td><%= rs.getInt("b") %></td>
                    </tr>
                    <tr>
                        <td>C</td>
                        <td><%= rs.getInt("c") %></td>
                    </tr>
                    <tr>
                        <td>D</td>
                        <td><%= rs.getInt("d") %></td>
                    </tr>
                    <tr>
                        <td>Other</td>
                        <td><%= rs.getInt("other") %></td>
                    </tr>
                </table>
                <%
                                } else {
                                    out.println("<p>No data found for the selected parameters.</p>");
                                }
                            }

                            // Query to get grade distribution for a professor over the years
                            String courseID2 = request.getParameter("courseID2");
                            String professor2 = request.getParameter("professor2");

                            if (courseID2 != null && !courseID2.isEmpty() && professor2 != null && !professor2.isEmpty()) {
                                String query2 = "SELECT a, b, c, d, other " +
                                                "FROM CPG " +
                                                "WHERE Course_Number = ? AND Professor_Name = ?";
                                pstmt = connection.prepareStatement(query2);
                                pstmt.setInt(1, Integer.parseInt(courseID2));
                                pstmt.setString(2, professor2);

                                rs = pstmt.executeQuery();
                                if (rs.next()) {
                %>
                <h3>Report 2: Grades Distribution for Professor <%= professor2 %> over the Years for Course ID <%= courseID2 %></h3>
                <table border="1">
                    <tr>
                        <th>Grade</th>
                        <th>Count</th>
                    </tr>
                    <tr>
                        <td>A</td>
                        <td><%= rs.getInt("a") %></td>
                    </tr>
                    <tr>
                        <td>B</td>
                        <td><%= rs.getInt("b") %></td>
                    </tr>
                    <tr>
                        <td>C</td>
                        <td><%= rs.getInt("c") %></td>
                    </tr>
                    <tr>
                        <td>D</td>
                        <td><%= rs.getInt("d") %></td>
                    </tr>
                    <tr>
                        <td>Other</td>
                        <td><%= rs.getInt("other") %></td>
                    </tr>
                </table>
                <%
                                } else {
                                    out.println("<p>No data found for the selected parameters.</p>");
                                }
                            }

                            // Query to get grade distribution for a course over the years
                            String courseID3 = request.getParameter("courseID3");

                            if (courseID3 != null && !courseID3.isEmpty()) {
                                String query3 = "SELECT COUNT(CASE WHEN Grade_Achieved LIKE 'A%' THEN 1 END) AS A_count, " +
                                                "       COUNT(CASE WHEN Grade_Achieved LIKE 'B%' THEN 1 END) AS B_count, " +
                                                "       COUNT(CASE WHEN Grade_Achieved LIKE 'C%' THEN 1 END) AS C_count, " +
                                                "       COUNT(CASE WHEN Grade_Achieved LIKE 'D%' THEN 1 END) AS D_count, " +
                                                "       COUNT(CASE WHEN Grade_Achieved NOT LIKE 'A%' AND Grade_Achieved NOT LIKE 'B%' AND Grade_Achieved NOT LIKE 'C%' AND Grade_Achieved NOT LIKE 'D%' THEN 1 END) AS other_count " +
                                                "FROM Enrolled_In " +
                                                "WHERE Course_Number = ? AND Grade_Achieved IS NOT NULL AND NOT (Quarter = 'Spring' AND Year = 2018)";
                                pstmt = connection.prepareStatement(query3);
                                pstmt.setInt(1, Integer.parseInt(courseID3));

                                rs = pstmt.executeQuery();
                                if (rs.next()) {
                %>
                <h3>Report 3: Grades Distribution for Course ID <%= courseID3 %> over the Years</h3>
                <table border="1">
                    <tr>
                        <th>Grade</th>
                        <th>Count</th>
                    </tr>
                    <tr>
                        <td>A</td>
                        <td><%= rs.getInt("A_count") %></td>
                    </tr>
                    <tr>
                        <td>B</td>
                        <td><%= rs.getInt("B_count") %></td>
                    </tr>
                    <tr>
                        <td>C</td>
                        <td><%= rs.getInt("C_count") %></td>
                    </tr>
                    <tr>
                        <td>D</td>
                        <td><%= rs.getInt("D_count") %></td>
                    </tr>
                    <tr>
                        <td>Other</td>
                        <td><%= rs.getInt("other_count") %></td>
                    </tr>
                </table>
                <%
                                } else {
                                    out.println("<p>No data found for the selected parameters.</p>");
                                }
                            }

                            // Query to get grade point average for a professor in a course over the years
                            String courseID4 = request.getParameter("courseID4");
                            String professor4 = request.getParameter("professor4");

                            if (courseID4 != null && !courseID4.isEmpty() && professor4 != null && !professor4.isEmpty()) {
                                String query4 = "SELECT AVG(CASE " +
                                                "WHEN Grade_Achieved = 'A+' THEN 4.3 " +
                                                "WHEN Grade_Achieved = 'A' THEN 4.0 " +
                                                "WHEN Grade_Achieved = 'A-' THEN 3.7 " +
                                                "WHEN Grade_Achieved = 'B+' THEN 3.3 " +
                                                "WHEN Grade_Achieved = 'B' THEN 3.0 " +
                                                "WHEN Grade_Achieved = 'B-' THEN 2.7 " +
                                                "WHEN Grade_Achieved = 'C+' THEN 2.3 " +
                                                "WHEN Grade_Achieved = 'C' THEN 2.0 " +
                                                "WHEN Grade_Achieved = 'C-' THEN 1.7 " +
                                                "WHEN Grade_Achieved = 'D+' THEN 1.3 " +
                                                "WHEN Grade_Achieved = 'D' THEN 1.0 " +
                                                "WHEN Grade_Achieved = 'D-' THEN 0.7 " +
                                                "ELSE 0.0 END) AS GPA " +
                                                "FROM Enrolled_In e " +
                                                "JOIN Taught_By t ON e.Section_id = t.Section_ID " +
                                                "WHERE e.Course_Number = ? AND t.First_Name = ? AND t.Middle_Name = ? AND t.Last_Name = ? AND (e.Grade_Achieved LIKE 'A%' " +
                                                "OR e.Grade_Achieved LIKE 'B%' " +
                                                "OR e.Grade_Achieved LIKE 'C%' " +
                                                "OR e.Grade_Achieved LIKE 'D%')";
                                pstmt = connection.prepareStatement(query4);
                                pstmt.setInt(1, Integer.parseInt(courseID4));

                                // Split professor name into first, middle, and last name
                                String[] names4 = professor4.split("\\s+", 3);
                                String firstName4 = names4.length > 1 ? names4[0] : "";
                                String middleName4 = names4.length == 3 ? names4[1] : "";
                                String lastName4 = names4.length > 0 ? names4[names4.length - 1] : "";

                                pstmt.setString(2, firstName4);
                                pstmt.setString(3, middleName4);
                                pstmt.setString(4, lastName4);

                                rs = pstmt.executeQuery();
                                if (rs.next()) {
                %>
                <h3>Report 4: Grade Point Average for Professor <%= professor4 %> in Course ID <%= courseID4 %> over the Years</h3>
                <p>GPA: <%= rs.getFloat("GPA") %></p>
                <%
                                } else {
                                    out.println("<p>No data found for the selected parameters.</p>");
                                }
                            }
                        } catch (SQLException | ClassNotFoundException e) {
                            e.printStackTrace();
                        } finally {
                            // Close all resources
                            try {
                                if (rs != null) {
                                    rs.close();
                                }
                                if (pstmt != null) {
                                    pstmt.close();
                                }
                                if (connection != null) {
                                    connection.close();
                                }
                            } catch (SQLException e) {
                                e.printStackTrace();
                            }
                        }
                    }
                %>
            </td>
        </tr>
    </table>
</body>
</html>
