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
import java.sql.Clob;
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
@WebServlet(name = "RequestHandle", urlPatterns = {"/RequestHandle"})
public class RequestHandle extends HttpServlet {

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
            out.println("<title>Servlet RequestHandle</title>");            
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet RequestHandle at " + request.getContextPath() + "</h1>");
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
        String workid=request.getParameter("workid");
        String action=request.getParameter("action");
        String askedpage=request.getParameter("asked_page");
        System.out.println("asked: "+askedpage);
        HttpSession session=request.getSession();
        String username="";
        if(null!=session.getAttribute("username"))username=session.getAttribute("username").toString();
        boolean done=false;
        String errmsg="invalid";
        try{
            done=deleteRequest(workid,username,action);
        }catch(Exception e) {
            errmsg = "dberror";
        }
        if(!done)session.setAttribute("errmsg",errmsg);
        response.sendRedirect(askedpage);
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
    
    
    private boolean deleteRequest(String workid, String username,String action) throws Exception {
        boolean isValid = false;
        Connection con;
        con = null;
        try {
            con = connect();
            
            PreparedStatement getWork=con.prepareStatement("select * from work where work_id=?");
            getWork.setString(1, workid);
            ResultSet workinfo=getWork.executeQuery();
            String userid="";
            String pull_request="";
            String workid_origin="";
            if(workinfo.next()){
                userid=workinfo.getString("user_id");
                pull_request=workinfo.getString("pull_request");
                workid_origin=workinfo.getString("work_id_origin");
            }
            
            PreparedStatement getOrigin=con.prepareStatement("select user_id from work where work_id=?");
            getOrigin.setString(1, workid_origin);
            ResultSet origininfo=getOrigin.executeQuery();
            String userid_origin="";
            if(origininfo.next()){
                userid_origin=origininfo.getString("user_id");
            }
            if(userid_origin.equals(username)){
                if(pull_request.equals("Y")){
                    if(action.equals("decline")){
                        PreparedStatement pstmt=con.prepareStatement("update work set pull_request=? where work_id=?");
                        pstmt.setString(1, "N");
                        pstmt.setString(2, workid);
                        pstmt.executeUpdate();
                        isValid=true;
                    }
                    else if(action.equals("accept")){
                        PreparedStatement pstmt=con.prepareStatement("select content from work where work_id=?");
                        pstmt.setString(1, workid);
                        ResultSet workContent=pstmt.executeQuery();
                        Clob clobFile=null;
                        if(workContent.next()){
                            clobFile=workContent.getClob("content");
                        }
                        pstmt=con.prepareStatement("update work set content=? where work_id=?");
                        pstmt.setClob(1, clobFile);
                        pstmt.setString(2, workid_origin);
                        pstmt.executeUpdate();
                        pstmt=con.prepareStatement("update work set pull_request=? where work_id=?");
                        pstmt.setString(1, "N");
                        pstmt.setString(2, workid);
                        pstmt.executeUpdate();
                        isValid=true;
                    }
                }
            }
            else if(userid.equals(username)){
                PreparedStatement pstmt=con.prepareStatement("update work set pull_request=? where work_id=?");
                pstmt.setString(2, workid);
                if(action.equals("Delete request")){
                    pstmt.setString(1, "N");
                    pstmt.executeUpdate();
                    isValid=true;
                }
                else if(action.equals("Send request")){
                    pstmt.setString(1, "Y");
                    pstmt.executeUpdate();
                    isValid=true;
                }
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
