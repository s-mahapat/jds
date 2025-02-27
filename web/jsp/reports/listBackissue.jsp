<%--
    Document   : Print Back Issue List report
    Author     : Deepali
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <jsp:include page="../templates/style.jsp"></jsp:include>
        <link rel="stylesheet" type="text/css" href="css/report/listBackIssue.css"/>
        <title>Report : Back Issue List</title>
        <script type="text/javascript" src="<%=request.getContextPath() + "/js/reports/listBackIssue.js"%>"></script>
        <script type="text/javascript" src="<%=request.getContextPath() + "/js/common.js"%>"></script>
        <script type="text/javascript" src="js/jquery/grid.common.js"></script>


        <script type="text/javascript">
            var selectedId = 0;
            //initally set to false, after the first search the flag is set to true
            var isPageLoaded = false;

            $(document).ready(function(){
                jdsAppend("<%=request.getContextPath() + "/CMasterData?md=year"%>","year","year");
                jdsAppend("<%=request.getContextPath() + "/CMasterData?md=journalname"%>","journalName","journalName");
                jdsAppend("<%=request.getContextPath() + "/CMasterData?md=subscriberType"%>","subscriberType","subscriberType");
             });

            $(function(){

                $("#bilTable").jqGrid({
                    url:"<%=request.getContextPath() + "/reports?action=listBil"%>",
                    datatype: 'xml',
                    mtype: 'GET',
                    width: '100%',
                    height: 240,
                    autowidth: true,
                    forceFit: true,
                    sortable: true,
                    loadonce: true,
                    rownumbers: true,
                    emptyrecords: "No Mailing List Found or Generated",
                    loadtext: "Loading...",
                    colNames:['Journal Code', 'Sub Type Code', 'Subscriber Number', 'Subscriber Name', 'City',
                                'State', 'Country', 'Pincode', 'Copies', 'Issue', 'Month', 'Year', 'Start Year', 'Start Month', 'End Year', 'End Month'],
                    colModel :[
                        {name:'journalCode', index:'journalCode', width:80, align:'center', xmlmap:'journalCode'},
                        {name:'subtypecode', index:'subtypecode', width:20, align:'center', xmlmap:'subtypecode'},
                        {name:'subscriberNumber', index:'subscriberNumber', width:80, align:'center', xmlmap:'subscriberNumber'},
                        {name:'subscriberName', index:'subscriberName', width:100, align:'center', xmlmap:'subscriberName'},
                        {name:'city', index:'city', width:60, align:'center', xmlmap:'city'},
                        {name:'state', index:'state', width:60, align:'center', xmlmap:'state'},
                        {name:'country', index:'country', width:60, align:'center', xmlmap:'country'},
                        {name:'pincode', index:'pincode', width:50, align:'center', xmlmap:'pincode'},
                        {name:'copies', index:'copies', width:30, align:'copies', xmlmap:'copies'},
                        {name:'issue', index:'issue', width:30, align:'center', xmlmap:'issue'},
                        {name:'month', index:'month', width:40, align:'center', xmlmap:'month'},
                        {name:'year', index:'year', width:40, align:'center', xmlmap:'year'},
                        {name:'startYear', index:'startYear', width:40, align:'center', xmlmap:'startYear'},
                        {name:'startMonth', index:'startMonth', width:40, align:'center', xmlmap:'startMonth'},
                        {name:'endYear', index:'endYear', width:40, align:'center', xmlmap:'endYear'},
                        {name:'endMonth', index:'endMonth', width:40, align:'center', xmlmap:'endMonth'},
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
                    editurl:"<%=request.getContextPath() + "/reports?action=listBil"%>",
                    gridComplete: function() {
                        
                        var ids = jQuery("#bilTable").jqGrid('getDataIDs');
                            if(ids.length > 0){
                                $("#printReportBtn").button("enable");
                                $("#printReportBtnExcel").button("enable");                                
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
                //check if search criteria is initial, raise alert else enable search for Records
                if ($("#year").val() == 0) {
                    alert("Select Year");
                }

                else if ($("#journalName").val() == 0){
                    alert("Select Journal");
                }

                else if ($("#issue").val() == 'value'){
                    alert("Select Issue");
                }
                else if ($("#volume").val() == 'value'){
                    alert("Select Volume Number");
                }
                else {
                        isPageLoaded = true;
                        jQuery("#bilTable").setGridParam({postData:
                                {year                   : $("#year").val(),
                                journalName             : $("#journalName").val(),
                                to                      : $("#to").val(),
                                from                    : $("#from").val(),
                                issue                   : $("#issue").val(),
                                volume                  : $("#volume").val(),
                                action                  : "listBil"
                            }});

                        jQuery("#bilTable").setGridParam({ datatype: "xml" });
                        jQuery("#bilTable").trigger("clearGridData");
                        jQuery("#bilTable").trigger("reloadGrid");

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
                }


            function loadIssues(){
                $("#issue").empty();
                //text("");

                var newOption = new Option("Select", "value");
                $(newOption).html("Select");
                $("#issue").append(newOption);

                requestURL = "CMasterData?md=getissues&mdvalue=" +  $("#journalName").val() + "&optionalParam=" +  $("#volume").val();
                jdsAppend(requestURL,"issueNumber","issue");
            }

             function loadvolumes(){
                $("#volume").empty();
                //text("");

                var newOption = new Option("Select", "value");
                $(newOption).html("Select");
                $("#volume").append(newOption);

                requestURL = "CMasterData?md=getvolumes&mdvalue=" +  $("#journalName").val() + "&optionalParam=" +  $("#year").val();
                jdsAppend(requestURL,"volumeNumber","volume");
            }

            // draw the date picker.
            jQueryDatePicker("from","to");
            
            function print()
            {
                var x = "printlistBil";
                $('#action').val(x);
            }
            
            function printReportExcel()
            {
                var x = "exportToExcelBil";
                $('#action').val(x);
            }             

        </script>
    </head>
    <body>

        <%@include file="../templates/layout.jsp" %>
        <div id="bodyContainer">
            <form method="get" action="<%=request.getContextPath() + "/reports"%>" name="bilForm">
                <div class="MainDiv">
                    <fieldset class="MainFieldset">
                        <legend>Report - Back Issue List</legend>
                            <fieldset class="subMainFieldSet">
                                <legend>Selection Criteria</legend>
                                    <%-- Search Criteria left div --%>
                                    <div class="IASFormLeftDiv">
                                        <div class="IASFormFieldDiv">
                                            <div class="IASFormFieldDiv">
                                                <span class="IASFormDivSpanLabel">
                                                    <label>Journal Name:</label>
                                                </span>
                                                <span class="IASFormDivSpanInputBox">
                                                    <select class="IASComboBoxWide allusers" TABINDEX="1" name="journalName" id="journalName" onchange="loadvolumes()">
                                                        <option value="0">Select</option>
                                                    </select>
                                                </span>
                                            </div>

                                            <div class="IASFormFieldDiv">
                                                <span class="IASFormDivSpanLabel">
                                                    <label>Year</label>
                                                </span>
                                                <span class="IASFormDivSpanInputBox">
                                                    <select class="IASComboBox allusers" TABINDEX="2" name="year" id="year" onchange="loadvolumes()">
                                                        <option value="0">Select</option>
                                                    </select>
                                                </span>
                                            </div>
                                            <div class="IASFormFieldDiv">
                                                <span class="IASFormDivSpanLabel">
                                                    <label>Volume Number:</label>
                                                </span>
                                                <span class="IASFormDivSpanInputBox">
                                                    <select class="IASComboBox allusers" TABINDEX="3" name="volume" id="volume" onchange="loadIssues()">
                                                        <option value="0">Select</option>
                                                    </select>
                                                </span>
                                            </div>
                                        </div>
                                    </div>
                                    <%-- Search Criteria right div --%>
                                    <div class="IASFormRightDiv">
                                        <div class="IASFormFieldDiv">
                                            <span class="IASFormDivSpanLabel">
                                                <label>Issue:</label>
                                            </span>
                                            <span class="IASFormDivSpanInputBox">
                                                <select class="IASComboBox allusers" TABINDEX="4" name="issue" id="issue">
                                                    <option value="0">Select</option>
                                                </select>
                                            </span>
                                        </div>
                                        <div class="IASFormFieldDiv">
                                            <span class="IASFormDivSpanLabel">
                                                <label>Subscriber Type</label>
                                            </span>
                                            <span class="IASFormDivSpanInputBox">
                                                <select class="IASComboBox allusers" TABINDEX="5" name="subscriberType" id="subscriberType">
                                                    <option value="0" selected>Select</option>
                                                </select>
                                            </span>
                                        </div>
                                        <div class="IASFormFieldDiv">
                                            <span class="IASFormDivSpanLabel">
                                                <label>Date Range:</label>
                                            </span>
                                            <div class="dateDiv"></div>
                                            <span class="IASFormDivSpanInputBox">
                                                <input class="IASDateTextBox allusers" TABINDEX="6" readonly size="10" type="text" id="from" name="from"/>
                                                <label> to </label>
                                                <input class="IASDateTextBox allusers" TABINDEX="7" readonly size="10" type="text" id="to" name="to"/>
                                            </span>
                                        </div>
                                    </div>
                                    <div class="actionBtnDiv">
                                        <button class="IASButton SearchButton allusers" type="button" TABINDEX="8" id="btnSearch" name="btnSearch" onclick="search()"/>Search</button>
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
                            <%-- Actions Field Set --%>
                            <%-----------------------------------------------------------------------------------------------------%>
                            <input class="allusers" type="hidden" name="action" id="action"/>
                            <fieldset class="subMainFieldSet">
                                <div class="actionBtnDiv">
                                    <input class="IASButton allusers" type="submit" TABINDEX="9" value="Print - PDF" disabled id="printReportBtn" onclick="print()"/>
                                    <input class="IASButton allusers" type="submit" TABINDEX="10" value="Print - Excel" disabled id="printReportBtnExcel" onclick="printReportExcel()"/>
                                    <input class="IASButton allusers" TABINDEX="11" type="reset" value="Reset"/>
                                </div>
                            </fieldset>
                    </fieldset>
                </div>
            </form>
        </div>
    </body>
</html>
