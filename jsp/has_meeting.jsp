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
                                "SELECT COUNT(*) FROM Has_Meeting WHERE Section_ID = ? AND Start_Time = ?");
                            checkStmt.setInt(1, Integer.parseInt(request.getParameter("Section_ID")));
                            checkStmt.setTime(2, java.sql.Time.valueOf(request.getParameter("Start_Time")));
                            ResultSet checkResult = checkStmt.executeQuery();
                            checkResult.next();
                            int count = checkResult.getInt(1);
                            checkStmt.close();
                            
                            if (count == 0) { // If record doesn't exist, then insert
                                PreparedStatement pstmt = connection.prepareStatement(
                                    "INSERT INTO Has_Meeting (Section_ID, Start_Time, End_Time) VALUES (?, ?, ?)");
                                pstmt.setInt(1, Integer.parseInt(request.getParameter("Section_ID")));
                                pstmt.setTime(2, java.sql.Time.valueOf(request.getParameter("Start_Time")));
                                pstmt.setTime(3, java.sql.Time.valueOf(request.getParameter("End_Time")));
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
                                "UPDATE Has_Meeting SET End_Time = ? WHERE Section_ID = ? AND Start_Time = ?");
                            pstmt.setTime(1, java.sql.Time.valueOf(request.getParameter("End_Time")));
                            pstmt.setInt(2, Integer.parseInt(request.getParameter("Section_ID")));
                            pstmt.setTime(3, java.sql.Time.valueOf(request.getParameter("Start_Time")));
                            pstmt.executeUpdate();
                            pstmt.close();
                        }

                        // Delete
                        // Check if a delete is requested
                        if (action != null && action.equals("delete")) {
                            PreparedStatement pstmt1 = connection.prepareStatement(
                                "DELETE FROM Has_Meeting WHERE Section_ID = ? AND Start_Time = ?");
                            pstmt1.setInt(1, Integer.parseInt(request.getParameter("Section_ID")));
                            pstmt1.setTime(2, java.sql.Time.valueOf(request.getParameter("Start_Time")));
                            pstmt1.executeUpdate();
                            pstmt1.close();
                        }

                        // Create the statement
                        statement = connection.createStatement();
                        rs = statement.executeQuery("SELECT * FROM Has_Meeting");
                    %>
                <table>
                    <tr>
                        <th>Section ID</th>
                        <th>Start Time</th>
                        <th>End Time</th>
                    </tr>
                    <tr>
                        <form action="has_meeting.jsp" method="get">
                            <input type="hidden" value="insert" name="action">
                            <th><input value="" name="Section_ID" size="15"></th>
                            <th><input value="" name="Start_Time" size="15"></th>
                            <th><input value="" name="End_Time" size="15"></th>
                            <th><input type="submit" value="Insert"></th>
                        </form>
                    </tr>
                    <%
                    // Iterate over the ResultSet
                    while (rs.next()) {
                    %>
                    <tr>
                        <form action="has_meeting.jsp" method="get">
                            <input type="hidden" value="update" name="action">
                            <input type="hidden" value="<%= rs.getInt("Section_ID") %>" name="Section_ID">
                            <input type="hidden" value="<%= rs.getTime("Start_Time") %>" name="Start_Time">
                            <th><input value="<%= rs.getInt("Section_ID") %>" name="Section_ID" readonly></th>
                            <th><input value="<%= rs.getTime("Start_Time") %>" name="Start_Time" readonly></th>
                            <th><input value="<%= rs.getTime("End_Time") %>" name="End_Time"></th>
                            <th><input type="submit" value="Update"></th>
                        </form>
                        <form action="has_meeting.jsp" method="get">
                            <input type="hidden" value="delete" name="action">
                            <th><input value="<%= rs.getInt("Section_ID") %>" name="Section_ID" readonly></th>
                            <th><input value="<%= rs.getTime("Start_Time") %>" name="Start_Time" readonly></th>
                            <th><input value="<%= rs.getTime("End_Time") %>" name="End_Time" readonly></th>
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
