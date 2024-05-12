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
                        
                        if (action != null && action.equals("insert")) {
                            // Check if the record already exists
                            PreparedStatement checkStmt = connection.prepareStatement(
                                "SELECT COUNT(*) FROM Class WHERE Course_number = ? AND Title = ? AND Quarter = ? AND Year = ?");
                            checkStmt.setInt(1, Integer.parseInt(request.getParameter("Course_number")));
                            checkStmt.setString(2, request.getParameter("Title"));
                            checkStmt.setString(3, request.getParameter("Quarter"));
                            checkStmt.setInt(4, Integer.parseInt(request.getParameter("Year")));
                            ResultSet checkResult = checkStmt.executeQuery();
                            checkResult.next();
                            int count = checkResult.getInt(1);
                            checkStmt.close();
                            
                            if (count == 0) { // If record doesn't exist, then insert
                                PreparedStatement pstmt = connection.prepareStatement(
                                    "INSERT INTO Class (Course_number, Title, Quarter, Year) VALUES (?, ?, ?, ?)");
                                pstmt.setInt(1, Integer.parseInt(request.getParameter("Course_number")));
                                pstmt.setString(2, request.getParameter("Title"));
                                pstmt.setString(3, request.getParameter("Quarter"));
                                pstmt.setInt(4, Integer.parseInt(request.getParameter("Year")));
                                pstmt.executeUpdate();
                                pstmt.close();
                            } else {
                                out.println("Record already exists!");
                            }
                        }

                        if (action != null && action.equals("update")) {
                            PreparedStatement pstatement = connection.prepareStatement(
                                "UPDATE Class SET Title = ?, Quarter = ?, Year = ? WHERE Course_number = ?");
                            pstatement.setString(1, request.getParameter("Title"));
                            pstatement.setString(2, request.getParameter("Quarter"));
                            pstatement.setInt(3, Integer.parseInt(request.getParameter("Year")));
                            pstatement.setInt(4, Integer.parseInt(request.getParameter("Course_number")));
                            pstatement.executeUpdate();
                            pstatement.close();
                        }

                        if (action != null && action.equals("delete")) {
                            PreparedStatement pstmt1 = connection.prepareStatement(
                                "DELETE FROM Class WHERE Course_number = ?");
                            pstmt1.setInt(1, Integer.parseInt(request.getParameter("Course_number")));
                            pstmt1.executeUpdate();
                            pstmt1.close();
                        }

                        statement = connection.createStatement();
                        rs = statement.executeQuery("SELECT * FROM Class");
                    %>
                <table>
                    <tr>
                        <th>Course Number</th>
                        <th>Title</th>
                        <th>Quarter</th>
                        <th>Year</th>
                    </tr>
                    <tr>
                        <form action="classes.jsp" method="get">
                            <input type="hidden" value="insert" name="action">
                            <th><input value="" name="Course_number" size="15"></th>
                            <th><input value="" name="Title" size="15"></th>
                            <th><input value="" name="Quarter" size="15"></th>
                            <th><input value="" name="Year" size="15"></th>
                            <th><input type="submit" value="Insert"></th>
                        </form>
                    </tr>
                    <%
                        while (rs.next()) {
                    %>
                    <tr>
                        <form action="classes.jsp" method="get">
                            <input type="hidden" value="update" name="action">
                            <th><input value="<%= rs.getInt("Course_number") %>" name="Course_number"></th>
                            <th><input value="<%= rs.getString("Title") %>" name="Title"></th>
                            <th><input value="<%= rs.getString("Quarter") %>" name="Quarter"></th>
                            <th><input value="<%= rs.getInt("Year") %>" name="Year"></th>
                            <th><input type="submit" value="Update"></th>
                        </form>
                        <form action="classes.jsp" method="get">
                            <input type="hidden" value="delete" name="action">
                            <input type="hidden" value="<%= rs.getInt("Course_number") %>" name="Course_number">
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
