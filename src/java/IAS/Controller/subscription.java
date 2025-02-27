package IAS.Controller;

//~--- non-JDK imports --------------------------------------------------------
import IAS.Class.JDSLogger;
import IAS.Class.util;
import IAS.Model.Subscriber.subscriberModel;
import IAS.Model.Subscription.SubscriptionModel;
import java.io.IOException;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.apache.log4j.Logger;
import com.thoughtworks.xstream.XStream;

public class subscription extends JDSController {

    private static final Logger logger = JDSLogger.getJDSLogger("IAS.Controller.subscription");

    @Override
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String oper = (request.getParameter("oper") != null)
                ? request.getParameter("oper")
                : "noop";
        String action = (request.getParameter("action") != null)
                ? request.getParameter("action")
                : "noop";
        String url = null;

        try {
            SubscriptionModel _subscriptionModel = new SubscriptionModel(request);
            subscriberModel _subscriberModel = new IAS.Model.Subscriber.subscriberModel(request);
            //SubscriptionFormBean _subscriptionFormBean = new IAS.Bean.Subscription.SubscriptionFormBean();

            if (oper.equalsIgnoreCase("view")) {
                url = "/jsp/subscription/viewsubscription.jsp";
            } else if (oper.equalsIgnoreCase("add")) {

                // save the subscription details sent from the UI
                String xml = _subscriptionModel.addSubscription();

                /*
                 ************************************************************
                 *
                 // PROCESS AGENT INWARD - // Variables createAgntSubscription
                 * are required for processing agent inwards. Do not complete
                 * inward from subscription if it is an agent subscription.
                 * Inward completion should be explicitly requested from client.
                 *
                 ************************************************************
                 */
                String createAgntSubscription = request.getParameter("createAgntSubscription");
                //Update inward with completed flag once the transaction is completed
                if (createAgntSubscription == null || createAgntSubscription.equals("null")) {
                    _subscriptionModel.complete_inward();
                }

                request.setAttribute("xml", xml);
                url = "/xmlserver";
            } else if (oper.equalsIgnoreCase("adddetail")) {
                String xml = null;
                int subscriptionID = Integer.parseInt(request.getParameter("subid"));
                int journalGroupID = Integer.parseInt(request.getParameter("journalGroupID"));
                int startYear = Integer.parseInt(request.getParameter("startYear"));
                int startMonth = Integer.parseInt(request.getParameter("startMonth"));
                int endYear = Integer.parseInt(request.getParameter("endYear"));
                int copies = Integer.parseInt(request.getParameter("copies"));
                float total = Float.parseFloat(request.getParameter("total"));
                int journalPriceGroupID = Integer.parseInt(request.getParameter("journalPriceGroupID"));

                // save the subscription details sent from the UI
                int[] res = _subscriptionModel.addNewSubscriptionDetail(subscriptionID, journalGroupID, startYear,
                        startMonth, endYear, copies, total, journalPriceGroupID);

                if (res.length == 1) {
                    xml = util.convertStringToXML(String.valueOf(res[0]), "success");
                }

                request.setAttribute("xml", xml);
                url = "/xmlserver";
            } else if ((action != null) && action.equalsIgnoreCase("edit")) {

                IAS.Bean.Subscription.SubscriptionFormBean _SubscriptionFormBean = _subscriptionModel.getSubscriptionByID(Integer.parseInt(request.getParameter("id")));

                if (_subscriberModel.GetSubscriber() != null) {
                    request.setAttribute("SubscriptionFormBean", _SubscriptionFormBean);
                    url = "/jsp/subscription/editsubscription.jsp";
                }
            } else if ((action != null) && action.equalsIgnoreCase("subscriptioninfo")) {
                String xml = null;
                IAS.Bean.Subscription.SubscriptionFormBean _SubscriptionFormBean = _subscriptionModel.getSubscriptionByID(Integer.parseInt(request.getParameter("id")));
                XStream xstream = new XStream();
                xstream.alias("results", IAS.Bean.Subscription.SubscriptionFormBean.class);
                xml = xstream.toXML(_SubscriptionFormBean);
                request.setAttribute("xml", xml);
                url = "/xmlserver";
            } else if (oper.equalsIgnoreCase("edit")) {

                // we reach here if the existing subscription is being edited
                String xml;
                int startYear = Integer.parseInt(request.getParameter("startYear"));
                int startMonth = Integer.parseInt(request.getParameter("startMonth"));
                int endYear = Integer.parseInt(request.getParameter("endYear"));
                int copies = Integer.parseInt(request.getParameter("copies"));
                int subTypeID = Integer.parseInt(request.getParameter("subtypeid"));
                boolean active = Boolean.parseBoolean(request.getParameter("active"));
                int id = Integer.parseInt(request.getParameter("id"));

                if (_subscriptionModel.updateSubscriptionDetail(id, startYear, startMonth, endYear, active, copies,
                        subTypeID) != 1) {
                    xml = util.convertStringToXML("Error updating subscription details", "error");
                } else {
                    xml = util.convertStringToXML("1", "success");
                }

                request.setAttribute("xml", xml);
                url = "/xmlserver";
            } else if (oper.equalsIgnoreCase("del")) {
                _subscriptionModel.deleteSubscription();
            } else if (oper.equalsIgnoreCase("getsubscription")) {

                // get the subscription details for the subscriber and send it back to the UI as xml
                String xml = _subscriptionModel.getSubscription();

                request.setAttribute("xml", xml);
                url = "/xmlserver";
            } else if (oper.equalsIgnoreCase("subid")) {
                int subscription_id = Integer.parseInt(request.getParameter("id"));
                int subscriber_type_id = Integer.parseInt(request.getParameter("subtypeid"));
                String xml = _subscriptionModel.getSubscriptionDetailBySubscriptionID(subscription_id,
                        subscriber_type_id);

                request.setAttribute("xml", xml);
                url = "/xmlserver";
            } else if (oper.equalsIgnoreCase("detail")) {
                String xml = _subscriptionModel.getSubscriptionDetails();

                request.setAttribute("xml", xml);
                url = "/xmlserver";
            } else if (oper.equalsIgnoreCase("getPrice")) {
                String xml = _subscriptionModel.getJournalPrice(Integer.parseInt(request.getParameter("startyear")),
                        Integer.parseInt(request.getParameter("years")),
                        Integer.parseInt(request.getParameter("journalgroupid")),
                        Integer.parseInt(request.getParameter("subtypeid")));

                request.setAttribute("xml", xml);
                url = "/xmlserver";
            } else if (oper.equalsIgnoreCase("getJournalGroupContents")) {
                int groupID = Integer.parseInt(request.getParameter("groupid"));
                String xml = _subscriptionModel.getJournalGroupContents(groupID);

                request.setAttribute("xml", xml);
                url = "/xmlserver";
            } else if (oper.equalsIgnoreCase("getSubscriptionDetailsForInward")) {
                String inwardNumber = request.getParameter("inwardNumber");
                String xml = _subscriptionModel.getSubscriptionDetailsForInward(inwardNumber);

                request.setAttribute("xml", xml);
                url = "/xmlserver";
            } else if (action.equalsIgnoreCase("inwardinfo")) {
                int subscription_id = Integer.parseInt(request.getParameter("id"));
                String xml = _subscriptionModel.getSubscriptionInwardInfo(subscription_id);

                request.setAttribute("xml", xml);
                url = "/xmlserver";
            } else if (action.equalsIgnoreCase("genprlist")) {
                int medium = Integer.parseInt(request.getParameter("medium"));
                int year = Integer.parseInt(request.getParameter("year"));
                String ctext = request.getParameter("ctext");
                String xml = _subscriptionModel.getPleaseReferList(medium, year, ctext);

                request.setAttribute("xml", xml);
                url = "/xmlserver";
            } else if (action.equalsIgnoreCase("payments")) {
                int subscription_id = Integer.parseInt(request.getParameter("id"));
                String xml = _subscriptionModel.getPaymentsForSubscription(subscription_id);

                request.setAttribute("xml", xml);
                url = "/xmlserver";
            }
        } catch (Exception e) {
            logger.error(e.getMessage(), e);

            throw new javax.servlet.ServletException(e);
        } finally {
            RequestDispatcher rd = getServletContext().getRequestDispatcher(url);

            if ((rd != null) && (url != null)) {
                rd.forward(request, response);

                // response.sendRedirect(request.getContextPath() + url);
            }
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
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
     * Handles the HTTP <code>POST</code> method.
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
    }    // </editor-fold>
}


//~ Formatted by Jindent --- http://www.jindent.com
