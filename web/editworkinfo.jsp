<%-- 
    Document   : editworkinfo
    Created on : 7 Nov, 2012, 2:22:09 PM
    Author     : varun
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Edit info | Wordsmith</title>
        <link rel="icon" href="images/favicon.gif" type="image/x-icon"/>
        <!--[if lt IE 9]>
        <script src="http://html5shiv.googlecode.com/svn/trunk/html5.js"></script>
         <![endif]-->
        <link rel="shortcut icon" href="images/favicon.gif" type="image/x-icon"/> 
        <link rel="stylesheet" type="text/css" href="css/styles2.css"/>
    </head>
    <body>
        <body>
        <%@ page import ="java.sql.*" %>
        <%@ page import ="javax.sql.*" %>
        <%@ page import ="java.util.*" %>
        <%
            String username = "";
            if (null == session.getAttribute("username")) {
            } else {
                username = session.getAttribute("username").toString();
            }
            System.out.println("Login: " + username);
            Class.forName("com.mysql.jdbc.Driver");
            java.sql.Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/wordsmith", "root", "renderman");
            
            PreparedStatement getUser = con.prepareStatement("select * from user where user_id=?");
            getUser.setString(1, username);
            ResultSet userinfo = getUser.executeQuery();

            String firstname="",lastname="",dob="",sex="",email="";
            while (userinfo.next()) {
                firstname = userinfo.getString("first_name");
                lastname = userinfo.getString("last_name");
                dob= userinfo.getString("DOB");
                sex= userinfo.getString("sex");
                email= userinfo.getString("email_id");
            }
            //}
            String workid=request.getParameter("workid");
            PreparedStatement getWork=con.prepareStatement("select * from work where work_id=?");
            getWork.setString(1, workid);
            ResultSet workinfo=getWork.executeQuery();
            String workname="",permission="",owner_userid="";
            ArrayList<String> genrelist=new ArrayList<String>();
            if(workinfo.next()){
                workname=workinfo.getString("work_name");
                permission=workinfo.getString("permission");
                owner_userid=workinfo.getString("user_id");
                genrelist.add(workinfo.getString("genre1"));
                genrelist.add(workinfo.getString("genre2"));
                genrelist.add(workinfo.getString("genre3"));
                genrelist.add(workinfo.getString("genre4"));
            }
            
            /*PreparedStatement getGenres=con.prepareStatement("select genre from genres where work_id=?");
            getGenres.setString(1,workid);
            ResultSet genres=getGenres.executeQuery();*/
            
            
            
            PreparedStatement prepStmt1 = con.prepareStatement("select count(*) from users_following where user_id_followed=?");
            prepStmt1.setString(1, username);
            ResultSet rs2 = prepStmt1.executeQuery();
            int num_followers = 0;
            if (rs2.next()) {
                num_followers = rs2.getInt(1);
            }

            prepStmt1 = con.prepareStatement("select count(*) from users_following where user_id_follower=?");
            prepStmt1.setString(1, username);
            rs2 = prepStmt1.executeQuery();
            int num_users_following = 0;
            if (rs2.next()) {
                num_users_following = rs2.getInt(1);
            }

            prepStmt1 = con.prepareStatement("select count(*) from works_following where user_id=?");
            prepStmt1.setString(1, username);
            rs2 = prepStmt1.executeQuery();
            int num_works_following = 0;
            if (rs2.next()) {
                num_works_following = rs2.getInt(1);
            }

            prepStmt1 = con.prepareStatement("select count(*) from work where user_id=?");
            prepStmt1.setString(1, username);
            rs2 = prepStmt1.executeQuery();
            int num_works = 0;
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
                                <li><a href="followers.jsp?userid=<%=username%>">Followers <%=num_followers%></a></li>
                                <li><a href="following.jsp?userid=<%=username%>">Users following <%=num_users_following%></a></li>
                                <li><a href="worksfollowing.jsp?userid=<%=username%>">Works following <%= num_works_following%></a></li>
                                <li><a href="works.jsp?userid=<%=username%>">Works <%= num_works%></a></li>
                            </ul>
                        </td>
                        <td style="width:70%; padding-left: 20px; padding-right: 20px; pading-bottom: 10px; ">
                            <div id="wrapper">
        	<br/>
        	Below is your present personal details in our database. Use the form below to edit the details. Note that upon submission, only those fields with non-empty data are updated. 
        	<br/><br/>
                <h1 style="font-size: 20px; margin-bottom:0px;">Work Information</h1><br/>
                <% if(username.equals(owner_userid)){
                %>
                <div id="info">Work name: <%=workname%> </div>
        	<div id="info">Permission <%=permission%></div>
                <div id="info">Genres: 
                <%
                for(int i=0;i<genrelist.size();i++){if(!genrelist.get(i).equals(""))
                    out.write("<a href='genre.jsp?genre="+genrelist.get(i)+"'>"+genrelist.get(i)+"</a> ");}
                %>
                </div>
                <div id="edit_info" class="animate form" style="width:60%; margin-left:auto;margin-right:auto;">
                    <form  action="WorkEditInfo" method="post" autocomplete="on"> 
                        <h1 style="font-size:20px;">Edit Info</h1> 
                        <input name="workid" value="<%=workid%>" type="hidden"/>
                        <p> 
                            <label for="username" class="uname" data-icon="u" > Edit the work name </label>
                            <input id="username" name="workname" type="text" placeholder="eg. Siddhartha"/>
                        </p>
                        <p> 
                            <label for="username" class="uname" data-icon="u" > Edit the permission </label>
                            <input id="username" name="permission" type="text" placeholder="eg. Gunti"/>
                        </p>
                        <p> 
                            <label for="username" class="uname" data-icon="u" > Edit genre 1 </label>
                            <input id="username" name="genre1" type="text" placeholder="eg. Siddhartha.gunti191@gmail.com"/>
                        </p>
                        <p> 
                            <label for="username" class="uname" data-icon="u" > Edit genre 2</label>
                            <input id="username" name="genre2" type="text" placeholder="eg. M"/>
                        </p>
                        <p> 
                            <label for="username" class="uname" data-icon="u" > Edit genre 3</label>
                            <input id="username" name="genre3" type="text" placeholder="eg. 14/12/1992"/>
                        </p>
                        <p> 
                            <label for="username" class="uname" data-icon="u" > Edit genre 4</label>
                            <input id="username" name="genre4" type="text" placeholder="eg. 14/12/1992"/>
                        </p>
                        <p class="login button"> 
                            <input type="submit" value="Edit" /> 
                        </p>

                    </form>
                </div>
                <% }
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
        <!--end bg-->
        </body>
    </body>
</html>
