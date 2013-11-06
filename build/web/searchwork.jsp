<%-- 
    Document   : searchuser
    Created on : 7 Nov, 2012, 1:13:27 PM
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

            PreparedStatement prepStmt1 = con.prepareStatement("select count(*) from activity where work_id in (select work_id from works_following where user_id=?) and timestamp>?");
            prepStmt1.setString(1, username);
            prepStmt1.setString(2, lastvisit);
            ResultSet rs2 = prepStmt1.executeQuery();
            if (rs2.next()) {
                num_notifications = rs2.getInt(1);
            }

            prepStmt1 = con.prepareStatement("select * from work where work_id_origin in (select work_id from work where user_id=?) and pull_request=?");
            prepStmt1.setString(1, username);
            prepStmt1.setString(2, "Y");
            rs2 = prepStmt1.executeQuery();
            if (rs2.next()) {
                num_requests = rs2.getInt(1);
            }

            prepStmt1 = con.prepareStatement("select count(*) from work where user_id=?");
            prepStmt1.setString(1, username);
            rs2 = prepStmt1.executeQuery();
            if (rs2.next()) {
                num_works = rs2.getInt(1);
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
                        </ul>
                    </nav>
                    <!--end menu-->
                    <!--end header-->
                </header>
                <br/>
                <br/>
                <table style="margin-top:15px;">
                    <tr>
                        <td style="width:30%; border-right:dotted 0.25px; vertical-align:top;">

                            <h2 style="text-align:center; font-size:20px; font-family:Georgia; border-bottom:dotted 0.25px; margin-top: 10px;"> <%=firstname%> <%=lastname%></h2>
                            <ul>
                                <li>Last visit: <%=lastvisit%></li>
                                <li><a href="works.jsp?userid=<%=username%>">Yours works <%= num_works%></a></li>
                                <li><a href="requests.jsp">Pending requests <%= num_requests%></a></li>
                                <li><a href="notifications.jsp">Notifications <%= num_notifications%></a></li>
                            </ul>
                        </td>
                        <td style="width:70%; padding-left: 20px; padding-right: 20px; pading-bottom: 10px; ">
                            <br/>
        	Below is the list of search results. These correspond to the actions happening on the works you are following.
        	<br/><br/>
                            <div id="wrapper"><h1>Search: <%=query%></h1></div>
        <%
            PreparedStatement getResults = con.prepareStatement("select * from work where work_name like ? and permission=?");
            getResults.setString(1, "%"+query+"%");
            getResults.setString(2, "Pb");
            ResultSet results = getResults.executeQuery();
            while(results.next()){
                String temp_workname=results.getString("work_name");
                String temp_workid=results.getString("work_id");
                String owner_userid=results.getString("user_id");
                PreparedStatement pstmt=con.prepareStatement("select * from works_following where work_id=? and user_id=?");
                pstmt.setString(1, temp_workid);
                pstmt.setString(2, username);
                ResultSet rs=pstmt.executeQuery();
                String button_value = "";
                if (rs.next()) {
                    button_value = "Unfollow";
                } else {
                    button_value = "Follow";
                }
        %>
        <form id="link" method="post" action="FollowHandle">
            <a href="work.jsp?workid=<%=temp_workid%>" id="follower_name"><%=temp_workname%></a>
            <%if(!username.equals(owner_userid)){ %>
            <input name="user_or_work" value="work" type="hidden"/><input name="workid" value="<%=temp_workid%>" type="hidden"/><input name="action" value="<%=button_value%>" type="hidden"/><input name="asked_page" value="searchwork.jsp?query=<%=query%>" type="hidden"/><input id="button" type="submit" value="<%=button_value%>"/>
            <% } %>
        </form>
        <%
            }
            con.close();
        %>
        </td>
        </tr>
        </table>
	
   </div>
   <!--end container-->
	
   <!--start footer-->
   <footer>
      <div class="container">  
         <div id="FooterTwo"> © 2012 WordSmith team IIT Bombay </div>
      </div>
   </footer>
   <!--end footer-->
   </div>
    </body>
</html>
