<%-- 
    Document   : notifications
    Created on : 4 Nov, 2012, 5:22:53 PM
    Author     : varun
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Notifications | Wordsmith</title>
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
        <%@ page import ="java.util.*" %>
        <%@ page import ="java.lang.Math" %>
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
                            <li><a href="notifications.jsp" id="current">Notifications</a></li>	<li>|</li>
                            <li><a href="requests.jsp">Requests</a></li><li>|</li>
                            <li><a href="home.jsp" >Home</a></li>
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
        	Below is the list of your notifications. These correspond to the actions happening on the works you are following.
        	<br/><br/>
                            <div id="wrapper"><h1>Notifications</h1></div>
                            <section>
        <%
            
            prepStmt1 = con.prepareStatement("select * from activity where work_id in (select work_id from works_following where user_id=?) order by timestamp desc");
            prepStmt1.setString(1,username);
            ResultSet notifications=prepStmt1.executeQuery();
            while(notifications.next()){
                String followed_user=notifications.getString("user_id");
                String timestamp=notifications.getString("timestamp");
                PreparedStatement prepStmt2 = con.prepareStatement("select first_name,last_name from user where user_id=?");
                prepStmt2.setString(1, followed_user);
                rs2=prepStmt2.executeQuery();
                firstname="";
                lastname="";
                while(rs2.next()){
                    firstname=rs2.getString("first_name");
                    lastname=rs2.getString("last_name");
                }
                String activity_type=notifications.getString("activity_type");
                String work_id=notifications.getString("work_id");
                prepStmt2=con.prepareStatement("select * from work where work_id=?");
                prepStmt2.setString(1, work_id);
                rs2=prepStmt2.executeQuery();
                Clob clobFile=null;
                String work_name="";
                ArrayList<String> genres=new ArrayList<String>();
                while(rs2.next()){
                    work_name=rs2.getString("work_name");
                    clobFile=rs2.getClob("content");
                    String genre1=rs2.getString("genre1");
                    genres.add(genre1);
                    String genre2=rs2.getString("genre2");
                    genres.add(genre2);
                    String genre3=rs2.getString("genre3");
                    genres.add(genre3);
                    String genre4=rs2.getString("genre4");
                    genres.add(genre4);
                }
                if(activity_type.equals("C"))activity_type="created";
                if(activity_type.equals("U"))activity_type="updated";
                if(activity_type.equals("F"))activity_type="followed";
                //if(activity_type.equals("K"))activity_type="forked";
                
                String filedata=clobFile.getSubString(1, (int)Math.min(200,clobFile.length()));
        %>
        <div id="post" style="border-bottom:dotted 0.25px;margin-bottom: 10px;">
	<div style="text-align:center; font-size:20px; font-family:calibri; margin-top: 10px;"><a href="work.jsp?workid=<%=work_id%>" ><%=work_name%></a><br/></div>
        <a href="profile.jsp?userid=<%=followed_user%>"> <%=firstname%> <%=lastname%></a> <%=activity_type%> a work on <%=timestamp%> Genres: <%for(int i=0;i<4;i++){if(!genres.get(i).equals(""))out.write("<a href=genre.jsp?genre="+genres.get(i)+">"+genres.get(i)+"</a> ");}%><br/><br/>
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
