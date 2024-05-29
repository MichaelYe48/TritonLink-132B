<%@ page language="java" import="java.sql.*" %>
<%
    String jdbcUrl = "jdbc:postgresql://localhost:5432/cse132";
    String username = "dylanolivares";
    String password = "dylanolivares";

    try {
        Class.forName("org.postgresql.Driver");
        Connection connection = DriverManager.getConnection(jdbcUrl, username, password);
        Statement statement = connection.createStatement();
        ResultSet rs = statement.executeQuery("SELECT * FROM Course");
%>
<!DOCTYPE html>
<html>
<head>
    <title>Course Management System</title>
    <style>
        label {
            display: inline-block;
            width: 150px;
            margin-bottom: 10px;
        }
        select, input[type=text], input[type=number], input[type=checkbox], input[type=submit] {
            width: 200px;
            margin-bottom: 10px;
        }
    </style>
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
                <form action="enrolled_in.jsp" method="get">
                    <label for="course">Select Course:</label>
                    <select id="course" name="course" onchange="populateClasses()">
                        <%
                            while (rs.next()) {
                        %>
                        <option value="<%= rs.getInt("Course_number") %>"><%= rs.getString("Course_consent") %> - <%= rs.getString("Grade_type") %></option>
                        <%
                            }
                            rs.close();
                        %>
                    </select><br>
                    <label for="class">Select Class:</label>
                    <select id="class" name="class" onchange="populateSections()">
                        <!-- populated dynamically using JavaScript -->
                    </select><br>
                    <label for="section">Select Section:</label>
                    <select id="section" name="section">
                        <!-- populated dynamically using JavaScript -->
                    </select><br>
                    <label for="SSN">Student SSN:</label>
                    <input type="text" id="SSN" name="SSN" required><br>
                    <label for="Year">Year:</label>
                    <input type="number" id="Year" name="Year" required><br>
                    <label for="Quarter">Quarter:</label>
                    <input type="text" id="Quarter" name="Quarter" required><br>
                    <label for="Taken">Taken:</label>
                    <input type="checkbox" id="Taken" name="Taken"><br>
                    <label for="Grade_Achieved">Grade Achieved:</label>
                    <input type="text" id="Grade_Achieved" name="Grade_Achieved"><br>
                    <input type="hidden" value="insert" name="action">
                    <input type="submit" value="Insert">
                </form>
            </td>
        </tr>
    </table>
</body>
</html>
<%
    } catch (Exception e) {
        out.println("Exception: " + e.getMessage());
    }
%>

<%
    // Handle form submission
    if ("insert".equals(request.getParameter("action"))) {
        String SSN = request.getParameter("SSN");
        int Year = Integer.parseInt(request.getParameter("Year"));
        String Title = request.getParameter("class");
        String Quarter = request.getParameter("Quarter");
        boolean Taken = request.getParameter("Taken") != null;
        String Grade_Achieved = request.getParameter("Grade_Achieved");

        try {
            Class.forName("org.postgresql.Driver");
            Connection connection = DriverManager.getConnection(jdbcUrl, username, password);

            // Check if the record already exists
            PreparedStatement checkStmt = connection.prepareStatement(
                "SELECT COUNT(*) FROM Enrolled_In WHERE SSN = ? AND Year = ? AND Title = ? AND Quarter = ?");
            checkStmt.setString(1, SSN);
            checkStmt.setInt(2, Year);
            checkStmt.setString(3, Title);
            checkStmt.setString(4, Quarter);
            ResultSet checkResult = checkStmt.executeQuery();
            checkResult.next();
            int count = checkResult.getInt(1);
            checkStmt.close();

            if (count == 0) { // If record doesn't exist, then insert
                PreparedStatement pstmt = connection.prepareStatement(
                    "INSERT INTO Enrolled_In (SSN, Year, Title, Quarter, Taken, Grade_Achieved) VALUES (?, ?, ?, ?, ?, ?)");
                pstmt.setString(1, SSN);
                pstmt.setInt(2, Year);
                pstmt.setString(3, Title);
                pstmt.setString(4, Quarter);
                pstmt.setBoolean(5, Taken);
                pstmt.setString(6, Grade_Achieved);
                pstmt.executeUpdate();
                pstmt.close();
                out.println("Record inserted successfully!");
            } else {
                out.println("Record already exists!");
            }

            connection.close();
        } catch (SQLException sqle) {
            out.println("SQL Exception: " + sqle.getMessage());
            sqle.printStackTrace();
        } catch (ClassNotFoundException cnfe) {
            out.println("Class Not Found Exception: " + cnfe.getMessage());
            cnfe.printStackTrace();
        }
    }
%>