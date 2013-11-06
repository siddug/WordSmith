<%-- 
    Document   : profile
    Created on : 4 Nov, 2012, 4:28:06 PM
    Author     : varun
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Profile | Wordsmith</title>
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
        <%@ page import ="java.lang.Math" %>
        <%
            String userid="";
            if(null==request.getParameter("userid")){}
            else userid=request.getParameter("userid");
            System.out.println("Profile: "+userid);
            String user_loggedin="";
            if(null==session.getAttribute("username")){}
            else user_loggedin=session.getAttribute("username").toString();
            System.out.println("Login: "+user_loggedin);
            Class.forName("com.mysql.jdbc.Driver");
            java.sql.Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/wordsmith", "root", "renderman");
            
            
            PreparedStatement getUser=con.prepareStatement("select * from user where user_id=?");
            getUser.setString(1,user_loggedin);
            ResultSet userinfo_loggedin=getUser.executeQuery();
            
            PreparedStatement prepStmt1 = con.prepareStatement("select * from user where user_id=?");
            prepStmt1.setString(1,userid);
            ResultSet userinfo;
            String firstname="";
            String lastname="";
            String emailid="";
            String dob="";
            String sex="";
            //if(!userid.equals(user_loggedin)){
                userinfo = prepStmt1.executeQuery();
                while(userinfo.next()){
                    firstname=userinfo.getString("first_name");
                    lastname=userinfo.getString("last_name");
                    emailid=userinfo.getString("email_id");
                    dob=userinfo.getString("DOB");
                    sex=userinfo.getString("sex");
                }
            //}
            
            prepStmt1=con.prepareStatement("select count(*) from users_following where user_id_followed=?");
            prepStmt1.setString(1, userid);
            ResultSet rs2=prepStmt1.executeQuery();
            int num_followers=0;
            if(rs2.next())num_followers=rs2.getInt(1);
            
            prepStmt1=con.prepareStatement("select count(*) from users_following where user_id_follower=?");
            prepStmt1.setString(1, userid);
            rs2=prepStmt1.executeQuery();
            int num_users_following=0;
            if(rs2.next())num_users_following=rs2.getInt(1);
            
            prepStmt1=con.prepareStatement("select count(*) from works_following where user_id=?");
            prepStmt1.setString(1, userid);
            rs2=prepStmt1.executeQuery();
            int num_works_following=0;
            if(rs2.next())num_works_following=rs2.getInt(1);
            
            prepStmt1=con.prepareStatement("select count(*) from work where user_id=?");
            prepStmt1.setString(1, userid);
            rs2=prepStmt1.executeQuery();
            int num_works=0;
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
                            <li><a href="profile.jsp?userid=<%=user_loggedin%>" id="current">Profile</a></li><li>|</li>
                            <li><a href="works.jsp?userid=<%=user_loggedin%>">My works</a></li>	<li>|</li>
                            <li><a href="notifications.jsp">Notifications</a></li>	<li>|</li>
                            <li><a href="requests.jsp">Requests</a></li><li>|</li>
                            <li><a href="home.jsp">Home</a></li>
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
                                <li><a href="followers.jsp?userid=<%=userid%>">Followers <%=num_followers%></a></li>
                                <li><a href="following.jsp?userid=<%=userid%>">Users following <%=num_users_following%></a></li>
                                <li><a href="worksfollowing.jsp?userid=<%=userid%>">Works following <%= num_works_following%></a></li>
                                <li><a href="works.jsp?userid=<%=userid%>">Works <%= num_works%></a></li>
                            </ul>
                        </td>
                        <td style="width:70%; padding-left: 20px; padding-right: 20px; pading-bottom: 10px; ">
                            <section id="comments" style="margin-bottom: 40px;"> 
                                <article id="post" style="margin-bottom:0px;padding-bottom:0px;">
                                    First name: <%=firstname%> | Last name: <%=lastname%> | Email id: <%=emailid%> | D.O.B: <%=dob%> | sex: <%=sex%>; 
                                    <%if(user_loggedin.equals(userid)){%><div id="link" class="link2" ><form method="post" action="edituserinfo.jsp"><input id="button" style="width: auto; font-size: 13px; float:left; height: 17px; float:right; padding:0px; padding-bottom:2px; " type="submit" value="Edit info"></form></div>
                                    <%}else{
                                        PreparedStatement getfollow = con.prepareStatement("select * from users_following where user_id_follower=? and user_id_followed=?");
                                            getfollow.setString(1, user_loggedin);
                                            getfollow.setString(2, userid);
                                            ResultSet isFollow = getfollow.executeQuery();
                                            String button_value = "";
                                            if (isFollow.next()) {
                                                button_value = "Unfollow";
                                            } else {
                                                button_value = "Follow";
                                            }
                                    %>
                                    <div id="link" class="link2" ><form method="post" action="FollowHandle"><input name="user_or_work" value="user" type="hidden"/><input name="userid" value="<%=userid%>" type="hidden"/><input name="action" value="<%=button_value%>" type="hidden"/><input name="asked_page" value="profile.jsp?userid=<%=userid%>" type="hidden"/><input id="button" type="submit" value="<%=button_value%>"/></form></div>
                                    <%
                                    }
                                    %>
                                </article>
                            </section>
                <section>
        <%
            
            PreparedStatement prepStmt2 = con.prepareStatement("select * from activity where user_id=?");
            prepStmt2.setString(1,userid);
            ResultSet activity = prepStmt2.executeQuery();
            while(activity.next()){
                String activity_type=activity.getString("activity_type");
                String work_id=activity.getString("work_id");
                String timestamp=activity.getString("timestamp");
                PreparedStatement getWork=con.prepareStatement("select work_name,content from work where work_id=?");
                getWork.setString(1, work_id);
                ResultSet workinfo=getWork.executeQuery();
                Clob clobFile=null;
                String work_name="";
                while(workinfo.next()){
                    work_name=workinfo.getString("work_name");
                    clobFile=workinfo.getClob("content");
                }
                System.out.println("Stage reached");
                if(activity_type.equals("C"))activity_type="created";
                if(activity_type.equals("U"))activity_type="updated";
                if(activity_type.equals("F"))activity_type="followed";
                //if(activity_type.equals("k"))activity_type="forked";
                
                String filedata=clobFile.getSubString(1, (int)Math.min(200, clobFile.length()));
        %>
        <div id="post" style="border-bottom:dotted 0.25px;margin-bottom: 10px;">
	<div style="text-align:center; font-size:20px; font-family:calibri; margin-top: 10px;"><a href="work.jsp?workid=<%=work_id%>" ><%=work_name%></a><br/></div>
        <a href="profile.jsp?userid=<%=userid%>"> <%=firstname%> <%=lastname%></a> <%=activity_type%> a work on <%=timestamp%><br/><br/>
        <%=filedata%>
        <a href="work.jsp?workid=<%=work_id%>">Read more...</a><br/><br/>
	</div>
        <%
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
        <!--end bg-->
    </body>
</html>
