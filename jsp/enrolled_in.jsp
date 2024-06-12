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
            xhr.open("GET", "enrolled_helpers/get_classes.jsp?courseNumber=" + courseNumber, true);
            xhr.send();
        }

        function populateSections() {
            var courseNumber = document.getElementById("course").value;
            var title = document.getElementById("class").value;
            var xhr = new XMLHttpRequest();
            xhr.onreadystatechange = function() {
                if (this.readyState == 4 && this.status == 200) {
                    document.getElementById("section").innerHTML = this.responseText;
                    populateQuarter();
                    populateYear();
                }
            };
            xhr.open("GET", "enrolled_helpers/get_sections.jsp?courseNumber=" + courseNumber + "&title=" + title, true);
            xhr.send();
        }

        function populateQuarter() {
            var courseNumber = document.getElementById("course").value;
            var title = document.getElementById("class").value;
            var sectionId = document.getElementById("section").value;
            var xhr = new XMLHttpRequest();
            xhr.onreadystatechange = function() {
                if (this.readyState == 4 && this.status == 200) {
                    document.getElementById("quarter").value = this.responseText;
                }
            };
            xhr.open("GET", "enrolled_helpers/get_quarter.jsp?courseNumber=" + courseNumber + "&title=" + title + "&sectionId=" + sectionId, true);
            xhr.send();
        }

        function populateYear() {
            var courseNumber = document.getElementById("course").value;
            var title = document.getElementById("class").value;
            var sectionId = document.getElementById("section").value;
            var xhr = new XMLHttpRequest();
            xhr.onreadystatechange = function() {
                if (this.readyState == 4 && this.status == 200) {
                    document.getElementById("year").value = this.responseText;
                }
            };
            xhr.open("GET", "enrolled_helpers/get_year.jsp?courseNumber=" + courseNumber + "&title=" + title + "&sectionId=" + sectionId, true);
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
                        if (action != null) {
                            try {
                                if (action.equals("insert")) {
                                    // Insert operation
                                    PreparedStatement pstmt = connection.prepareStatement(
                                        "INSERT INTO Enrolled_In (SSN, Course_number, Title, Section_id, Quarter, Year, Taken, Grade_Achieved) VALUES (?, ?, ?, ?, ?, ?, ?, ?)");
                                    pstmt.setString(1, request.getParameter("SSN"));
                                    pstmt.setInt(2, Integer.parseInt(request.getParameter("Course_number")));
                                    pstmt.setString(3, request.getParameter("Title"));
                                    pstmt.setInt(4, Integer.parseInt(request.getParameter("Section_id")));
                                    pstmt.setString(5, request.getParameter("Quarter"));
                                    pstmt.setInt(6, Integer.parseInt(request.getParameter("Year")));
                                    boolean taken = request.getParameter("Taken") != null && request.getParameter("Taken").equals("on");
                                    pstmt.setBoolean(7, taken);
                                    pstmt.setString(8, request.getParameter("Grade_Achieved"));
                                    pstmt.executeUpdate();
                                    pstmt.close();
                                } else if (action.equals("update")) {
                                    // Update operation
                                    PreparedStatement pstmt = connection.prepareStatement(
                                        "UPDATE Enrolled_In SET Taken = ?, Grade_Achieved = ? WHERE SSN = ? AND Course_number = ? AND Title = ? AND Section_id = ? AND Quarter = ? AND Year = ?");
                                    boolean taken = request.getParameter("Taken") != null && request.getParameter("Taken").equals("on");
                                    pstmt.setBoolean(1, taken);
                                    pstmt.setString(2, request.getParameter("Grade_Achieved"));
                                    pstmt.setString(3, request.getParameter("SSN"));
                                    pstmt.setInt(4, Integer.parseInt(request.getParameter("Course_number")));
                                    pstmt.setString(5, request.getParameter("Title"));
                                    pstmt.setInt(6, Integer.parseInt(request.getParameter("Section_id")));
                                    pstmt.setString(7, request.getParameter("Quarter"));
                                    pstmt.setInt(8, Integer.parseInt(request.getParameter("Year")));
                                    pstmt.executeUpdate();
                                    pstmt.close();
                                } else if (action.equals("delete")) {
                                    // Delete operation
                                    PreparedStatement pstmt = connection.prepareStatement(
                                        "DELETE FROM Enrolled_In WHERE SSN = ? AND Course_number = ? AND Title = ? AND Section_id = ? AND Quarter = ? AND Year = ?");
                                    pstmt.setString(1, request.getParameter("SSN"));
                                    pstmt.setInt(2, Integer.parseInt(request.getParameter("Course_number")));
                                    pstmt.setString(3, request.getParameter("Title"));
                                    pstmt.setInt(4, Integer.parseInt(request.getParameter("Section_id")));
                                    pstmt.setString(5, request.getParameter("Quarter"));
                                    pstmt.setInt(6, Integer.parseInt(request.getParameter("Year")));
                                    pstmt.executeUpdate();
                                    pstmt.close();
                                }
                            } catch (SQLException e) {
                                String errorMessage = e.getMessage();
                                if (errorMessage.contains("Enrollment limit")) {
                                    errorMessage = errorMessage.split("Where:")[0].trim();  // Remove the 'Where:' part
                                }
                                out.println("Error: " + errorMessage);
                            }
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
                        <th>Quarter</th>
                        <th>Year</th>
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
                                    <option value="<%= rs2.getInt("Course_number") %>"><%= rs2.getInt("Course_number") %></option>
                                    <%
                                        }
                                    %>
                                </select>
                            </th>
                            <th><select id="class" name="Title" onchange="populateSections()">
                            </select>
                            </th>
                            <th><select id="section" name="Section_id" onchange="populateQuarter(); populateYear()"></select></th>
                            <th><input id="quarter" name="Quarter" size="15"></th>
                            <th><input id="year" name="Year" size="15"></th>
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
                            <th><input value="<%= rs.getString("Quarter") %>" name="Quarter"></th>
                            <th><input value="<%= rs.getInt("Year") %>" name="Year"></th>
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
                            <th><input type="hidden" value="<%= rs.getString("Quarter") %>" name="Quarter"></th>
                            <th><input type="hidden" value="<%= rs.getInt("Year") %>" name="Year"></th>
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