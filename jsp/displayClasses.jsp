<%@ page language="java" import="java.sql.*" %>
<html>
<body>
    <h2>Classes Taken by Selected Student</h2>
    <%
        String selectedSSN = request.getParameter("SSN");
        if (selectedSSN != null && !selectedSSN.isEmpty()) {
            String jdbcUrl = "jdbc:postgresql://localhost:5432/cse132";
            String username = "dylanolivares";
            String password = "dylanolivares";

            Connection connection = null;
            PreparedStatement ps = null;
            ResultSet classesRs = null;

            try {
                Class.forName("org.postgresql.Driver");
                connection = DriverManager.getConnection(jdbcUrl, username, password);
                
                String query = "SELECT c.Course_number, c.Title, c.Quarter, c.Year, c.Units, se.Section_id " +
                               "FROM Class c " +
                               "JOIN Consists_of_Sections cs ON c.Course_number = cs.Course_number " +
                               "JOIN Student_Section ss ON cs.Section_id = ss.Section_id " +
                               "WHERE ss.SSN = ? AND c.Quarter = 'SPRING' AND c.Year = 2018";
                               
                ps = connection.prepareStatement(query);
                ps.setString(1, selectedSSN);
                classesRs = ps.executeQuery();
    %>
                <table border="1">
                    <tr>
                        <th>Course Number</th>
                        <th>Title</th>
                        <th>Quarter</th>
                        <th>Year</th>
                        <th>Units</th>
                        <th>Section ID</th>
                    </tr>
                    <%
                        while (classesRs.next()) {
                            out.println("<tr>");
                            out.println("<td>" + classesRs.getInt("Course_number") + "</td>");
                            out.println("<td>" + classesRs.getString("Title") + "</td>");
                            out.println("<td>" + classesRs.getString("Quarter") + "</td>");
                            out.println("<td>" + classesRs.getInt("Year") + "</td>");
                            out.println("<td>" + classesRs.getInt("Units") + "</td>");
                            out.println("<td>" + classesRs.getInt("Section_id") + "</td>");
                            out.println("</tr>");
                        }
                    %>
                </table>
    <%
            } catch (Exception e) {
                e.printStackTrace();
            } finally {
                try {
                    if (classesRs != null) classesRs.close();
                    if (ps != null) ps.close();
                    if (connection != null) connection.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        } else {
            out.println("Please select a student.");
        }
    %>
</body>
</html>
