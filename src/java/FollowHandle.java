/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 *
 * @author varun
 */
@WebServlet(name = "FollowHandle", urlPatterns = {"/FollowHandle"})
public class FollowHandle extends HttpServlet {

    /**
     * Processes requests for both HTTP
     * <code>GET</code> and
     * <code>POST</code> methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    private static final String DBNAME = "wordsmith";
    private static final String DB_USERNAME = "root";
    private static final String DB_PASSWORD = "renderman";

    
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();
        try {
            /* TODO output your page here. You may use following sample code. */
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet FollowHandle</title>");            
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet FollowHandle at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        } finally {            
            out.close();
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP
     * <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP
     * <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        //processRequest(request, response);
        String userorwork=request.getParameter("user_or_work");
        String action=request.getParameter("action");
        String askedpage=request.getParameter("asked_page");
        System.out.println(userorwork+" "+action+" "+askedpage);
        HttpSession session=request.getSession();
        String username="";
        if(null!=session.getAttribute("username"))username=session.getAttribute("username").toString();
        if(userorwork.equals("user")){
            String userid=request.getParameter("userid");
            System.out.println(userid);
            String errmsg="invalid";
            boolean done=false;
            try{
                done=toggleUser(userid,username,action);
            } catch (Exception e) {
                errmsg = "dberror";
            }
            if(!done)session.setAttribute("errmsg", errmsg);
            response.sendRedirect(askedpage);
        }
        if(userorwork.equals("work")){
            String workid=request.getParameter("workid");
            String errmsg="invalid";
            boolean done=false;
            try{
                done=toggleWork(workid,username,action);
            } catch (Exception e) {
                errmsg = "dberror";
            }
            if(!done)session.setAttribute("errmsg", errmsg);
            response.sendRedirect(askedpage);
        }
        if(userorwork.equals("genre")){
            String genre=request.getParameter("genre");
            String errmsg="invalid";
            boolean done=false;
            try{
                done=toggleGenre(genre,username,action);
            } catch (Exception e) {
                errmsg = "dberror";
            }
            if(!done)session.setAttribute("errmsg", errmsg);
            response.sendRedirect(askedpage);
        }
    }
    
    Connection connect() throws Exception {
        Connection con = null;
        try {
            String url = "jdbc:mysql://localhost:3306/" + DBNAME + "?user=" + DB_USERNAME + "&password=" + DB_PASSWORD;
            Class.forName("com.mysql.jdbc.Driver");
            con = DriverManager.getConnection(url);
        } catch (SQLException sqle) {
            System.out.println("SQLException: Unable to open connection to db: " + sqle.getMessage());
            throw sqle;
        } catch (Exception e) {
            System.out.println("Exception: Unable to open connection to db: " + e.getMessage());
            throw e;
        }
        return con;
    }

    
    private boolean toggleUser(String userid, String username,String action) throws Exception {
        boolean isValid = false;
        Connection con;
        con = null;
        try {
            con = connect();
            if(action.equals("Follow")){
                PreparedStatement pstmt=con.prepareStatement("select * from users_following where user_id_followed=? and user_id_follower=?");
                pstmt.setString(1, userid);
                pstmt.setString(2, username);
                ResultSet rs=pstmt.executeQuery();
                if(!rs.next()){
                    pstmt=con.prepareStatement("insert into users_following values (?,?)");
                    pstmt.setString(1, userid);
                    pstmt.setString(2, username);
                    pstmt.executeUpdate();
                }
                isValid=true;
            }
            else if (action.equals("Unfollow")){
                PreparedStatement pstmt=con.prepareStatement("delete from users_following where user_id_followed=? and user_id_follower=?");
                pstmt.setString(1, userid);
                pstmt.setString(2, username);
                pstmt.executeUpdate();
                isValid=true;
            }
        }catch (Exception e) {
            System.out.println("Error : " + e.getMessage());
            throw e;
        } finally {
            con.close();
        }
        return isValid;
    }
    
    private boolean toggleWork(String workid, String username,String action) throws Exception {
        boolean isValid = false;
        Connection con;
        con = null;
        System.out.println(workid+" "+username);
        try {
            con = connect();
            if (action.equals("Follow")) {
                PreparedStatement pstmt = con.prepareStatement("select * from work where work_id=?");
                pstmt.setString(1, workid);
                ResultSet rs = pstmt.executeQuery();
                String permission = "";
                if(rs.next()){
                    permission=rs.getString("permission");
                }
                if(permission.equals("Pb")){
                    pstmt = con.prepareStatement("select * from works_following where work_id=? and user_id=?");
                    pstmt.setString(1, workid);
                    pstmt.setString(2, username);
                    rs = pstmt.executeQuery();
                    if (!rs.next()) {
                        pstmt = con.prepareStatement("insert into works_following values (?,?)");
                        pstmt.setString(2, workid);
                        pstmt.setString(1, username);
                        pstmt.executeUpdate();
                        pstmt = con.prepareStatement("insert into activity values(?,?,?,now())");
                        pstmt.setString(1, username);
                        pstmt.setString(2, workid);
                        pstmt.setString(1, "F");
                        pstmt.executeUpdate();
                    }
                    isValid = true;
                }
            } else if (action.equals("Unfollow")) {
                PreparedStatement pstmt = con.prepareStatement("delete from works_following where work_id=? and user_id=?");
                pstmt.setString(1, workid);
                pstmt.setString(2, username);
                pstmt.executeUpdate();
                isValid = true;
            }
        }catch (Exception e) {
            System.out.println("Error while deleting request: " + e.getMessage());
            throw e;
        } finally {
            con.close();
        }
        return isValid;
    }
    
    private boolean toggleGenre(String genre, String username,String action) throws Exception {
        boolean isValid = false;
        Connection con;
        con = null;
        System.out.println(genre+" "+username);
        try {
            con = connect();
            if(action.equals("Follow")){
                PreparedStatement pstmt=con.prepareStatement("insert into genres_following values(?,?)");
                pstmt.setString(1, genre);
                pstmt.setString(2, username);
                pstmt.executeUpdate();
                isValid=true;
            }
            else if(action.equals("Unfollow")){
                PreparedStatement pstmt=con.prepareStatement("delete from genres_following where genre=? and user_id=?");
                pstmt.setString(1, genre);
                pstmt.setString(2, username);
                pstmt.executeUpdate();
                isValid=true;
            }
        }catch (Exception e) {
            System.out.println("Error while deleting request: " + e.getMessage());
            throw e;
        } finally {
            con.close();
        }
        return isValid;
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>
}
