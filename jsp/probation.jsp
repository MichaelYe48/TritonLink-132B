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
                            "INSERT INTO Probation (SSN, Reason, Start_Quarter, End_Quarter, Start_Year, End_Year) VALUES (?, ?, ?, ?, ?, ?)");
                        pstmt.setString(1, request.getParameter("SSN"));
                        pstmt.setString(2, request.getParameter("Reason"));
                        pstmt.setString(3, request.getParameter("Start_Quarter"));
                        pstmt.setString(4, request.getParameter("End_Quarter"));
                        pstmt.setInt(5, Integer.parseInt(request.getParameter("Start_Year")));
                        pstmt.setInt(6, Integer.parseInt(request.getParameter("End_Year")));
                        pstmt.executeUpdate();
                        pstmt.close();
                    }

                    if (action != null && action.equals("update")) {
                        PreparedStatement pstmt = connection.prepareStatement(
                            "UPDATE Probation SET Reason = ?, Start_Quarter = ?, End_Quarter = ?, Start_Year = ?, End_Year = ? WHERE SSN = ?");
                        pstmt.setString(1, request.getParameter("Reason"));
                        pstmt.setString(2, request.getParameter("Start_Quarter"));
                        pstmt.setString(3, request.getParameter("End_Quarter"));
                        pstmt.setInt(4, Integer.parseInt(request.getParameter("Start_Year")));
                        pstmt.setInt(5, Integer.parseInt(request.getParameter("End_Year")));
                        pstmt.setString(6, request.getParameter("SSN"));
                        pstmt.executeUpdate();
                        pstmt.close();
                    }

                    if (action != null && action.equals("delete")) {
                        PreparedStatement pstmt = connection.prepareStatement(
                            "DELETE FROM Probation WHERE SSN = ?");
                        pstmt.setString(1, request.getParameter("SSN"));
                        pstmt.executeUpdate();
                        pstmt.close();
                    }

                    statement = connection.createStatement();
                    rs = statement.executeQuery("SELECT * FROM Probation");
                %>
                <table>
                    <tr>
                        <th>SSN</th>
                        <th>Reason</th>
                        <th>Start Quarter</th>
                        <th>End Quarter</th>
                        <th>Start Year</th>
                        <th>End Year</th>
                    </tr>
                    <tr>
                        <form action="probation.jsp" method="get">
                            <input type="hidden" value="insert" name="action">
                            <th><input value="" name="SSN" size="15"></th>
                            <th><input value="" name="Reason" size="15"></th>
                            <th><input value="" name="Start_Quarter" size="15"></th>
                            <th><input value="" name="End_Quarter" size="15"></th>
                            <th><input value="" name="Start_Year" size="15"></th>
                            <th><input value="" name="End_Year" size="15"></th>
                            <th><input type="submit" value="Insert"></th>
                        </form>
                    </tr>
                    <%
                    while (rs.next()) {
                    %>
                    <tr>
                        <form action="probation.jsp" method="get">
                            <input type="hidden" value="update" name="action">
                            <th><input value="<%= rs.getString("SSN") %>" name="SSN"></th>
                            <th><input value="<%= rs.getString("Reason") %>" name="Reason"></th>
                            <th><input value="<%= rs.getString("Start_Quarter") %>" name="Start_Quarter"></th>
                            <th><input value="<%= rs.getString("End_Quarter") %>" name="End_Quarter"></th>
                            <th><input value="<%= rs.getInt("Start_Year") %>" name="Start_Year"></th>
                            <th><input value="<%= rs.getInt("End_Year") %>" name="End_Year"></th>
                            <th><input type="submit" value="Update"></th>
                        </form>
                        <form action="probation.jsp" method="get">
                            <input type="hidden" value="delete" name="action">
                            <input type="hidden" value="<%= rs.getString("SSN") %>" name="SSN">
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
