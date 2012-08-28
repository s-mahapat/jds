/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package IAS.Controller;

import IAS.Class.Database;
import IAS.Class.Queries;
import IAS.Class.util;
import java.io.IOException;
import java.io.PrintWriter;
import java.rmi.ServerException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author Shailendra Mahapatra
 */
public class CMasterData extends JDSController {

    @Override
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        PrintWriter out = response.getWriter();
        String xml = null;
        String mdataRequested = request.getParameter("md").toLowerCase();
        String mdataReqKey = request.getParameter("mdkey");
        String mdataReqValue = request.getParameter("mdvalue");
        String optionalParam[] = request.getParameterValues("optionalParam");
        try {
            Connection conn = Database.getConnection();
            PreparedStatement ps = conn.prepareStatement(Queries.getQuery(mdataRequested));
            if (mdataReqValue != null) {
                //PreparedStatement ps = conn.prepareStatement(Queries.getQuery(mdataRequested));
                ps.setString(1, mdataReqValue);

                if (optionalParam != null) {
                    for (int i = 0, j = 2; i < optionalParam.length; i++) {
                        ps.setInt(j++, Integer.parseInt(optionalParam[i]));
                    }
                }
            }
            
            ResultSet rs = ps.executeQuery();
            xml = util.convertResultSetToXML(rs);
            rs.close();
            ps.close();
        } catch (SQLException ex) {
            throw (new ServerException(ex.getMessage()));
        } catch (Exception ex) {
            throw (new ServerException(ex.getMessage()));
        } finally {
            response.setContentType("text/xml");
            out.println(xml);
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
        processRequest(request, response);
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
