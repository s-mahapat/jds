<%--
    Document   : Search Agent
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <%@include file="../templates/style.jsp" %>
        <link rel="stylesheet" type="text/css" href="css/report/listAgent.css" />
        <title>List and Print Agent</title>
        <script type="text/javascript" src="<%=request.getContextPath() + "/js/reports/listAgent.js"%>"></script>
        <script type="text/javascript">
            $(document).ready(function() {
                jdsAppend("<%=request.getContextPath() + "/CMasterData?md=country"%>","country","country");
                jdsAppend("<%=request.getContextPath() + "/CMasterData?md=state"%>","state","state");
                jdsAppend("<%=request.getContextPath() + "/CMasterData?md=city"%>","city","city");
            });
        </script>

        <script type="text/javascript">
            //var selectedAgentName = 0;
            var selectedAgentId = 0;
            //initally set to false, after the first search the flag is set to true
            var isPageLoaded = false;

            $(function(){

                $("#agentTable").jqGrid({
                    url:"<%=request.getContextPath() + "/reports?action=listAgents"%>",
                    datatype: 'xml',
                    mtype: 'GET',
                    width: '100%',
                    height: 240,
                    autowidth: true,
                    forceFit: true,
                    sortable: true,
                    loadonce: true,
                    rownumbers: true,
                    emptyrecords: "No Agent",
                    loadtext: "Loading...",
                    colNames:['Agent Id','Agent Name','Registriation Date','Email Id', 'Address','City'],
                    colModel :[
                        {name:'id', index:'id', width:50, align:'center', xmlmap:'id'},
                        {name:'agentName', index:'agentName', width:80, align:'center', xmlmap:'agentName'},
                        {name:'regDate', index:'regDate', width:80, align:'center', xmlmap:'regDate'},
                        {name:'emailId', index:'emailId', width:80, align:'center', xmlmap:'emailId'},
                        {name:'address', index:'address', width:80, align:'center', xmlmap:'address'},
                        {name:'city', index:'city', width:80, align:'center', xmlmap:'city'}
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
                    rowNum:10,
                    rowList:[10,20,30],
                    viewrecords: true,
                    gridview: true,
                    caption: '&nbsp;',
                    gridComplete: function() {
                        var ids = jQuery("#agentTable").jqGrid('getDataIDs');
                        if(ids.length > 0){
                            $("#printReportBtn").button("enable");
                            $("#printReportBtnExportToExcel").button("enable");
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

            // called when the search button is clicked
            function searchAgents(){
                if(($("#country").val() == 0) && $("#city").val() == 0 && $("#state").val() == 0 && document.getElementById("selall").value == 0)
                    alert("Atleast one search parameter should be selected");
                else
                 {
                    isPageLoaded = true;

                    jQuery("#agentTable").setGridParam({postData:
                            {country       : $("#country").val(),
                            state          : $("#state").val(),
                            city           : $("#city").val(),
                            selall         : $("#selall:checked").length
                            //selall         : $("#selall").val
                        }});
                    jQuery("#agentTable").setGridParam({ datatype: "xml" });
                    jQuery("#agentTable").trigger("clearGridData");
                    jQuery("#agentTable").trigger("reloadGrid");
                }
            }

            function getChecked(){
                if (document.getElementById("selall").value == 1 ){
                    document.getElementById("selall").value = 0;
                }else {
                    document.getElementById("selall").value = 1;
                }
            }
            
            function printReportPdf()
            {
                var x = "printAgents";
                $('#action').val(x);
            }
            
            function printReportExcel()
            {
                var x = "exportToExcelAgents";
                $('#action').val(x);
            }            

        </script>


    </head>
    <body>
        <%@include file="../templates/layout.jsp" %>

        <div id="bodyContainer">
            <form method="post" action="<%=request.getContextPath() + "/reports"%>" name="listAgentForm">
                <div class="MainDiv">
                    <fieldset class="MainFieldset">
                        <legend>List and Print Agent Data</legend>

                        <%-----------------------------------------------------------------------------------------------------%>
                        <%-- Search Criteria Field Set --%>
                        <%-----------------------------------------------------------------------------------------------------%>
                        <fieldset class="subMainFieldSet">
                            <legend>Search Criteria</legend>

                            <%-- Search Criteria left div --%>
                            <div class="IASFormLeftDiv">
                                <div class="IASFormFieldDiv">
                                    <span class="IASFormDivSpanLabel">
                                        <label>Country:</label>
                                    </span>
                                    <span class="IASFormDivSpanInputBox">
                                        <select class="IASComboBox allusers" TABINDEX="1" name="country" id="country">
                                            <option value="0" selected >Select</option>
                                        </select>
                                    </span>
                                </div>
                                <div class="IASFormFieldDiv">
                                    <span class="IASFormDivSpanLabel">
                                        <label>State:</label>
                                    </span>
                                    <span class="IASFormDivSpanInputBox">
                                        <select class="IASComboBox allusers" TABINDEX="2" name="state" id="state">
                                            <option value="0" selected>Select</option>
                                        </select>
                                        <%--<input class="IASTextBoxMandatory" TABINDEX="3" name="state" id="state" value="<jsp:getProperty name="inwardFormBean" property="state"/>"--%>
                                    </span>
                                </div>
                            </div>

                            <%-- Search Criteria right div --%>
                            <div class="IASFormRightDiv">
                                <div class="IASFormFieldDiv">
                                    <span class="IASFormDivSpanLabel">
                                        <label>City:</label>
                                    </span>
                                    <span class="IASFormDivSpanInputBox">
                                        <select class="IASComboBox allusers" TABINDEX="3" name="city" id="city">
                                            <option value="0" selected>Select</option>
                                        </select>
                                    </span>
                                </div>
                                <div class="IASFormFieldDiv">
                                    <span class="IASFormDivSpanLabel">
                                        <label>All Agents</label>
                                    </span>
                                    <span class="IASFormDivSpanInputBox">
                                        <input class="IASCheckBox allusers" TABINDEX="4" type="checkbox" value="0" name="selall" id="selall" onclick="getChecked()"/>
                                    </span>
                                </div>

                            </div>
                            <div class="actionBtnDiv">
                                <button class="IASButton SearchButton allusers" type="button" TABINDEX="5" onclick="searchAgents()"/>Search</button>
                            </div>

                        </fieldset>



                        <%-----------------------------------------------------------------------------------------------------%>
                        <%-- Search Result Field Set --%>
                        <%-----------------------------------------------------------------------------------------------------%>
                        <fieldset class="subMainFieldSet">
                            <legend>Search Result</legend>

                            <table class="datatable" id="agentTable"></table>
                            <div id="pager"></div>
                        </fieldset>
                    </fieldset>

                        <%-----------------------------------------------------------------------------------------------------%>
                        <%-- SPrint Button Field Set --%>
                        <%-----------------------------------------------------------------------------------------------------%>
                    <input class="allusers" type="hidden" name="action" id="action"/>
                    <fieldset class="subMainFieldSet">
                        <div class="IASFormFieldDiv">
                            <div class="singleActionBtnDiv">
                                <input class="IASButton allusers" type="submit" TABINDEX="6" value="Print - PDF" disabled id="printReportBtn" onclick="printReportPdf()"/>
                                <input class="IASButton allusers" type="submit" TABINDEX="7" value="Print - Excel" disabled id="printReportBtnExportToExcel" onclick="printReportExcel()"/>
                            </div>
                        </div>
                    </fieldset>
                </div>
            </form>
        </div>
    </body>
</html>