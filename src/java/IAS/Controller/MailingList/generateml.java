package IAS.Controller.MailingList;

import IAS.Model.ml.mlModel;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import IAS.Class.JDSLogger;
import IAS.Controller.JDSController;
import java.sql.ResultSet;
import javax.servlet.RequestDispatcher;

/**
 *
 * @author aloko
 */
public class generateml extends JDSController {
    private mlModel _mlModel = null;
    private static final Logger logger = JDSLogger.getJDSLogger("IAS.Controller.masterData");

    @Override
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        String url = null;

        try {
            _mlModel = new IAS.Model.ml.mlModel(request);

            if(action.equalsIgnoreCase("generate")){
                
                String xml = _mlModel.generate();
                request.setAttribute("xml", xml);
                url = "/xmlserver";

            }else if(action.equalsIgnoreCase("checkml")){
                String xml = _mlModel.checkMl();
                request.setAttribute("xml", xml);
                url = "/xmlserver";

            }else if(action.equalsIgnoreCase("search")){

                String xml = _mlModel.search();
                request.setAttribute("xml", xml);
                url = "/xmlserver";

            }else if(action.equalsIgnoreCase("printLabel")){

                /*
                String pdf = _mlModel.printml(response, "LABEL");
                //request.setAttribute("pdf", pdf);
                url = "/pdfserver";
                //url = "";
                 *
                 */
                ResultSet rs = _mlModel.printml();
                request.setAttribute("ResultSet", rs);
                url = "/pdfserver?action=generatemlPrintLabel";

            }else if(action.equalsIgnoreCase("printSticker")){

                /*
                String pdf = _mlModel.printml(response, "STICKER");
                //request.setAttribute("pdf", pdf);
                url = "/pdfserver";
                //url = "";
                 *
                 */
                ResultSet rs = _mlModel.printml();
                request.setAttribute("ResultSet", rs);
                url = "/pdfserver?action=generatemlPrintSticker";
            }else if (action.equalsIgnoreCase("exportToExcel")) {

                ResultSet rs = _mlModel.printml();
                request.setAttribute("ResultSet", rs);

                String noHeader = "off";
                request.setAttribute("noHeader", noHeader);

                String periodicals = "off";
                request.setAttribute("periodicals", periodicals);
                
                String query = "Stickers-Labels";
                request.setAttribute("query", query);
                url = "/excelserver?action=generatemlPrintLabel";                
            }

        } catch (Exception e) {
            logger.error(e.getMessage(), e);
            throw new javax.servlet.ServletException(e);

        } finally {
            if(url == null){
                url = "/jsp/errors/404.jsp";
                logger.error("Redirect url was not found, forwarding to 404");
            }
            else
            {
                logger.debug("Called->" + url);
            }
            RequestDispatcher rd = getServletContext().getRequestDispatcher(url);
            if (rd != null && url != null) {
                rd.forward(request, response);
            }
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
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
     * Handles the HTTP <code>POST</code> method.
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
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>
}
