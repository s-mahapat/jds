package IAS.Model.masterdata;

import IAS.Bean.masterdata.journalSubjectGroupFormBean;
import IAS.Model.JDSModel;
import java.lang.reflect.InvocationTargetException;
import org.apache.log4j.Logger;
import IAS.Class.JDSLogger;
import javax.servlet.http.HttpServletRequest;
import java.sql.*;
import IAS.Class.Queries;
import IAS.Class.util;
import javax.xml.parsers.ParserConfigurationException;
import javax.xml.transform.TransformerException;

/**
 *
 * @author aloko
 */
public class journalSubjectGroupModel extends JDSModel {

    private journalSubjectGroupFormBean _journalSubjectGroupFormBean = null;
    private static final Logger logger = JDSLogger.getJDSLogger(journalSubjectGroupModel.class.getName());

    public journalSubjectGroupModel(HttpServletRequest request) throws SQLException {
        super(request);

    }

    public synchronized void save() throws SQLException, IllegalAccessException, InvocationTargetException {
        journalSubjectGroupFormBean journalSubjectGroupFormBean = new IAS.Bean.masterdata.journalSubjectGroupFormBean();
        request.setAttribute("journalSubjectGroupFormBean", journalSubjectGroupFormBean);

        //FillBean is defined in the parent class IAS.Model/JDSModel.java
        FillBean(this.request, journalSubjectGroupFormBean);
        this._journalSubjectGroupFormBean = journalSubjectGroupFormBean;
        request.setAttribute("journalSubjectGroupFormBean", this._journalSubjectGroupFormBean);

        String journalName = _journalSubjectGroupFormBean.getJournalName();
        String newJournalGroupName = _journalSubjectGroupFormBean.getNewJournalGroupName();
        //int select = _journalSubjectGroupFormBean.getSelect();
        String select = _journalSubjectGroupFormBean.getSelect();

        // Step1: Check if the journalGroupName and year exist in the table
        String sql = Queries.getQuery("checkIfJournalGroupExists");
        try (Connection conn = this.getConnection(); PreparedStatement st = conn.prepareStatement(sql)) {
            conn.setAutoCommit(false);
            int paramIndex = 1;
            st.setString(paramIndex++, newJournalGroupName);
            try (ResultSet rs = st.executeQuery()) {
                // If the entry does not exist, then add to the db
                if (!rs.next()) {
                    // Step2: If the group and year does not exist, then add to the table
                    sql = Queries.getQuery("createNewJournalGroup");
                    try (PreparedStatement pst = conn.prepareStatement(sql);) {
                        paramIndex = 1;
                        pst.setString(paramIndex++, newJournalGroupName);
                        pst.executeUpdate();
                    }
                }
            } catch (SQLException ex) {
                logger.error(ex);
            }

            // Now that the new group is created, now add the journals belonging to the group to the group contents table
            // We will reach here when a new group is being created or when journals are being added to the group
            if (select.equals("Yes")) {
                sql = Queries.getQuery("checkIfJournalGroupContentExists");
                try (PreparedStatement gst = conn.prepareStatement(sql);) {
                    gst.setString(1, newJournalGroupName);
                    gst.setString(2, journalName);
                    try (ResultSet rs = gst.executeQuery()) {
                        // If the entry does not exist, then add to the db. This is just extra protection
                        if (!rs.next()) {
                            // Step2: Now that the groupId and journalId is present, add to the group contents table
                            sql = Queries.getQuery("addToJournalGroupContents");
                            try (PreparedStatement pst = conn.prepareStatement(sql)) {
                                pst.setString(1, newJournalGroupName);
                                pst.setString(2, journalName);
                                pst.executeUpdate();
                            } catch (SQLException ex) {
                                logger.error(ex);
                            }
                        }
                    }
                    conn.commit();
                } catch (SQLException ex) {
                    logger.error(ex);
                }
            }

        } catch (SQLException ex) {
            logger.error(ex);
        }
    }

