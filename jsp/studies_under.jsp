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
                                "SELECT COUNT(*) FROM Studies_Under WHERE SSN = ? AND Department_Name = ?");
                            checkStmt.setString(1, request.getParameter("SSN"));
                            checkStmt.setString(2, request.getParameter("Department_Name"));
                            ResultSet checkResult = checkStmt.executeQuery();
                            checkResult.next();
                            int count = checkResult.getInt(1);
                            checkStmt.close();
                            
                            if (count == 0) { // If record doesn't exist, then insert
                                PreparedStatement pstmt = connection.prepareStatement(
                                    "INSERT INTO Studies_Under (SSN, Department_Name) VALUES (?, ?)");
                                pstmt.setString(1, request.getParameter("SSN"));
                                pstmt.setString(2, request.getParameter("Department_Name"));
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
                                "UPDATE Studies_Under SET Department_Name = ? WHERE SSN = ?");
                            pstmt.setString(1, request.getParameter("Department_Name"));
                            pstmt.setString(2, request.getParameter("SSN"));
                            pstmt.executeUpdate();
                            pstmt.close();
                        }

                        // Delete
                        // Check if a delete is requested
                        if (action != null && action.equals("delete")) {
                            PreparedStatement pstmt1 = connection.prepareStatement(
                                "DELETE FROM Studies_Under WHERE SSN = ?");
                            pstmt1.setString(1, request.getParameter("SSN"));
                            pstmt1.executeUpdate();
                            pstmt1.close();
                        }

                        // Create the statement
                        statement = connection.createStatement();
                        rs = statement.executeQuery("SELECT * FROM Studies_Under");
                    %>
                <table>
                    <tr>
                        <th>SSN</th>
                        <th>Department Name</th>
                    </tr>
                    <tr>
                        <form action="studies_under.jsp" method="get">
                            <input type="hidden" value="insert" name="action">
                            <th><input value="" name="SSN" size="15"></th>
                            <th><input value="" name="Department_Name" size="15"></th>
                            <th><input type="submit" value="Insert"></th>
                        </form>
                    </tr>
                    <%
                    // Iterate over the ResultSet
                    while (rs.next()) {
                    %>
                    <tr>
                        <form action="studies_under.jsp" method="get">
                            <input type="hidden" value="update" name="action">
                            <th><input value="<%= rs.getString("SSN") %>" name="SSN"></th>
                            <th><input value="<%= rs.getString("Department_Name") %>" name="Department_Name"></th>
                            <th><input type="submit" value="Update"></th>
                        </form>
                        <form action="studies_under.jsp" method="get">
                            <input type="hidden" value="delete" name="action">
                            <th><input type="hidden" value="<%= rs.getString("SSN") %>" name="SSN"></th>
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
