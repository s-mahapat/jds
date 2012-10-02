/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package JDSMigration;

import java.io.IOException;
import java.lang.reflect.InvocationTargetException;
import java.sql.SQLException;
import java.text.ParseException;
import jxl.read.biff.BiffException;
import org.apache.log4j.Logger;

/**
 *
 * @author Shailendra
 */
public class HON extends MigrationBase{
    
    private static final Logger logger = Logger.getLogger(HON.class.getName());

    public HON() throws SQLException, IOException, BiffException {
        this.dataFile = this.dataFolder + "\\HON.xls";
        this.openExcel(this.dataFile);
    }

    @Override
    public void Migrate() throws SQLException, IOException, BiffException, ParseException,
            InvocationTargetException, IllegalAccessException, Exception {

        String[] datacolumns;
        int rownum = 1;
        int success = 0;

        while (true) {
            datacolumns = this.getNextRow();
            if (datacolumns == null) {
                break;
            }
            rownum++;
            logger.info("Migrating row: " + rownum);
            
            String name = datacolumns[2];
            String address = null;
            String institute = datacolumns[4];
            String department = datacolumns[3];
            int pin = 0;
            int stateid = 0;
            int countryid = this.getCountryID(datacolumns[8]); //default to india
            int cityid = 0;
            String cityPin = datacolumns[7];

            int copies = 1;
            
            if (datacolumns[5].isEmpty() == false) {
                address = address == null ? datacolumns[5] : address + "\n" + datacolumns[5];
            }
            if (datacolumns[6].isEmpty() == false) {
                address = address == null ? datacolumns[6] : address + "\n" + datacolumns[6];
            }

            if (cityPin.matches(".*\\d+$")) {
                String[] city = cityPin.split("\\d+", 2);
                cityid = this.getCityID(city[0]);
                logger.debug("city is:" + city[0]);
                logger.debug("city id is:" + cityid);
            }
            int subscriberid = this.insertSubscriber(
                    "HONFEL",
                    name, 
                    department, 
                    institute, 
                    address, 
                    address, 
                    cityid, 
                    stateid, 
                    pin, 
                    countryid, 
                    null);
            if(subscriberid > 0){
                logger.info("Successfully inserted subsciber data for:" + name);
                int subscription_id = this.insertSubscription(subscriberid);
                if(subscription_id > 0){
                    boolean isSuccess = this.insertSubscriptionDetails(
                            subscription_id, 
                            11, //jgroup id
                            copies, //copies
                            2012, //start year
                            1, //start month
                            2050, //end year
                            12, //end month
                            1); //price group id
                    
                    if(isSuccess){
                        logger.info("Subscription inserted successfully for: " + name);
                        success++;
                    }
                }else{
                    logger.fatal("Failed to insert subscription for: " + name);
                }
            }else{
                logger.fatal("Failed to insert subscriber for: " + name);
            }
            
        }
        logger.info("Total rows: " + (rownum - 1));
        logger.info("Success: " + success);
    }
}
