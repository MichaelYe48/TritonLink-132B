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
                                "INSERT INTO Masters_student (SSN, \"5_year_MS_program\") VALUES (?, ?)");
                            pstmt.setString(1, request.getParameter("SSN"));
                            String msProgramValue = request.getParameter("5_year_MS_program");
                            boolean msProgram = msProgramValue != null && msProgramValue.equals("on");
                            pstmt.setBoolean(2, msProgram);
                            pstmt.executeUpdate();
                            pstmt.close();
                        } else if (action.equals("update")) {
                            PreparedStatement pstmt = connection.prepareStatement(
                                "UPDATE Masters_student SET \"5_year_MS_program\" = ? WHERE SSN = ?");
                            String msProgramValue = request.getParameter("5_year_MS_program");
                            boolean msProgram = msProgramValue != null && msProgramValue.equals("on");
                            pstmt.setBoolean(1, msProgram);
                            pstmt.setString(2, request.getParameter("SSN"));
                            pstmt.executeUpdate();
                            pstmt.close();
                        } else if (action.equals("delete")) {
                            PreparedStatement pstmt = connection.prepareStatement(
                                "DELETE FROM Masters_student WHERE SSN = ?");
                            pstmt.setString(1, request.getParameter("SSN"));
                            pstmt.executeUpdate();
                            pstmt.close();
                        }
                    }

                    statement = connection.createStatement();
                    rs = statement.executeQuery("SELECT * FROM Masters_student");
                %>
                <table>
                    <tr>
                        <th>SSN</th>
                        <th>5-year MS Program</th>
                    </tr>
                    <tr>
                        <form action="masters_students.jsp" method="get">
                            <input type="hidden" value="insert" name="action">
                            <th><input value="" name="SSN" size="15"></th>
                            <th><input type="checkbox" name="5_year_MS_program"></th>
                            <th><input type="submit" value="Insert"></th>
                        </form>
                    </tr>
                    <%
                    while (rs.next()) {
                    %>
                    <tr>
                        <form action="masters_students.jsp" method="get">
                            <input type="hidden" value="update" name="action">
                            <th><input value="<%= rs.getString("SSN") %>" name="SSN"></th>
                            <th><input type="checkbox" name="5_year_MS_program" <%= rs.getBoolean("5_year_MS_program") ? "checked" : "" %>></th>
                            <th><input type="submit" value="Update"></th>
                        </form>
                        <form action="masters_students.jsp" method="get">
                            <input type="hidden" value="delete" name="action">
                            <input type="hidden" value="<%= rs.getString("SSN") %>" name="SSN">
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
