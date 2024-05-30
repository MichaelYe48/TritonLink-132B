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

                    try {
                        Class.forName("org.postgresql.Driver");
                        connection = DriverManager.getConnection(jdbcUrl, username, password);

                        // Insert
                        // Check if an insertion is requested
                        String action = request.getParameter("action");
                        if (action != null && action.equals("insert")) {
                            // Check if the record already exists
                            PreparedStatement checkStmt = connection.prepareStatement(
                                "SELECT COUNT(*) FROM Degree WHERE Degree_name = ?");
                            checkStmt.setString(1, request.getParameter("Degree_name"));
                            ResultSet checkResult = checkStmt.executeQuery();
                            checkResult.next();
                            int count = checkResult.getInt(1);
                            checkStmt.close();

                            if (count == 0) { // If record doesn't exist, then insert
                                PreparedStatement pstmt = connection.prepareStatement(
                                    "INSERT INTO Degree (Degree_name, Degree_Type, University, Total_units, Lower_div_units, Upper_div_units) VALUES (?, ?, ?, ?, ?, ?)");
                                pstmt.setString(1, request.getParameter("Degree_name"));
                                pstmt.setString(2, request.getParameter("Degree_Type"));
                                pstmt.setString(3, request.getParameter("University"));
                                pstmt.setInt(4, Integer.parseInt(request.getParameter("Total_units")));
                                pstmt.setInt(5, Integer.parseInt(request.getParameter("Lower_div_units")));
                                pstmt.setInt(6, Integer.parseInt(request.getParameter("Upper_div_units")));
                                pstmt.executeUpdate();
                                pstmt.close();
                            } else {
                                out.println("Record already exists!");
                            }
                        }

                        // Update
                        // Check if an update is requested
                        if (action != null && action.equals("update")) {
                            PreparedStatement pstatement = connection.prepareStatement(
                                "UPDATE Degree SET Degree_Type = ?, University = ?, Total_units = ?, Lower_div_units = ?, Upper_div_units = ? WHERE Degree_name = ?");
                            pstatement.setString(1, request.getParameter("Degree_Type"));
                            pstatement.setString(2, request.getParameter("University"));
                            pstatement.setInt(3, Integer.parseInt(request.getParameter("Total_units")));
                            pstatement.setInt(4, Integer.parseInt(request.getParameter("Lower_div_units")));
                            pstatement.setInt(5, Integer.parseInt(request.getParameter("Upper_div_units")));
                            pstatement.setString(6, request.getParameter("Degree_name"));
                            int rowCount = pstatement.executeUpdate();
                            pstatement.close();
                        }

                        // Delete
                        // Check if a delete is requested
                        if (action != null && action.equals("delete")) {
                            PreparedStatement pstmt1 = connection.prepareStatement(
                                "DELETE FROM Degree WHERE Degree_name = ?");
                            pstmt1.setString(1, request.getParameter("Degree_name"));
                            int rowCount = pstmt1.executeUpdate();
                            pstmt1.close();
                        }

                        // Create the statement
                        statement = connection.createStatement();
                        rs = statement.executeQuery("SELECT * FROM Degree");
                    %>
                    <table>
                        <tr>
                            <th>Degree Name</th>
                            <th>Degree Type</th>
                            <th>University</th>
                            <th>Total Units</th>
                            <th>Lower Div Units</th>
                            <th>Upper Div Units</th>
                        </tr>
                        <tr>
                            <form action="degree.jsp" method="get">
                                <input type="hidden" value="insert" name="action">
                                <th><input value="" name="Degree_name" size="15"></th>
                                <th><input value="" name="Degree_Type" size="15"></th>
                                <th><input value="" name="University" size="15"></th>
                                <th><input value="" name="Total_units" size="15"></th>
                                <th><input value="" name="Lower_div_units" size="15"></th>
                                <th><input value="" name="Upper_div_units" size="15"></th>
                                <th><input type="submit" value="Insert"></th>
                            </form>
                        </tr>
                        <%
                            while (rs.next()) {
                        %>
                        <tr>
                            <form action="degree.jsp" method="get">
                                <input type="hidden" value="update" name="action">
                                <th><input value="<%= rs.getString("Degree_name") %>" name="Degree_name"></th>
                                <th><input value="<%= rs.getString("Degree_Type") %>" name="Degree_Type"></th>
                                <th><input value="<%= rs.getString("University") %>" name="University"></th>
                                <th><input value="<%= rs.getInt("Total_units") %>" name="Total_units"></th>
                                <th><input value="<%= rs.getInt("Lower_div_units") %>" name="Lower_div_units"></th>
                                <th><input value="<%= rs.getInt("Upper_div_units") %>" name="Upper_div_units"></th>
                                <th><input type="submit" value="Update"></th>
                            </form>
                            <form action="degree.jsp" method="get">
                                <input type="hidden" value="delete" name="action">
                                <input type="hidden" value="<%= rs.getString("Degree_name") %>" name="Degree_name">
                                <td><input type="submit" value="Delete"></td>
                            </form>
                        </tr>
                        <%
                            }
                            rs.close();
                            statement.close();
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
                    </table>
            </td>
        </tr>
    </table>
</body>
</html>
