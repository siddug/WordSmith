<%--
    Document   : index
    Created on : 3 Nov, 2012, 12:14:09 AM
    Author     : varun
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<head>
<meta charset="UTF-8">
<title>Welcome to Wordsmith</title>
<link rel="icon" href="images/favicon.gif" type="image/x-icon"/>
 <!--[if lt IE 9]>
 <script src="http://html5shiv.googlecode.com/svn/trunk/html5.js"></script>
  <![endif]-->
<link rel="shortcut icon" href="images/favicon.gif" type="image/x-icon"/> 
<link rel="stylesheet" type="text/css" href="css/index_style.css"/>
</head>
<body>
   <div class="bg">
    <!--start container-->
    <div id="container">
    <!--start header-->
    <header>
      <!--start logo-->
      <div id="logo">
                    <a href="index.html" style="color: #B22222;">Word</a><a href="index.html" style="color: #606060;"> Smith </a>
                </div>
      <!--end logo-->
      
      <!--end header-->
	</header>
   <!--start intro-->
   <section id="intro">
      <hgroup>
      <h1>"Shape your next great work here!"</h1>
      <h2>Create an account and enter the world of social writing. Everything a writer needs is here - new public ideas, follow your friends, follow interesting works, create new one's and many more new features. Use the forms below to prceed further. For any problems/assistance do not hesitate to contact our team.</h2>
      </hgroup>
   </section>
   <!--end intro-->
   
   </div>
   <!--end container-->
   <section>				
                <div id="container_demo" >
                    <!-- hidden anchor to stop jump http://www.css3create.com/Astuce-Empecher-le-scroll-avec-l-utilisation-de-target#wrap4  -->
                     <div id="wrapper">
                        <div id="login" class="animate form">
                            <form  action="CheckLogin" method="post" autocomplete="on"> 
                                <h1>Log in</h1> 
                                <% 
                                String errmsg="";
                                if(null==session.getAttribute("errmsg")){}
                                else errmsg=session.getAttribute("errmsg").toString();
                                if(errmsg.equals("dberror"))out.println("<p style='color: #B22222'>Not able check in database. Please try again</p><br/>");
                                if(errmsg.equals("invalid"))out.println("<p style='color: #B22222'>Username or password wrong.</p><br/>");
                                %>
                                <p> 
                                    <label for="username" class="uname" data-icon="u" > Your username </label>
                                    <input id="username" name="username" required="required" type="text" placeholder="eg. Siddhartha"/>
                                </p>
                                <p> 
                                    <label for="password" class="youpasswd" data-icon="p"> Your password </label>
                                    <input id="password" name="password" required="required" type="password" placeholder="eg. X8df!90EO" /> 
                                </p>
                                <p class="keeplogin"> 
									<input type="checkbox" name="loginkeeping" id="loginkeeping" value="loginkeeping" /> 
									<label for="loginkeeping">Keep me logged in</label>
								</p>
                                <p class="login button"> 
                                    <input type="submit" value="Login" /> 
								</p>
                                	
                            </form>
                        </div>

                        <div id="register" class="animate form">
                            <form  action="Signup" method="post" autocomplete="off"> 
                                <h1> Sign up </h1> 
                                <% 
                                errmsg="";
                                if(null==session.getAttribute("errmsg")){}
                                else errmsg=session.getAttribute("errmsg").toString();
                                if(errmsg.equals("signupdberror"))out.println("<p style='color: #B22222'>Not able check in database. Please try again</p><br/>");
                                if(errmsg.equals("signupinvalid"))out.println("<p style='color: #B22222'>Username already exists. Please use another one</p><br/>");
                                %>
                                <p> 
                                    <label for="usernamesignup" class="uname" data-icon="u">Your first name</label>
                                    <input id="firstnamesignup" name="firstnamesignup" required="required" type="text" placeholder="mysuperusername690" />
                                </p>
                                <p> 
                                    <label for="usernamesignup" class="uname" data-icon="u">Your last name</label>
                                    <input id="lastnamesignup" name="lastnamesignup" required="required" type="text" placeholder="mysuperusername690" />
                                </p>
                                <p> 
                                    <label for="usernamesignup" class="uname" data-icon="u">Choose a Username</label>
                                    <input id="usernamesignup" name="usernamesignup" required="required" type="text" placeholder="mysuperusername690" />
                                </p>
                                <p> 
                                    <label for="emailsignup" class="youmail" data-icon="e" > Your email id</label>
                                    <input id="emailsignup" name="emailsignup" required="required" type="email" placeholder="mysupermail@mail.com"/> 
                                </p>
                                <p> 
                                    <label for="passwordsignup" class="youpasswd" data-icon="p">Your password </label>
                                    <input id="passwordsignup" name="passwordsignup" required="required" type="password" placeholder="eg. X8df!90EO"/>
                                </p>
                                <p> 
                                    <label for="passwordsignup_confirm" class="youpasswd" data-icon="p">Please confirm your password </label>
                                    <input id="passwordsignup_confirm" name="passwordsignup_confirm" required="required" type="password" placeholder="eg. X8df!90EO"/>
                                </p>
                                <p class="signin button"> 
									<input type="submit" value="Sign up"/> 
								</p>
                                
                            </form>
                        </div>
						
                    </div>
                </div>  
            </section>
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