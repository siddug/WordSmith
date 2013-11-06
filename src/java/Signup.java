/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
import java.util.Date;
import java.sql.Timestamp;
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
@WebServlet(name = "Signup", urlPatterns = {"/Signup"})
public class Signup extends HttpServlet {
    
    String firstname;
    String lastname;
    String username;
    String password;
    String email;
    String dob;
    String sex;
    
    private static final String DBNAME = "wordsmith";
    private static final String DB_USERNAME = "root";
    private static final String DB_PASSWORD = "renderman";
    
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
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();
        try {
            /* TODO output your page here. You may use following sample code. */
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet Signup</title>");            
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet Signup at " + request.getContextPath() + "</h1>");
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
        firstname=request.getParameter("firstnamesignup");
        lastname=request.getParameter("lastnamesignup");
        username=request.getParameter("usernamesignup");
        password=request.getParameter("passwordsignup");
        email=request.getParameter("emailsignup");
        //dob=request.getParameter("dob");
        //sex=request.getParameter("sex");
        boolean canSignup=false;
        String errmsg="signupinvalid";
        try{
            canSignup=doSignup();
        } catch(Exception e) {
            errmsg = "signupdberror";
        }
        HttpSession session=request.getSession();
        if(canSignup){
            session.setAttribute("username", username);
        }
        if(canSignup)response.sendRedirect("home.jsp");
        else{
            session.setMaxInactiveInterval(20);
            session.setAttribute("errmsg", errmsg);
            response.sendRedirect("index.jsp");
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
    
    private boolean doSignup() throws Exception {
        boolean isValid = false;
        Connection con;
        con = null;
        try {
            con = connect();
            PreparedStatement prepStmt = con.prepareStatement("select * from user where user_id=?");
            prepStmt.setString(1, username);
            ResultSet rs = prepStmt.executeQuery();
            if(rs.next())return false;
            prepStmt=con.prepareStatement("insert into user (user_id,first_name,last_name,password,email_id,current_visit) values(?,?,?,?,?,now())");
            prepStmt.setString(1, username);
            prepStmt.setString(2, firstname);
            prepStmt.setString(3, lastname);
            prepStmt.setString(4, password);
            prepStmt.setString(5, email);
            //java.util.Date date = new java.util.Date();
            //String current_time = new Timestamp(date.getTime()).toString().substring(0, 18);
            //prepStmt.setString(6, current_time);
            prepStmt.executeUpdate();
            isValid=true;
        } catch (Exception e) {
            System.out.println(" Error while signing up: " + e.getMessage());
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
