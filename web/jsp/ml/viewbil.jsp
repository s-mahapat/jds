<%--
    Document   : Generate and Print - Back Issue List
    Author     : Deepali
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <jsp:include page="../templates/style.jsp"></jsp:include>
            <link rel="stylesheet" type="text/css" href="css/ml/generatebil.css"/>
            <title>View and Print Back Issue List</title>
            <script type="text/javascript" src="<%=request.getContextPath() + "/js/ml/generatebil.js"%>"></script>
        <script type="text/javascript" src="<%=request.getContextPath() + "/js/common.js"%>"></script>
        <script type="text/javascript" src="js/jquery/grid.common.js"></script>
        <script type="text/javascript" src="js/jquery/grid.formedit.js"></script>
        <script type="text/javascript" src="js/jquery/jquery.jqGrid.src.js"></script>
        <script type="text/javascript" src="js/jquery/jquery.jqGrid.min.js"></script>


        <script type="text/javascript">
            var selectedId = 0;
            //initally set to false, after the first search the flag is set to true
            var isPageLoaded = false;

            $(document).ready(function(){
                jQuery("#btnPrint").attr("disabled",true);
                //reloadSubscriberNumber('s');
            });

            $(function(){

                $("#bilTable").jqGrid({
                    url:"<%=request.getContextPath()%>/generatebil",
                    datatype: 'xml',
                    mtype: 'GET',
                    width: '100%',
                    height: Constants.jqgrid.HEIGHT,
                    autowidth: true,
                    forceFit: true,
                    sortable: true,
                    loadonce: true,
                    rownumbers: true,
                    emptyrecords: "No Mailing List Found",
                    loadtext: "Loading...",
                    colNames:['Journal Code', 'Sub. Type', 'Subscriber Number', 'Subscriber Name', 'City',
                        'State', 'Country', 'PIN code', 'Copies', 'Volume','Issue', 'Year', 'Date', 'Page Size'],
                    colModel :[
                        {name:'journalCode', index:'journalCode', width:80, align:'center', xmlmap:'journalCode'},
                        {name:'subtypecode', index:'subtypecode', width:80, align:'center', xmlmap:'subtypecode'},
                        {name:'subscriberNumber', index:'subscriberNumber', width:80, align:'center', xmlmap:'subscriberNumber'},
                        {name:'subscriberName', index:'subscriberName', width:80, align:'center', xmlmap:'subscriberName'},
                        {name:'city', index:'city', width:80, align:'center', xmlmap:'city'},
                        {name:'state', index:'state', width:80, align:'center', xmlmap:'state'},
                        {name:'country', index:'country', width:80, align:'center', xmlmap:'country'},
                        {name:'pincode', index:'pincode', width:80, align:'center', xmlmap:'pincode'},
                        {name:'copies', index:'copies', width:80, align:'copies', xmlmap:'copies'},
                        {name:'volumeNumber', index:'volumeNumber', width:80, align:'center', xmlmap:'volumeNumber'},
                        {name:'issue', index:'issue', width:80, align:'center', xmlmap:'issue'},
                        {name:'year', index:'year', width:80, align:'center', xmlmap:'year'},
                        {name:'bildate', index:'bildate', width:80, align:'center', xmlmap:'bildate'},
                        {name:'page_size', index:'page_size', width:80, align:'center', xmlmap:'page_size'},
                    ],
                    xmlReader : {
                        root: "results",
                        row: "row",
                        page: "results>page",
                        total: "results>total",
                        records : "results>records",
                        repeatitems: false,
                        id: "id"
                    },
                    pager: '#pager',
                    rowNum:15,
                    rowList:[15,30,45],
                    viewrecords: true,
                    gridview: true,
                    caption: '&nbsp;',
                    editurl:"<%=request.getContextPath()%>/generatebil?action=search",
                    gridComplete: function() {
                        var ids = jQuery("#bilTable").jqGrid('getDataIDs');
                        for (var i = 0; i < ids.length; i++) {
                            action = "<a style='color:blue;' href='generatebil?action=print&id=" + ids[i] + "'>Print</a>";
                            jQuery("#generatebil").jqGrid('setRowData', ids[i], { Action: action });
                        }
                    },
                    beforeRequest: function(){
                        return isPageLoaded;
                    },
                    loadError: function(xhr,status,error){
                        alert("Failed getting data from server" + status);
                    }

                });

            });

            //jQuery("#mlTable").jqGrid('searchGrid', {multipleSearch:true} );


            jQuery("#bilTable").jqGrid('navGrid','#pager',
            // Which buttons to show
            {edit:false,add:false,del:false,search:true},
            // Edit options
            {},
            // Add options
            {},
            // Delete options
            {},
            // Search options
            {multipleGroup:true, multipleSearch:true}
        );

            function search(){

                if (($("#subscriberNumber").val() == 0) && (($("#to").val()) == 0 && ($("#from").val()) == 0)){
                    alert("Select Subscriber Number or Date Range");
                }
                else {
                    isPageLoaded = true;
                    jQuery("#bilTable").setGridParam({postData:
                            {
                            subscriberNumber        : $("#subscriberNumber").val(),
                            to                      : $("#to").val(),
                            from                      : $("#from").val(),
                            bilCreationDate          : $("#bilCreationDate").val(),
                            periodicals             : $("#periodicals").length,
                            separateLabel           : $("#separateLabel").length,
                            action                  : "search"
                        }});
                    jQuery("#bilTable").setGridParam({ datatype: "xml" });
                    jQuery("#bilTable").trigger("clearGridData");
                    jQuery("#bilTable").trigger("reloadGrid");

                    //jQuery("#mlTable").jqGrid('searchGrid', {multipleSearch:true} );

                    jQuery("#bilTable").jqGrid('navGrid','#pager',
                    // Which buttons to show
                    {edit:false,add:false,del:false,search:true},
                    // Edit options
                    {},
                    // Add options
                    {},
                    // Delete options
                    {},
                    // Search options
                    {multipleGroup:true, multipleSearch:true}
                );

                }
                jQuery("#btnPrint").attr("disabled",false);
            }

            function reloadSubscriberNumber( mode ){

                $("#subscriberNumber").empty();
                $("#subscriberNumber").text("");

                var newOption = new Option("Select", "0");
                $(newOption).html("Select");
                $("#subscriberNumber").append(newOption);
                if (mode == 'g')
                    requestURL = "CMasterData?md=subscribernumber";
                else
                    requestURL = "CMasterData?md=subscribernumberbil";

                jdsAppend(requestURL,"subscriberNumber","subscriberNumber");

            }

            function printLabel()
            {
                var x = "printLabel";
                $('#action').val(x);
            }

            function printSticker()
            {
                var x = "printSticker";
                $('#action').val(x);
            }
            
            function exportToExcel()
            {
                var x = "exportToExcel";
                $('#action').val(x);
            }            

            // draw the date picker.
            jQueryDatePicker("from","to");

        </script>
    </head>
    <body>

        <%@include file="../templates/layout.jsp" %>
        <div id="bodyContainer">
            <form method="get" action="<%=request.getContextPath() + "/generatebil"%>" name="mlForm">
                <div class="MainDiv">
                    <fieldset class="MainFieldset">
                        <legend>View and Print Back Issue List</legend>
                        <jsp:useBean class="IAS.Bean.MailingList.bilFormBean" id="bilFormBean" scope="request"></jsp:useBean>
                        <fieldset class="subMainFieldSet">
                            <legend>Selection Criteria</legend>
                            <%-- Search Criteria left div --%>
                            <div class="IASFormLeftDiv">
                                <div class="IASFormFieldDiv">
                                    <span class="IASFormDivSpanLabel">
                                        <label>Subscriber Number</label>
                                    </span>
                                    <span class="IASFormDivSpanInputBox">
                                        <input class="IASTextBox" TABINDEX="-1" type="text" name="subscriberNumber" id="subscriberNumber"/>
                                    </span>
                                </div>
                                <div class="IASFormFieldDiv">
                                    <div class="IASFormFieldDiv">
                                        <span class="IASFormDivSpanLabel">
                                            <label>Creation Date:</label>
                                        </span>
                                        <span class="IASFormDivSpanInputBox">
                                            <input class="IASDateTextBox" TABINDEX="-1" readonly type="text" name="bilCreationDate" id="bilCreationDate" value="<jsp:getProperty name="bilFormBean" property="bilCreationDate"/>"/>
                                        </span>
                                    </div>
                                </div>
                            </div>
                            <%-- Search Criteria right div --%>
                            <div class="IASFormRightDiv">
                                <div class="IASFormFieldDiv">
                                    <span class="IASFormDivSpanLabel">
                                        <label>Date Range:</label>
                                    </span>
                                    <div class="dateDiv"></div>
                                    <span class="IASFormDivSpanInputBox">
                                        <input class="IASDateTextBox" TABINDEX="5" readonly size="10" type="text" id="from" name="from"/>
                                        <label> to </label>
                                        <input class="IASDateTextBox" TABINDEX="6" readonly size="10" type="text" id="to" name="to"/>
                                    </span>
                                </div>
                            </div>
                            <div class="actionBtnDiv">
                                <button class="IASButton SearchButton" TABINDEX="5" type="button" value="Search" id="btnSearch" name="btnSearch" onclick="search()"/>Search</button>
                            </div>
                        </fieldset>

                        <%-----------------------------------------------------------------------------------------------------%>
                        <%-- Search Result Field Set --%>
                        <%-----------------------------------------------------------------------------------------------------%>
                        <fieldset class="subMainFieldSet">
                            <legend>Mailing List Table</legend>

                            <table class="datatable" id="bilTable"></table>
                            <div id="pager"></div>
                        </fieldset>

                        <%-----------------------------------------------------------------------------------------------------%>
                        <%-- Journal Actions Field Set --%>
                        <%-----------------------------------------------------------------------------------------------------%>

                        <input type="hidden" name="action" id="action"/>
                        <fieldset class="subMainFieldSet">
                            <div class="actionBtnDiv">
                                <label>Periodicals</label>
                                <input class="IASCheckBox" TABINDEX="6" type="checkbox" name="periodicals" id="periodicals"/>
                                <input class="IASButton" TABINDEX="7" type="submit" value="Print Label" id="btnPrintLabel" name="btnPrintLabel" onclick="printLabel()"/>
                                <input class="IASButton" TABINDEX="8" type="submit" value="Print Sticker" id="btnPrintSticker" name="btnPrintSticker" onclick="printSticker()"/>
                                <input class="IASButton" TABINDEX="9" type="submit" value="Label/Sticker - Excel" id="btnExportToExcel" name="btnExportToExcel" onclick="exportToExcel()"/>
                                <input class="IASButton" TABINDEX="10" type="reset" value="Reset"/>
                            </div>
                            <div class="SeparateLabel">
                                <input class="IASCheckBox" TABINDEX="11" type="checkbox" name="separateLabelForP" id="separateLabelForP"/>
                                <label>Generate separate label for latest issue of P</label>
                                <input class="IASCheckBox" TABINDEX="12" type="checkbox" name="separateLabelForRES" id="separateLabelForRES"/>
                                <label>Generate separate label for latest issue of RES</label>
                                <input class="IASCheckBox" TABINDEX="13" type="checkbox" name="separateLabelForCURR" id="separateLabelForCURR"/>
                                <label>Generate separate label for latest issue of CURR</label>                                
                            </div>                            
                        </fieldset>
                    </fieldset>
                </div>
            </form>
        </div>
    </body>
</html>
