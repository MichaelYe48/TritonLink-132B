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

    try {
        // Load the PostgreSQL JDBC driver class
        Class.forName("org.postgresql.Driver");

        // Create a connection to the database
        connection = DriverManager.getConnection(jdbcUrl, username, password);

        // Create the statement
        statement = connection.createStatement();

        // Query to get the degree requirements
        String degreeQuery = "SELECT c.Category_name, c.Units " +
                             "FROM Composed_Of co " +
                             "JOIN Category c ON co.Category_Name = c.Category_name " +
                             "WHERE co.Degree_Name = ?";
        PreparedStatement pstmtDegree = connection.prepareStatement(degreeQuery);
        pstmtDegree.setString(1, degreeName);
        rsDegree = pstmtDegree.executeQuery();

        // Query to get the total units the student has taken that count towards the degree
        String studentUnitsQuery = "SELECT SUM(co.Units) AS TotalUnits, c.Category_name " +
                                   "FROM Enrolled_In e " +
                                   "JOIN Class cl ON e.Course_Number = cl.Course_number AND e.Title = cl.Title AND e.Quarter = cl.Quarter AND e.Year = cl.Year " +
                                   "JOIN Course_In_Category cc ON cc.Course_Number = cl.Course_Number " + 
                                   "JOIN Composed_Of c ON con.Course_Number = c.Course_Number " +
                                   "WHERE e.SSN = ? " +
                                   "GROUP BY c.Category_name";
        PreparedStatement pstmtStudentUnits = connection.prepareStatement(studentUnitsQuery);
        pstmtStudentUnits.setString(1, studentSSN);
        rsStudentUnits = pstmtStudentUnits.executeQuery();

        // Calculate remaining units for each category
        Map<String, Integer> degreeRequirements = new HashMap<>();
        while (rsDegree.next()) {
            degreeRequirements.put(rsDegree.getString("Category_name"), rsDegree.getInt("Units"));
        }

        Map<String, Integer> studentUnits = new HashMap<>();
        while (rsStudentUnits.next()) {
            studentUnits.put(rsStudentUnits.getString("Category_name"), rsStudentUnits.getInt("TotalUnits"));
        }

        // Display remaining requirements
%>
<table border="1">
    <tr>
        <th>Category</th>
        <th>Required Units</th>
        <th>Units Taken</th>
        <th>Remaining Units</th>
    </tr>
    <%
        for (String category : degreeRequirements.keySet()) {
            int requiredUnits = degreeRequirements.get(category);
            int unitsTaken = studentUnits.getOrDefault(category, 0);
            int remainingUnits = requiredUnits - unitsTaken;
    %>
    <tr>
        <td><%= category %></td>
        <td><%= requiredUnits %></td>
        <td><%= unitsTaken %></td>
        <td><%= remainingUnits %></td>
    </tr>
    <%
        }
    %>
</table>
<%
        // Close resources
        if (rsDegree != null) rsDegree.close();
        if (rsStudentUnits != null) rsStudentUnits.close();
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
