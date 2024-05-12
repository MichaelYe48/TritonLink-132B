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
                                "SELECT COUNT(*) FROM Course WHERE Course_number = ?");
                            checkStmt.setInt(1, Integer.parseInt(request.getParameter("Course_number")));
                            ResultSet checkResult = checkStmt.executeQuery();
                            checkResult.next();
                            int count = checkResult.getInt(1);
                            checkStmt.close();
                            
                            if (count == 0) { // If record doesn't exist, then insert
                                PreparedStatement pstmt = connection.prepareStatement(
                                    "INSERT INTO Course (Course_number, Course_consent, Grade_type, Lab, Units, Prerequisites) VALUES (?, ?, ?, ?, ?, ?)");
                                pstmt.setInt(1, Integer.parseInt(request.getParameter("Course_number")));
                                pstmt.setString(2, request.getParameter("Course_consent"));
                                pstmt.setString(3, request.getParameter("Grade_type"));
                                String labValue = request.getParameter("Lab");
                                boolean lab = labValue != null && labValue.equals("on");
                                pstmt.setBoolean(4, lab);
                                pstmt.setInt(5, Integer.parseInt(request.getParameter("Units")));
                                pstmt.setString(6, request.getParameter("Prerequisites"));
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
                        "UPDATE Course SET Course_consent = ?, Grade_type = ?, " +
                        "Lab = ?, Units = ?, Prerequisites = ? WHERE Course_number = ?");
                        pstatement.setString(1, request.getParameter("Course_consent"));
                        pstatement.setString(2, request.getParameter("Grade_type"));
                        String labValue = request.getParameter("Lab");
                        boolean lab = labValue != null && labValue.equals("on");
                        pstatement.setBoolean(3, lab);
                        pstatement.setInt(4, Integer.parseInt(request.getParameter("Units")));
                        pstatement.setString(5, request.getParameter("Prerequisites"));
                        pstatement.setInt(6, Integer.parseInt(request.getParameter("Course_number")));

                        int rowCount = pstatement.executeUpdate();
                        connection.setAutoCommit(false);
                        // connection.setAutoCommit(true);
                        pstatement.close();
                        }

                        // Delete
                        // Check if a delete is requested
                        if (action != null && action.equals("delete")) {
                        PreparedStatement pstmt1 = connection.prepareStatement(
                        "DELETE FROM Course WHERE Course_number = ?");
                        pstmt1.setInt(1,
                        Integer.parseInt(request.getParameter("Course_number")));
                        int rowCount = pstmt1.executeUpdate();
                        pstmt1.close();
                        }

                        // Create the statement
                        statement = connection.createStatement();
                        rs = statement.executeQuery("SELECT * FROM Course");
                    %>
                <table>
                    <tr>
                        <th>Course Number</th>
                        <th>Course Consent</th>
                        <th>Grade Type</th>
                        <th>Lab</th>
                        <th>Units</th>
                        <th>Prerequisites</th>
                    </tr>
                    <tr>
                        <form action="courses.jsp" method="get">
                            <input type="hidden" value="insert" name="action">
                            <th><input value="" name="Course_number" size="15"></th>
                            <th><input value="" name="Course_consent" size="15"></th>
                            <th><input value="" name="Grade_type" size="15"></th>
                            <th><input type="checkbox" name="Lab"></th>
                            <th><input value="" name="Units" size="15"></th>
                            <th><input value="" name="Prerequisites" size="15"></th>
                            <th><input type="submit" value="Insert"></th>
                        </form>
                    </tr>
                    <%
                    // Iterate over the ResultSet
                    while ( rs.next() ) {
                    %>
                    <tr>
                        <form action="courses.jsp" method="get">
                            <input type="hidden" value="update" name="action">
                            <th><input value="<%= rs.getInt("Course_number") %>" name="Course_number"></th>
                            <th><input value="<%= rs.getString("Course_consent") %>" name="Course_consent"></th>
                            <th><input value="<%= rs.getString("Grade_type") %>" name="Grade_type"></th>
                            <th><input type="checkbox" name="Lab" <%= rs.getBoolean("Lab") ? "checked" : "" %>></th>
                            <th><input value="<%= rs.getInt("Units") %>" name="Units"></th>
                            <th><input value="<%= rs.getString("Prerequisites") %>" name="Prerequisites"></th>
                            <th><input type="submit" value="Update"></th>
                        </form>
                        <form action="courses.jsp" method="get">
                            <input type="hidden" value="delete" name="action">
                            <input type="hidden" value="<%= rs.getInt("Course_number") %>" name="Course_number">
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