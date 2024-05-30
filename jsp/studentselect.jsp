<html>
<head>
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
                    out.println("oink");

                    // Try to establish a connection to the database
                    try {
                        // Load the PostgreSQL JDBC driver class
                        Class.forName("org.postgresql.Driver");

                        // Create a connection to the database
                        connection = DriverManager.getConnection(jdbcUrl, username, password);
                        out.println("that");
                        String action = request.getParameter("action");
                        if (action != null && action.equals("Submit")) {
                            out.println("this");
                            PreparedStatement pstmt = connection.prepareStatement(
                                "SELECT * FROM Enrolled_In WHERE SSN = ?");
                            pstmt.setString(1, request.getParameter("SSN"));
                            pstmt.executeUpdate();
                            pstmt.close();
                        }
                        out.println("those");
                        // Create the statement
                        statement = connection.createStatement();
                        statement2 = connection.createStatement();
                        //rs = statement.executeQuery("SELECT * FROM ");
                    %>
                <table>
                    <tr>
                        <th>Student</th>
                    </tr>
                    <tr>
                        <form action="studentselect.jsp" method="get">
                            <input type="hidden" value="Submit" name="action">
                            <th>
                                <select id="student" name="Student">
                                    <%
                                        rs2 = statement2.executeQuery("SELECT DISTINCT s.SSN AS SSN, s.First_name AS FIRSTNAME, s.Middle_Name AS MIDDLENAME, s.Last_Name AS LASTNAME FROM Student s, Enrolled_In e WHERE s.SSN = e.SSN AND e.Quarter = 'SPRING' AND e.Year = 2018");
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
                <table>
                    <tr>
                        <th>Student</th>
                        <th></th>
                        <th></th>
                        <th></th>
                        <th></th>
                    </tr>
                </table>
                <%
                    rs2.close();
                    rs.close();
                    statement.close();
                    statement2.close();
                    connection.close();
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