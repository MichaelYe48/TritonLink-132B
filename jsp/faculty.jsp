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
                                "SELECT COUNT(*) FROM Faculty WHERE First_name = ? AND Middle_name = ? AND Last_name = ?");
                            checkStmt.setString(1, request.getParameter("First_name"));
                            checkStmt.setString(2, request.getParameter("Middle_name"));
                            checkStmt.setString(3, request.getParameter("Last_name"));
                            ResultSet checkResult = checkStmt.executeQuery();
                            checkResult.next();
                            int count = checkResult.getInt(1);
                            checkStmt.close();
                            
                            if (count == 0) { // If record doesn't exist, then insert
                                PreparedStatement pstmt = connection.prepareStatement(
                                    "INSERT INTO Faculty (First_name, Middle_name, Last_name, Title) VALUES (?, ?, ?, ?)");
                                pstmt.setString(1, request.getParameter("First_name"));
                                pstmt.setString(2, request.getParameter("Middle_name"));
                                pstmt.setString(3, request.getParameter("Last_name"));
                                pstmt.setString(4, request.getParameter("Title"));
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
                            // UPDATE the Faculty attributes in the Faculty table.
                            PreparedStatement pstatement = connection.prepareStatement(
                                "UPDATE Faculty SET Title = ? WHERE First_name = ? AND Middle_name = ? AND Last_name = ?");
                            pstatement.setString(1, request.getParameter("Title"));
                            pstatement.setString(2, request.getParameter("First_name"));
                            pstatement.setString(3, request.getParameter("Middle_name"));
                            pstatement.setString(4, request.getParameter("Last_name"));
                            pstatement.executeUpdate();
                            pstatement.close();
                        }

                        // Delete
                        // Check if a delete is requested
                        if (action != null && action.equals("delete")) {
                            PreparedStatement pstmt1 = connection.prepareStatement(
                                "DELETE FROM Faculty WHERE First_name = ? AND Middle_name = ? AND Last_name = ?");
                            pstmt1.setString(1, request.getParameter("First_name"));
                            pstmt1.setString(2, request.getParameter("Middle_name"));
                            pstmt1.setString(3, request.getParameter("Last_name"));
                            pstmt1.executeUpdate();
                            pstmt1.close();
                        }

                        // Create the statement
                        statement = connection.createStatement();
                        rs = statement.executeQuery("SELECT * FROM Faculty");
                    %>
                <table>
                    <tr>
                        <th>First Name</th>
                        <th>Middle Name</th>
                        <th>Last Name</th>
                        <th>Title</th>
                    </tr>
                    <tr>
                        <form action="faculty.jsp" method="get">
                            <input type="hidden" value="insert" name="action">
                            <th><input value="" name="First_name" size="15"></th>
                            <th><input value="" name="Middle_name" size="15"></th>
                            <th><input value="" name="Last_name" size="15"></th>
                            <th><input value="" name="Title" size="15"></th>
                            <th><input type="submit" value="Insert"></th>
                        </form>
                    </tr>
                    <%
                    // Iterate over the ResultSet
                    while (rs.next()) {
                    %>
                    <tr>
                        <form action="faculty.jsp" method="get">
                            <input type="hidden" value="update" name="action">
                            <th><input value="<%= rs.getString("First_name") %>" name="First_name"></th>
                            <th><input value="<%= rs.getString("Middle_name") %>" name="Middle_name"></th>
                            <th><input value="<%= rs.getString("Last_name") %>" name="Last_name"></th>
                            <th><input value="<%= rs.getString("Title") %>" name="Title"></th>
                            <th><input type="submit" value="Update"></th>
                        </form>
                        <form action="faculty.jsp" method="get">
                            <input type="hidden" value="delete" name="action">
                            <input type="hidden" value="<%= rs.getString("First_name") %>" name="First_name">
                            <input type="hidden" value="<%= rs.getString("Middle_name") %>" name="Middle_name">
                            <input type="hidden" value="<%= rs.getString("Last_name") %>" name="Last_name">
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
