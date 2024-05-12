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
                                "SELECT COUNT(*) FROM Undergraduate_student WHERE SSN = ?");
                            checkStmt.setString(1, request.getParameter("SSN"));
                            ResultSet checkResult = checkStmt.executeQuery();
                            checkResult.next();
                            int count = checkResult.getInt(1);
                            checkStmt.close();
                            
                            if (count == 0) { // If record doesn't exist, then insert
                                PreparedStatement pstmt = connection.prepareStatement(
                                    "INSERT INTO Undergraduate_student (SSN, College, Major, Minor, \"5_year_MS_program\") VALUES (?, ?, ?, ?, ?)");
                                pstmt.setString(1, request.getParameter("SSN"));
                                pstmt.setString(2, request.getParameter("College"));
                                pstmt.setString(3, request.getParameter("Major"));
                                pstmt.setString(4, request.getParameter("Minor"));
                                boolean msProgram = request.getParameter("5_year_MS_program") != null && request.getParameter("5_year_MS_program").equals("on");
                                pstmt.setBoolean(5, msProgram);
                                pstmt.executeUpdate();
                                pstmt.close();
                            } else {
                                out.println("Record already exists!");
                            }
                        }

                        // Update
                        // Check if an update is requested
                        if (action != null && action.equals("update")) {
                            connection.setAutoCommit(false);
                            // Create the prepared statement and use it to
                            // UPDATE the student attributes in the Student table.
                            PreparedStatement pstatement = connection.prepareStatement(
                                "UPDATE Undergraduate_student SET College = ?, Major = ?, Minor = ?, \"5_year_MS_program\" = ? WHERE SSN = ?");
                            pstatement.setString(1, request.getParameter("College"));
                            pstatement.setString(2, request.getParameter("Major"));
                            pstatement.setString(3, request.getParameter("Minor"));
                            boolean msProgram = request.getParameter("5_year_MS_program") != null && request.getParameter("5_year_MS_program").equals("on");
                            pstatement.setBoolean(4, msProgram);
                            pstatement.setString(5, request.getParameter("SSN"));

                            int rowCount = pstatement.executeUpdate();
                            connection.setAutoCommit(false);
                            // connection.setAutoCommit(true);
                            pstatement.close();
                        }

                        // Delete
                        // Check if a delete is requested
                        if (action != null && action.equals("delete")) {
                            PreparedStatement pstmt1 = connection.prepareStatement(
                                "DELETE FROM Undergraduate_student WHERE SSN = ?");
                            pstmt1.setString(1, request.getParameter("SSN"));
                            int rowCount = pstmt1.executeUpdate();
                            pstmt1.close();
                        }

                        // Create the statement
                        statement = connection.createStatement();
                        rs = statement.executeQuery("SELECT * FROM Undergraduate_student");
                    %>
                <table>
                    <tr>
                        <th>SSN</th>
                        <th>College</th>
                        <th>Major</th>
                        <th>Minor</th>
                        <th>5 Year MS Program</th>
                    </tr>
                    <tr>
                        <form action="undergrad_students.jsp" method="get">
                            <input type="hidden" value="insert" name="action">
                            <th><input value="" name="SSN" size="15"></th>
                            <th><input value="" name="College" size="15"></th>
                            <th><input value="" name="Major" size="15"></th>
                            <th><input value="" name="Minor" size="15"></th>
                            <th><input type="checkbox" name="5_year_MS_program"></th>
                            <th><input type="submit" value="Insert"></th>
                        </form>
                    </tr>
                    <%
                    // Iterate over the ResultSet
                    while ( rs.next() ) {
                    %>
                    <tr>
                        <form action="undergrad_students.jsp" method="get">
                            <input type="hidden" value="update" name="action">
                            <th><input value="<%= rs.getString("SSN") %>" name="SSN"></th>
                            <th><input value="<%= rs.getString("College") %>" name="College"></th>
                            <th><input value="<%= rs.getString("Major") %>" name="Major"></th>
                            <th><input value="<%= rs.getString("Minor") %>" name="Minor"></th>
                            <th><input type="checkbox" name="5_year_MS_program" <%= rs.getBoolean("5_year_MS_program") ? "checked" : "" %>></th>
                            <th><input type="submit" value="Update"></th>
                        </form>
                        <form action="undergrad_students.jsp" method="get">
                            <input type="hidden" value="delete" name="action">
                            <input type="hidden" value="<%= rs.getString("SSN") %>" name="SSN">
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
