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
import java.sql.Clob;
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
@WebServlet(name = "CopyWork", urlPatterns = {"/CopyWork"})
public class CopyWork extends HttpServlet {

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
            out.println("<title>Servlet CopyWork</title>");            
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet CopyWork at " + request.getContextPath() + "</h1>");
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
        HttpSession session=request.getSession();
        String username="";
        if(null!=session.getAttribute("username"))username=session.getAttribute("username").toString();
        String errmsg="invalid";
        String new_workid="";
        try{
            new_workid=copyWork(workid,username);
        }catch(Exception e){
            errmsg="dberror";
        }
        if(new_workid.equals("")){
            session.setAttribute("errmsg", errmsg);
            response.sendRedirect("work.jsp?workid="+workid);
        }
        else response.sendRedirect("editwork.jsp?workid="+new_workid);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
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
    
    private String copyWork(String workid, String username) throws Exception {
        Connection con;
        con = null;
        String new_workid="";
        try {
            con = connect();
            PreparedStatement pstmt=con.prepareStatement("select * from work where work_id=?");
            pstmt.setString(1, workid);
            ResultSet rs=pstmt.executeQuery();
            String permission="";
            Clob clobFile=null;
            String workname="";
            String orig_userid="";
            String genre1="",genre2="",genre3="",genre4="";
            if(rs.next()){
                permission=rs.getString("permission");
                clobFile=rs.getClob("content");
                workname=rs.getString("work_name");
                orig_userid=rs.getString("user_id");
                genre1=rs.getString("genre1");
                genre2=rs.getString("genre2");
                genre3=rs.getString("genre3");
                genre4=rs.getString("genre4");
            }
            if(permission.equals("Pb")){
                pstmt=con.prepareStatement("select max(work_id) from work");
                rs=pstmt.executeQuery();
                String max="";
                if(rs.next())max=rs.getString(1);
                int max_workid=Integer.parseInt(max);
                new_workid=Integer.toString(max_workid+1);
                System.out.println(new_workid+" "+username+" "+orig_userid);
                pstmt=con.prepareStatement("insert into work (work_id,user_id,work_id_origin,content,work_name,permission,genre1,genre2,genre3,genre4) values (?,?,?,?,?,?,?,?,?,?)");
                pstmt.setString(1, new_workid);
                pstmt.setString(2, username);
                pstmt.setString(3, workid);
                pstmt.setClob(4, clobFile);
                pstmt.setString(5, workname);
                pstmt.setString(6, permission);
                pstmt.setString(7, genre1);
                pstmt.setString(8, genre2);
                pstmt.setString(9, genre3);
                pstmt.setString(10, genre4);
                pstmt.executeUpdate();
                pstmt = con.prepareStatement("insert into activity values(?,?,?,now())");
                pstmt.setString(1, username);
                pstmt.setString(2, new_workid);
                pstmt.setString(3, "C");
                pstmt.executeUpdate();
            }
        }catch (Exception e) {
            System.out.println("Error : " + e.getMessage());
            throw e;
        } finally {
            con.close();
        }
        return new_workid;
    }
    
    
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>
}
