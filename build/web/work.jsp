<%-- 
    Document   : creatework
    Created on : 7 Nov, 2012, 4:33:20 PM
    Author     : varun
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Work | Wordsmith</title>
        <!-- load the jQuery and require.js libraries -->
        <script type="text/javascript" src="http://cdn.aloha-editor.org/latest/lib/vendor/jquery-1.7.2.js"></script>
        <script type="text/javascript" src="http://cdn.aloha-editor.org/latest/lib/require.js"></script>
                  
        <!-- load the Aloha Editor core and some plugins -->
        <script src="http://cdn.aloha-editor.org/latest/lib/aloha.js"
                data-aloha-plugins="common/ui,
                common/format,
                common/list,
                common/link,
                common/highlighteditables">
        </script>
                  
        <!-- load the Aloha Editor CSS styles -->
        <link href="http://cdn.aloha-editor.org/latest/css/aloha.css" rel="stylesheet" type="text/css" />
                  
        <!-- make all elements with class="editable" editable with Aloha Editor -->
        <script type="text/javascript">
            Aloha.ready( function() {
                var $ = Aloha.jQuery;
                $('.editable').aloha();
            });
        </script>
                  
        <link rel="icon" href="images/favicon.gif" type="image/x-icon"/>
        <link rel="shortcut icon" href="images/favicon.gif" type="image/x-icon"/> 
        <link rel="stylesheet" type="text/css" href="css/styles2.css"/>
    </head>
    <body>
        <%@ page import ="java.sql.*" %>
        <%@ page import ="javax.sql.*" %>
        <%@ page import ="java.util.*" %>
        <%
            String workid=request.getParameter("workid");
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
                
            String firstname = "", lastname = "", dob = "", sex = "", email = "";
            while (userinfo.next()) {
                firstname = userinfo.getString("first_name");
                lastname = userinfo.getString("last_name");
                dob = userinfo.getString("DOB");
                sex = userinfo.getString("sex");
                email = userinfo.getString("email_id");
            }
            //}
                
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
                                <li><a href="followers.jsp?userid=<%=username%>">Followers <%=num_followers%></a></li>
                                <li><a href="following.jsp?userid=<%=username%>">Users following <%=num_users_following%></a></li>
                                <li><a href="worksfollowing.jsp?userid=<%=username%>">Works following <%= num_works_following%></a></li>
                                <li><a href="works.jsp?userid=<%=username%>">Works <%= num_works%></a></li>
                            </ul>
                        </td>
                        <td style="width:680px; padding-left: 20px; padding-right: 20px; pading-bottom: 10px; margin-left:auto;margin-right:auto;">
                        <%
                            PreparedStatement pstmt = con.prepareStatement("select * from work where work_id=?");
                            pstmt.setString(1, workid);
                            ResultSet rs = pstmt.executeQuery();
                            String owner_userid = "";
                            Clob clob = null;
                            String fileData = "";
                            String workname = "";
                            String permission="";
                            String origin_userid="";
                            String pullrequest="";
                            ArrayList<String> genres=new ArrayList<String>();
                            if (rs.next()) {
                                owner_userid = rs.getString("user_id");
                                clob = rs.getClob("content");
                                workname = rs.getString("work_name");
                                permission=rs.getString("permission");
                                pullrequest=rs.getString("pull_request");
                                origin_userid=rs.getString("work_id_origin");
                                long length = clob.length();
                                fileData = clob.getSubString(1, (int) length);
                                String genre1 = rs.getString("genre1");
                                genres.add(genre1);
                                String genre2 = rs.getString("genre2");
                                genres.add(genre2);
                                String genre3 = rs.getString("genre3");
                                genres.add(genre3);
                                String genre4 = rs.getString("genre4");
                                genres.add(genre4);
                            }
                            %>
                            <section id="comments" style="margin-bottom: 40px;"> 
                                <article id="post" style="margin-bottom:0px;padding-bottom:0px;">
                                    Work name: <%= workname%> | Genres: <%for(int i=0;i<4;i++){if(!genres.get(i).equals(""))out.write("<a href=genre.jsp?genre="+genres.get(i)+">"+genres.get(i)+"</a> ");}%>; 
                                    <%if(username.equals(owner_userid)){%><div id="link" class="link2" ><form method="post" action="editworkinfo.jsp"><input name="workid" type="hidden" value="<%=workid%>"/><input id="button" style="width: auto; font-size: 13px; float:left; height: 17px; float:right; padding:0px; padding-bottom:2px; " type="submit" value="Edit info"></form></div><%}%>
                                </article>
                            </section>
                                    <%
                                                                       
                                        String request_button = "";
                                        if (pullrequest.equals("Y")) {
                                            request_button = "Delete request";
                                        } else {
                                            request_button = "Send request";
                                        }
                                        if (username.equals(owner_userid)) {
                                    %>
                                    <div id="link" style="margin-top: 20px;">
                                        <form action="editwork.jsp" method="post"><input type="hidden" name="workid" value="<%=workid%>"/><input id="button" style="width:50px; margin-right:40px;"type="submit" value="Edit"/></form>
                                        <%if ((origin_userid != null) && !origin_userid.equals("")) {%><form action="RequestHandle" method="post"><input type="hidden" name="action" value="<%=request_button%>"/><input type="hidden" name="workid" value="<%=workid%>"/><input type="hidden" name="asked_page" value="work.jsp?workid=<%=workid%>"/><input id="button" type="submit" style="margin-right:50px;"value="<%=request_button%>"></form><% }%>
                                        <form action="DeleteWork" method="post"><input type="hidden" name="workid" value="<%=workid%>"/><input id="button" style="width:50px; margin-right:40px;"type="submit" value="Delete"/></form>
                                    </div>
                                    <div id="wrapper" style="margin-top: 15px;margin-bottom: 0px;"><h1><%=workname%></h1></div>
                                    <div id="work"><%=fileData%></div>
                                    <div id="wrapper" style="margin-top: 15px;margin-bottom: 0px;"><h3>Comments</h3></div>
                                    <section id="comments"> 
                                        <% } else if (permission.equals("Pb")) {
                                            PreparedStatement getfollow = con.prepareStatement("select * from works_following where work_id=? and user_id=?");
                                            getfollow.setString(1, workid);
                                            getfollow.setString(2, username);
                                            ResultSet isFollow = getfollow.executeQuery();
                                            String button_value = "";
                                            if (isFollow.next()) {
                                                button_value = "Unfollow";
                                            } else {
                                                button_value = "Follow";
                                            }
                                        %>
                                        <div id="link" style="margin-top: 20px;">
                                            <form action="FollowHandle" method="post"><input name="user_or_work" value="work" type="hidden"/><input name="workid" value="<%=workid%>" type="hidden"/><input name="action" value="<%=button_value%>" type="hidden"/><input name="asked_page" value="work.jsp?workid=<%=workid%>" type="hidden"/><input id="button" type="submit" value="<%=button_value%>"/></form>
                                            <form action="CopyWork" method="post"><input type="hidden" name="workid" value="<%=workid%>"/><input id="button" type="submit" style="margin-right:50px;"value="Copy"></form>
                                        </div>
                                        <div id="wrapper" style="margin-top: 15px;margin-bottom: 0px;"><h1><%=workname%></h1></div>
                                        <div id="work"><%=fileData%></div><br/>
                                        <div id="wrapper" style="margin-top: 15px;margin-bottom: 0px;"><h3>Comments</h3></div>
                                        <section id="comments"> 
                                            <%
                                                }
                                                if (username.equals(owner_userid) || permission.equals("Pb")) {
                                                    PreparedStatement getComments = con.prepareStatement("select * from comments where work_id=? order by timestamp");
                                                    getComments.setString(1, workid);
                                                    ResultSet comments = getComments.executeQuery();
                                                    while (comments.next()) {
                                                        String userid = comments.getString("user_id");
                                                        String content = comments.getString("content");
                                                        String timestamp = comments.getString("timestamp");
                                                        pstmt = con.prepareStatement("select * from user where user_id=?");
                                                        pstmt.setString(1, userid);
                                                        ResultSet rs1 = pstmt.executeQuery();
                                                        firstname = "";
                                                        lastname = "";
                                                        if (rs1.next()) {
                                                            firstname = rs1.getString("first_name");
                                                            lastname = rs1.getString("last_name");
                                                        }
                                            %>
                                            <article id="post">  
                                                <a href="profile.jsp?userid=<%=userid%>"><%=firstname%> <%=lastname%></a> Wrote a comment on <%=timestamp%> <br/><br/>
                                                <p><%=content%></p>  
                                            </article>
                                            <%
                                                    }
                                                }
                                            %>
                                        </section>  
                                        <!-- comments end -->
                            
                                        <!-- comments form -->
                                        <div id="wrapper">
                                            <div id="edit_info" class="animate form" style="width:60%; margin-left:auto;margin-right:auto;">
                                                <form  action="PostComment" method="post" autocomplete="on"> 
                                                    <h1 style="font-size:20px;">Post a Comment</h1> 
                                                    <input type="hidden" name="workid" value="<%=workid%>"/>
                                                    <p>   
                                                        <textarea name="comment" id="comment" required placeholder="This article is..." style="width: 100%;"></textarea>  
                                                    </p>
                                        
                                                    <p class="login button"> 
                                                        <input type="submit" value="Submit" style="padding-top:5px; padding-bottom: 3px; font-size: 15px;"/> 
                                                    </p>
                                        
                                                </form>
                                            </div>
                                
                                        </div>
                            
                            
                                        <!-- comments form end -->
                            
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
