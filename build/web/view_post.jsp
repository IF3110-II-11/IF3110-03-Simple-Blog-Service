<%@page import="SimpleBlog.User"%>
<%@page import="SimpleBlog.CookieController"%>
<%@page import="SimpleBlog.Komentar"%>
<%@page import="SimpleBlog.Post"%>
<%@page import="java.util.List"%>
<%@page import="java.util.List"%>
<%@page import="java.util.ArrayList"%>
<%@page import="SimpleBlog.MySQLAccess"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<script type="text/javascript" src="javascript/komentar.js"></script> 
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="description" content="website description" />
        <meta name="keywords" content="website keywords, website keywords" />
        <meta http-equiv="content-type" content="text/html; charset=windows-1252" />
        <link rel="stylesheet" type="text/css" href="css/stylesheet.css" />
        <!-- modernizr enables HTML5 elements and feature detects -->
        <script type="text/javascript" src="javascript/modernizr-1.5.min.js"></script>
        <title>Simple Blog - View Post</title>
    </head>
<body onload="get_komentar()">
    <div id="main">		
    <header>
        <div id="strapline">
            <div id="welcome_slogan">
                <a href="index.jsp"><h3>-- Simple Blog --</h3></a>
            </div><!--close welcome_slogan-->
        </div><!--close strapline-->
        <nav>
            <div id="menubar">
                <ul id="nav">
                    <li><a href="index.jsp">Home</a></li>
                    <%
                        CookieController CC = new CookieController();
                Cookie[] cookies = request.getCookies();
                MySQLAccess sql = new MySQLAccess();
                
                if(cookies!=null)
                {
                    int idx = CC.FindUserCookie(cookies);
                    if(idx<cookies.length)
                    {
                        
                    }
                    else
                    {
                        // Menciptakan cookies untuk guest      
                        Cookie guest = new Cookie("user","guest"); 
                        // Meng - set agar cookie hilang setelah 24 jam
                        guest.setMaxAge(60*60*2); 
                        // Menambahkan cookie ke header response
                        response.addCookie(guest);
                    }
                }
                else
                                {
                    // Menciptakan cookies untuk guest      
                    Cookie guest = new Cookie("user","guest"); 
                    // Meng - set agar cookie hilang setelah 24 jam
                    guest.setMaxAge(60*60*2); 
                    // Menambahkan cookie ke header response
                    response.addCookie(guest);
                }
                int idx = CC.FindUserCookie(cookies);
                String username = cookies[idx].getValue();
                
                User user = null;
                if(idx<cookies.length && !username.equalsIgnoreCase("guest"))
                {
                    user=new User(username, " ", " ", sql.getRolebyUsername(username));
                }
                else
                {
                    user = new User("guest"," "," ","guest");
                }
                if(!user.role.equalsIgnoreCase("guest") && !user.role.equalsIgnoreCase("editor"))
                {
                    out.println("<li><a href=\"add_post.jsp\">Add Post</a></li>");
                }
                if(user.role.equalsIgnoreCase("admin"))
                {
                    out.println("<li><a href=\"user_list.jsp\">User List</a></li>");
                }
                if(user.username.equalsIgnoreCase("guest"))
                {
                    out.println(CC.LoginForm());
                }
                else
                {
                    out.println(CC.Welcome(user.username));
                }
                out.println(CC.SearchForm());
                    %>
                </ul>
            </div><!--close menubar-->	
        </nav>
    </header>
    <div id="site_content">
        <%
            String idPost= request.getParameter("idPost");
            
            org.chamerling.heroku.service.Post postId=sql.getPostId(idPost);
        %>
        <h5><% out.print(postId.getJudul()); %></h5>    
        <%    
            out.println("<div id=\"post-konten\">"+postId.getKonten() +"<br><br>(posted on : "+postId.getTanggal()+")</div>");
        %>
        <article class="art simple post">  
            <div class="art-body">
                <div class="art-body-inner">        
                    <div id="contact-area">
                        <%
                            out.println("<hr>");
                            out.println("<h2>Komentar</h2>");
                            out.println("<hr>");
                            out.println("<form method=\"POST\" onSubmit=\"return post_komentar()\"");
                            out.println("<label for=\"ID\"></label>");
                            out.println("<input type=\"hidden\" name=\"ID\" id=\"ID\" value=\""+idPost+"\">");  

                            cookies=request.getCookies();
                            int indexUser= CC.FindUserCookie(cookies);

                            MySQLAccess SQL = new MySQLAccess();
                            String name="";
                            String email="";

                            if(cookies[indexUser].getValue().compareTo("guest")!=0)
                            {
                                org.chamerling.heroku.service.User user2=SQL.getSpesificUser(cookies[indexUser].getValue());
                                name=user2.getUsername();
                                email=user2.getEmail();
                            }

                            out.println("<label for=\"Nama\">Nama:</label>");
                            out.println("<input type=\"text\" name=\"Nama\" id=\"Nama\" value=\""+ name + "\">");
                            out.println("<label for=\"Email\">Email:</label>");
                            out.println("<input type=\"text\" name=\"Email\" id=\"Email\" value=\""+email+ "\">");
                            out.println("<label for=\"Komentar\">Komentar:</label>");
                            out.println("<textarea name=\"Komentar\" rows=\"20\" cols=\"20\" id=\"Komentar\"></textarea>");
                            out.println("<input type=\"submit\" name=\"submit\" value=\"Kirim\" class=\"submit-button\">"); 
                            out.println("</form>");

                        %>

                    </div>
                </div>
            </div>
        </article>
        <ul class="art-list-body" id="Tempat_Komentar">

        </ul>     
        <footer>
                <a href="twitter.com/djstephendj">Stephen / 13512025</a> | <a href="twitter.com/ivanaclairine"> Ivana / 13512041</a> | <a href="http://twitter.com/susantigojali"> Susanti / 13512057</a> 
        </footer>   
    </div>
    </div>
</body>
</html>
