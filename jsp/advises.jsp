<%@ page language="java" import="java.sql.*" %>
<html>
<body>
    <table>
        <tr>
            <td>
                <jsp:include page="menu.html" />
            </td>
            <td>
                <%
                String jdbcUrl = "jdbc:postgresql://localhost:5432/cse132";
                String username = "dylanolivares";
                String password = "dylanolivares";

                Connection connection = null;
                Statement statement = null;
                ResultSet rs = null;

                try {
                    Class.forName("org.postgresql.Driver");
                    connection = DriverManager.getConnection(jdbcUrl, username, password);

                    String action = request.getParameter("action");

                    if (action != null && action.equals("insert")) {
                        PreparedStatement pstmt = connection.prepareStatement(
                            "INSERT INTO Advises (SSN, First_Name, Middle_Name, Last_Name) VALUES (?, ?, ?, ?)");
                        pstmt.setString(1, request.getParameter("SSN"));
                        pstmt.setString(2, request.getParameter("First_Name"));
                        pstmt.setString(3, request.getParameter("Middle_Name"));
                        pstmt.setString(4, request.getParameter("Last_Name"));
                        pstmt.executeUpdate();
                        pstmt.close();
                    }

                    if (action != null && action.equals("update")) {
                        PreparedStatement pstmt = connection.prepareStatement(
                            "UPDATE Advises SET First_Name = ?, Middle_Name = ?, Last_Name = ? WHERE SSN = ?");
                        pstmt.setString(1, request.getParameter("First_Name"));
                        pstmt.setString(2, request.getParameter("Middle_Name"));
                        pstmt.setString(3, request.getParameter("Last_Name"));
                        pstmt.setString(4, request.getParameter("SSN"));
                        pstmt.executeUpdate();
                        pstmt.close();
                    }

                    if (action != null && action.equals("delete")) {
                        PreparedStatement pstmt = connection.prepareStatement(
                            "DELETE FROM Advises WHERE SSN = ? AND First_Name = ? AND Middle_Name = ? AND Last_Name = ?");
                        pstmt.setString(1, request.getParameter("SSN"));
                        pstmt.setString(2, request.getParameter("First_Name"));
                        pstmt.setString(3, request.getParameter("Middle_Name"));
                        pstmt.setString(4, request.getParameter("Last_Name"));
                        pstmt.executeUpdate();
                        pstmt.close();
                    }

                    statement = connection.createStatement();
                    rs = statement.executeQuery("SELECT * FROM Advises");
                %>
                <table>
                    <tr>
                        <th>SSN</th>
                        <th>First Name</th>
                        <th>Middle Name</th>
                        <th>Last Name</th>
                    </tr>
                    <tr>
                        <form action="advises.jsp" method="get">
                            <input type="hidden" value="insert" name="action">
                            <th><input value="" name="SSN" size="15"></th>
                            <th><input value="" name="First_Name" size="15"></th>
                            <th><input value="" name="Middle_Name" size="15"></th>
                            <th><input value="" name="Last_Name" size="15"></th>
                            <th><input type="submit" value="Insert"></th>
                        </form>
                    </tr>
                    <%
                    while (rs.next()) {
                    %>
                    <tr>
                        <form action="advises.jsp" method="get">
                            <input type="hidden" value="update" name="action">
                            <input type="hidden" value="<%= rs.getString("SSN") %>" name="SSN">
                            <td><input value="<%= rs.getString("SSN") %>" name="SSN" size="15" readonly></td>
                            <td><input value="<%= rs.getString("First_Name") %>" name="First_Name" size="15"></td>
                            <td><input value="<%= rs.getString("Middle_Name") %>" name="Middle_Name" size="15"></td>
                            <td><input value="<%= rs.getString("Last_Name") %>" name="Last_Name" size="15"></td>
                            <td><input type="submit" value="Update"></td>
                        </form>
                        <form action="advises.jsp" method="get">
                            <input type="hidden" value="delete" name="action">
                            <input type="hidden" value="<%= rs.getString("SSN") %>" name="SSN">
                            <input type="hidden" value="<%= rs.getString("First_Name") %>" name="First_Name">
                            <input type="hidden" value="<%= rs.getString("Middle_Name") %>" name="Middle_Name">
                            <input type="hidden" value="<%= rs.getString("Last_Name") %>" name="Last_Name">
                            <td><input type="submit" value="Delete"></td>
                        </form>
                    </tr>
                    <%
                    }
                    %>
                </table>
                <%
                rs.close();
                statement.close();
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
