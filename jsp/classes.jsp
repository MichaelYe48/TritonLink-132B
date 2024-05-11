<html>
<body>
    <table>
        <tr>
            <td>
                <jsp:include page="../menu.html" />
            </td>
            <td>
                <%@ page language="java" import="java.sql.*" %>
                    <%
                        System.out.println("hello");
                        //try {
                            //DriverManager.registerDriver(new oracle.jdbc.driver.OracleDriver());
                            //Connection conn = DriverManager.getConnection("jdbc:oracle:thin:@feast.ucsd.edu:1521:source",“user", “pass");

                        //} catch (SQLException sqle) {
                            //out.println(sqle.getMessage());
                        //} catch (Exception e) {
                            //out.println(e.getMessage());
                        //}
                    %>
                <!-- Statement code
                Presentation code
                Close connection code -->
            </td>
        </tr>
    </table>
</body>
</html>