<%@ page language="java" import="java.sql.*" %>
<html>
<head>
    <title>Dates Attended Management</title>
</head>
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

                try {
                    // Load the PostgreSQL JDBC driver class
                    Class.forName("org.postgresql.Driver");

                    // Create a connection to the database
                    connection = DriverManager.getConnection(jdbcUrl, username, password);

                    // Check if an insertion is requested
                    String action = request.getParameter("action");
                    if (action != null && action.equals("insert")) {
                        // Insert a new record
                        PreparedStatement pstmt = connection.prepareStatement(
                            "INSERT INTO Dates_Attended (SSN, Start_Quarter, End_Quarter, Start_Year, End_Year) VALUES (?, ?, ?, ?, ?)");
                        pstmt.setString(1, request.getParameter("SSN"));
                        pstmt.setString(2, request.getParameter("Start_Quarter"));
                        pstmt.setString(3, request.getParameter("End_Quarter"));
                        pstmt.setInt(4, Integer.parseInt(request.getParameter("Start_Year")));
                        pstmt.setInt(5, Integer.parseInt(request.getParameter("End_Year")));
                        pstmt.executeUpdate();
                        pstmt.close();
                    }

                    // Create the statement
                    statement = connection.createStatement();
                    rs = statement.executeQuery("SELECT * FROM Dates_Attended");
                %>
                <table>
                    <tr>
                        <th>SSN</th>
                        <th>Start Quarter</th>
                        <th>End Quarter</th>
                        <th>Start Year</th>
                        <th>End Year</th>
                    </tr>
                    <tr>
                        <form action="dates_attended.jsp" method="post">
                            <input type="hidden" value="insert" name="action">
                            <th><input value="" name="SSN" size="10"></th>
                            <th><input value="" name="Start_Quarter" size="15"></th>
                            <th><input value="" name="End_Quarter" size="15"></th>
                            <th><input value="" name="Start_Year" size="5"></th>
                            <th><input value="" name="End_Year" size="5"></th>
                            <th><input type="submit" value="Insert"></th>
                        </form>
                    </tr>
                    <%
                    // Iterate over the ResultSet
                    while (rs.next()) {
                    %>
                    <tr>
                        <td><%= rs.getString("SSN") %></td>
                        <td><%= rs.getString("Start_Quarter") %></td>
                        <td><%= rs.getString("End_Quarter") %></td>
                        <td><%= rs.getInt("Start_Year") %></td>
                        <td><%= rs.getInt("End_Year") %></td>
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
