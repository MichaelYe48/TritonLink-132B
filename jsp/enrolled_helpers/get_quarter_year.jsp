<%@ page language="java" import="java.sql.*" contentType="application/json; charset=UTF-8" %>
<%
    String courseNumber = request.getParameter("courseNumber");
    String title = request.getParameter("title");
    String jdbcUrl = "jdbc:postgresql://localhost:5432/cse132";
    String username = "dylanolivares";
    String password = "dylanolivares";

    try {
        Class.forName("org.postgresql.Driver");
        Connection connection = DriverManager.getConnection(jdbcUrl, username, password);
        PreparedStatement pstmt = connection.prepareStatement("SELECT Quarter, Year FROM Class WHERE Course_number = ? AND Title = ?");
        pstmt.setInt(1, Integer.parseInt(courseNumber));
        pstmt.setString(2, title);
        ResultSet rs = pstmt.executeQuery();
        
        if (rs.next()) {
            String quarter = rs.getString("Quarter");
            int year = rs.getInt("Year");
            out.print("{\"quarter\":\"" + quarter + "\", \"year\":" + year + "}");
        }
        rs.close();
        pstmt.close();
        connection.close();
    } catch (Exception e) {
        out.println("{\"error\":\"" + e.getMessage() + "\"}");
    }
%>