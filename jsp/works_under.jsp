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
            
                    // Try to establish a connection to the database
                    try {
                        // Load the PostgreSQL JDBC driver class
                        Class.forName("org.postgresql.Driver");
            
                        // Create a connection to the database
                        connection = DriverManager.getConnection(jdbcUrl, username, password);
                        
                        // Insert
                        // Check if an insertion is requested
                        String action = request.getParameter("action");
                        if (action != null && action.equals("insert")) {
                            // Check if the record already exists
                            PreparedStatement checkStmt = connection.prepareStatement(
                                "SELECT COUNT(*) FROM Works_Under WHERE Department_Name = ? AND First_Name = ? AND Middle_Name = ? AND Last_Name = ?");
                            checkStmt.setString(1, request.getParameter("Department_Name"));
                            checkStmt.setString(2, request.getParameter("First_Name"));
                            checkStmt.setString(3, request.getParameter("Middle_Name"));
                            checkStmt.setString(4, request.getParameter("Last_Name"));
                            ResultSet checkResult = checkStmt.executeQuery();
                            checkResult.next();
                            int count = checkResult.getInt(1);
                            checkStmt.close();
                            
                            if (count == 0) { // If record doesn't exist, then insert
                                PreparedStatement pstmt = connection.prepareStatement(
                                    "INSERT INTO Works_Under (Department_Name, First_Name, Middle_Name, Last_Name) VALUES (?, ?, ?, ?)");
                                pstmt.setString(1, request.getParameter("Department_Name"));
                                pstmt.setString(2, request.getParameter("First_Name"));
                                pstmt.setString(3, request.getParameter("Middle_Name"));
                                pstmt.setString(4, request.getParameter("Last_Name"));
                                pstmt.executeUpdate();
                                pstmt.close();
                            } else {
                                out.println("Record already exists!");
                            }
                        }

                        // Update
                        // Check if an update is requested
                        if (action != null && action.equals("update")) {
                            PreparedStatement pstmt = connection.prepareStatement(
                                "UPDATE Works_Under SET Department_Name = ?, First_Name = ?, Middle_Name = ?, Last_Name = ? WHERE Department_Name = ? AND First_Name = ? AND Middle_Name = ? AND Last_Name = ?");
                            pstmt.setString(1, request.getParameter("Department_Name"));
                            pstmt.setString(2, request.getParameter("First_Name"));
                            pstmt.setString(3, request.getParameter("Middle_Name"));
                            pstmt.setString(4, request.getParameter("Last_Name"));
                            pstmt.setString(5, request.getParameter("old_Department_Name"));
                            pstmt.setString(6, request.getParameter("old_First_Name"));
                            pstmt.setString(7, request.getParameter("old_Middle_Name"));
                            pstmt.setString(8, request.getParameter("old_Last_Name"));
                            pstmt.executeUpdate();
                            pstmt.close();
                        }

                        // Delete
                        // Check if a delete is requested
                        if (action != null && action.equals("delete")) {
                            PreparedStatement pstmt1 = connection.prepareStatement(
                                "DELETE FROM Works_Under WHERE Department_Name = ? AND First_Name = ? AND Middle_Name = ? AND Last_Name = ?");
                            pstmt1.setString(1, request.getParameter("Department_Name"));
                            pstmt1.setString(2, request.getParameter("First_Name"));
                            pstmt1.setString(3, request.getParameter("Middle_Name"));
                            pstmt1.setString(4, request.getParameter("Last_Name"));
                            pstmt1.executeUpdate();
                            pstmt1.close();
                        }

                        // Create the statement
                        statement = connection.createStatement();
                        rs = statement.executeQuery("SELECT * FROM Works_Under");
                    %>
                <table>
                    <tr>
                        <th>Department Name</th>
                        <th>First Name</th>
                        <th>Middle Name</th>
                        <th>Last Name</th>
                    </tr>
                    <tr>
                        <form action="works_under.jsp" method="get">
                            <input type="hidden" value="insert" name="action">
                            <th><input value="" name="Department_Name" size="15"></th>
                            <th><input value="" name="First_Name" size="15"></th>
                            <th><input value="" name="Middle_Name" size="15"></th>
                            <th><input value="" name="Last_Name" size="15"></th>
                            <th><input type="submit" value="Insert"></th>
                        </form>
                    </tr>
                    <%
                    // Iterate over the ResultSet
                    while (rs.next()) {
                    %>
                    <tr>
                        <form action="works_under.jsp" method="get">
                            <input type="hidden" value="update" name="action">
                            <input type="hidden" value="<%= rs.getString("Department_Name") %>" name="old_Department_Name">
                            <input type="hidden" value="<%= rs.getString("First_Name") %>" name="old_First_Name">
                            <input type="hidden" value="<%= rs.getString("Middle_Name") %>" name="old_Middle_Name">
                            <input type="hidden" value="<%= rs.getString("Last_Name") %>" name="old_Last_Name">
                            <th><input value="<%= rs.getString("Department_Name") %>" name="Department_Name"></th>
                            <th><input value="<%= rs.getString("First_Name") %>" name="First_Name"></th>
                            <th><input value="<%= rs.getString("Middle_Name") %>" name="Middle_Name"></th>
                            <th><input value="<%= rs.getString("Last_Name") %>" name="Last_Name"></th>
                            <th><input type="submit" value="Update"></th>
                        </form>
                        <form action="works_under.jsp" method="get">
                            <input type="hidden" value="delete" name="action">
                            <th><input type="hidden" value="<%= rs.getString("Department_Name") %>" name="Department_Name"></th>
                            <th><input type="hidden" value="<%= rs.getString("First_Name") %>" name="First_Name"></th>
                            <th><input type="hidden" value="<%= rs.getString("Middle_Name") %>" name="Middle_Name"></th>
                            <th><input type="hidden" value="<%= rs.getString("Last_Name") %>" name="Last_Name"></th>
                            <th><input type="submit" value="Delete"></th>
                        </form>
                    </tr>
                    <%
                    }
                    %>
                </table>
                <%
                // Close the ResultSet
                rs.close();
                // Close the Statement
                statement.close();
                // Close the Connection
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