    public String search() throws IllegalAccessException, InvocationTargetException, SQLException, ParserConfigurationException, TransformerException {
        journalSubjectGroupFormBean journalSubjectGroupFormBean = new IAS.Bean.masterdata.journalSubjectGroupFormBean();
        request.setAttribute("journalSubjectGroupFormBean", journalSubjectGroupFormBean);

        //FillBean is defined in the parent class IAS.Model/JDSModel.java
        FillBean(this.request, journalSubjectGroupFormBean);
        this._journalSubjectGroupFormBean = journalSubjectGroupFormBean;

        request.setAttribute("journalSubjectGroupFormBean", this._journalSubjectGroupFormBean);

        //Get the journal group ID
        String sql = Queries.getQuery("getJournalGroupId");
        String xml;
        try (Connection conn = this.getConnection(); PreparedStatement st = conn.prepareStatement(sql);) {
            st.setString(1, this._journalSubjectGroupFormBean.getJournalGroupName());

            try (ResultSet rs = st.executeQuery();) {
                rs.next();
                int id = rs.getInt(1);
            }

            //Get journal group contents
            sql = Queries.getQuery("getJournalGroupContents");
            try (PreparedStatement pst = conn.prepareStatement(sql);) {
                pst.setString(1, this._journalSubjectGroupFormBean.getJournalGroupName());
                try (ResultSet rs2 = pst.executeQuery()) {
                    xml = convertResultSetToXMLForJournalSubjectGroup(rs2, true);
                }
            }
        }
        //xml = util.convertResultSetToXML(rs);
        return xml;
    }

    // This function is called when the user presses the "Add new subject group" on the UI.
    // This function just returns the list of journals from the journal table
    public String add() throws IllegalAccessException, InvocationTargetException, SQLException, ParserConfigurationException, TransformerException {
        journalSubjectGroupFormBean journalSubjectGroupFormBean = new IAS.Bean.masterdata.journalSubjectGroupFormBean();
        request.setAttribute("journalSubjectGroupFormBean", journalSubjectGroupFormBean);

        //FillBean is defined in the parent class IAS.Model/JDSModel.java
        FillBean(this.request, journalSubjectGroupFormBean);
        this._journalSubjectGroupFormBean = journalSubjectGroupFormBean;

        request.setAttribute("printOrderFormBean", this._journalSubjectGroupFormBean);

        String sql = Queries.getQuery("journal_name");
        String xml;
        try (Connection conn = this.getConnection(); ResultSet rs = conn.prepareStatement(sql).executeQuery()) {
            //st.setInt(1, this._journalSubscriptionRateGroupFormBean.getYear());            
            //xml = convertResultSetToXMLForJournalSubjectGroup(rs, false);
            xml = util.convertResultSetToXML(rs);
        }
        return xml;
    }

    // This function adds the Yes/No status to each resultset entry which is shown as checked or not checked on the UI
    public String convertResultSetToXMLForJournalSubjectGroup(ResultSet result, boolean checked) throws SQLException {
        String xml = "";
        xml = xml + "<?xml version='1.0' encoding='utf-8'?>\n";
        xml = xml + "<results>";

        ResultSetMetaData rsmd = result.getMetaData();
        int numberOfColumns = rsmd.getColumnCount();

        while (result.next()) {
            for (int i = 1; i <= numberOfColumns; i++) {
                String columnValue = result.getString(i);

                if (i == 1) {
                    xml = xml + "<row>";
                    //xml = xml + "<id>" + id + "</id>";
                    //xml = xml + "<journalGroupName>" + journalGroupName + "</journalGroupName>";
                }

                xml = xml + "<" + rsmd.getColumnName(i) + ">" + columnValue + "</" + rsmd.getColumnName(i) + ">";

                if (i == numberOfColumns) {
                    if (checked) {
                        xml = xml + "<select>" + "1" + "</select>";
                    } else {
                        xml = xml + "<select>" + "0" + "</select>";
                    }
                    xml = xml + "</row>";
                }
            }
        }
        xml = xml + "</results>";

        return xml;
    }

}
