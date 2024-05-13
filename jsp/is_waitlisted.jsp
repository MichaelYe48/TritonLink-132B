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
                            "INSERT INTO Is_Waitlisted (SSN, Section_ID) VALUES (?, ?)");
                        pstmt.setString(1, request.getParameter("SSN"));
                        pstmt.setInt(2, Integer.parseInt(request.getParameter("Section_ID")));
                        pstmt.executeUpdate();
                        pstmt.close();
                    }

                    if (action != null && action.equals("update")) {
                        PreparedStatement pstmt = connection.prepareStatement(
                            "UPDATE Is_Waitlisted SET Section_ID = ? WHERE SSN = ?");
                        pstmt.setInt(1, Integer.parseInt(request.getParameter("Section_ID")));
                        pstmt.setString(2, request.getParameter("SSN"));
                        pstmt.executeUpdate();
                        pstmt.close();
                    }

                    if (action != null && action.equals("delete")) {
                        PreparedStatement pstmt = connection.prepareStatement(
                            "DELETE FROM Is_Waitlisted WHERE SSN = ? AND Section_ID = ?");
                        pstmt.setString(1, request.getParameter("SSN"));
                        pstmt.setInt(2, Integer.parseInt(request.getParameter("Section_ID")));
                        pstmt.executeUpdate();
                        pstmt.close();
                    }

                    statement = connection.createStatement();
                    rs = statement.executeQuery("SELECT * FROM Is_Waitlisted");
                %>
                <table>
                    <tr>
                        <th>SSN</th>
                        <th>Section ID</th>
                    </tr>
                    <tr>
                        <form action="is_waitlisted.jsp" method="get">
                            <input type="hidden" value="insert" name="action">
                            <th><input value="" name="SSN" size="15"></th>
                            <th><input value="" name="Section_ID" size="15"></th>
                            <th><input type="submit" value="Insert"></th>
                        </form>
                    </tr>
                    <%
                    while (rs.next()) {
                    %>
                    <tr>
                        <form action="is_waitlisted.jsp" method="get">
                            <input type="hidden" value="update" name="action">
                            <th><input value="<%= rs.getString("SSN") %>" name="SSN" size="15"></th>
                            <th><input value="<%= rs.getInt("Section_ID") %>" name="Section_ID" size="15"></th>
                            <th><input type="submit" value="Update"></th>
                        </form>
                        <form action="is_waitlisted.jsp" method="get">
                            <input type="hidden" value="delete" name="action">
                            <input type="hidden" value="<%= rs.getString("SSN") %>" name="SSN">
                            <input type="hidden" value="<%= rs.getInt("Section_ID") %>" name="Section_ID">
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
