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
                                "SELECT COUNT(*) FROM Account_information WHERE SSN = ?");
                            checkStmt.setString(1, request.getParameter("SSN"));
                            ResultSet checkResult = checkStmt.executeQuery();
                            checkResult.next();
                            int count = checkResult.getInt(1);
                            checkStmt.close();
                            
                            if (count == 0) { // If record doesn't exist, then insert
                                PreparedStatement pstmt = connection.prepareStatement(
                                    "INSERT INTO Account_information (SSN, Street, City, State, Zip_code, Financial_aid, Tuition_fees, Account_balance, Payment_history, Outstanding_charges, Transaction_history) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)");
                                pstmt.setString(1, request.getParameter("SSN"));
                                pstmt.setString(2, request.getParameter("Street"));
                                pstmt.setString(3, request.getParameter("City"));
                                pstmt.setString(4, request.getParameter("State"));
                                pstmt.setString(5, request.getParameter("Zip_code"));
                                pstmt.setFloat(6, Float.parseFloat(request.getParameter("Financial_aid")));
                                pstmt.setFloat(7, Float.parseFloat(request.getParameter("Tuition_fees")));
                                pstmt.setFloat(8, Float.parseFloat(request.getParameter("Account_balance")));
                                pstmt.setString(9, request.getParameter("Payment_history"));
                                pstmt.setFloat(10, Float.parseFloat(request.getParameter("Outstanding_charges")));
                                pstmt.setString(11, request.getParameter("Transaction_history"));
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
                            // UPDATE the Account_information attributes in the Account_information table.
                            PreparedStatement pstatement = connection.prepareStatement(
                                "UPDATE Account_information SET Street = ?, City = ?, State = ?, Zip_code = ?, Financial_aid = ?, Tuition_fees = ?, Account_balance = ?, Payment_history = ?, Outstanding_charges = ?, Transaction_history = ? WHERE SSN = ?");
                            pstatement.setString(1, request.getParameter("Street"));
                            pstatement.setString(2, request.getParameter("City"));
                            pstatement.setString(3, request.getParameter("State"));
                            pstatement.setString(4, request.getParameter("Zip_code"));
                            pstatement.setFloat(5, Float.parseFloat(request.getParameter("Financial_aid")));
                            pstatement.setFloat(6, Float.parseFloat(request.getParameter("Tuition_fees")));
                            pstatement.setFloat(7, Float.parseFloat(request.getParameter("Account_balance")));
                            pstatement.setString(8, request.getParameter("Payment_history"));
                            pstatement.setFloat(9, Float.parseFloat(request.getParameter("Outstanding_charges")));
                            pstatement.setString(10, request.getParameter("Transaction_history"));
                            pstatement.setString(11, request.getParameter("SSN"));
                            pstatement.executeUpdate();
                            pstatement.close();
                        }

                        // Delete
                        // Check if a delete is requested
                        if (action != null && action.equals("delete")) {
                            PreparedStatement pstmt1 = connection.prepareStatement(
                                "DELETE FROM Account_information WHERE SSN = ?");
                            pstmt1.setString(1, request.getParameter("SSN"));
                            pstmt1.executeUpdate();
                            pstmt1.close();
                        }

                        // Create the statement
                        statement = connection.createStatement();
                        rs = statement.executeQuery("SELECT * FROM Account_information");
                    %>
                <table>
                    <tr>
                        <th>SSN</th>
                        <th>Street</th>
                        <th>City</th>
                        <th>State</th>
                        <th>Zip Code</th>
                        <th>Financial Aid</th>
                        <th>Tuition Fees</th>
                        <th>Account Balance</th>
                        <th>Payment History</th>
                        <th>Outstanding Charges</th>
                        <th>Transaction History</th>
                    </tr>
                    <tr>
                        <form action="account_information.jsp" method="get">
                            <input type="hidden" value="insert" name="action">
                            <th><input value="" name="SSN" size="15"></th>
                            <th><input value="" name="Street" size="15"></th>
                            <th><input value="" name="City" size="15"></th>
                            <th><input value="" name="State" size="15"></th>
                            <th><input value="" name="Zip_code" size="15"></th>
                            <th><input value="" name="Financial_aid" size="15"></th>
                            <th><input value="" name="Tuition_fees" size="15"></th>
                            <th><input value="" name="Account_balance" size="15"></th>
                            <th><input value="" name="Payment_history" size="15"></th>
                            <th><input value="" name="Outstanding_charges" size="15"></th>
                            <th><input value="" name="Transaction_history" size="15"></th>
                            <th><input type="submit" value="Insert"></th>
                        </form>
                    </tr>
                    <%
                    // Iterate over the ResultSet
                    while (rs.next()) {
                    %>
                    <tr>
                        <form action="account_information.jsp" method="get">
                            <input type="hidden" value="update" name="action">
                            <th><input value="<%= rs.getString("SSN") %>" name="SSN"></th>
                            <th><input value="<%= rs.getString("Street") %>" name="Street"></th>
                            <th><input value="<%= rs.getString("City") %>" name="City"></th>
                            <th><input value="<%= rs.getString("State") %>" name="State"></th>
                            <th><input value="<%= rs.getString("Zip_code") %>" name="Zip_code"></th>
                            <th><input value="<%= rs.getFloat("Financial_aid") %>" name="Financial_aid"></th>
                            <th><input value="<%= rs.getFloat("Tuition_fees") %>" name="Tuition_fees"></th>
                            <th><input value="<%= rs.getFloat("Account_balance") %>" name="Account_balance"></th>
                            <th><input value="<%= rs.getString("Payment_history") %>" name="Payment_history"></th>
                            <th><input value="<%= rs.getFloat("Outstanding_charges") %>" name="Outstanding_charges"></th>
                            <th><input value="<%= rs.getString("Transaction_history") %>" name="Transaction_history"></th>
                            <th><input type="submit" value="Update"></th>
                        </form>
                        <form action="account_information.jsp" method="get">
                            <input type="hidden" value="delete" name="action">
                            <input type="hidden" value="<%= rs.getString("SSN") %>" name="SSN">
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
