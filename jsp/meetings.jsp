<%@ page language="java" import="java.sql.*" %>
<html>
<body>
    <table>
        <tr>
            <td>
                <jsp:include page="menu.html" />
            </td>
            <td>
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

                    String action = request.getParameter("action");

                    if (action != null && action.equals("insert")) {
                        PreparedStatement pstmt = connection.prepareStatement(
                            "INSERT INTO Meeting (Section_id, Meeting_type, Location, Mandatory, Meeting_frequency, Start_date, End_date, Start_time, End_time) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)");
                        pstmt.setInt(1, Integer.parseInt(request.getParameter("Section_id")));
                        pstmt.setString(2, request.getParameter("Meeting_type"));
                        pstmt.setString(3, request.getParameter("Location"));
                        pstmt.setBoolean(4, request.getParameter("Mandatory") != null && request.getParameter("Mandatory").equals("on"));
                        pstmt.setString(5, request.getParameter("Meeting_frequency"));
                        pstmt.setDate(6, Date.valueOf(request.getParameter("Start_date")));
                        pstmt.setDate(7, Date.valueOf(request.getParameter("End_date")));
                        pstmt.setTime(8, Time.valueOf(request.getParameter("Start_time")));
                        pstmt.setTime(9, Time.valueOf(request.getParameter("End_time")));
                        pstmt.executeUpdate();
                        pstmt.close();
                    }

                    if (action != null && action.equals("update")) {
                        PreparedStatement pstmt = connection.prepareStatement(
                            "UPDATE Meeting SET Meeting_type = ?, Location = ?, Mandatory = ?, Meeting_frequency = ?, End_date = ?, End_time = ? WHERE Section_id = ? AND Start_date = ? AND Start_time = ?");
                        pstmt.setString(1, request.getParameter("Meeting_type"));
                        pstmt.setString(2, request.getParameter("Location"));
                        pstmt.setBoolean(3, request.getParameter("Mandatory") != null && request.getParameter("Mandatory").equals("on"));
                        pstmt.setString(4, request.getParameter("Meeting_frequency"));
                        pstmt.setDate(5, Date.valueOf(request.getParameter("End_date")));
                        pstmt.setTime(6, Time.valueOf(request.getParameter("End_time")));
                        pstmt.setInt(7, Integer.parseInt(request.getParameter("Section_id")));
                        pstmt.setDate(8, Date.valueOf(request.getParameter("Start_date")));
                        pstmt.setTime(9, Time.valueOf(request.getParameter("Start_time")));
                        pstmt.executeUpdate();
                        pstmt.close();
                    }

                    if (action != null && action.equals("delete")) {
                        PreparedStatement pstmt = connection.prepareStatement(
                            "DELETE FROM Meeting WHERE Section_id = ? AND Start_date = ? AND Start_time = ?");
                        pstmt.setInt(1, Integer.parseInt(request.getParameter("Section_id")));
                        pstmt.setDate(2, Date.valueOf(request.getParameter("Start_date")));
                        pstmt.setTime(3, Time.valueOf(request.getParameter("Start_time")));
                        pstmt.executeUpdate();
                        pstmt.close();
                    }

                    statement = connection.createStatement();
                    rs = statement.executeQuery("SELECT * FROM Meeting");
                %>
                <table>
                    <tr>
                        <th>Section ID</th>
                        <th>Meeting Type</th>
                        <th>Location</th>
                        <th>Mandatory</th>
                        <th>Meeting Frequency</th>
                        <th>Start Date</th>
                        <th>End Date</th>
                        <th>Start Time</th>
                        <th>End Time</th>
                    </tr>
                    <tr>
                        <form action="meetings.jsp" method="get">
                            <input type="hidden" value="insert" name="action">
                            <th><input value="" name="Section_id" size="15"></th>
                            <th><input value="" name="Meeting_type" size="15"></th>
                            <th><input value="" name="Location" size="15"></th>
                            <th><input type="checkbox" name="Mandatory"></th>
                            <th><input value="" name="Meeting_frequency" size="15"></th>
                            <th><input value="" name="Start_date" size="15"></th>
                            <th><input value="" name="End_date" size="15"></th>
                            <th><input value="" name="Start_time" size="15"></th>
                            <th><input value="" name="End_time" size="15"></th>
                            <th><input type="submit" value="Insert"></th>
                        </form>
                    </tr>
                    <%
                    while (rs.next()) {
                    %>
                    <tr>
                        <form action="meetings.jsp" method="get">
                            <input type="hidden" value="update" name="action">
                            <th><input value="<%= rs.getInt("Section_id") %>" name="Section_id"></th>
                            <th><input value="<%= rs.getString("Meeting_type") %>" name="Meeting_type"></th>
                            <th><input value="<%= rs.getString("Location") %>" name="Location"></th>
                            <th><input type="checkbox" name="Mandatory" <%= rs.getBoolean("Mandatory") ? "checked" : "" %>></th>
                            <th><input value="<%= rs.getString("Meeting_frequency") %>" name="Meeting_frequency"></th>
                            <th><input value="<%= rs.getDate("Start_date") %>" name="Start_date"></th>
                            <th><input value="<%= rs.getDate("End_date") %>" name="End_date"></th>
                            <th><input value="<%= rs.getTime("Start_time") %>" name="Start_time"></th>
                            <th><input value="<%= rs.getTime("End_time") %>" name="End_time"></th>
                            <th><input type="submit" value="Update"></th>
                        </form>
                        <form action="meetings.jsp" method="get">
                            <input type="hidden" value="delete" name="action">
                            <input type="hidden" value="<%= rs.getInt("Section_id") %>" name="Section_id">
                            <input type="hidden" value="<%= rs.getDate("Start_date") %>" name="Start_date">
                            <input type="hidden" value="<%= rs.getTime("Start_time") %>" name="Start_time">
                            <td><input type="submit" value="Delete"></td>
                        </form>
                    </tr>
                    <%
                    }
                    %>
                </table>
                <%
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
            </td>
        </tr>
    </table>
</body>
</html>
