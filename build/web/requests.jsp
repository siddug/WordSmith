<%-- 
    Document   : requests
    Created on : 4 Nov, 2012, 9:43:27 PM
    Author     : varun
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Requests | Wordsmith</title>
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
            
            PreparedStatement prepStmt1=con.prepareStatement("select count(*) from activity where work_id in (select work_id from works_following where user_id=?) and timestamp>?");
            prepStmt1.setString(1, username);
            prepStmt1.setString(2, lastvisit);
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
                            <li><a href="requests.jsp" id="current">Requests</a></li><li>|</li>
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
                                <li><a href="works.jsp?userid=<%=username%>">Yours works <%= num_works%></a></li>
                                <li><a href="requests.jsp">Pending requests <%= num_requests%></a></li>
                                <li><a href="notifications.jsp">Notifications <%= num_notifications%></a></li>
                            </ul>
                        </td>
                        <td style="width:70%; padding-left: 20px; padding-right: 20px; pading-bottom: 10px; ">
                        <br/>
        	Below is the list of your pending requests. By clicking on accept your work will be replaced by the corresponding requested person's work. If you don't want that, you can decline the request.
        	<br/><br/>
                            <div id="wrapper"><h1>Requests</h1></div>
                            <section>
        <%
            
            PreparedStatement getRequests = con.prepareStatement("select * from work where work_id_origin in (select work_id from work where user_id=?) and pull_request=? order by timestamp");
            getRequests.setString(1, username);
            getRequests.setString(2, "Y");
            ResultSet requests=getRequests.executeQuery();
            
            while(requests.next()){
                String orig_workid=requests.getString("work_id_origin");
                String copy_workid=requests.getString("work_id");
                String copy_userid=requests.getString("user_id");
                String copy_workname=requests.getString("work_name");
                PreparedStatement pstmt=con.prepareStatement("select first_name,last_name from user where user_id=?");
                pstmt.setString(1,copy_userid);
                ResultSet temp=pstmt.executeQuery();
                String copy_firstname="";
                String copy_lastname="";
                if(temp.next()){
                    copy_firstname=temp.getString("first_name");
                    copy_lastname=temp.getString("last_name");
                }
                pstmt=con.prepareStatement("select work_name from work where work_id=?");
                pstmt.setString(1,orig_workid);
                temp=pstmt.executeQuery();
                String orig_workname="";
                if(temp.next()){
                    orig_workname=temp.getString("work_name");
                }
        %>
        <a href="profile.jsp?userid=<%=copy_userid%>"><%=copy_firstname%> <%=copy_lastname%></a> requested you to merge his <a href="work.jsp?workid=<%=copy_workid%>"><%=copy_workname%></a> into your <a href="work.jsp?workid=<%=orig_workid%>"><%=orig_workname%></a>
        <form id="link" method="post" action="RequestHandle"><input name="workid" value="<%=copy_workid%>" type="hidden"/><input name="action" value="accept" type="hidden"/><input name="asked_page" value="requests.jsp" type="hidden"/><input id="button" type="submit" value="Accept"/></form>
        <form id="link" method="post" action="RequestHandle"><input name="workid" value="<%=copy_workid%>" type="hidden"/><input name="action" value="decline" type="hidden"/><input name="asked_page" value="requests.jsp" type="hidden"/><input id="button" type="submit" value="Decline"/></form>
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
