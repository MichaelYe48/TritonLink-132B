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
                        connection.setAutoCommit(false);
                        // Create the prepared statement and use it to
                        // INSERT the student attrs INTO the Student table.
                        PreparedStatement pstmt = connection.prepareStatement(
                        ("INSERT INTO Class VALUES (?, ?, ?, ?)"));
                        pstmt.setInt(1,Integer.parseInt(request.getParameter("Course_number")));
                        pstmt.setString(2, request.getParameter("Title"));
                        pstmt.setString(3, request.getParameter("Quarter"));
                        pstmt.setInt(4, Integer.parseInt(request.getParameter("Year")));
                       
                        pstmt.executeUpdate();
                        connection.commit();
                        connection.setAutoCommit(true);
                        pstmt.close();
                        }

                        // Update
                        // Check if an update is requested
                        if (action != null && action.equals("update")) {
                        connection.setAutoCommit(false);
                        // Create the prepared statement and use it to
                        // UPDATE the student attributes in the Student table.
                        PreparedStatement pstatement = connection.prepareStatement(
                        "UPDATE Class SET Title = ?, Quarter = ?, " +
                        "Year = ? WHERE Course_number = ?");
                        pstatement.setInt(1,Integer.parseInt(request.getParameter("Course_number")));
                        pstatement.setString(2, request.getParameter("Title"));
                        pstatement.setString(3, request.getParameter("Quarter"));
                        pstatement.setInt(4, Integer.parseInt(request.getParameter("Year")));

                        int rowCount = pstatement.executeUpdate();
                        connection.setAutoCommit(false);
                        connection.setAutoCommit(true);
                        pstatement.close();
                        }

                        // Delete
                        // Check if a delete is requested
                        if (action != null && action.equals("delete")) {
                        connection.setAutoCommit(false);
                        // Create the prepared statement and use it to
                        // DELETE the student FROM the Student table.
                        PreparedStatement pstmt1 = connection.prepareStatement(
                        "DELETE FROM Class WHERE Course_number = ?");
                        pstmt1.setInt(1,
                        Integer.parseInt(request.getParameter("Course_number")));
                        int rowCount = pstmt1.executeUpdate();
                        connection.setAutoCommit(false);
                        connection.setAutoCommit(true);
                        }

                        // Create the statement
                        statement = connection.createStatement();
                        // Use the statement to SELECT the student attributes
                        // FROM the Student table.
                        rs = statement.executeQuery("SELECT * FROM Class");            
                    %>
                <table>
                    <tr>
                        <th>Course Number</th>
                        <th>Title</th>
                        <th>Quarter</th>
                        <th>Year</th>
                    </tr>
                    <tr>
                        <form action="classes.jsp" method="get">
                        <input type="hidden" value="insert" name="action">
                        <th><input value="" name="Course_number" size="15"></th>
                        <th><input value="" name="Title" size="15"></th>
                        <th><input value="" name="Quarter" size="15"></th>
                        <th><input value="" name="Year" size="15"></th>
                        <th><input type="submit" value="Insert"></th>
                        </form>
                    </tr>
                    <tr>
                        <form action="classes.jsp" method="get">
                        <input type="hidden" value="update" name="action">
                        <td><input value="<%= rs.getInt("Course_number") %>" name="Course_number"></td>
                        <td><input value="<%= rs.getString("Title") %>" name="Title"></td>
                        <td><input value="<%= rs.getString("Quarter") %>" name="Quarter"></td>
                        <td><input value="<%= rs.getInt("Year") %>" name="Year"></td>
                        <td><input type="submit" value="Update"></td>
                        </form>

                        <form action="classes.jsp" method="get">
                        <input type="hidden" value="delete" name="action">
                        <input type="hidden" value="<%= rs.getInt("Course_number") %>"
                        name="Course_number">
                        <td><input type="submit" value="Delete"></td>
                        </form>
                    </tr>
                    <%
                    // Iterate over the ResultSet
                    if (rs != null) {
                    while ( rs.next() ) {
                    %>

                    <tr>
                        <%-- Get the Course Number --%>
                        <td><%= rs.getString("CourseNumber") %></td>
                        <%-- Get the Title --%>
                        <td><%= rs.getString("Title") %></td>
                        <%-- Get the Quarter --%>
                        <td><%= rs.getString("Quarter") %></td>
                        <%-- Get the Year --%>
                        <td><%= rs.getInt("Year") %></td>
                    </tr>

                <%
                    }
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