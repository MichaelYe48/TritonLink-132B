<!DOCTYPE html>
<html>
<head>
    <title>Grade Report</title>
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
                    ResultSet rsClasses = null;

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

                        // Query to get the list of students
                        String studentQuery = "SELECT DISTINCT s.SSN, s.First_name, s.Middle_name, s.Last_name " +
                                              "FROM Student s " +
                                              "JOIN Enrolled_In e ON s.SSN = e.SSN";
                        rsStudents = statement.executeQuery(studentQuery);

                        String action = request.getParameter("action");
                        String studentSSN = request.getParameter("StudentSSN");

                        if (action != null && action.equals("Submit") && studentSSN != null) {
                            // Query to get the classes and grades for the selected student
                            String query = "SELECT cl.*, e.Grade_Achieved, c.Units " +
                                           "FROM Enrolled_In e " +
                                           "JOIN Class cl ON e.Course_number = cl.Course_number AND e.Title = cl.Title AND e.Quarter = cl.Quarter AND e.Year = cl.Year " +
                                           "JOIN Course c ON cl.Course_number = c.Course_number " +
                                           "WHERE e.SSN = ? " +
                                           "ORDER BY cl.Year, cl.Quarter";
                            PreparedStatement pstmt = connection.prepareStatement(query);
                            pstmt.setString(1, studentSSN);
                            rsClasses = pstmt.executeQuery();
                        }
                %>
                <form action="gradereport.jsp" method="get">
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
                            <td colspan="2"><input type="submit" value="Submit"></td>
                        </tr>
                    </table>
                </form>

                <%
                    if (action != null && action.equals("Submit") && rsClasses != null) {
                        Map<String, List<Map<String, Object>>> classesByQuarter = new LinkedHashMap<>();
                        Map<String, Double> gpaByQuarter = new LinkedHashMap<>();
                        double totalGpaSum = 0;
                        int totalUnits = 0;

                        while (rsClasses.next()) {
                            String quarterYear = rsClasses.getString("Quarter") + " " + rsClasses.getInt("Year");
                            if (!classesByQuarter.containsKey(quarterYear)) {
                                classesByQuarter.put(quarterYear, new ArrayList<>());
                            }
                            Map<String, Object> classDetails = new HashMap<>();
                            classDetails.put("Course_number", rsClasses.getInt("Course_number"));
                            classDetails.put("Title", rsClasses.getString("Title"));
                            classDetails.put("Quarter", rsClasses.getString("Quarter"));
                            classDetails.put("Year", rsClasses.getInt("Year"));
                            classDetails.put("Grade_Achieved", rsClasses.getString("Grade_Achieved"));
                            classDetails.put("Units", rsClasses.getInt("Units"));
                            classesByQuarter.get(quarterYear).add(classDetails);

                            // Calculate GPA for the quarter
                            if (!rsClasses.getString("Grade_Achieved").equals("IN")) {
                                double gradePoints = gradeToGPA.get(rsClasses.getString("Grade_Achieved")) * rsClasses.getInt("Units");
                                if (!gpaByQuarter.containsKey(quarterYear)) {
                                    gpaByQuarter.put(quarterYear, gradePoints);
                                } else {
                                    gpaByQuarter.put(quarterYear, gpaByQuarter.get(quarterYear) + gradePoints);
                                }
                                totalGpaSum += gradePoints;
                                totalUnits += rsClasses.getInt("Units");
                            }
                        }

                        // Calculate GPA
                        for (String quarterYear : gpaByQuarter.keySet()) {
                            int unitsInQuarter = classesByQuarter.get(quarterYear).stream()
                                    .filter(c -> !c.get("Grade_Achieved").equals("IN"))
                                    .mapToInt(c -> (int) c.get("Units"))
                                    .sum();
                            gpaByQuarter.put(quarterYear, gpaByQuarter.get(quarterYear) / unitsInQuarter);
                        }
                        double cumulativeGPA = totalUnits > 0 ? totalGpaSum / totalUnits : 0;
                %>

                <h2>Grade Report for Student: <%= studentSSN %></h2>

                <%
                        for (String quarterYear : classesByQuarter.keySet()) {
                %>
                <h3>Quarter: <%= quarterYear %> - GPA: <%= String.format("%.2f", gpaByQuarter.get(quarterYear)) %></h3>
                <table border="1">
                    <tr>
                        <th>Course Number</th>
                        <th>Title</th>
                        <th>Quarter</th>
                        <th>Year</th>
                        <th>Grade Achieved</th>
                        <th>Units</th>
                    </tr>
                    <%
                            for (Map<String, Object> classDetails : classesByQuarter.get(quarterYear)) {
                    %>
                    <tr>
                        <td><%= classDetails.get("Course_number") %></td>
                        <td><%= classDetails.get("Title") %></td>
                        <td><%= classDetails.get("Quarter") %></td>
                        <td><%= classDetails.get("Year") %></td>
                        <td><%= classDetails.get("Grade_Achieved") %></td>
                        <td><%= classDetails.get("Units") %></td>
                    </tr>
                    <%
                            }
                    %>
                </table>
                <%
                        }
                %>

                <h3>Cumulative GPA: <%= String.format("%.2f", cumulativeGPA) %></h3>

                <%
                    }

                    // Close resources
                    if (rsStudents != null) rsStudents.close();
                    if (rsClasses != null) rsClasses.close();
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
