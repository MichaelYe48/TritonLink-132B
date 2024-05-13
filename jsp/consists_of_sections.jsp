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
                                "SELECT COUNT(*) FROM Consists_of_Sections WHERE Section_ID = ? AND Course_number = ? AND Year = ? AND Title = ? AND Quarter = ?");
                            checkStmt.setInt(1, Integer.parseInt(request.getParameter("Section_ID")));
                            checkStmt.setInt(2, Integer.parseInt(request.getParameter("Course_number")));
                            checkStmt.setInt(3, Integer.parseInt(request.getParameter("Year")));
                            checkStmt.setString(4, request.getParameter("Title"));
                            checkStmt.setString(5, request.getParameter("Quarter"));
                            ResultSet checkResult = checkStmt.executeQuery();
                            checkResult.next();
                            int count = checkResult.getInt(1);
                            checkStmt.close();
                            
                            if (count == 0) { // If record doesn't exist, then insert
                                PreparedStatement pstmt = connection.prepareStatement(
                                    "INSERT INTO Consists_of_Sections (Section_ID, Course_number, Year, Title, Quarter) VALUES (?, ?, ?, ?, ?)");
                                pstmt.setInt(1, Integer.parseInt(request.getParameter("Section_ID")));
                                pstmt.setInt(2, Integer.parseInt(request.getParameter("Course_number")));
                                pstmt.setInt(3, Integer.parseInt(request.getParameter("Year")));
                                pstmt.setString(4, request.getParameter("Title"));
                                pstmt.setString(5, request.getParameter("Quarter"));
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
                                "UPDATE Consists_of_Sections SET Section_ID = ?, Course_number = ?, Year = ?, Title = ?, Quarter = ? WHERE Section_ID = ? AND Course_number = ? AND Year = ? AND Title = ? AND Quarter = ?");
                            pstmt.setInt(1, Integer.parseInt(request.getParameter("New_Section_ID")));
                            pstmt.setInt(2, Integer.parseInt(request.getParameter("New_Course_number")));
                            pstmt.setInt(3, Integer.parseInt(request.getParameter("New_Year")));
                            pstmt.setString(4, request.getParameter("New_Title"));
                            pstmt.setString(5, request.getParameter("New_Quarter"));
                            pstmt.setInt(6, Integer.parseInt(request.getParameter("Section_ID")));
                            pstmt.setInt(7, Integer.parseInt(request.getParameter("Course_number")));
                            pstmt.setInt(8, Integer.parseInt(request.getParameter("Year")));
                            pstmt.setString(9, request.getParameter("Title"));
                            pstmt.setString(10, request.getParameter("Quarter"));
                            pstmt.executeUpdate();
                            pstmt.close();
                        }

                        // Delete
                        // Check if a delete is requested
                        if (action != null && action.equals("delete")) {
                            PreparedStatement pstmt1 = connection.prepareStatement(
                                "DELETE FROM Consists_of_Sections WHERE Section_ID = ? AND Course_number = ? AND Year = ? AND Title = ? AND Quarter = ?");
                            pstmt1.setInt(1, Integer.parseInt(request.getParameter("Section_ID")));
                            pstmt1.setInt(2, Integer.parseInt(request.getParameter("Course_number")));
                            pstmt1.setInt(3, Integer.parseInt(request.getParameter("Year")));
                            pstmt1.setString(4, request.getParameter("Title"));
                            pstmt1.setString(5, request.getParameter("Quarter"));
                            pstmt1.executeUpdate();
                            pstmt1.close();
                        }

                        // Create the statement
                        statement = connection.createStatement();
                        rs = statement.executeQuery("SELECT * FROM Consists_of_Sections");
                    %>
                <table>
                    <tr>
                        <th>Section ID</th>
                        <th>Course Number</th>
                        <th>Year</th>
                        <th>Title</th>
                        <th>Quarter</th>
                    </tr>
                    <tr>
                        <form action="consists_of_sections.jsp" method="get">
                            <input type="hidden" value="insert" name="action">
                            <th><input value="" name="Section_ID" size="15"></th>
                            <th><input value="" name="Course_number" size="15"></th>
                            <th><input value="" name="Year" size="15"></th>
                            <th><input value="" name="Title" size="15"></th>
                            <th><input value="" name="Quarter" size="15"></th>
                            <th><input type="submit" value="Insert"></th>
                        </form>
                    </tr>
                    <%
                    // Iterate over the ResultSet
                    while (rs.next()) {
                    %>
                    <tr>
                        <form action="consists_of_sections.jsp" method="get">
                            <input type="hidden" value="update" name="action">
                            <th><input value="<%= rs.getInt("Section_ID") %>" name="Section_ID"></th>
                            <th><input value="<%= rs.getInt("Course_number") %>" name="Course_number"></th>
                            <th><input value="<%= rs.getInt("Year") %>" name="Year"></th>
                            <th><input value="<%= rs.getString("Title") %>" name="Title"></th>
                            <th><input value="<%= rs.getString("Quarter") %>" name="Quarter"></th>
                            <th><input type="text" name="New_Section_ID"></th>
                            <th><input type="text" name="New_Course_number"></th>
                            <th><input type="text" name="New_Year"></th>
                            <th><input type="text" name="New_Title"></th>
                            <th><input type="text" name="New_Quarter"></th>
                            <th><input type="submit" value="Update"></th>
                        </form>
                        <form action="consists_of_sections.jsp" method="get">
                            <input type="hidden" value="delete" name="action">
                            <th><input type="hidden" value="<%= rs.getInt("Section_ID") %>" name="Section_ID"></th>
                            <th><input type="hidden" value="<%= rs.getInt("Course_number") %>" name="Course_number"></th>
                            <th><input type="hidden" value="<%= rs.getInt("Year") %>" name="Year"></th>
                            <th><input type="hidden" value="<%= rs.getString("Title") %>" name="Title"></th>
                            <th><input type="hidden" value="<%= rs.getString("Quarter") %>" name="Quarter"></th>
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
