<%@ page language="java" import="java.sql.*" %>
<html>
<body>
    <jsp:include page="menu.html" />
    <h2>Select a Student</h2>
    <form action="displayClasses.jsp" method="get">
        <select name="SSN">
            <option value="">Select a student</option>
            <%
                String jdbcUrl = "jdbc:postgresql://localhost:5432/cse132";
                String username = "dylanolivares";
                String password = "dylanolivares";

                Connection connection = null;
                Statement statement = null;
                ResultSet studentsRs = null;

                try {
                    Class.forName("org.postgresql.Driver");
                    connection = DriverManager.getConnection(jdbcUrl, username, password);
                    statement = connection.createStatement();
                    studentsRs = statement.executeQuery("SELECT s.SSN, s.First_name, s.Middle_name, s.Last_name FROM Student s JOIN Student_Enrollment se ON s.SSN = se.SSN WHERE se.Quarter = 'SPRING' AND se.Year = 2018");

                    while (studentsRs.next()) {
                        String ssn = studentsRs.getString("SSN");
                        String firstName = studentsRs.getString("First_name");
                        String middleName = studentsRs.getString("Middle_name");
                        String lastName = studentsRs.getString("Last_name");
                        out.println("<option value='" + ssn + "'>" + ssn + " - " + firstName + " " + middleName + " " + lastName + "</option>");
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                } finally {
                    try {
                        if (studentsRs != null) studentsRs.close();
                        if (statement != null) statement.close();
                        if (connection != null) connection.close();
                    } catch (SQLException e) {
                        e.printStackTrace();
                    }
                }
            %>
        </select>
        <input type="submit" value="Submit">
    </form>
</body>
</html>
