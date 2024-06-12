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
                                "SELECT COUNT(*) FROM Section WHERE Section_id = ?");
                            checkStmt.setInt(1, Integer.parseInt(request.getParameter("Section_id")));
                            ResultSet checkResult = checkStmt.executeQuery();
                            checkResult.next();
                            int count = checkResult.getInt(1);
                            checkStmt.close();
                            
                            if (count == 0) { // If record doesn't exist, then insert
                                PreparedStatement pstmt = connection.prepareStatement(
                                    "INSERT INTO Section (Section_id, Enroll_limit, Number_enrolled) VALUES (?, ?, ?)");
                                pstmt.setInt(1, Integer.parseInt(request.getParameter("Section_id")));
                                pstmt.setInt(2, Integer.parseInt(request.getParameter("Enroll_limit")));
                                pstmt.setInt(3, 0);
                                pstmt.executeUpdate();
                                pstmt.close();
                            } else {
                                out.println("Record already exists!");
                            }
                        }


                        // Update
                        // Check if an update is requested
                        if (action != null && action.equals("update")) {
                            // Create the prepared statement and use it to
                            // UPDATE the Section attributes in the Section table.
                            PreparedStatement pstatement = connection.prepareStatement(
                                "UPDATE Section SET Enroll_limit = ? WHERE Section_id = ?");
                            pstatement.setInt(1, Integer.parseInt(request.getParameter("Enroll_limit")));
                            pstatement.setInt(2, Integer.parseInt(request.getParameter("Section_id")));
                            pstatement.executeUpdate();
                            pstatement.close();
                        }

                        // Delete
                        // Check if a delete is requested
                        if (action != null && action.equals("delete")) {
                            PreparedStatement pstmt1 = connection.prepareStatement(
                                "DELETE FROM Section WHERE Section_id = ?");
                            pstmt1.setInt(1, Integer.parseInt(request.getParameter("Section_id")));
                            pstmt1.executeUpdate();
                            pstmt1.close();
                        }

                        // Create the statement
                        statement = connection.createStatement();
                        rs = statement.executeQuery("SELECT * FROM Section");
                    %>
                <table>
                    <tr>
                        <th>Section ID</th>
                        <th>Enrollment Limit</th>
                        <th>Number Enrolled</th>
                    </tr>
                    <tr>
                        <form action="sections.jsp" method="get">
                            <input type="hidden" value="insert" name="action">
                            <th><input value="" name="Section_id" size="15"></th>
                            <th><input value="" name="Enroll_limit" size="15"></th>
                            <th><input value="" name="Number_enrolled" size="15" readonly></th>
                            <th><input type="submit" value="Insert"></th>
                        </form>
                    </tr>
                    <%
                    // Iterate over the ResultSet
                    while (rs.next()) {
                    %>
                    <tr>
                        <form action="sections.jsp" method="get">
                            <input type="hidden" value="update" name="action">
                            <th><input value="<%= rs.getInt("Section_id") %>" name="Section_id"></th>
                            <th><input value="<%= rs.getInt("Enroll_limit") %>" name="Enroll_limit"></th>
                            <th><input value="<%= rs.getInt("Number_enrolled") %>" name="Number_enrolled"></th>
                            <th><input type="submit" value="Update"></th>
                        </form>
                        <form action="sections.jsp" method="get">
                            <input type="hidden" value="delete" name="action">
                            <input type="hidden" value="<%= rs.getInt("Section_id") %>" name="Section_id">
                            <td><input type="submit" value="Delete"></td>
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
