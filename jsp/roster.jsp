<!DOCTYPE html>
<html>
<head>
    <title>Class Roster</title>
</head>
<body>
    <table>
        <tr>
            <td>
                <jsp:include page="menu.html" />
            </td>
            <td>
                <%@ page language="java" import="java.sql.*" %>
                <%
                    String jdbcUrl = "jdbc:postgresql://localhost:5432/cse132";
                    String username = "dylanolivares";
                    String password = "dylanolivares";

                    Connection connection = null;
                    Statement statement = null;
                    ResultSet rsClasses = null;
                    ResultSet rsStudents = null;

                    try {
                        // Load the PostgreSQL JDBC driver class
                        Class.forName("org.postgresql.Driver");

                        // Create a connection to the database
                        connection = DriverManager.getConnection(jdbcUrl, username, password);

                        // Create the statement
                        statement = connection.createStatement();

                        // Query to get the list of classes
                        String classQuery = "SELECT Course_number, Title, Quarter, Year FROM Class";
                        rsClasses = statement.executeQuery(classQuery);

                        String action = request.getParameter("action");
                        String classInfo = request.getParameter("Class");

                        if (action != null && action.equals("Submit") && classInfo != null) {
                            // Parse the class info to get Course_number, Title, Quarter, and Year
                            String[] classDetails = classInfo.split(",");
                            String courseNumber = classDetails[0];
                            String title = classDetails[1];
                            String quarter = classDetails[2];
                            String year = classDetails[3];

                            // Query to get the students enrolled in the selected class, including units and grade_option (grade_type)
                            String query = "SELECT s.*, e.Taken, e.Grade_Achieved, c.Units, c.Grade_type " +
                                           "FROM Student s " +
                                           "JOIN Enrolled_In e ON s.SSN = e.SSN " +
                                           "JOIN Class cl ON e.Course_number = cl.Course_number AND e.Title = cl.Title AND e.Quarter = cl.Quarter AND e.Year = cl.Year " +
                                           "JOIN Course c ON cl.Course_number = c.Course_number " +
                                           "WHERE cl.Course_number = ? AND cl.Title = ? AND cl.Quarter = ? AND cl.Year = ?";
                            PreparedStatement pstmt = connection.prepareStatement(query);
                            pstmt.setInt(1, Integer.parseInt(courseNumber));
                            pstmt.setString(2, title);
                            pstmt.setString(3, quarter);
                            pstmt.setInt(4, Integer.parseInt(year));
                            rsStudents = pstmt.executeQuery();
                        }
                %>
                <form action="roster.jsp" method="get">
                    <input type="hidden" value="Submit" name="action">
                    <table>
                        <tr>
                            <th>Select Class:</th>
                            <td>
                                <select name="Class" required>
                                    <%
                                        while (rsClasses.next()) {
                                            String classOption = rsClasses.getInt("Course_number") + "," +
                                                                 rsClasses.getString("Title") + "," +
                                                                 rsClasses.getString("Quarter") + "," +
                                                                 rsClasses.getInt("Year");
                                    %>
                                    <option value="<%= classOption %>">
                                        <%= rsClasses.getString("Title") %> - <%= rsClasses.getString("Quarter") %> <%= rsClasses.getInt("Year") %>
                                    </option>
                                    <%
                                        }
                                    %>
                                </select>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2"><input type="submit" value="Submit"></td>
                        </tr>
                    </table>
                </form>

                <%
                    if (action != null && action.equals("Submit") && rsStudents != null) {
                %>
                <table border="1">
                    <tr>
                        <th>SSN</th>
                        <th>First Name</th>
                        <th>Middle Name</th>
                        <th>Last Name</th>
                        <th>Residency Status</th>
                        <th>Student ID</th>
                        <th>Taken</th>
                        <th>Grade Achieved</th>
                        <th>Units</th>
                        <th>Grade Type</th>
                    </tr>
                    <%
                        while (rsStudents.next()) {
                    %>
                    <tr>
                        <td><%= rsStudents.getString("SSN") %></td>
                        <td><%= rsStudents.getString("First_name") %></td>
                        <td><%= rsStudents.getString("Middle_name") %></td>
                        <td><%= rsStudents.getString("Last_name") %></td>
                        <td><%= rsStudents.getString("Residency_status") %></td>
                        <td><%= rsStudents.getInt("Student_ID") %></td>
                        <td><%= rsStudents.getBoolean("Taken") %></td>
                        <td><%= rsStudents.getString("Grade_Achieved") %></td>
                        <td><%= rsStudents.getInt("Units") %></td>
                        <td><%= rsStudents.getString("Grade_type") %></td>
                    </tr>
                    <%
                        }
                    %>
                </table>
                <%
                    }

                    // Close resources
                    if (rsClasses != null) rsClasses.close();
                    if (rsStudents != null) rsStudents.close();
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
        </tr>
    </table>
</body>
</html>
