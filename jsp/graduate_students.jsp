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
                                "SELECT COUNT(*) FROM Graduate_student WHERE SSN = ?");
                            checkStmt.setString(1, request.getParameter("SSN"));
                            ResultSet checkResult = checkStmt.executeQuery();
                            checkResult.next();
                            int count = checkResult.getInt(1);
                            checkStmt.close();

                            if (count == 0) { // If record doesn't exist, then insert
                                PreparedStatement pstmt = connection.prepareStatement(
                                    "INSERT INTO Graduate_student (SSN, Department) VALUES (?, ?)");
                                pstmt.setString(1, request.getParameter("SSN"));
                                pstmt.setString(2, request.getParameter("Department"));
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
                                "UPDATE Graduate_student SET Department = ? WHERE SSN = ?");
                            pstatement.setString(1, request.getParameter("Department"));
                            pstatement.setString(2, request.getParameter("SSN"));
                            int rowCount = pstatement.executeUpdate();
                            pstatement.close();
                        }

                        // Delete
                        // Check if a delete is requested
                        if (action != null && action.equals("delete")) {
                            PreparedStatement pstmt1 = connection.prepareStatement(
                                "DELETE FROM Graduate_student WHERE SSN = ?");
                            pstmt1.setString(1, request.getParameter("SSN"));
                            int rowCount = pstmt1.executeUpdate();
                            pstmt1.close();
                        }

                        // Create the statement
                        statement = connection.createStatement();
                        rs = statement.executeQuery("SELECT * FROM Graduate_student");
                    %>
                    <table>
                        <tr>
                            <th>SSN</th>
                            <th>Department</th>
                        </tr>
                        <tr>
                            <form action="graduate_students.jsp" method="get">
                                <input type="hidden" value="insert" name="action">
                                <th><input value="" name="SSN" size="15"></th>
                                <th><input value="" name="Department" size="15"></th>
                                <th><input type="submit" value="Insert"></th>
                            </form>
                        </tr>
                        <%
                            while (rs.next()) {
                        %>
                        <tr>
                            <form action="graduate_students.jsp" method="get">
                                <input type="hidden" value="update" name="action">
                                <th><input value="<%= rs.getString("SSN") %>" name="SSN"></th>
                                <th><input value="<%= rs.getString("Department") %>" name="Department"></th>
                                <th><input type="submit" value="Update"></th>
                            </form>
                            <form action="graduate_students.jsp" method="get">
                                <input type="hidden" value="delete" name="action">
                                <input type="hidden" value="<%= rs.getString("SSN") %>" name="SSN">
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
