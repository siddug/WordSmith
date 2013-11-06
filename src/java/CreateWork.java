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
@WebServlet(name = "CreateWork", urlPatterns = {"/CreateWork"})
public class CreateWork extends HttpServlet {

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
    
    String[] genre;
    
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();
        try {
            /* TODO output your page here. You may use following sample code. */
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet CreateWork</title>");            
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet CreateWork at " + request.getContextPath() + "</h1>");
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
        String work_name=request.getParameter("workname");
        String permission=request.getParameter("permission");
        genre=new String[4];
        genre[0]=request.getParameter("genre1");
        genre[1]=request.getParameter("genre2");
        genre[2]=request.getParameter("genre3");
        genre[3]=request.getParameter("genre4");
        HttpSession session=request.getSession();
        String username="";
        if(null!=session.getAttribute("username"))username=session.getAttribute("username").toString();
        String errmsg="invalid";
        String new_workid="";
        try{
            new_workid=createWork(work_name,username,permission);
        }catch(Exception e){
            errmsg="dberror";
        }
        if(new_workid.equals("")){
            session.setAttribute("errmsg", errmsg);
            response.sendRedirect("works.jsp?userid="+username);
        }
        else //response.sendRedirect("editwork.jsp?workid="+new_workid);
            response.sendRedirect("works.jsp?userid="+username);
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
    
    private String createWork(String workname, String username, String permission) throws Exception {
        boolean isValid = false;
        Connection con;
        con = null;
        String new_workid="";
        try {
            con = connect();
            PreparedStatement pstmt=con.prepareStatement("select max(work_id) from work");
            ResultSet rs=pstmt.executeQuery();
            String max="";
            if(rs.next())max=rs.getString(1);
            int max_workid=Integer.parseInt(max);
            new_workid=Integer.toString(max_workid+1);
            pstmt=con.prepareStatement("insert into work (work_id,user_id,work_name,permission,content) values(?,?,?,?,?)");
            pstmt.setString(1, new_workid);
            pstmt.setString(2, username);
            pstmt.setString(3, workname);
            pstmt.setString(4, permission);
            pstmt.setString(5, "");
            pstmt.executeUpdate();
            for(int i=0;i<4;i++){
                if(!genre[i].equals("")){
                    PreparedStatement insertgenre=con.prepareStatement("update work set genre"+(i+1)+"=? where work_id=?");
                    insertgenre.setString(1, genre[i]);
                    insertgenre.setString(2, new_workid);
                    insertgenre.executeUpdate();
                }
            }
            pstmt=con.prepareStatement("insert into activity values(?,?,?,now())");
            pstmt.setString(1, username);
            pstmt.setString(2, new_workid);
            pstmt.setString(1, "C");
            pstmt.executeUpdate();
        }catch (Exception e) {
            System.out.println("Error : " + e.getMessage());
            throw e;
        } finally {
            con.close();
        }
        return new_workid;
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
