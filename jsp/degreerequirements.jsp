<!DOCTYPE html>
<html>
<head>
    <title>Degree Requirements</title>
</head>
<body>
    <table>
        <tr>
            <td>
                <jsp:include page="menu.html" />
            </td>
            <td>
                <%@ page language="java" import="java.sql.*, java.util.*" %>
                <%
                    String jdbcUrl = "jdbc:postgresql://localhost:5432/cse132";
                    String username = "dylanolivares";
                    String password = "dylanolivares";

                    Connection connection = null;
                    Statement statement = null;
                    ResultSet rsStudents = null;
                    ResultSet rsDegrees = null;
                    ResultSet rsUnitsTaken = null;
                    ResultSet rsDegreeRequirements = null;

                    try {
                        // Load the PostgreSQL JDBC driver class
                        Class.forName("org.postgresql.Driver");

                        // Create a connection to the database
                        connection = DriverManager.getConnection(jdbcUrl, username, password);

                        // Create the statement
                        statement = connection.createStatement();

                        // Query to get the list of undergraduate students enrolled in the current quarter
                        String studentQuery = "SELECT DISTINCT s.SSN, s.First_name, s.Middle_name, s.Last_name " +
                                              "FROM Student s " +
                                              "JOIN Enrolled_In e ON s.SSN = e.SSN " +
                                              "WHERE e.Quarter = 'CURRENT_QUARTER'";
                        rsStudents = statement.executeQuery(studentQuery);

                        // Query to get the list of BSC degrees
                        String degreeQuery = "SELECT Degree_name, Degree_Type FROM Degree WHERE Degree_Type = 'BSC'";
                        rsDegrees = statement.executeQuery(degreeQuery);

                        String action = request.getParameter("action");
                        String studentSSN = request.getParameter("StudentSSN");
                        String degreeName = request.getParameter("DegreeName");

                        if (action != null && action.equals("Submit") && studentSSN != null && degreeName != null) {
                            // Query to get the units taken by the student
                            String unitsTakenQuery = "SELECT SUM(c.Units) AS TotalUnits, " +
                                                     "SUM(CASE WHEN c.Course_number < 200 THEN c.Units ELSE 0 END) AS LowerDivUnits, " +
                                                     "SUM(CASE WHEN c.Course_number >= 200 THEN c.Units ELSE 0 END) AS UpperDivUnits " +
                                                     "FROM Enrolled_In e " +
                                                     "JOIN Class cl ON e.Course_number = cl.Course_number AND e.Title = cl.Title AND e.Quarter = cl.Quarter AND e.Year = cl.Year " +
                                                     "JOIN Course c ON cl.Course_number = c.Course_number " +
                                                     "WHERE e.SSN = ? AND e.Taken = TRUE";
                            PreparedStatement pstmtUnitsTaken = connection.prepareStatement(unitsTakenQuery);
                            pstmtUnitsTaken.setString(1, studentSSN);
                            rsUnitsTaken = pstmtUnitsTaken.executeQuery();

                            // Query to get the degree requirements
                            String degreeRequirementsQuery = "SELECT Total_units, Lower_div_units, Upper_div_units " +
                                                             "FROM Degree " +
                                                             "WHERE Degree_name = ?";
                            PreparedStatement pstmtDegreeRequirements = connection.prepareStatement(degreeRequirementsQuery);
                            pstmtDegreeRequirements.setString(1, degreeName);
                            rsDegreeRequirements = pstmtDegreeRequirements.executeQuery();
                        }
                %>
                <form action="degreeRequirements.jsp" method="get">
                    <input type="hidden" value="Submit" name="action">
                    <table>
                        <tr>
                            <th>Select Student:</th>
                            <td>
                                <select name="StudentSSN" required>
                                    <%
                                        while (rsStudents.next()) {
                                            String studentSSNOption = rsStudents.getString("SSN");
                                    %>
                                    <option value="<%= studentSSNOption %>">
                                        <%= rsStudents.getString("First_name") %> <%= rsStudents.getString("Middle_name") %> <%= rsStudents.getString("Last_name") %>
                                    </option>
                                    <%
                                        }
                                    %>
                                </select>
                            </td>
                        </tr>
                        <tr>
                            <th>Select Degree:</th>
                            <td>
                                <select name="DegreeName" required>
                                    <%
                                        while (rsDegrees.next()) {
                                            String degreeNameOption = rsDegrees.getString("Degree_name");
                                    %>
                                    <option value="<%= degreeNameOption %>">
                                        <%= rsDegrees.getString("Degree_name") %> - <%= rsDegrees.getString("Degree_Type") %>
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
                    if (action != null && action.equals("Submit") && rsUnitsTaken != null && rsDegreeRequirements != null) {
                        rsUnitsTaken.next();
                        rsDegreeRequirements.next();

                        int totalUnitsTaken = rsUnitsTaken.getInt("TotalUnits");
                        int lowerDivUnitsTaken = rsUnitsTaken.getInt("LowerDivUnits");
                        int upperDivUnitsTaken = rsUnitsTaken.getInt("UpperDivUnits");

                        int totalUnitsRequired = rsDegreeRequirements.getInt("Total_units");
                        int lowerDivUnitsRequired = rsDegreeRequirements.getInt("Lower_div_units");
                        int upperDivUnitsRequired = rsDegreeRequirements.getInt("Upper_div_units");

                        int remainingTotalUnits = totalUnitsRequired - totalUnitsTaken;
                        int remainingLowerDivUnits = lowerDivUnitsRequired - lowerDivUnitsTaken;
                        int remainingUpperDivUnits = upperDivUnitsRequired - upperDivUnitsTaken;
                %>

                <h2>Degree Requirements for Student: <%= studentSSN %></h2>
                <table border="1">
                    <tr>
                        <th>Degree Name</th>
                        <th>Total Units Required</th>
                        <th>Lower Division Units Required</th>
                        <th>Upper Division Units Required</th>
                        <th>Total Units Taken</th>
                        <th>Lower Division Units Taken</th>
                        <th>Upper Division Units Taken</th>
                        <th>Remaining Total Units</th>
                        <th>Remaining Lower Division Units</th>
                        <th>Remaining Upper Division Units</th>
                    </tr>
                    <tr>
                        <td><%= degreeName %></td>
                        <td><%= totalUnitsRequired %></td>
                        <td><%= lowerDivUnitsRequired %></td>
                        <td><%= upperDivUnitsRequired %></td>
                        <td><%= totalUnitsTaken %></td>
                        <td><%= lowerDivUnitsTaken %></td>
                        <td><%= upperDivUnitsTaken %></td>
                        <td><%= remainingTotalUnits %></td>
                        <td><%= remainingLowerDivUnits %></td>
                        <td><%= remainingUpperDivUnits %></td>
                    </tr>
                </table>

                <%
                    }

                    // Close resources
                    if (rsStudents != null) rsStudents.close();
                    if (rsDegrees != null) rsDegrees.close();
                    if (rsUnitsTaken != null) rsUnitsTaken.close();
                    if (rsDegreeRequirements != null) rsDegreeRequirements.close();
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
