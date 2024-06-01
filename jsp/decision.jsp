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
                                String query = "SELECT COUNT(CASE WHEN Grade_Achieved = 'A' THEN 1 END) AS A_count, " +
                                               "       COUNT(CASE WHEN Grade_Achieved = 'B' THEN 1 END) AS B_count, " +
                                               "       COUNT(CASE WHEN Grade_Achieved = 'C' THEN 1 END) AS C_count, " +
                                               "       COUNT(CASE WHEN Grade_Achieved = 'D' THEN 1 END) AS D_count, " +
                                               "       COUNT(CASE WHEN Grade_Achieved NOT IN ('A', 'B', 'C', 'D') THEN 1 END) AS other_count " +
                                               "FROM Enrolled_In e " +
                                               "JOIN Class c ON e.Course_Number = c.Course_number AND e.Title = c.Title AND e.Quarter = c.Quarter AND e.Year = c.Year " +
                                               "WHERE e.Course_Number = ? AND c.Quarter = ? AND c.Year = ? AND e.Grade_Achieved IS NOT NULL " +
                                               "  AND EXISTS (SELECT 1 FROM Taught_By t WHERE t.Section_ID = e.Section_id " +
                                               "              AND t.First_Name = ? AND t.Middle_Name = ? AND t.Last_Name = ?)";
                                pstmt = connection.prepareStatement(query);
                                pstmt.setInt(1, Integer.parseInt(courseID));
                                pstmt.setString(2, quarter);
                                pstmt.setInt(3, Integer.parseInt(year));

                                // Split professor name into first, middle, and last name
                                String[] names = professor.split("\\s+", 3);
                                String firstName = names.length > 0 ? names[0] : "";
                                String middleName = names.length > 1 ? names[1] : "";
                                String lastName = names.length > 2 ? names[2] : "";

                                pstmt.setString(4, firstName);
                                pstmt.setString(5, middleName);
                                pstmt.setString(6, lastName);

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

                            // Query to get grade distribution for a professor over the years
                            String courseID2 = request.getParameter("courseID2");
                            String professor2 = request.getParameter("professor2");

                            if (courseID2 != null && !courseID2.isEmpty() && professor2 != null && !professor2.isEmpty()) {
                                String query2 = "SELECT COUNT(CASE WHEN Grade_Achieved = 'A' THEN 1 END) AS A_count, " +
                                                "       COUNT(CASE WHEN Grade_Achieved = 'B' THEN 1 END) AS B_count, " +
                                                "       COUNT(CASE WHEN Grade_Achieved = 'C' THEN 1 END) AS C_count, " +
                                                "       COUNT(CASE WHEN Grade_Achieved = 'D' THEN 1 END) AS D_count, " +
                                                "       COUNT(CASE WHEN Grade_Achieved NOT IN ('A', 'B', 'C', 'D') THEN 1 END) AS other_count " +
                                                "FROM Enrolled_In e " +
                                                "JOIN Taught_By t ON e.Section_id = t.Section_ID " +
                                                "WHERE e.Course_Number = ? AND t.First_Name = ? AND t.Middle_Name = ? AND t.Last_Name = ?";
                                pstmt = connection.prepareStatement(query2);
                                pstmt.setInt(1, Integer.parseInt(courseID2));

                                // Split professor name into first, middle, and last name
                                String[] names2 = professor2.split("\\s+", 3);
                                String firstName2 = names2.length > 0 ? names2[0] : "";
                                String middleName2 = names2.length > 1 ? names2[1] : "";
                                String lastName2 = names2.length > 2 ? names2[2] : "";

                                pstmt.setString(2, firstName2);
                                pstmt.setString(3, middleName2);
                                pstmt.setString(4, lastName2);

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

                            // Query to get grade distribution for a course over the years
                            String courseID3 = request.getParameter("courseID3");

                            if (courseID3 != null && !courseID3.isEmpty()) {
                                String query3 = "SELECT COUNT(CASE WHEN Grade_Achieved = 'A' THEN 1 END) AS A_count, " +
                                                "       COUNT(CASE WHEN Grade_Achieved = 'B' THEN 1 END) AS B_count, " +
                                                "       COUNT(CASE WHEN Grade_Achieved = 'C' THEN 1 END) AS C_count, " +
                                                "       COUNT(CASE WHEN Grade_Achieved = 'D' THEN 1 END) AS D_count, " +
                                                "       COUNT(CASE WHEN Grade_Achieved NOT IN ('A', 'B', 'C', 'D') THEN 1 END) AS other_count " +
                                                "FROM Enrolled_In " +
                                                "WHERE Course_Number = ? AND Grade_Achieved IS NOT NULL";
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
                                String query4 = "SELECT AVG(CASE WHEN Grade_Achieved = 'A' THEN 4.0 " +
                                                "            WHEN Grade_Achieved = 'B' THEN 3.0 " +
                                                "            WHEN Grade_Achieved = 'C' THEN 2.0 " +
                                                "            WHEN Grade_Achieved = 'D' THEN 1.0 " +
                                                "            ELSE 0.0 END) AS GPA " +
                                                "FROM Enrolled_In e " +
                                                "JOIN Taught_By t ON e.Section_id = t.Section_ID " +
                                                "WHERE e.Course_Number = ? AND t.First_Name = ? AND t.Middle_Name = ? AND t.Last_Name = ? AND e.Grade_Achieved NOT IN ('I', 'S', 'U')";
                                pstmt = connection.prepareStatement(query4);
                                pstmt.setInt(1, Integer.parseInt(courseID4));

                                // Split professor name into first, middle, and last name
                                String[] names4 = professor4.split("\\s+", 3);
                                String firstName4 = names4.length > 0 ? names4[0] : "";
                                String middleName4 = names4.length > 1 ? names4[1] : "";
                                String lastName4 = names4.length > 2 ? names4[2] : "";

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
