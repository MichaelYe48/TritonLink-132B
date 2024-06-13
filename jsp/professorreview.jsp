<%@ page language="java" import="java.sql.*, java.util.*, java.text.SimpleDateFormat, java.text.ParseException" %>
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
                            String studentSchedulesQuery = "SELECT DISTINCT " +
                               "    m.Day AS day_of_the_week, " +
                               "    m.Start_time AS time_start, " +
                               "    m.End_time AS time_end " +
                               "FROM Enrolled_In e " +
                               "JOIN Meeting m ON e.Section_ID = m.Section_ID " +
                               "WHERE e.Quarter = ? AND e.Year = ? " +
                               "AND m.Section_ID IN (" +
                               "    SELECT DISTINCT e2.Section_id " +
                               "    FROM Enrolled_In e2 " +
                               "    WHERE e2.SSN IN (" +
                               "        SELECT e3.SSN " +
                               "        FROM Enrolled_In e3 " +
                               "        WHERE e3.Section_id = ? " +
                               "          AND e3.Quarter = 'Spring' " +
                               "          AND e3.Year = 2018" +
                               "    )" +
                               "    AND e2.Quarter = 'Spring' " +
                               "    AND e2.Year = 2018" +
                               ")";
                            pstmtConflicts = connection.prepareStatement(studentSchedulesQuery);
                            pstmtConflicts.setString(1, "Spring"); // Set quarter
                            pstmtConflicts.setInt(2, 2018); // Set year
                            pstmtConflicts.setInt(3, Integer.parseInt(sectionID)); // Set section ID
                            
                            rsConflicts = pstmtConflicts.executeQuery();

                            // Process conflict times into a set
                            Set<String[]> conflictTimes = new HashSet<>();
                            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");

                            // Calculate all hourly slots between 8AM and 8PM for each day in the date range
                            List<String[]> allSlots = new ArrayList<>();
                            Calendar startCal = Calendar.getInstance();
                            startCal.setTime(sdf.parse(startDate));
                            Calendar endCal = Calendar.getInstance();
                            endCal.setTime(sdf.parse(endDate));

                            while (!startCal.after(endCal)) {
                                for (int hour = 8; hour < 20; hour++) {
                                    String[] slot = new String[4];
                                    slot[0] = sdf.format(startCal.getTime()); // Date
                                    slot[1] = hour + ":00"; // Time
                                    
                                    // Calculate end time (1 hour after start time)
                                    Calendar endTimeCal = Calendar.getInstance();
                                    endTimeCal.setTime(sdf.parse(slot[0]));
                                    endTimeCal.set(Calendar.HOUR_OF_DAY, hour + 1);
                                    slot[2] = new SimpleDateFormat("HH:mm").format(endTimeCal.getTime()); // End Time

                                    // Get day of the week
                                    int dayOfWeek = startCal.get(Calendar.DAY_OF_WEEK);
                                    String dayOfWeekStr;
                                    switch (dayOfWeek) {
                                        case Calendar.SUNDAY:
                                            dayOfWeekStr = "Su";
                                            break;
                                        case Calendar.MONDAY:
                                            dayOfWeekStr = "M";
                                            break;
                                        case Calendar.TUESDAY:
                                            dayOfWeekStr = "Tu";
                                            break;
                                        case Calendar.WEDNESDAY:
                                            dayOfWeekStr = "W";
                                            break;
                                        case Calendar.THURSDAY:
                                            dayOfWeekStr = "Th";
                                            break;
                                        case Calendar.FRIDAY:
                                            dayOfWeekStr = "F";
                                            break;
                                        case Calendar.SATURDAY:
                                            dayOfWeekStr = "Sa";
                                            break;
                                        default:
                                            dayOfWeekStr = "";
                                            break;
                                    }
                                    slot[3] = dayOfWeekStr; // Day of the week
                                    allSlots.add(slot);
                                }
                                startCal.add(Calendar.DATE, 1); // Increment by 1 day
                            }

                            // Add student schedule times to the conflict set
                            while (rsConflicts.next()) {
                                String dayOfWeek = rsConflicts.getString("day_of_the_week");
                                Time startTime = rsConflicts.getTime("time_start");
                                Time endTime = rsConflicts.getTime("time_end");

                                for (String day : dayOfWeek.split("\\|")) {
                                    String[] conflictSlot = new String[3];
                                    conflictSlot[0] = startTime.toString().substring(0, 5); // Time start
                                    conflictSlot[1] = endTime.toString().substring(0, 5); // Time end
                                    conflictSlot[2] = day; // Day of the week
                                    conflictTimes.add(conflictSlot);

                                    // Print the conflict slot details to the screen
                                    out.println("<p>Conflict Slot: Time Start=" + conflictSlot[0] + ", Time End=" + conflictSlot[1] + ", Day=" + conflictSlot[2] + "</p>");
                                }
                            }

                            // Remove conflict times from the set of all slots for each specific date
                            Iterator<String[]> slotIterator = allSlots.iterator();
                            while (slotIterator.hasNext()) {
                                String[] slot = slotIterator.next();
                                for (String[] conflictSlot : conflictTimes) {
                                    // Compare time and day to check for overlap
                                    SimpleDateFormat slotTimeFormat = new SimpleDateFormat("HH:mm");
                                    java.util.Date slotStartTime = slotTimeFormat.parse(slot[1]);
                                    java.util.Date slotEndTime = slotTimeFormat.parse(slot[2]);
                                    java.util.Date conflictStartTime = slotTimeFormat.parse(conflictSlot[0]);
                                    java.util.Date conflictEndTime = slotTimeFormat.parse(conflictSlot[1]);
                                    
                                    // Add one minute to the conflict start time
                                    Calendar cal = Calendar.getInstance();
                                    cal.setTime(conflictStartTime);
                                    cal.add(Calendar.MINUTE, 1);
                                    conflictStartTime = cal.getTime();
                                    if (conflictSlot[2].equals(slot[3]) &&
                                        !(slotEndTime.before(conflictStartTime) || conflictEndTime.before(slotStartTime))) {
                                        slotIterator.remove();
                                        break; // Remove only one slot per day per hour
                                    }
                                }
                            }

                            // Display available times
                            out.println("<h3>Available Times for Review Session:</h3>");
                            out.println("<table border='1'>");
                            out.println("<tr><th>Date</th><th>Day</th><th>Start Time</th><th>End Time</th></tr>");
                            for (String[] slot : allSlots) {
                                out.println("<tr><td>" + slot[0] + "</td><td>" + slot[3] + "</td><td>" + slot[1] + "</td><td>" + slot[2] + "</td>");
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
