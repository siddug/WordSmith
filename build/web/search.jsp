<%-- 
    Document   : search
    Created on : 8 Nov, 2012, 3:37:07 AM
    Author     : varun
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Search results | Wordsmith</title>
        <link rel="icon" href="images/favicon.gif" type="image/x-icon"/>
        <!--[if lt IE 9]>
        <script src="http://html5shiv.googlecode.com/svn/trunk/html5.js"></script>
         <![endif]-->
        <link rel="shortcut icon" href="images/favicon.gif" type="image/x-icon"/> 
        <link rel="stylesheet" type="text/css" href="css/styles2.css"/>
    </head>
    <body>
        <%@ page import ="java.sql.*" %>
        <%@ page import ="javax.sql.*" %>
        <%
            String query=request.getParameter("query");
            String username = "";
            if (null == session.getAttribute("username")) {
            } else {
                username = session.getAttribute("username").toString();
            }
            Class.forName("com.mysql.jdbc.Driver");
            java.sql.Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/wordsmith", "root", "renderman");

            PreparedStatement getUser = con.prepareStatement("select * from user where user_id=?");
            getUser.setString(1, username);
            ResultSet userinfo = getUser.executeQuery();

            String firstname = "";
            String lastname = "";
            String lastvisit = "";
            int num_requests = 0;
            int num_works = 0;
            int num_notifications = 0;
            if (userinfo.next()) {
                firstname = userinfo.getString("first_name");
                lastname = userinfo.getString("last_name");
                lastvisit = userinfo.getString("last_visit");
                System.out.println(lastname);
            }
        %>
        <div class="bg">

            <!--start container-->
            <div id="container">
                <header>
                    <!--start header-->
                    <!--start menu-->
                    <nav>
                        <ul>
                            <!--start logo-->
                            <a href="home.jsp" style="color: #B22222;font-size: 30px;font-family:calibri;text-decoration:none;">Word</a>
                            <a href="home.jsp" style="color: #606060;font-size: 30px;font-family:calibri;text-decoration:none;">Smith </a>
                            <!--end logo-->
                            <li><a href="Logout">Logout</a></li><li>|</li>
                            <li><a href="profile.jsp?userid=<%=username%>">Profile</a></li><li>|</li>
                            <li><a href="works.jsp?userid=<%=username%>">My works</a></li>	<li>|</li>
                            <li><a href="notifications.jsp">Notifications</a></li>	<li>|</li>
                            <li><a href="requests.jsp">Requests</a></li><li>|</li>
                            <li><a href="home.jsp" id="current">Home</a></li>
                            <li id="searchbox" class="searchbox" style="width: 300px;"> <form action="search.jsp" method="get" class="form-wrapper-02"><input type="submit" value="search" id="submit"><input name="query" type="text" id="search" placeholder="Search users, works...">
                                </form></li>
                        </ul>
                    </nav>
                    <!--end menu-->
                    <!--end header-->
                </header>
            </div>
                            <br/><br/><br/><br/><br/>
                            <table style="width:986px;margin-left:auto;margin-right:auto;">
                                <tr>
                                    <td style="vertical-align:top; width:493px;">
                                        <div id="wrapper"><h1 style="margin-left:auto;margin-right:auto;">Related Users</h1></div>
                                        <ul>
                                            <%
                                            PreparedStatement getResults = con.prepareStatement("select * from user where first_name like ? or last_name like ?");
            getResults.setString(1, "%"+query+"%");
            getResults.setString(2, "%"+query+"%");
            ResultSet results = getResults.executeQuery();
            while(results.next()){
                String temp_firstname=results.getString("first_name");
                String temp_lastname=results.getString("last_name");                
                String temp_userid=results.getString("user_id");
        %>
        <li><a href="profile.jsp?userid=<%=temp_userid%>"><%=temp_firstname%> <%=temp_lastname%></a></li>
        <% } %>
                                        </ul>
                                    </td>

                                    <td style="vertical-align:top;">
                                        <div id="wrapper"><h1 style="margin-left:auto;margin-right:auto;">Related Works</h1></div>
                                        <ul>
                                            <%
                                            getResults = con.prepareStatement("select * from work where work_name like ? and permission=?");
            getResults.setString(1, "%"+query+"%");
            getResults.setString(2, "Pb");
            results = getResults.executeQuery();
            while(results.next()){
                String temp_workname=results.getString("work_name");
                String temp_workid=results.getString("work_id");
                String owner_userid=results.getString("user_id");
                                            %>
        <li><a href="work.jsp?workid=<%=temp_workid%>"><%=temp_workname%></a></li>
                                            <%
            }
                                            %>
                                        </ul>
                                    </td>
                                </tr>
                            </table>


                            <!--start footer-->
                            <footer>
                                <div class="container">  
                                    <div id="FooterTwo"> © 2012 WordSmith team IIT Bombay </div>
                                </div>
                            </footer>
                            <!--end footer-->
        </div>
   </div>
    </body>
</html>
