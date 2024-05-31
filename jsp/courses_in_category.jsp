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
                            "INSERT INTO Courses_In_Category (Course_Number, Category_Name) VALUES (?, ?)");
                        pstmt.setInt(1, Integer.parseInt(request.getParameter("Course_Number")));
                        pstmt.setString(2, request.getParameter("Category_Name"));
                        pstmt.executeUpdate();
                        pstmt.close();
                    }

                    if (action != null && action.equals("update")) {
                        PreparedStatement pstmt = connection.prepareStatement(
                            "UPDATE Courses_In_Category SET Category_Name = ? WHERE Course_Number = ?");
                        pstmt.setString(1, request.getParameter("Category_Name"));
                        pstmt.setInt(2, Integer.parseInt(request.getParameter("Course_Number")));
                        pstmt.executeUpdate();
                        pstmt.close();
                    }

                    if (action != null && action.equals("delete")) {
                        PreparedStatement pstmt = connection.prepareStatement(
                            "DELETE FROM Courses_In_Category WHERE Course_Number = ? AND Category_Name = ?");
                        pstmt.setInt(1, Integer.parseInt(request.getParameter("Course_Number")));
                        pstmt.setString(2, request.getParameter("Category_Name"));
                        pstmt.executeUpdate();
                        pstmt.close();
                    }

                    statement = connection.createStatement();
                    rs = statement.executeQuery("SELECT * FROM Courses_In_Category");
                %>
                <table>
                    <tr>
                        <th>Course Number</th>
                        <th>Category Name</th>
                    </tr>
                    <tr>
                        <form action="courses_in_category.jsp" method="get">
                            <input type="hidden" value="insert" name="action">
                            <th><input value="" name="Course_Number" size="15"></th>
                            <th><input value="" name="Category_Name" size="15"></th>
                            <th><input type="submit" value="Insert"></th>
                        </form>
                    </tr>
                    <%
                    while (rs.next()) {
                    %>
                    <tr>
                        <form action="courses_in_category.jsp" method="get">
                            <input type="hidden" value="update" name="action">
                            <input type="hidden" value="<%= rs.getInt("Course_Number") %>" name="Course_Number">
                            <td><input value="<%= rs.getInt("Course_Number") %>" name="Course_Number" size="15" readonly></td>
                            <td><input value="<%= rs.getString("Category_Name") %>" name="Category_Name" size="15"></td>
                            <td><input type="submit" value="Update"></td>
                        </form>
                        <form action="courses_in_category.jsp" method="get">
                            <input type="hidden" value="delete" name="action">
                            <input type="hidden" value="<%= rs.getInt("Course_Number") %>" name="Course_Number">
                            <input type="hidden" value="<%= rs.getString("Category_Name") %>" name="Category_Name">
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