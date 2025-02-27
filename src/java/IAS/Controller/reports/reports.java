package IAS.Controller.reports;

//~--- non-JDK imports --------------------------------------------------------

import IAS.Class.JDSLogger;
import IAS.Class.util;

import IAS.Controller.JDSController;

import IAS.Model.Reports.reportModel;

import org.apache.log4j.Logger;

//~--- JDK imports ------------------------------------------------------------

import java.io.IOException;

import java.sql.ResultSet;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author Deepali
 */
    public class reports extends JDSController {
    private static final Logger logger       = JDSLogger.getJDSLogger("IAS.Controller.reports");
    private reportModel         _reportModel = null;

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        String url    = null;

        try {
            _reportModel = new IAS.Model.Reports.reportModel(request);

            /* ---------------------------------------------------------------- */
            if (action.equalsIgnoreCase("listRates")) {
                String xml = _reportModel.listRates();

                request.setAttribute("xml", xml);
                url = "/xmlserver";
            } else if (action.equalsIgnoreCase("printRates")) {
                String xml = _reportModel.listRates();

                request.setAttribute("xml", xml);

                String query = "Annual Rates for Journals";

                request.setAttribute("query", query);
                url = "/pdfserver?action=printXML";
            } else if (action.equalsIgnoreCase("exportToExcelRates")) {
                String xml = _reportModel.listRates();

                request.setAttribute("xml", xml);

                String query = "Annual Rates for Journals";

                request.setAttribute("query", query);
                url = "/excelserver?action=printXML";
            } else if (action.equalsIgnoreCase("constructTableJournalRates")) {
                _reportModel.constructTableJournalRates();
                url = "/jsp/reports/journalRates.jsp";
            }

            /* ---------------------------------------------------------------- */
            if (action.equalsIgnoreCase("listJournalGroup")) {
                ResultSet rs  = _reportModel.searchJournalGroup();
                String    xml = util.convertResultSetToXML(rs);

                request.setAttribute("xml", xml);
                url = "/xmlserver";
            } else if (action.equalsIgnoreCase("printJournalGroup")) {
                ResultSet rs = _reportModel.searchJournalGroup();

                request.setAttribute("ResultSet", rs);

                String query = "List of journals in group";

                request.setAttribute("query", query);
                url = "/pdfserver?action=printResultset";
            } else if (action.equalsIgnoreCase("exportToExcelJournalGroup")) {
                ResultSet rs = _reportModel.searchJournalGroup();

                request.setAttribute("ResultSet", rs);

                String query = "List of journals in group";

                request.setAttribute("query", query);
                url = "/excelserver?action=printResultset";
            }

            // This actually generates a html page with table. This functionality is nolonger used
            else if (action.equalsIgnoreCase("listJournalPrint")) {
                ResultSet rs = _reportModel.searchJournalGroup();

                request.setAttribute("ResultSet", rs);
                url = "/jsp/reports/listJournalPrint.jsp";
            }

            /* ---------------------------------------------------------------- */
            else if (action.equalsIgnoreCase("listSubType")) {
                ResultSet rs  = _reportModel.searchSubType();
                String    xml = util.convertResultSetToXML(rs);

                request.setAttribute("xml", xml);
                url = "/xmlserver";
            } else if (action.equalsIgnoreCase("printSubType")) {
                ResultSet rs = _reportModel.searchSubType();

                request.setAttribute("ResultSet", rs);

                String query = "List of subscriber types";

                request.setAttribute("query", query);
                url = "/pdfserver?action=printResultset";
            } else if (action.equalsIgnoreCase("exportToExcelSubType")) {
                ResultSet rs = _reportModel.searchSubType();

                request.setAttribute("ResultSet", rs);

                String query = "List of subscriber types";

                request.setAttribute("query", query);
                url = "/excelserver?action=printResultset";
            }

            // This actually generates a html page with table. This functionality is nolonger used
            else if (action.equalsIgnoreCase("listSubTypePrint")) {
                ResultSet rs = _reportModel.searchSubType();

                request.setAttribute("ResultSet", rs);
                url = "/jsp/reports/listSubTypePrint.jsp";
            }

            /* ---------------------------------------------------------------- */
            else if (action.equalsIgnoreCase("listInwards")) {
                ResultSet rs  = _reportModel.searchInwardsAll();
                String    xml = util.convertResultSetToXML(rs);

                request.setAttribute("xml", xml);
                url = "/xmlserver";
            } else if (action.equalsIgnoreCase("printInwardsList")) {
                ResultSet rs = _reportModel.searchInwardsAll();

                request.setAttribute("ResultSet", rs);

                String query = "List of inwards";

                request.setAttribute("query", query);
                url = "/pdfserver?action=printResultset";
            }else if (action.equalsIgnoreCase("exportToExcelInwardsList")) {
                ResultSet rs = _reportModel.searchInwardsAll();

                request.setAttribute("ResultSet", rs);

                String query = "List of inwards";

                request.setAttribute("query", query);
                url = "/excelserver?action=printResultset";
            }

            /* ---------------------------------------------------------------- */
            else if (action.equalsIgnoreCase("listAgents")) {
                ResultSet rs  = _reportModel.searchAgents();
                String    xml = util.convertResultSetToXML(rs);

                request.setAttribute("xml", xml);
                url = "/xmlserver";
            } else if (action.equalsIgnoreCase("printAgents")) {
                ResultSet rs = _reportModel.searchAgents();

                request.setAttribute("ResultSet", rs);

                String query = "List of Agents";

                request.setAttribute("query", query);
                url = "/pdfserver?action=printResultset";
            }else if (action.equalsIgnoreCase("exportToExcelAgents")) {
                ResultSet rs = _reportModel.searchAgents();

                request.setAttribute("ResultSet", rs);

                String query = "List of Agents";

                request.setAttribute("query", query);
                url = "/excelserver?action=printResultset";
            }

            // This actually generates a html page with table. This functionality is nolonger used
            else if (action.equalsIgnoreCase("listAgentPrint")) {
                ResultSet rs = _reportModel.searchAgents();

                request.setAttribute("ResultSet", rs);
                url = "/jsp/reports/listAgentPrint.jsp";
            }

            /* ---------------------------------------------------------------- */
            else if (action.equalsIgnoreCase("listSubscribers")) {
                String orderBy = "subscriberName";
                ResultSet rs  = _reportModel.searchSubscriber(orderBy);
                String    xml = util.convertResultSetToXML(rs);

                request.setAttribute("xml", xml);
                url = "/xmlserver";
            } else if (action.equalsIgnoreCase("printSubscribersReport")) {
                String orderBy = "subscriberName";

                ResultSet rs = _reportModel.searchSubscriber(orderBy);

                request.setAttribute("ResultSet", rs);

                String query = "List of Subscribers";

                request.setAttribute("query", query);
                //url = "/excelserver?action=printResultset";
                url = "/pdfserver?action=printResultset";
            } else if (action.equalsIgnoreCase("printSubscribersSticker")) {

                String orderBy = "pincode";
                // ResultSet rs = _reportModel.printSubscribersList();
                ResultSet rs = _reportModel.searchSubscriber(orderBy);

                request.setAttribute("ResultSet", rs);

                String noHeader = "off";

                request.setAttribute("noHeader", noHeader);

                String periodicals = "off";

                request.setAttribute("periodicals", periodicals);
                url = "/pdfserver?action=generatemlPrintSticker";
            } else if (action.equalsIgnoreCase("printSubscribersLabel")) {
                
                String orderBy = "pincode";
                // ResultSet rs = _reportModel.printSubscribersList();
                ResultSet rs = _reportModel.searchSubscriber(orderBy);

                request.setAttribute("ResultSet", rs);

                String noHeader = "off";

                request.setAttribute("noHeader", noHeader);

                String periodicals = "off";

                request.setAttribute("periodicals", periodicals);
                url = "/pdfserver?action=generatemlPrintSticker";
               
            } else if (action.equalsIgnoreCase("exportReportToExcel")) {

                String orderBy = "pincode";
                // ResultSet rs = _reportModel.printSubscribersList();
                ResultSet rs = _reportModel.searchSubscriber(orderBy);

                request.setAttribute("ResultSet", rs);

                String noHeader = "off";

                request.setAttribute("noHeader", noHeader);

                String periodicals = "off";

                request.setAttribute("periodicals", periodicals);
                String query = "Stickers-Labels";
                request.setAttribute("query", query);
                url = "/excelserver?action=printResultset";                
            }else if (action.equalsIgnoreCase("printSubscribersExportToExcel")) {

                String orderBy = "pincode";
                // ResultSet rs = _reportModel.printSubscribersList();
                ResultSet rs = _reportModel.searchSubscriber(orderBy);

                request.setAttribute("ResultSet", rs);

                String noHeader = "off";

                request.setAttribute("noHeader", noHeader);

                String periodicals = "off";

                request.setAttribute("periodicals", periodicals);
                url = "/excelserver?action=generatemlPrintLabel";
            }

            // This actually generates a html page with table. This functionality is nolonger used
            /*
            else if (action.equalsIgnoreCase("listSubscribersPrint")) {
                ResultSet rs = _reportModel.searchSubscriber();

                request.setAttribute("ResultSet", rs);
                url = "/jsp/reports/listSubscriberPrint.jsp";


            }*/ else if (action.equalsIgnoreCase("listCirculationFigures")) {
                ResultSet rs  = _reportModel.searchCirculationFigures();
                String    xml = util.convertResultSetToXML(rs);

                request.setAttribute("xml", xml);
                url = "/xmlserver";
            } else if (action.equalsIgnoreCase("listCirculationFiguresPrint")) {
                ResultSet rs = _reportModel.searchCirculationFigures();

                request.setAttribute("ResultSet", rs);
                url = "/jsp/reports/listCirculationFiguresPrint.jsp";
            }

            /* ---------------------------------------------------------------- */
            else if (action.equalsIgnoreCase("statement")) {
                String xml = _reportModel.statement();

                request.setAttribute("xml", xml);
                url = "/xmlserver";
            } else if (action.equalsIgnoreCase("printStatement")) {
                ResultSet rs  = null;
                String    xml = _reportModel.statement();

                request.setAttribute("xml", xml);

                String query = "Statement for Journal " + request.getParameter("journalName") + " for year "
                               + request.getParameter("year") + " for issue no " + request.getParameter("issue");

                request.setAttribute("query", query);
                url = "/pdfserver?action=printXML";
            }else if (action.equalsIgnoreCase("exportToExcelStatement")) {
                ResultSet rs  = null;
                String    xml = _reportModel.statement();

                request.setAttribute("xml", xml);

                String query = "Statement for Journal " + request.getParameter("journalName") + " for year "
                               + request.getParameter("year") + " for issue no " + request.getParameter("issue");

                request.setAttribute("query", query);
                url = "/excelserver?action=printXML";
            }

            /* ---------------------------------------------------------------- */
            else if (action.equalsIgnoreCase("circulationFigures")) {
                String xml = _reportModel.circulationFigures();

                request.setAttribute("xml", xml);
                url = "/xmlserver";
            } else if (action.equalsIgnoreCase("printCirculationFigures")) {
                String xml = _reportModel.circulationFigures();

                request.setAttribute("xml", xml);

                String query = "Circulation Figures for Year " + request.getParameter("year") + " for Month "
                               + request.getParameter("month");

                request.setAttribute("query", query);
                url = "/pdfserver?action=printXML";
            }else if (action.equalsIgnoreCase("exportToExcelCirculationFigures")) {
                String xml = _reportModel.circulationFigures();

                request.setAttribute("xml", xml);

                String query = "Circulation Figures for Year " + request.getParameter("year") + " for Month "
                               + request.getParameter("month");

                request.setAttribute("query", query);
                url = "/excelserver?action=printXML";
            }

            /* ---------------------------------------------------------------- */
            else if (action.equalsIgnoreCase("constructTableSubcriptionFigures")) {
                _reportModel.constructTableSubcriptionFigures();
                url = "/jsp/reports/subscriptionFigures.jsp";
            } else if (action.equalsIgnoreCase("subscriptionFigures")) {
                String xml = _reportModel.subscriptionFigures();

                request.setAttribute("xml", xml);
                url = "/xmlserver";
            } else if (action.equalsIgnoreCase("printSubscriptionFigures")) {
                String xml = _reportModel.subscriptionFigures();

                request.setAttribute("xml", xml);

                String query = "Subscription Figures";

                request.setAttribute("query", query);
                url = "/pdfserver?action=printXML";
            }else if (action.equalsIgnoreCase("exportToExcelSubscriptionFigures")) {
                String xml = _reportModel.subscriptionFigures();

                request.setAttribute("xml", xml);

                String query = "Subscription Figures";

                request.setAttribute("query", query);
                url = "/excelserver?action=printXML";
            }
            /* ---------------------------------------------------------------- */
            else if (action.equalsIgnoreCase("subscriptionFiguresLegacy")) {
                String xml = _reportModel.subscriptionFiguresLegacy();

                request.setAttribute("xml", xml);
                url = "/xmlserver";
            } else if (action.equalsIgnoreCase("printSubscriptionFiguresLegacy")) {
                String xml = _reportModel.subscriptionFiguresLegacy();

                request.setAttribute("xml", xml);

                String query = "Circulation Figures Legacy for " + request.getParameter("year");

                request.setAttribute("query", query);
                url = "/pdfserver?action=printXML";
            }else if (action.equalsIgnoreCase("exportToExcelSubscriptionFiguresLegacy")) {
                String xml = _reportModel.subscriptionFiguresLegacy();

                request.setAttribute("xml", xml);

                String query = "Circulation Figures Legacy for " + request.getParameter("year");

                request.setAttribute("query", query);
                url = "/excelserver?action=printXML";
            }             

            /* ---------------------------------------------------------------- */
            else if (action.equalsIgnoreCase("listMl")) {
                ResultSet rs  = _reportModel.listMl();
                String    xml = util.convertResultSetToXML(rs);

                request.setAttribute("xml", xml);
                url = "/xmlserver";
            } else if (action.equalsIgnoreCase("printlistMl")) {
                ResultSet rs = _reportModel.listMl();

                request.setAttribute("ResultSet", rs);

                String query = "Circulation Figures";

                request.setAttribute("query", query);
                url = "/pdfserver?action=printResultset";
            } else if (action.equalsIgnoreCase("exportToExcelMl")) {
                ResultSet rs = _reportModel.listMl();

                request.setAttribute("ResultSet", rs);

                String query = "Circulation Figures";

                request.setAttribute("query", query);
                url = "/excelserver?action=printResultset";
            }                        
            else if (action.equalsIgnoreCase("listBil")) {
                ResultSet rs  = _reportModel.listBil();
                String    xml = util.convertResultSetToXML(rs);

                request.setAttribute("xml", xml);
                url = "/xmlserver";
            } else if (action.equalsIgnoreCase("printlistBil")) {
                ResultSet rs = _reportModel.listBil();

                request.setAttribute("ResultSet", rs);

                String query = "Circulation Figures";

                request.setAttribute("query", query);
                url = "/pdfserver?action=printResultset";
            }else if (action.equalsIgnoreCase("exportToExcelBil")) {
                ResultSet rs = _reportModel.listBil();

                request.setAttribute("ResultSet", rs);

                String query = "Circulation Figures";

                request.setAttribute("query", query);
                url = "/excelserver?action=printResultset";
            }

            /* ---------------------------------------------------------------- */
            else if (action.equalsIgnoreCase("listInvoice")) {
                String    xml  = _reportModel.listInvoice();
                request.setAttribute("xml", xml);
                url = "/xmlserver";
            } else if (action.equalsIgnoreCase("printlistInvoice")) {
                String    xml  = _reportModel.listInvoice();
                request.setAttribute("xml", xml);
                String query = "List invoice";
                request.setAttribute("query", query);
                url = "/pdfserver?action=printXML";
            }else if (action.equalsIgnoreCase("exportToExcelInvoice")) {
                String    xml  = _reportModel.listInvoice();
                request.setAttribute("xml", xml);
                String query = "List invoice";
                request.setAttribute("query", query);
                url = "/excelserver?action=printXML";
            }

            /* ---------------------------------------------------------------- */
            else if (action.equalsIgnoreCase("listReminder")) {
                ResultSet rs  = _reportModel.listReminders();
                String    xml = util.convertResultSetToXML(rs);

                request.setAttribute("xml", xml);
                url = "/xmlserver";
            } else if (action.equalsIgnoreCase("printListReminder")) {
                ResultSet rs = _reportModel.listReminders();

                request.setAttribute("ResultSet", rs);

                String query = "List Reminders";

                request.setAttribute("query", query);
                url = "/pdfserver?action=printResultset";
            }else if (action.equalsIgnoreCase("exportToExcelListReminder")) {
                ResultSet rs = _reportModel.listReminders();

                request.setAttribute("ResultSet", rs);

                String query = "List Reminders";

                request.setAttribute("query", query);
                url = "/excelserver?action=printResultset";
            }

            /* ---------------------------------------------------------------- */
            else if (action.equalsIgnoreCase("printOrderTableDetailsList")) {
                String xml = _reportModel.printOrderTableDetailsList();

                request.setAttribute("xml", xml);
                url = "/xmlserver";
            } else if (action.equalsIgnoreCase("contructTableForPrintOrderReport")) {
                _reportModel.contructTableForPrintOrderReport();
                url = "/jsp/reports/listPrintOrder.jsp";
            } else if (action.equalsIgnoreCase("printPOT")) {
                String xml = _reportModel.printOrderTableDetailsList();

                request.setAttribute("xml", xml);

                String query = "Print Order Table";

                request.setAttribute("query", query);
                url = "/pdfserver?action=printXML";
            }else if (action.equalsIgnoreCase("exportToExcelPOT")) {
                String xml = _reportModel.printOrderTableDetailsList();

                request.setAttribute("xml", xml);

                String query = "Print Order Table";

                request.setAttribute("query", query);
                url = "/excelserver?action=printXML";
            }

            /* -----------------------outstaning Bill -------------------------- */
            else if (action.equalsIgnoreCase("listOutstandingBalance")) {
                String xml = _reportModel.outstaningBalnace();

                request.setAttribute("xml", xml);
                url = "/xmlserver";
            } else if (action.equalsIgnoreCase("printOutstandingBalance")) {
                String xml = _reportModel.outstaningBalnace();

                request.setAttribute("xml", xml);

                String query = "Outstanding balance for Subscriptions";

                request.setAttribute("query", query);
                url = "/pdfserver?action=printXML";
            }else if (action.equalsIgnoreCase("exportToExcelOutstandingBalance")) {
                String xml = _reportModel.outstaningBalnace();

                request.setAttribute("xml", xml);

                String query = "Outstanding balance for Subscriptions";

                request.setAttribute("query", query);
                url = "/excelserver?action=printXML";
            }

            /* ---------------------------------------------------------------- */
            /* -----------------------List of Generated mailing list -------------------------- */
            else if (action.equalsIgnoreCase("gml")) {
                ResultSet rs  = _reportModel.gml();
                String    xml = util.convertResultSetToXML(rs);
                request.setAttribute("xml", xml);
                url = "/xmlserver";

            } else if (action.equalsIgnoreCase("printgml")) {
                ResultSet rs = _reportModel.gml();

                request.setAttribute("ResultSet", rs);

                String query = "List of Generated mailing list";

                request.setAttribute("query", query);
                url = "/pdfserver?action=printResultset";
            }else if (action.equalsIgnoreCase("exportToExcelgml")) {
                ResultSet rs = _reportModel.gml();

                request.setAttribute("ResultSet", rs);

                String query = "List of Generated mailing list";

                request.setAttribute("query", query);
                url = "/excelserver?action=printResultset";
            }

            /* ---------------------------------------------------------------- */
        } catch (Exception e) {
            logger.error(e.getMessage(), e);

            throw new javax.servlet.ServletException(e);
        } finally {
            if (url == null) {
                url = "/jsp/errors/404.jsp";
                logger.error("Redirect url was not found, forwarding to 404");
            } else {
                logger.debug("Called->" + url);
            }

            RequestDispatcher rd = getServletContext().getRequestDispatcher(url);

            if ((rd != null) && (url != null)) {
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
    }    // </editor-fold>
}


//~ Formatted by Jindent --- http://www.jindent.com
