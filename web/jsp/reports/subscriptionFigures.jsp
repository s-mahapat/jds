<%--
    Document   : Subscription Figure for Journal
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <%@include file="../templates/style.jsp" %>
        <link rel="stylesheet" type="text/css" href="css/report/circulationFigures.css" />
        <title>Subscription Figures</title>
        <script type="text/javascript">
            $(document).ready(function() {
                <%--jdsAppend("<%=request.getContextPath() + "/CMasterData?md=year"%>","year","year");--%>
                $("#printReportBtn").button("disable");
            });
        </script>

        <script>
            var isPageLoaded = false;

            $(function(){

                      $("#subscriptionFigTable").jqGrid({
                        url:"<%=request.getContextPath() + "/reports?action=subscriptionFigures"%>",
                        datatype: 'xml',
                        mtype: 'GET',
                        width: '100%',
                        height: Constants.jqgrid.HEIGHT,
                        autowidth: true,
                        forceFit: true,
                        sortable: true,
                        loadonce: true,
                        rownumbers: true,
                        emptyrecords: "No records to view",
                        loadtext: "Loading...",
                        colNames: <jsp:getProperty name="subscriptionFiguresFormBeanReport" property="colN"/>,
                        colModel: <jsp:getProperty name="subscriptionFiguresFormBeanReport" property="colM"/>,
                        xmlReader : {
                          root: "results",
                          row: "row",
                          page: "results>page",
                          total: "results>total",
                          records : "results>records",
                          repeatitems: false,
                          id: "journal_id"
                       },
                        pager: '#pager',
                        rowNum:15,
                        rowList:[15,30,50],
                        viewrecords: true,
                        gridview: true,
                        caption: '&nbsp;',
                        gridComplete: function() {
                            var ids = jQuery("#subscriptionFigTable").jqGrid('getDataIDs');
                            if(ids.length > 0){
                                $("#printReportBtn").button("enable");
                                $("#printReportBtnExcel").button("enable");                                
                            }
                        },
                        beforeRequest: function(){
                          return isPageLoaded;
                        },
                        loadError: function(xhr,status,error){
                            alert("Failed getting data from server: " + status);
                        }
                    });
            });

            function getReport(){

                    isPageLoaded = true;
                    jQuery("#subscriptionFigTable").setGridParam({postData:
                            {action         : "subscriptionFigures",
                            year            : $("#year").val()
                        }});
                    jQuery("#subscriptionFigTable").setGridParam({ datatype: "xml" });
                    jQuery("#subscriptionFigTable").trigger("clearGridData");
                    jQuery("#subscriptionFigTable").trigger("reloadGrid");

            }
            
            function printReportPdf()
            {
                var x = "printSubscriptionFigures";
                $('#action').val(x);
            }
            
            function printReportExcel()
            {
                var x = "exportToExcelSubscriptionFigures";
                $('#action').val(x);
            }              

        </script>
    </head>
    <body>
        <%@include file="../templates/layout.jsp" %>

        <div id="bodyContainer">
            <jsp:useBean class="IAS.Bean.Reports.subscriptionFiguresFormBeanReport" id="subscriptionFiguresFormBeanReport" scope="request"></jsp:useBean>
            <form method="post" action="<%=request.getContextPath() + "/reports"%>" name="subscriptionFigures">
                <div class="MainDiv">
                    <fieldset class="MainFieldset">
                        <legend>Subscription Figures</legend>

                        <%-----------------------------------------------------------------------------------------------------%>
                        <%-- Search Criteria Field Set --%>
                        <%-----------------------------------------------------------------------------------------------------%>
                        <fieldset class="subMainFieldSet">
                            <legend>Search Criteria</legend>
                            <div class="IASFormLeftDiv">

                                <div class="IASFormFieldDiv">
                                    <span class="IASFormDivSpanLabel">
                                        <label>Year</label>
                                    </span>
                                    <span class="IASFormDivSpanInputBox">
                                        <select class="IASComboBoxSmallMandatory allusers" TABINDEX="1" name="year" id="year">
                                            <%--<option value="0">Select</option>--%>
                                            <%
                                                for (int j = 1990; j <= 2050; j++) {
                                                    out.println("<option value =\"" + j + "\">" + j + "</option>");
                                                }
                                            %>
                                        </select>
                                    </span>
                                </div>
                            </div>

                            <div class="IASFormRightDiv">

                            </div>

                            <div class="IASFormFieldDiv">
                                <div id="searchBtnDiv">
                                    <input class="IASButton allusers" TABINDEX="2" type="button" onclick="getReport()" value="Get Report"/>
                                </div>

                                <div id="resetBtnDiv">
                                    <input class="IASButton allusers" TABINDEX="3" type="reset" value="Reset"/>
                                </div>
                            </div>

                        </fieldset>


                        <%-----------------------------------------------------------------------------------------------------%>
                        <%-- Search Result Field Set --%>
                        <%-----------------------------------------------------------------------------------------------------%>
                        <fieldset class="subMainFieldSet">
                            <legend>Search Result</legend>

                            <table class="subscriptionFigTable" id="subscriptionFigTable"></table>
                            <div id="pager"></div>
                        </fieldset>

                        <%-----------------------------------------------------------------------------------------------------%>
                        <%-- Print Action Field Set --%>
                        <%-----------------------------------------------------------------------------------------------------%>

                        <input class="allusers" type="hidden" name="action" id="action"/>
                        <fieldset class="subMainFieldSet">
                            <div class="IASFormFieldDiv">
                                <div class="singleActionBtnDiv">
                                    <%--<input class="IASButton" type="button" value="Print" onclick="javascript:window.print();"/>--%>
                                    <input class="IASButton allusers" type="submit" TABINDEX="4" value="Print - PDF" disabled id="printReportBtn" onclick="printReportPdf()"/>
                                    <input class="IASButton allusers" type="submit" TABINDEX="5" value="Print - Excel" disabled id="printReportBtnExcel" onclick="printReportExcel()"/>                                                                        
                                </div>
                            </div>
                        </fieldset>
                    </fieldset>
                </div>
            </form>
        </div>
    </body>
</html>