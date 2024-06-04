<!DOCTYPE html>
<html>
<head>
    <title>Student Enrollment</title>
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
                    ResultSet rs = null;
                    ResultSet rs2 = null;
                    Statement statement2 = null;

                    try {
                        // Load the PostgreSQL JDBC driver class
                        Class.forName("org.postgresql.Driver");

                        // Create a connection to the database
                        connection = DriverManager.getConnection(jdbcUrl, username, password);

                        // Create the statements
                        statement = connection.createStatement();
                        statement2 = connection.createStatement();

                        String action = request.getParameter("action");
                        String studentSSN = request.getParameter("Student");

                        if (action != null && action.equals("Submit") && studentSSN != null) {
                            // Query to get the classes taken by the student
                            String query = "SELECT c.Course_number, c.Title, c.Quarter, c.Year, t.First_name, t.Middle_name, t.Last_name, co.Units, s.Section_id, s.Enroll_limit, s.Number_enrolled " +
                                           "FROM Class c " +
                                           "JOIN Enrolled_In e ON c.Course_number = e.Course_number AND c.Title = e.Title AND c.Quarter = e.Quarter AND c.Year = e.Year " +
                                           "JOIN Course co ON c.Course_number = co.Course_number " +
                                           "JOIN Section s ON e.Section_id = s.Section_id " +
                                           "JOIN Taught_by t ON t.Section_id = s.Section_id " +
                                           "WHERE e.SSN = ? AND e.Quarter = 'SPRING' AND e.Year = 2018";
                            PreparedStatement pstmt = connection.prepareStatement(query);
                            pstmt.setString(1, studentSSN);
                            rs = pstmt.executeQuery();
                        }

                        // Query to get the list of students
                        String studentQuery = "SELECT DISTINCT s.SSN AS SSN, s.First_name AS FIRSTNAME, s.Middle_Name AS MIDDLENAME, s.Last_Name AS LASTNAME " +
                                              "FROM Student s " +
                                              "JOIN Enrolled_In e ON s.SSN = e.SSN " +
                                              "WHERE e.Quarter = 'SPRING' AND e.Year = 2018";
                        rs2 = statement2.executeQuery(studentQuery);
                %>
                <table>
                    <tr>
                        <th>Select Student</th>
                    </tr>
                    <tr>
                        <form action="studentselect.jsp" method="get">
                            <input type="hidden" value="Submit" name="action">
                            <th>
                                <select id="student" name="Student">
                                    <%
                                        while (rs2.next()) {
                                    %>
                                    <option value="<%= rs2.getString("SSN") %>"><%= rs2.getString("SSN") %> <%= rs2.getString("FIRSTNAME") %> <%= rs2.getString("MIDDLENAME") %> <%= rs2.getString("LASTNAME") %></option>
                                    <%
                                        }
                                    %>
                                </select>
                            </th>
                            <th><input type="submit" value="Submit"></th>
                        </form>
                    </tr>
                </table>

                <%
                    if (action != null && action.equals("Submit") && rs != null) {
                %>
                <table border="1">
                    <tr>
                        <th>Course Number</th>
                        <th>Title</th>
                        <th>Instructor First Name</th>
                        <th>Instructor Middle Name</th>
                        <th>Instructor Last Name</th>
                        <th>Units</th>
                        <th>Section ID</th>
                        <th>Quarter</th>
                        <th>Year</th>
                        <th>Enrollment Limit</th>
                        <th>Number of Students Enrolled</th>
                    </tr>
                    <%
                        while (rs.next()) {
                    %>
                    <tr>
                        <td><%= rs.getInt("Course_number") %></td>
                        <td><%= rs.getString("Title") %></td>
                        <td><%= rs.getString("First_name") %></td>
                        <td><%= rs.getString("Middle_name") %></td>
                        <td><%= rs.getString("Last_name") %></td>
                        <td><%= rs.getInt("Units") %></td>
                        <td><%= rs.getInt("Section_id") %></td>
                        <td><%= rs.getString("Quarter") %></td>
                        <td><%= rs.getInt("Year") %></td>
                        <td><%= rs.getInt("Enroll_limit") %></td>
                        <td><%= rs.getInt("Number_enrolled") %></td>
                    </tr>
                    <%
                        }
                    %>
                </table>
                <%
                    }

                    // Close resources
                    if (rs != null) rs.close();
                    if (rs2 != null) rs2.close();
                    if (statement != null) statement.close();
                    if (statement2 != null) statement2.close();
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