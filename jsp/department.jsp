<%@ page language="java" import="java.sql.*" %>
<html>
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

                try {
                    Class.forName("org.postgresql.Driver");
                    connection = DriverManager.getConnection(jdbcUrl, username, password);

                    String action = request.getParameter("action");

                    if (action != null) {
                        if (action.equals("insert")) {
                            PreparedStatement pstmt = connection.prepareStatement(
                                "INSERT INTO Department (Department_name) VALUES (?)");
                            pstmt.setString(1, request.getParameter("Department_name"));
                            pstmt.executeUpdate();
                            pstmt.close();
                        } else if (action.equals("update")) {
                            PreparedStatement pstmt = connection.prepareStatement(
                                "UPDATE Department SET Department_name = ? WHERE Department_name = ?");
                            pstmt.setString(1, request.getParameter("Department_name"));
                            pstmt.setString(2, request.getParameter("old_Department_name"));
                            pstmt.executeUpdate();
                            pstmt.close();
                        } else if (action.equals("delete")) {
                            PreparedStatement pstmt = connection.prepareStatement(
                                "DELETE FROM Department WHERE Department_name = ?");
                            pstmt.setString(1, request.getParameter("Department_name"));
                            pstmt.executeUpdate();
                            pstmt.close();
                        }
                    }

                    statement = connection.createStatement();
                    rs = statement.executeQuery("SELECT * FROM Department");
                %>
                <table>
                    <tr>
                        <th>Department Name</th>
                    </tr>
                    <tr>
                        <form action="department.jsp" method="get">
                            <input type="hidden" value="insert" name="action">
                            <th><input value="" name="Department_name" size="100"></th>
                            <th><input type="submit" value="Insert"></th>
                        </form>
                    </tr>
                    <%
                    while (rs.next()) {
                    %>
                    <tr>
                        <form action="department.jsp" method="get">
                            <input type="hidden" value="update" name="action">
                            <input type="hidden" value="<%= rs.getString("Department_name") %>" name="old_Department_name">
                            <th><input value="<%= rs.getString("Department_name") %>" name="Department_name" size="100"></th>
                            <th><input type="submit" value="Update"></th>
                        </form>
                        <form action="department.jsp" method="get">
                            <input type="hidden" value="delete" name="action">
                            <input type="hidden" value="<%= rs.getString("Department_name") %>" name="Department_name">
                            <td><input type="submit" value="Delete"></td>
                        </form>
                    </tr>
                    <%
                    }

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
                </table>
            </td>
        </tr>
    </table>
</body>
</html>
