<%-- 
    Document   : genre
    Created on : 6 Nov, 2012, 10:26:15 AM
    Author     : varun
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Genre | Wordsmith</title>
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
            String genre=request.getParameter("genre");
            String username = "";
            if(null==session.getAttribute("username")){}
            else username=session.getAttribute("username").toString();
            Class.forName("com.mysql.jdbc.Driver");
            java.sql.Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/wordsmith","root","renderman");
            
            PreparedStatement getUser=con.prepareStatement("select * from user where user_id=?");
            getUser.setString(1,username);
            ResultSet userinfo=getUser.executeQuery();
            
            String firstname="";
            String lastname="";
            String lastvisit="";
            int num_requests=0;
            int num_works=0;
            int num_notifications=0;
            if(userinfo.next()){
                firstname=userinfo.getString("first_name");
                lastname=userinfo.getString("last_name");
                lastvisit=userinfo.getString("last_visit");
                System.out.println(lastname);
            }
            
            PreparedStatement prepStmt1=con.prepareStatement("select count(*) from activity where work_id in (select work_id from works_following where user_id=?)");
            prepStmt1.setString(1, username);
            ResultSet rs2=prepStmt1.executeQuery();
            if(rs2.next())num_notifications=rs2.getInt(1);
            
            prepStmt1=con.prepareStatement("select count(*) from work where work_id_origin in (select work_id from work where user_id=?) and pull_request=?");
            prepStmt1.setString(1, username);
            prepStmt1.setString(2, "Y");
            rs2=prepStmt1.executeQuery();
            if(rs2.next())num_requests=rs2.getInt(1);
            
            prepStmt1=con.prepareStatement("select count(*) from work where user_id=?");
            prepStmt1.setString(1, username);
            rs2=prepStmt1.executeQuery();
            if(rs2.next())num_works=rs2.getInt(1);
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
                <br/>
                <br/>
                <table style="margin-top:15px;">
                    <tr>
                        <td style="width:30%; vertical-align:top;">
                            <div id="wrapper" style="margin-top: 15px;margin-bottom: 0px;"><h1><%=firstname%> <%=lastname%></h1></div>
                            <ul>
                                <li><a href="works.jsp?userid=<%=username%>">Yours works <%= num_works%></a></li>
                                <li><a href="requests.jsp">Pending requests <%= num_requests%></a></li>
                                <li><a href="notifications.jsp">Notifications <%= num_notifications%></a></li>
                            </ul>
                        </td>
                        <td style="width:70%; padding-left: 20px; padding-right: 20px; pading-bottom: 10px; ">
                        <section>
                        <article id="post" style="margin-bottom:0px;padding-bottom:0px;">
                            <%
                            PreparedStatement getFollow=con.prepareStatement("select * from genres_following where genre=? and user_id=?");
                            getFollow.setString(1, genre);
                            getFollow.setString(2, username);
                            ResultSet follow=getFollow.executeQuery();
                            String button="";
                            if(follow.next())button="Unfollow";
                                                       else button="Follow";
                            %>
                            <div id="link" class="link2">
                                <form method="post" action="FollowHandle">
                                    <input type="hidden" name="user_or_work" value="genre"/><input type="hidden" name="genre" value="<%=genre%>"/><input type="hidden" name="action" value="<%=button%>"/><input type="hidden" name="asked_page" value="genre.jsp?genre=<%=genre%>"/>
                                    <input id="button" style="width: auto; font-size: 13px; float:left; height: 17px; float:right; padding:0px; padding-bottom:2px;" type="submit" value="<%=button%>"/>
                                </form>
                            </div>
                        </article>
                    </section>
                                <br/>
        	Below is the list of the works. If these do not correspond to you, you will see a follow/unfollow button.
        	<br/><br/>
                            <div id="wrapper"><h1>Genre: <%=genre%></h1></div>
                            <section>
        <%
            PreparedStatement pstmt=con.prepareStatement("select * from work where genre1=? or genre2=? or genre3=? or genre4=?");
            pstmt.setString(1, genre);
            pstmt.setString(2, genre);
            pstmt.setString(3, genre);
            pstmt.setString(4, genre);
            ResultSet rs=pstmt.executeQuery();
            while(rs.next()){
                String temp_workid=rs.getString("work_id");
                String temp_workname=rs.getString("work_name");
                String permission=rs.getString("permission");
                String owner_userid=rs.getString("user_id");
                if(permission.equals("Pb")){
                        PreparedStatement getfollow = con.prepareStatement("select * from works_following where work_id=? and user_id=?");

                    getfollow.setString(1, temp_workid);
                    getfollow.setString(2, username);
                    ResultSet isFollow = getfollow.executeQuery();
                    String button_value = "";
                    if (isFollow.next()) {
                        button_value = "Unfollow";
                    } else {
                        button_value = "Follow";
                    }
        %>
        <form id="link" method="post" action="FollowHandle"><a href="work.jsp?workid=<%=temp_workid%>" id="follower_name"><%=temp_workname%></a><%if(owner_userid.equals(username)){%><input name="user_or_work" value="work" type="hidden"/><input name="workid" value="<%=temp_workid%>" type="hidden"/><input name="action" value="<%=button_value%>" type="hidden"/><input name="asked_page" value="genre.jsp?genre=<%=genre%>" type="hidden"/><input id="button" type="submit" value="<%=button_value%>"/><% } %></form>
        <%
                }
            }
            con.close();
        %>
        </section>
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
