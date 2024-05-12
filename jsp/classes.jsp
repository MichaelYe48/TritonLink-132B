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