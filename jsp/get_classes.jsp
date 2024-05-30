<%@ page language="java" import="java.sql.*" %>
<%
    String courseNumber = request.getParameter("courseNumber");
    String jdbcUrl = "jdbc:postgresql://localhost:5432/cse132";
    String username = "dylanolivares";
    String password = "dylanolivares";

    try {
        Class.forName("org.postgresql.Driver");
        Connection connection = DriverManager.getConnection(jdbcUrl, username, password);
        PreparedStatement pstmt = connection.prepareStatement("SELECT * FROM Class WHERE Course_number = ?");
        pstmt.setInt(1, Integer.parseInt(courseNumber));
        ResultSet rs = pstmt.executeQuery();
        
        while (rs.next()) {
%>
<option value="<%= rs.getString("Title") %>"><%= rs.getString("Title") %> - <%= rs.getString("Quarter") %> <%= rs.getInt("Year") %></option>
<%
        }
        rs.close();
        pstmt.close();
        connection.close();
    } catch (Exception e) {
        out.println("Exception: " + e.getMessage());
    }
%>