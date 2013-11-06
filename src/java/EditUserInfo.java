/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

import java.io.IOException;
import java.io.PrintWriter;
import java.util.*;
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
@WebServlet(name = "EditUserInfo", urlPatterns = {"/EditUserInfo"})
public class EditUserInfo extends HttpServlet {

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
    
    String firstname;
    String lastname;
    String password;
    String emailid;
    String dob;
    String sex;
    
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();
        try {
            /* TODO output your page here. You may use following sample code. */
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet EditInfo</title>");            
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet EditInfo at " + request.getContextPath() + "</h1>");
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
        /*Enumeration<String> attList=request.getAttributeNames();
        while(attList.hasMoreElements()){
            String attName=attList.nextElement();
            if(attName.equals("firstname"))firstname=request.getParameter(attName);
            if(attName.equals("lastname"))lastname=request.getParameter(attName);
            if(attName.equals("password"))password=request.getParameter(attName);
            if(attName.equals("emailid"))emailid=request.getParameter(attName);
            if(attName.equals("dob"))dob=request.getParameter(attName);
            if(attName.equals("sex"))sex=request.getParameter(attName);
        }*/
        firstname=request.getParameter("firstname");
        lastname=request.getParameter("lastname");
        password=request.getParameter("password");
        emailid=request.getParameter("emailid");
        dob=request.getParameter("dob");
        sex=request.getParameter("sex");
        System.out.println(firstname);
        System.out.println(lastname);
        System.out.println(password);
        System.out.println(emailid);
        System.out.println(dob);
        System.out.println(sex);
        String errmsg="invalid";
        boolean done=false;
        HttpSession session=request.getSession();
        String username="";
        if(null!=session.getAttribute("username"))username=session.getAttribute("username").toString();
        try{
            done=updateInfo(username);
        }catch(Exception e){
            errmsg="dberror";
        }
        if(!done){
            session.setAttribute("errmsg", errmsg);
        }
        response.sendRedirect("edituserinfo.jsp");
    }
    
    private boolean updateInfo(String username) throws Exception{
        boolean valid=false;
        Connection con=null;
        try{
            con=connect();
            if(firstname!=null && !firstname.equals("")){
                PreparedStatement pstmt=con.prepareStatement("update user set first_name=? where user_id=?");
                pstmt.setString(1,firstname);
                pstmt.setString(2,username);
                pstmt.executeUpdate();
            }
            if(lastname!=null && !lastname.equals("")){
                PreparedStatement pstmt=con.prepareStatement("update user set last_name=? where user_id=?");
                pstmt.setString(1,lastname);
                pstmt.setString(2,username);
                pstmt.executeUpdate();
            }
            if(password!=null && !password.equals("")){
                PreparedStatement pstmt=con.prepareStatement("update user set password=? where user_id=?");
                pstmt.setString(1,password);
                pstmt.setString(2,username);
                pstmt.executeUpdate();
            }
            if(emailid!=null && !emailid.equals("")){
                PreparedStatement pstmt=con.prepareStatement("update user set email_id=? where user_id=?");
                pstmt.setString(1,emailid);
                pstmt.setString(2,username);
                pstmt.executeUpdate();
            }
            if(dob!=null && !dob.equals("")){
                PreparedStatement pstmt=con.prepareStatement("update user set DOB=? where user_id=?");
                pstmt.setString(1,dob);
                pstmt.setString(2,username);
                pstmt.executeUpdate();
            }
            if(sex!=null && !sex.equals("")){
                PreparedStatement pstmt=con.prepareStatement("update user set sex=? where user_id=?");
                pstmt.setString(1,sex);
                pstmt.setString(2,username);
                pstmt.executeUpdate();
            }
            valid=true;
        }catch (Exception e) {
            System.out.println("validateLogon: Error while validating password: " + e.getMessage());
            throw e;
        } finally {
            con.close();
        }
        return valid;
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
