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
                                "SELECT COUNT(*) FROM Taught_By WHERE Section_ID = ? AND First_Name = ? AND Middle_Name = ? AND Last_Name = ?");
                            checkStmt.setInt(1, Integer.parseInt(request.getParameter("Section_ID")));
                            checkStmt.setString(2, request.getParameter("First_Name"));
                            checkStmt.setString(3, request.getParameter("Middle_Name"));
                            checkStmt.setString(4, request.getParameter("Last_Name"));
                            ResultSet checkResult = checkStmt.executeQuery();
                            checkResult.next();
                            int count = checkResult.getInt(1);
                            checkStmt.close();
                            
                            if (count == 0) { // If record doesn't exist, then insert
                                PreparedStatement pstmt = connection.prepareStatement(
                                    "INSERT INTO Taught_By (Section_ID, First_Name, Middle_Name, Last_Name) VALUES (?, ?, ?, ?)");
                                pstmt.setInt(1, Integer.parseInt(request.getParameter("Section_ID")));
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
                                "UPDATE Taught_By SET First_Name = ?, Middle_Name = ?, Last_Name = ? WHERE Section_ID = ?");
                            pstmt.setString(1, request.getParameter("First_Name"));
                            pstmt.setString(2, request.getParameter("Middle_Name"));
                            pstmt.setString(3, request.getParameter("Last_Name"));
                            pstmt.setInt(4, Integer.parseInt(request.getParameter("Section_ID")));
                            pstmt.executeUpdate();
                            pstmt.close();
                        }

                        // Delete
                        // Check if a delete is requested
                        if (action != null && action.equals("delete")) {
                            PreparedStatement pstmt1 = connection.prepareStatement(
                                "DELETE FROM Taught_By WHERE Section_ID = ?");
                            pstmt1.setInt(1, Integer.parseInt(request.getParameter("Section_ID")));
                            pstmt1.executeUpdate();
                            pstmt1.close();
                        }

                        // Create the statement
                        statement = connection.createStatement();
                        rs = statement.executeQuery("SELECT * FROM Taught_By");
                    %>
                <table>
                    <tr>
                        <th>Section ID</th>
                        <th>First Name</th>
                        <th>Middle Name</th>
                        <th>Last Name</th>
                    </tr>
                    <tr>
                        <form action="taught_by.jsp" method="get">
                            <input type="hidden" value="insert" name="action">
                            <th><input value="" name="Section_ID" size="15"></th>
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
                        <form action="taught_by.jsp" method="get">
                            <input type="hidden" value="update" name="action">
                            <th><input value="<%= rs.getInt("Section_ID") %>" name="Section_ID"></th>
                            <th><input value="<%= rs.getString("First_Name") %>" name="First_Name"></th>
                            <th><input value="<%= rs.getString("Middle_Name") %>" name="Middle_Name"></th>
                            <th><input value="<%= rs.getString("Last_Name") %>" name="Last_Name"></th>
                            <th><input type="submit" value="Update"></th>
                        </form>
                        <form action="taught_by.jsp" method="get">
                            <input type="hidden" value="delete" name="action">
                            <th><input type="hidden" value="<%= rs.getInt("Section_ID") %>" name="Section_ID"></th>
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
