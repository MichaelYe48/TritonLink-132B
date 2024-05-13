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
                                "SELECT COUNT(*) FROM Enrolled_In WHERE SSN = ? AND Year = ? AND Title = ? AND Quarter = ?");
                            checkStmt.setString(1, request.getParameter("SSN"));
                            checkStmt.setInt(2, Integer.parseInt(request.getParameter("Year")));
                            checkStmt.setString(3, request.getParameter("Title"));
                            checkStmt.setString(4, request.getParameter("Quarter"));
                            ResultSet checkResult = checkStmt.executeQuery();
                            checkResult.next();
                            int count = checkResult.getInt(1);
                            checkStmt.close();
                            
                            if (count == 0) { // If record doesn't exist, then insert
                                PreparedStatement pstmt = connection.prepareStatement(
                                    "INSERT INTO Enrolled_In (SSN, Year, Title, Quarter, Zip_code, Grade_Achieved) VALUES (?, ?, ?, ?, ?, ?)");
                                pstmt.setString(1, request.getParameter("SSN"));
                                pstmt.setInt(2, Integer.parseInt(request.getParameter("Year")));
                                pstmt.setString(3, request.getParameter("Title"));
                                pstmt.setString(4, request.getParameter("Quarter"));
                                pstmt.setString(5, request.getParameter("Zip_code"));
                                pstmt.setString(6, request.getParameter("Grade_Achieved"));
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
                                "UPDATE Enrolled_In SET Year = ?, Title = ?, Quarter = ?, Zip_code = ?, Grade_Achieved = ? WHERE SSN = ? AND Year = ? AND Title = ? AND Quarter = ?");
                            pstmt.setInt(1, Integer.parseInt(request.getParameter("New_Year")));
                            pstmt.setString(2, request.getParameter("New_Title"));
                            pstmt.setString(3, request.getParameter("New_Quarter"));
                            pstmt.setString(4, request.getParameter("New_Zip_code"));
                            pstmt.setString(5, request.getParameter("New_Grade_Achieved"));
                            pstmt.setString(6, request.getParameter("SSN"));
                            pstmt.setInt(7, Integer.parseInt(request.getParameter("Year")));
                            pstmt.setString(8, request.getParameter("Title"));
                            pstmt.setString(9, request.getParameter("Quarter"));
                            pstmt.executeUpdate();
                            pstmt.close();
                        }

                        // Delete
                        // Check if a delete is requested
                        if (action != null && action.equals("delete")) {
                            PreparedStatement pstmt1 = connection.prepareStatement(
                                "DELETE FROM Enrolled_In WHERE SSN = ? AND Year = ? AND Title = ? AND Quarter = ?");
                            pstmt1.setString(1, request.getParameter("SSN"));
                            pstmt1.setInt(2, Integer.parseInt(request.getParameter("Year")));
                            pstmt1.setString(3, request.getParameter("Title"));
                            pstmt1.setString(4, request.getParameter("Quarter"));
                            pstmt1.executeUpdate();
                            pstmt1.close();
                        }

                        // Create the statement
                        statement = connection.createStatement();
                        rs = statement.executeQuery("SELECT * FROM Enrolled_In");
                    %>
                <table>
                    <tr>
                        <th>SSN</th>
                        <th>Year</th>
                        <th>Title</th>
                        <th>Quarter</th>
                        <th>Zip Code</th>
                        <th>Grade Achieved</th>
                    </tr>
                    <tr>
                        <form action="enrolled_in.jsp" method="get">
                            <input type="hidden" value="insert" name="action">
                            <th><input value="" name="SSN" size="15"></th>
                            <th><input value="" name="Year" size="15"></th>
                            <th><input value="" name="Title" size="15"></th>
                            <th><input value="" name="Quarter" size="15"></th>
                            <th><input value="" name="Zip_code" size="15"></th>
                            <th><input value="" name="Grade_Achieved" size="15"></th>
                            <th><input type="submit" value="Insert"></th>
                        </form>
                    </tr>
                    <%
                    // Iterate over the ResultSet
                    while (rs.next()) {
                    %>
                    <tr>
                        <form action="enrolled_in.jsp" method="get">
                            <input type="hidden" value="update" name="action">
                            <th><input value="<%= rs.getString("SSN") %>" name="SSN" readonly></th>
                            <th><input value="<%= rs.getInt("Year") %>" name="Year" readonly></th>
                            <th><input value="<%= rs.getString("Title") %>" name="Title" readonly></th>
                            <th><input value="<%= rs.getString("Quarter") %>" name="Quarter" readonly></th>
                            <th><input value="<%= rs.getString("Zip_code") %>" name="Zip_code" readonly></th>
                            <th><input value="<%= rs.getString("Grade_Achieved") %>" name="Grade_Achieved" readonly></th>
                            <th><input type="text" name="New_Year"></th>
                            <th><input type="text" name="New_Title"></th>
                            <th><input type="text" name="New_Quarter"></th>
                            <th><input type="text" name="New_Zip_code"></th>
                            <th><input type="text" name="New_Grade_Achieved"></th>
                            <th><input type="submit" value="Update"></th>
                        </form>
                        <form action="enrolled_in.jsp" method="get">
                            <input type="hidden" value="delete" name="action">
                            <th><input value="<%= rs.getString("SSN") %>" name="SSN" readonly></th>
                            <th><input value="<%= rs.getInt("Year") %>" name="Year" readonly></th>
                            <th><input value="<%= rs.getString("Title") %>" name="Title" readonly></th>
                            <th><input value="<%= rs.getString("Quarter") %>" name="Quarter" readonly></th>
                            <th><input value="<%= rs.getString("Zip_code") %>" name="Zip_code" readonly></th>
                            <th><input value="<%= rs.getString("Grade_Achieved") %>" name="Grade_Achieved" readonly></th>
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
