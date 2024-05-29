<html>
<head>
    <script>
        function populateClasses() {
            var courseNumber = document.getElementById("course").value;
            var xhr = new XMLHttpRequest();
            xhr.onreadystatechange = function() {
                if (this.readyState == 4 && this.status == 200) {
                    document.getElementById("class").innerHTML = this.responseText;
                    populateSections(); // Automatically populate sections when classes change
                }
            };
            xhr.open("GET", "get_classes.jsp?courseNumber=" + courseNumber, true);
            xhr.send();
        }

        function populateSections() {
            var courseNumber = document.getElementById("course").value;
            var title = document.getElementById("class").value;
            var xhr = new XMLHttpRequest();
            xhr.onreadystatechange = function() {
                if (this.readyState == 4 && this.status == 200) {
                    document.getElementById("section").innerHTML = this.responseText;
                }
            };
            xhr.open("GET", "get_sections.jsp?courseNumber=" + courseNumber + "&title=" + title, true);
            xhr.send();
        }
    </script>
</head>
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
                    ResultSet rs2 = null;
                    Statement statement2 = null;

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
                                "SELECT COUNT(*) FROM Enrolled_In WHERE SSN = ? AND Course_number = ? AND Title = ? AND Section_id = ?");
                            checkStmt.setString(1, request.getParameter("SSN"));
                            checkStmt.setInt(2, Integer.parseInt(request.getParameter("Course_number")));
                            checkStmt.setString(3, request.getParameter("Title"));
                            checkStmt.setInt(4, Integer.parseInt(request.getParameter("Section_id")));
                            ResultSet checkResult = checkStmt.executeQuery();
                            checkResult.next();
                            int count = checkResult.getInt(1);
                            checkStmt.close();
                            
                            if (count == 0) { // If record doesn't exist, then insert
                                PreparedStatement pstmt = connection.prepareStatement(
                                    "INSERT INTO Enrolled_In (SSN, Course_number, Title, Section_id, Taken, Grade_Achieved) VALUES (?, ?, ?, ?, ?, ?)");
                                pstmt.setString(1, request.getParameter("SSN"));
                                pstmt.setInt(2, Integer.parseInt(request.getParameter("Course_number")));
                                pstmt.setString(3, request.getParameter("Title"));
                                pstmt.setInt(4, Integer.parseInt(request.getParameter("Section_id")));
                                boolean taken = request.getParameter("Taken") != null && request.getParameter("Taken").equals("on");
                                pstmt.setBoolean(5, taken);
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
                                "UPDATE Enrolled_In SET Taken = ?, Grade_Achieved = ? WHERE SSN = ? AND Course_number = ? AND Title = ? AND Section_id = ?");
                            boolean taken = request.getParameter("Taken") != null && request.getParameter("Taken").equals("on");
                            pstmt.setBoolean(1, taken);
                            pstmt.setString(2, request.getParameter("Grade_Achieved"));
                            pstmt.setString(3, request.getParameter("SSN"));
                            pstmt.setInt(4, Integer.parseInt(request.getParameter("Course_number")));
                            pstmt.setString(5, request.getParameter("Title"));
                            pstmt.setInt(6, Integer.parseInt(request.getParameter("Section_id")));
                            pstmt.executeUpdate();
                            pstmt.close();
                        }

                        // Delete
                        // Check if a delete is requested
                        if (action != null && action.equals("delete")) {
                            PreparedStatement pstmt1 = connection.prepareStatement(
                                "DELETE FROM Enrolled_In WHERE SSN = ? AND Course_number = ? AND Title = ? AND Section_id = ?");
                            pstmt1.setString(1, request.getParameter("SSN"));
                            pstmt1.setInt(2, Integer.parseInt(request.getParameter("Course_number")));
                            pstmt1.setString(3, request.getParameter("Title"));
                            pstmt1.setInt(4, Integer.parseInt(request.getParameter("Section_id")));
                            pstmt1.executeUpdate();
                            pstmt1.close();
                        }

                        // Create the statement
                        statement = connection.createStatement();
                        statement2 = connection.createStatement();
                        rs = statement.executeQuery("SELECT * FROM Enrolled_In");
                    %>
                <table>
                    <tr>
                        <th>SSN</th>
                        <th>Course</th>
                        <th>Class</th>
                        <th>Section</th>
                        <th>Taken</th>
                        <th>Grade Achieved</th>
                    </tr>
                    <tr>
                        <form action="enrolled_in.jsp" method="get">
                            <input type="hidden" value="insert" name="action">
                            <th><input value="" name="SSN" size="15"></th>
                            <th>
                                <select id="course" name="Course_number" onchange="populateClasses()">
                                    <%
                                        rs2 = statement2.executeQuery("SELECT * FROM Course");
                                        while (rs2.next()) {
                                    %>
                                    <option value="<%= rs2.getInt("Course_number") %>"><%= rs2.getString("Course_number") %></option>
                                    <%
                                        }
                                    %>
                                </select>
                            </th>
                            <th><select id="class" name="Title" onchange="populateSections()">
                            </select>
                            </th>
                            <th><select id="section" name="Section_id"></select></th>
                            <th><input type="checkbox" name="Taken"></th>
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
                            <th><input value="<%= rs.getString("SSN") %>" name="SSN"></th>
                            <th><input value="<%= rs.getString("Course_number") %>" name="Course_number"></th>
                            <th><input value="<%= rs.getString("Title") %>" name="Title"></th>
                            <th><input value="<%= rs.getInt("Section_id") %>" name="Section_id"></th>
                            <th><input type="checkbox" name="Taken" <%= rs.getBoolean("Taken") ? "checked" : "" %>></th>
                            <th><input value="<%= rs.getString("Grade_Achieved") %>" name="Grade_Achieved"></th>
                            <th><input type="submit" value="Update"></th>
                        </form>
                        <form action="enrolled_in.jsp" method="get">
                            <input type="hidden" value="delete" name="action">
                            <th><input type="hidden" value="<%= rs.getString("SSN") %>" name="SSN"></th>
                            <th><input type="hidden" value="<%= rs.getString("Course_number") %>" name="Course_number"></th>
                            <th><input type="hidden" value="<%= rs.getString("Title") %>" name="Title"></th>
                            <th><input type="hidden" value="<%= rs.getInt("Section_id") %>" name="Section_id"></th>
                            <th><input type="submit" value="Delete"></th>
                        </form>
                    </tr>
                    <%
                    }
                    %>
                </table>
                <%
                    rs2.close();
                    rs.close();
                    statement.close();
                    statement2.close();
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