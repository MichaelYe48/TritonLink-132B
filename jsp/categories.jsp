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
                                "SELECT COUNT(*) FROM Category WHERE Category_name = ?");
                            checkStmt.setString(1, request.getParameter("Category_name"));
                            ResultSet checkResult = checkStmt.executeQuery();
                            checkResult.next();
                            int count = checkResult.getInt(1);
                            checkStmt.close();
                            
                            if (count == 0) { // If record doesn't exist, then insert
                                PreparedStatement pstmt = connection.prepareStatement(
                                    "INSERT INTO Category (Category_name, Minimum_average_grade, Units) VALUES (?, ?, ?)");
                                pstmt.setString(1, request.getParameter("Category_name"));
                                pstmt.setFloat(2, Float.parseFloat(request.getParameter("Minimum_average_grade")));
                                pstmt.setInt(3, Integer.parseInt(request.getParameter("Units")));
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
                            // UPDATE the Category attributes in the Category table.
                            PreparedStatement pstatement = connection.prepareStatement(
                                "UPDATE Category SET Minimum_average_grade = ?, Units = ? WHERE Category_name = ?");
                            pstatement.setFloat(1, Float.parseFloat(request.getParameter("Minimum_average_grade")));
                            pstatement.setInt(2, Integer.parseInt(request.getParameter("Units")));
                            pstatement.setString(3, request.getParameter("Category_name"));
                            pstatement.executeUpdate();
                            pstatement.close();
                        }

                        // Delete
                        // Check if a delete is requested
                        if (action != null && action.equals("delete")) {
                            PreparedStatement pstmt1 = connection.prepareStatement(
                                "DELETE FROM Category WHERE Category_name = ?");
                            pstmt1.setString(1, request.getParameter("Category_name"));
                            pstmt1.executeUpdate();
                            pstmt1.close();
                        }

                        // Create the statement
                        statement = connection.createStatement();
                        rs = statement.executeQuery("SELECT * FROM Category");
                    %>
                <table>
                    <tr>
                        <th>Category Name</th>
                        <th>Minimum Average Grade</th>
                        <th>Units</th>
                    </tr>
                    <tr>
                        <form action="categories.jsp" method="get">
                            <input type="hidden" value="insert" name="action">
                            <th><input value="" name="Category_name" size="15"></th>
                            <th><input value="" name="Minimum_average_grade" size="15"></th>
                            <th><input value="" name="Units" size="15"></th>
                            <th><input type="submit" value="Insert"></th>
                        </form>
                    </tr>
                    <%
                    // Iterate over the ResultSet
                    while (rs.next()) {
                    %>
                    <tr>
                        <form action="categories.jsp" method="get">
                            <input type="hidden" value="update" name="action">
                            <th><input value="<%= rs.getString("Category_name") %>" name="Category_name"></th>
                            <th><input value="<%= rs.getFloat("Minimum_average_grade") %>" name="Minimum_average_grade"></th>
                            <th><input value="<%= rs.getInt("Units") %>" name="Units"></th>
                            <th><input type="submit" value="Update"></th>
                        </form>
                        <form action="categories.jsp" method="get">
                            <input type="hidden" value="delete" name="action">
                            <input type="hidden" value="<%= rs.getString("Category_name") %>" name="Category_name">
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
