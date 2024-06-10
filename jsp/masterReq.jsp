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
                    Statement degreeStatement = null;
                    ResultSet rsStudents = null;
                    ResultSet rsDegrees = null;

                    try {
                        // Load the PostgreSQL JDBC driver class
                        Class.forName("org.postgresql.Driver");

                        // Create a connection to the database
                        connection = DriverManager.getConnection(jdbcUrl, username, password);

                        // Create the statement
                        statement = connection.createStatement();
                        degreeStatement = connection.createStatement();

                        String studentQuery = "SELECT DISTINCT s.SSN AS SSN, s.First_name AS FIRSTNAME, s.Middle_name AS MIDDLENAME, s.Last_name AS LASTNAME " +
                                              "FROM Student s " +
                                              "JOIN Enrolled_In e ON s.SSN = e.SSN " +
                                              "JOIN Graduate_student u ON s.SSN = u.SSN " +
                                              "WHERE e.Quarter = 'Spring' AND e.Year = 2018";
                        rsStudents = statement.executeQuery(studentQuery);

                        String degreeQuery = "SELECT Degree_name, Degree_Type " +
                                             "FROM Degree " +
                                             "WHERE Degree_Type = 'MS'";
                        rsDegrees = degreeStatement.executeQuery(degreeQuery);
                %>
                <form action="graddegreerequirements.jsp" method="get">
                    <table>
                        <tr>
                            <th>Select Graduate Student</th>
                            <td>
                                <select name="StudentSSN">
                                    <%
                                        while (rsStudents.next()) {
                                            String ssn = rsStudents.getString("SSN");
                                            String firstName = rsStudents.getString("FIRSTNAME");
                                            String middleName = rsStudents.getString("MIDDLENAME");
                                            String lastName = rsStudents.getString("LASTNAME");
                                    %>
                                    <option value="<%= ssn %>"><%= ssn %> - <%= firstName %> <%= middleName %> <%= lastName %></option>
                                    <%
                                        }
                                    %>
                                </select>
                            </td>
                        </tr>
                        <tr>
                            <th>Select BSC Degree</th>
                            <td>
                                <select name="DegreeName">
                                    <%
                                        while (rsDegrees.next()) {
                                            String degreeName = rsDegrees.getString("Degree_name");
                                            String degreeType = rsDegrees.getString("Degree_Type");
                                    %>
                                    <option value="<%= degreeName %>"><%= degreeName %> (<%= degreeType %>)</option>
                                    <%
                                        }
                                    %>
                                </select>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2">
                                <input type="submit" value="Get Degree Requirements">
                            </td>
                        </tr>
                    </table>
                </form>
                <%
                    // Close resources
                    if (rsStudents != null) rsStudents.close();
                    if (rsDegrees != null) rsDegrees.close();
                    if (statement != null) statement.close();
                    if (degreeStatement!= null) degreeStatement.close();
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
