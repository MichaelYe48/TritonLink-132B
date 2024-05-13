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
                                "INSERT INTO Candidates (SSN, Advisors, Thesis_commitee) VALUES (?, ?, ?)");
                            pstmt.setString(1, request.getParameter("SSN"));
                            pstmt.setString(2, request.getParameter("Advisors"));
                            pstmt.setString(3, request.getParameter("Thesis_commitee"));
                            pstmt.executeUpdate();
                            pstmt.close();
                        } else if (action.equals("update")) {
                            PreparedStatement pstmt = connection.prepareStatement(
                                "UPDATE Candidates SET Advisors = ?, Thesis_commitee = ? WHERE SSN = ?");
                            pstmt.setString(1, request.getParameter("Advisors"));
                            pstmt.setString(2, request.getParameter("Thesis_commitee"));
                            pstmt.setString(3, request.getParameter("SSN"));
                            pstmt.executeUpdate();
                            pstmt.close();
                        } else if (action.equals("delete")) {
                            PreparedStatement pstmt = connection.prepareStatement(
                                "DELETE FROM Candidates WHERE SSN = ?");
                            pstmt.setString(1, request.getParameter("SSN"));
                            pstmt.executeUpdate();
                            pstmt.close();
                        }
                    }

                    statement = connection.createStatement();
                    rs = statement.executeQuery("SELECT * FROM Candidates");
                %>
                <table>
                    <tr>
                        <th>SSN</th>
                        <th>Advisors</th>
                        <th>Thesis Committee</th>
                    </tr>
                    <tr>
                        <form action="candidates.jsp" method="get">
                            <input type="hidden" value="insert" name="action">
                            <th><input value="" name="SSN" size="10"></th>
                            <th><input value="" name="Advisors" size="50"></th>
                            <th><input value="" name="Thesis_commitee" size="50"></th>
                            <th><input type="submit" value="Insert"></th>
                        </form>
                    </tr>
                    <%
                    while (rs.next()) {
                    %>
                    <tr>
                        <form action="candidates.jsp" method="get">
                            <input type="hidden" value="update" name="action">
                            <th><input value="<%= rs.getString("SSN") %>" name="SSN" size="10"></th>
                            <th><input value="<%= rs.getString("Advisors") %>" name="Advisors" size="50"></th>
                            <th><input value="<%= rs.getString("Thesis_commitee") %>" name="Thesis_commitee" size="50"></th>
                            <th><input type="submit" value="Update"></th>
                        </form>
                        <form action="candidates.jsp" method="get">
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
