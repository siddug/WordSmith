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
import java.util.ArrayList;

/**
 *
 * @author varun
 */
@WebServlet(name = "WorkEditInfo", urlPatterns = {"/WorkEditInfo"})
public class WorkEditInfo extends HttpServlet {

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
    
    String workname,permission,workid;
    String genre1,genre2,genre3,genre4;
    
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();
        try {
            /* TODO output your page here. You may use following sample code. */
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet EditWorkInfo</title>");            
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet EditWorkInfo at " + request.getContextPath() + "</h1>");
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
        workname=request.getParameter("workname");
        workid=request.getParameter("workid");
        permission=request.getParameter("permission");
        genre1=request.getParameter("genre1");
        genre2=request.getParameter("genre2");
        genre3=request.getParameter("genre3");
        genre4=request.getParameter("genre4");
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
        response.sendRedirect("editworkinfo.jsp?workid="+workid);
    }
    
    private boolean updateInfo(String username) throws Exception{
        boolean valid=false;
        Connection con=null;
        try{
            con=connect();
            PreparedStatement pstmt=con.prepareStatement("select user_id from work where work_id=?");
            pstmt.setString(1, workid);
            ResultSet rs=pstmt.executeQuery();
            String owner_userid="";
            if(rs.next())owner_userid=rs.getString("user_id");
            if(username.equals(owner_userid)){
                if(workname!=null && !workname.equals("")){
                    pstmt=con.prepareStatement("update work set work_name=? where work_id=?");
                    pstmt.setString(1,workname);
                    pstmt.setString(2,workid);
                    pstmt.executeUpdate();
                }
                if(permission!=null && !permission.equals("")){
                    pstmt=con.prepareStatement("update work set permission=? where work_id=?");
                    pstmt.setString(1,permission);
                    pstmt.setString(2,workid);
                    pstmt.executeUpdate();
                }
                if(genre1!=null && !genre1.equals("")){
                    pstmt=con.prepareStatement("update work set genre1=? where work_id=?");
                    pstmt.setString(1,genre1);
                    pstmt.setString(2,workid);
                    pstmt.executeUpdate();
                }
                if(genre2!=null && !genre2.equals("")){
                    pstmt=con.prepareStatement("update work set genre2=? where work_id=?");
                    pstmt.setString(1,genre2);
                    pstmt.setString(2,workid);
                    pstmt.executeUpdate();
                }
                if(genre3!=null && !genre3.equals("")){
                    pstmt=con.prepareStatement("update work set genre3=? where work_id=?");
                    pstmt.setString(1,genre3);
                    pstmt.setString(2,workid);
                    pstmt.executeUpdate();
                }
                if(genre4!=null && !genre4.equals("")){
                    pstmt=con.prepareStatement("update work set genre4=? where work_id=?");
                    pstmt.setString(1,genre4);
                    pstmt.setString(2,workid);
                    pstmt.executeUpdate();
                }
            }
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
