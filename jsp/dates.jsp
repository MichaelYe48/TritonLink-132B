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
                                "SELECT COUNT(*) FROM Dates WHERE Start_Quarter = ? AND End_Quarter = ? AND Start_Year = ? AND End_Year = ?");
                            checkStmt.setString(1, request.getParameter("Start_Quarter"));
                            checkStmt.setString(2, request.getParameter("End_Quarter"));
                            checkStmt.setInt(3, Integer.parseInt(request.getParameter("Start_Year")));
                            checkStmt.setInt(4, Integer.parseInt(request.getParameter("End_Year")));
                            ResultSet checkResult = checkStmt.executeQuery();
                            checkResult.next();
                            int count = checkResult.getInt(1);
                            checkStmt.close();
                            
                            if (count == 0) { // If record doesn't exist, then insert
                                PreparedStatement pstmt = connection.prepareStatement(
                                    "INSERT INTO Dates (Start_Quarter, End_Quarter, Start_Year, End_Year) VALUES (?, ?, ?, ?)");
                                pstmt.setString(1, request.getParameter("Start_Quarter"));
                                pstmt.setString(2, request.getParameter("End_Quarter"));
                                pstmt.setInt(3, Integer.parseInt(request.getParameter("Start_Year")));
                                pstmt.setInt(4, Integer.parseInt(request.getParameter("End_Year")));
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
                            // UPDATE the Dates attributes in the Dates table.
                            PreparedStatement pstatement = connection.prepareStatement(
                                "UPDATE Dates SET Start_Year = ?, End_Year = ? WHERE Start_Quarter = ? AND End_Quarter = ?");
                            pstatement.setInt(1, Integer.parseInt(request.getParameter("Start_Year")));
                            pstatement.setInt(2, Integer.parseInt(request.getParameter("End_Year")));
                            pstatement.setString(3, request.getParameter("Start_Quarter"));
                            pstatement.setString(4, request.getParameter("End_Quarter"));
                            pstatement.executeUpdate();
                            pstatement.close();
                        }

                        // Delete
                        // Check if a delete is requested
                        if (action != null && action.equals("delete")) {
                            PreparedStatement pstmt1 = connection.prepareStatement(
                                "DELETE FROM Dates WHERE Start_Quarter = ? AND End_Quarter = ? AND Start_Year = ? AND End_Year = ?");
                            pstmt1.setString(1, request.getParameter("Start_Quarter"));
                            pstmt1.setString(2, request.getParameter("End_Quarter"));
                            pstmt1.setInt(3, Integer.parseInt(request.getParameter("Start_Year")));
                            pstmt1.setInt(4, Integer.parseInt(request.getParameter("End_Year")));
                            pstmt1.executeUpdate();
                            pstmt1.close();
                        }

                        // Create the statement
                        statement = connection.createStatement();
                        rs = statement.executeQuery("SELECT * FROM Dates");
                    %>
                <table>
                    <tr>
                        <th>Start Quarter</th>
                        <th>End Quarter</th>
                        <th>Start Year</th>
                        <th>End Year</th>
                    </tr>
                    <tr>
                        <form action="dates.jsp" method="get">
                            <input type="hidden" value="insert" name="action">
                            <th><input value="" name="Start_Quarter" size="15"></th>
                            <th><input value="" name="End_Quarter" size="15"></th>
                            <th><input value="" name="Start_Year" size="15"></th>
                            <th><input value="" name="End_Year" size="15"></th>
                            <th><input type="submit" value="Insert"></th>
                        </form>
                    </tr>
                    <%
                    // Iterate over the ResultSet
                    while (rs.next()) {
                    %>
                    <tr>
                        <form action="dates.jsp" method="get">
                            <input type="hidden" value="update" name="action">
                            <th><input value="<%= rs.getString("Start_Quarter") %>" name="Start_Quarter"></th>
                            <th><input value="<%= rs.getString("End_Quarter") %>" name="End_Quarter"></th>
                            <th><input value="<%= rs.getInt("Start_Year") %>" name="Start_Year"></th>
                            <th><input value="<%= rs.getInt("End_Year") %>" name="End_Year"></th>
                            <th><input type="submit" value="Update"></th>
                        </form>
                        <form action="dates.jsp" method="get">
                            <input type="hidden" value="delete" name="action">
                            <input type="hidden" value="<%= rs.getString("Start_Quarter") %>" name="Start_Quarter">
                            <input type="hidden" value="<%= rs.getString("End_Quarter") %>" name="End_Quarter">
                            <input type="hidden" value="<%= rs.getInt("Start_Year") %>" name="Start_Year">
                            <input type="hidden" value="<%= rs.getInt("End_Year") %>" name="End_Year">
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
