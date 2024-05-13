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
                                "SELECT COUNT(*) FROM Student_Account_Information WHERE SSN = ?");
                            checkStmt.setString(1, request.getParameter("SSN"));
                            ResultSet checkResult = checkStmt.executeQuery();
                            checkResult.next();
                            int count = checkResult.getInt(1);
                            checkStmt.close();
                            
                            if (count == 0) { // If record doesn't exist, then insert
                                PreparedStatement pstmt = connection.prepareStatement(
                                    "INSERT INTO Student_Account_Information (SSN, Street, City, State, Zip_code) VALUES (?, ?, ?, ?, ?)");
                                pstmt.setString(1, request.getParameter("SSN"));
                                pstmt.setString(2, request.getParameter("Street"));
                                pstmt.setString(3, request.getParameter("City"));
                                pstmt.setString(4, request.getParameter("State"));
                                pstmt.setString(5, request.getParameter("Zip_code"));
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
                                "UPDATE Student_Account_Information SET Street = ?, City = ?, State = ?, Zip_code = ? WHERE SSN = ?");
                            pstmt.setString(1, request.getParameter("Street"));
                            pstmt.setString(2, request.getParameter("City"));
                            pstmt.setString(3, request.getParameter("State"));
                            pstmt.setString(4, request.getParameter("Zip_code"));
                            pstmt.setString(5, request.getParameter("SSN"));
                            pstmt.executeUpdate();
                            pstmt.close();
                        }

                        // Delete
                        // Check if a delete is requested
                        if (action != null && action.equals("delete")) {
                            PreparedStatement pstmt1 = connection.prepareStatement(
                                "DELETE FROM Student_Account_Information WHERE SSN = ?");
                            pstmt1.setString(1, request.getParameter("SSN"));
                            pstmt1.executeUpdate();
                            pstmt1.close();
                        }

                        // Create the statement
                        statement = connection.createStatement();
                        rs = statement.executeQuery("SELECT * FROM Student_Account_Information");
                    %>
                <table>
                    <tr>
                        <th>SSN</th>
                        <th>Street</th>
                        <th>City</th>
                        <th>State</th>
                        <th>Zip Code</th>
                    </tr>
                    <tr>
                        <form action="student_account_information.jsp" method="get">
                            <input type="hidden" value="insert" name="action">
                            <th><input value="" name="SSN" size="15"></th>
                            <th><input value="" name="Street" size="15"></th>
                            <th><input value="" name="City" size="15"></th>
                            <th><input value="" name="State" size="15"></th>
                            <th><input value="" name="Zip_code" size="15"></th>
                            <th><input type="submit" value="Insert"></th>
                        </form>
                    </tr>
                    <%
                    // Iterate over the ResultSet
                    while (rs.next()) {
                    %>
                    <tr>
                        <form action="student_account_information.jsp" method="get">
                            <input type="hidden" value="update" name="action">
                            <th><input value="<%= rs.getString("SSN") %>" name="SSN" readonly></th>
                            <th><input value="<%= rs.getString("Street") %>" name="Street"></th>
                            <th><input value="<%= rs.getString("City") %>" name="City"></th>
                            <th><input value="<%= rs.getString("State") %>" name="State"></th>
                            <th><input value="<%= rs.getString("Zip_code") %>" name="Zip_code"></th>
                            <th><input type="submit" value="Update"></th>
                        </form>
                        <form action="student_account_information.jsp" method="get">
                            <input type="hidden" value="delete" name="action">
                            <th><input value="<%= rs.getString("SSN") %>" name="SSN" readonly></th>
                            <th><input value="<%= rs.getString("Street") %>" name="Street" readonly></th>
                            <th><input value="<%= rs.getString("City") %>" name="City" readonly></th>
                            <th><input value="<%= rs.getString("State") %>" name="State" readonly></th>
                            <th><input value="<%= rs.getString("Zip_code") %>" name="Zip_code" readonly></th>
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
