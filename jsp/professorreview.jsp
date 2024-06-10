<%@ page language="java" import="java.sql.*, java.util.*, java.text.SimpleDateFormat" %>
<html>
<head>
    <title>Schedule Review Session</title>
</head>
<body>
    <table>
        <tr>
            <td>
                <jsp:include page="menu.html" />
            </td>
            <td>
                <form method="post">
                    <label for="sectionID">Select Section:</label>
                    <select id="sectionID" name="sectionID">
                        <%
                            String jdbcUrl = "jdbc:postgresql://localhost:5432/cse132";
                            String username = "dylanolivares";
                            String password = "dylanolivares";
                            Connection connection = null;
                            PreparedStatement pstmtSections = null;
                            ResultSet rsSections = null;

                            try {
                                // Load the PostgreSQL JDBC driver class
                                Class.forName("org.postgresql.Driver");

                                // Create a connection to the database
                                connection = DriverManager.getConnection(jdbcUrl, username, password);

                                // Query to get all sections in the current quarter
                                String sectionsQuery = "SELECT s.Section_id, c.Course_number " +
                                                      "FROM Section s " +
                                                      "JOIN Consists_of_Sections cos ON s.Section_id = cos.Section_ID " +
                                                      "JOIN Class c ON cos.Course_number = c.Course_number AND cos.Title = c.Title AND cos.Quarter = c.Quarter AND cos.Year = c.Year " +
                                                      "WHERE c.Quarter = ? AND c.Year = ?";
                                pstmtSections = connection.prepareStatement(sectionsQuery);
                                pstmtSections.setString(1, "Spring");
                                pstmtSections.setInt(2, 2018);
                                rsSections = pstmtSections.executeQuery();

                                // Populate the dropdown with sections
                                while (rsSections.next()) {
                                    int sectionID = rsSections.getInt("Section_id");
                                    int courseNumber = rsSections.getInt("Course_number");
                        %>
                        <option value="<%= sectionID %>"><%= sectionID %> - <%= courseNumber %></option>
                        <%
                                }
                            } catch (SQLException sqle) {
                                out.println("SQL Exception: " + sqle.getMessage());
                                sqle.printStackTrace();
                            } catch (ClassNotFoundException cnfe) {
                                out.println("Class Not Found Exception: " + cnfe.getMessage());
                                cnfe.printStackTrace();
                            } finally {
                                try {
                                    if (rsSections != null) rsSections.close();
                                    if (pstmtSections != null) pstmtSections.close();
                                    if (connection != null) connection.close();
                                } catch (SQLException sqle) {
                                    sqle.printStackTrace();
                                }
                            }
                        %>
                    </select>
                    <label for="startDate">Start Date:</label>
                    <input type="date" id="startDate" name="startDate">
                    <label for="endDate">End Date:</label>
                    <input type="date" id="endDate" name="endDate">
                    <input type="submit" value="Find Available Times">
                </form>

                <%
                    if (request.getMethod().equalsIgnoreCase("POST")) {
                        String sectionID = request.getParameter("sectionID");
                        String startDate = request.getParameter("startDate");
                        String endDate = request.getParameter("endDate");

                        connection = null;
                        PreparedStatement pstmtConflicts = null;
                        ResultSet rsConflicts = null;

                        try {
                            // Load the PostgreSQL JDBC driver class
                            Class.forName("org.postgresql.Driver");

                            // Create a connection to the database
                            connection = DriverManager.getConnection(jdbcUrl, username, password);

                            // Query to find all student schedules for the selected section within the date range
                            String studentSchedulesQuery = "SELECT m.Start_time, m.End_time, e.Section_ID " +
                                                           "FROM Enrolled_In e " +
                                                           "JOIN Meeting m ON e.Section_ID = m.Section_ID " +
                                                           "WHERE e.Quarter = ? AND e.Year = ? " +
                                                           "AND m.Start_date <= ? AND m.End_date >= ?";
                            pstmtConflicts = connection.prepareStatement(studentSchedulesQuery);
                            pstmtConflicts.setString(1, "Spring");
                            pstmtConflicts.setInt(2, 2018);
                            pstmtConflicts.setDate(3, java.sql.Date.valueOf(startDate));
                            pstmtConflicts.setDate(4, java.sql.Date.valueOf(endDate));
                            rsConflicts = pstmtConflicts.executeQuery();

                            // Process conflict times into a set
                            Set<String> conflictTimes = new HashSet<>();
                            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");

                            // Calculate all hourly slots between 8AM and 8PM for each day in the date range
                            List<String> allSlots = new ArrayList<>();
                            Calendar startCal = Calendar.getInstance();
                            startCal.setTime(sdf.parse(startDate));
                            Calendar endCal = Calendar.getInstance();
                            endCal.setTime(sdf.parse(endDate));

                            while (!startCal.after(endCal)) {
                                for (int hour = 8; hour < 20; hour++) {
                                    String slot = sdf.format(startCal.getTime()) + " " + hour + ":00";
                                    allSlots.add(slot);
                                }
                                startCal.add(Calendar.DATE, 1); // Increment by 1 day
                            }

                            // Add student schedule times to the conflict set
                            while (rsConflicts.next()) {
                                Time startTime = rsConflicts.getTime("Start_time");
                                Time endTime = rsConflicts.getTime("End_time");

                                Calendar cal = Calendar.getInstance();
                                cal.setTime(startTime);
                                int startHour = cal.get(Calendar.HOUR_OF_DAY);
                                cal.setTime(endTime);
                                int endHour = cal.get(Calendar.HOUR_OF_DAY);

                                for (int hour = startHour; hour < endHour; hour++) {
                                    conflictTimes.add(hour + ":00");
                                }
                            }

                            // Calculate recurring dates based on a 7-day interval from the start date
                            List<String> recurringDates = new ArrayList<>();
                            Calendar tempCal = Calendar.getInstance();
                            tempCal.setTime(sdf.parse(startDate));
                            while (tempCal.getTime().before(sdf.parse(endDate))) {
                                recurringDates.add(sdf.format(tempCal.getTime()));
                                tempCal.add(Calendar.DATE, 7); // Increment by 7 days
                            }

                            // Remove conflict times from the set of all slots for each specific date
                            for (String date : recurringDates) {
                                for (String slot : new ArrayList<>(allSlots)) {
                                    if (conflictTimes.contains(slot.split(" ")[1]) && slot.startsWith(date)) {
                                        allSlots.remove(slot);
                                    }
                                }
                            }

                            // Display available times
                            out.println("<h3>Available Times for Review Session:</h3>");
                            out.println("<table border='1'>");
                            out.println("<tr><th>Date</th><th>Time</th></tr>");
                            for (String slot : allSlots) {
                                String[] parts = slot.split(" ");
                                out.println("<tr><td>" + parts[0] + "</td><td>" + parts[1] + "</td></tr>");
                            }
                            out.println("</table>");

                        } catch (SQLException sqle) {
                            out.println("SQL Exception: " + sqle.getMessage());
                            sqle.printStackTrace();
                        } catch (ClassNotFoundException cnfe) {
                            out.println("Class Not Found Exception: " + cnfe.getMessage());
                            cnfe.printStackTrace();
                        } catch (Exception e) {
                            out.println("Exception: " + e.getMessage());
                            e.printStackTrace();
                        } finally {
                            try {
                                if (rsConflicts != null) rsConflicts.close();
                                if (pstmtConflicts != null) pstmtConflicts.close();
                                if (connection != null) connection.close();
                            } catch (SQLException sqle) {
                                sqle.printStackTrace();
                            }
                        }
                    }
                %>
            </td>
        </tr>
    </table>
</body>
</html>
