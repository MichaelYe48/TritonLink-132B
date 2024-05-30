<%@ page language="java" import="java.sql.*" %>
<%
    String courseNumber = request.getParameter("courseNumber");
    String title = request.getParameter("title");
    String jdbcUrl = "jdbc:postgresql://localhost:5432/cse132";
    String username = "dylanolivares";
    String password = "dylanolivares";

    try {
        Class.forName("org.postgresql.Driver");
        Connection connection = DriverManager.getConnection(jdbcUrl, username, password);
        PreparedStatement pstmt = connection.prepareStatement("SELECT DISTINCT Year FROM Consists_of_Sections WHERE Course_number = ? AND Title = ?");
        pstmt.setInt(1, Integer.parseInt(courseNumber));
        pstmt.setString(2, title);
        ResultSet rs = pstmt.executeQuery();

        if (rs.next()) {
            out.print(rs.getInt("Year"));
        }
        
        rs.close();
        pstmt.close();
        connection.close();
    } catch (Exception e) {
        out.println("Exception: " + e.getMessage());
    }
%>