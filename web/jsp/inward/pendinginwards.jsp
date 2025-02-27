<%--
    Document   : Process Inward
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <%@include file="../templates/style.jsp" %>
        <link rel="stylesheet" type="text/css" href="css/inward/inward.css" />
        <script type="text/javascript" src="<%=request.getContextPath() + "/js/inward/processinward.js"%>"></script>
        <script type="text/javascript" src="<%=request.getContextPath() + "/js/inward/inward.js"%>"></script>
        <title>Pending Inwards</title>
        <script type="text/javascript">

            var isPageLoaded = true;
            $(document).ready(function () {
                $("#btnNext").button("disable");

                // fill in the inward purpose
                jdsAppend("CMasterData?md=purpose", "purpose", "inwardPurpose");

                $("#inwardTable").jqGrid({
                    url: "inward?action=pendinginwards",
                    datatype: 'xml',
                    mtype: 'GET',
                    width: '100%',
                    autowidth: true,
                    shrinkToFit: true,
                    height: Constants.jqgrid.HEIGHT,
                    forceFit: true,
                    sortable: true,
                    loadonce: false,
                    rownumbers: true,
                    sortname: 'inwardCreationDate',
                    sortorder: 'desc',
                    emptyrecords: "No inwards to view",
                    loadtext: "Loading...",
                    colNames: ['Inward No', 'Subscriber Id', 'Agent', 'From', 'Received Date', 'City', 'Cheque#', 'Amount', 'Purpose', 'PurposeID', 'Action'],
                    colModel: [
                        {name: 'InwardNo', sortable: false, index: 'inward_id', width: 40, align: 'center', xmlmap: 'inwardNumber', formatter: inwardlink},
                        {name: 'SubscriberId'
                            , index: 'subscriber_id'
                            , width: 45
                            , align: 'center'
                            , sortable: false
                            , xmlmap: 'subscriberId'
                        },
                        {name: 'Agent'
                            , index: 'agent'
                            , width: 50
                            , align: 'center'
                            , sortable: false
                            , xmlmap: 'agentName'
                        },
                        {name: 'From', index: 'from', width: 80, align: 'center', xmlmap: 'from'},
                        {
                            name: 'ReceivedDate',
                            index: 'inwardCreationDate',
                            width: 60,
                            align: 'center',
                            xmlmap: 'inwardCreationDate'

                        },
                        {name: 'City', index: 'city', sortable: false, width: 80, align: 'center', xmlmap: 'city'},
                        {name: 'Cheque', index: 'cheque', sortable: false, width: 40, align: 'center', xmlmap: 'chqddNumber'},
                        {name: 'amount', index: 'amount', sortable: false, width: 40, align: 'center', xmlmap: 'amount'},
                        {name: 'Purpose', index: 'purpose', sortable: false, width: 80, align: 'center', xmlmap: 'inwardPurpose'},
                        {name: 'PurposeID', index: 'purposeid', sortable: false, width: 80, align: 'center', hidden: true, xmlmap: 'inwardPurposeID'},
                        {
                            name: 'action',
                            index: '',
                            width: 80,
                            align: 'center',
                            xmlmap: '',
                            formatter: subscriberlink
                        }
                    ],
                    xmlReader: {
                        root: "results",
                        row: "row",
                        page: "results>page",
                        total: "results>total",
                        records: "results>records",
                        repeatitems: false,
                        id: "inwardNumber"
                    },
                    pager: '#pager_1',
                    rowNum: 20,
                    rowList: [20, 50, 100],
                    viewrecords: true,
                    gridview: true,
                    caption: '&nbsp;',
                    gridComplete: function () {
                        var ids = jQuery("#inwardTable").jqGrid('getDataIDs');
                        if (ids.length > 0) {
                            $("#btnNext").button("enable");
                            jQuery("#inwardTable").jqGrid('setSelection', ids[0]);
                        }
                    },
                    beforeRequest: function () {
                        return isPageLoaded;
                    },
                    loadError: function (xhr, status, error) {
                        alert("Failed getting data from server" + status);
                    },
                    onSelectRow: function (rowid, status, e) {
                        selectRow(rowid);
                    }

                });

                // enable scrolling of the Grid with the arrow keys
                // Pressing ENTER will process the Inward
                jQuery("#inwardTable").jqGrid('bindKeys', {scrollingRows: true, onEnter: function (rowid) {
                        selectRow(rowid);
                        $("#processInwardForm").submit();
                    }});


                // create a dialog on the div id=dialog
                $("#dialog").dialog({
                    height: 680,
                    width: 1200,
                    modal: true,
                    autoOpen: false,
                    buttons: {
                        "Select": function () {
                            $(this).dialog("close");

                            // call this function from the subscriberlist.jsp
                            subscriber = dlg_getSelectedSubscriber();
                            
                            var rowid = $("#inwardTable").getGridParam('selrow');

                            jQuery("#inwardTable").jqGrid('setRowData', rowid, {
                                'SubscriberId': subscriber.SubscriberNumber
                            });
                            selectedSubscriberId = subscriber.SubscriberNumber;
                            // set the subscriber if it is selected after selecting the inward,
                            // or any changes are made
                            $("#subscriberNumber").val(selectedSubscriberId);

                        },
                        "Cancel": function () {
                            $(this).dialog("close");
                        }
                    },
                    close: function () {

                    }
                });

            });

            /*
             * selects a row and highlights the selected row
             */
            function selectRow(rowid) {
                var purposeId = jQuery("#inwardTable").jqGrid('getCell', rowid, "PurposeID");
                setInwardSubscriber(rowid, purposeId);
            }

            // called when the search button is clicked
            function searchInwards() {
                if (true) {
                    isPageLoaded = true;
                    jQuery("#inwardTable").setGridParam({datatype: "xml"});
                    jQuery("#inwardTable").setGridParam({postData:
                                {inwardPurpose: $("#inwardPurpose").val()
                                }});
                    jQuery("#inwardTable").trigger("clearGridData");
                    jQuery("#inwardTable").trigger("reloadGrid");
                }
                return true;

            }

            function inwardlink(cellvalue, options, rowObject) {
                if (cellvalue) {
                    var link = '<a href="inward?action=view&inwardNumber=' + cellvalue + '">' + cellvalue + '</a>';
                    return link;
                }
                return cellvalue;
            }

            /*$(function(){
             $("#btnManualCreation")
             .click(function(){
             $("agentXLUpload").val("false");
             });
             });
             
             $(function(){
             $("#btnAgentXLUpload")
             .click(function(){
             $("agentXLUpload").val("true");
             });
             });*/


        </script>

    </head>
    <body>
        <%@include file="../templates/layout.jsp" %>

        <div id="bodyContainer">
            <form method="post" action="inward?action=processinward" name="processInwardForm" id="processInwardForm" onsubmit="return isInwardSelected()">
                <input class="allusers" type="hidden" id="inwardNumber" name ="inwardNumber" value=""/>
                <input class="allusers" type="hidden" id="subscriberNumber" name ="subscriberNumber" value=""/>
                <input class="allusers" type="hidden" id="purpose" name ="purpose" value=""/>
                <input class="allusers" type="hidden" id="asf" name ="asf" value="<%=request.getParameter("asf") != null ? request.getParameter("asf") : 0%>"/>
                <input class="allusers" type="hidden" id="afs" name ="afs" value="<%=request.getParameter("afs") != null ? request.getParameter("afs") : 0%>"/>
                <input class="allusers" type="hidden" id="agentXLUpload" name ="agentXLUpload" value=""/>
                <div class="MainDiv">
                    <fieldset class="MainFieldset">
                        <legend>Pending Inwards</legend>

                        <%-----------------------------------------------------------------------------------------------------%>
                        <%-- Search Criteria Field Set --%>
                        <%-----------------------------------------------------------------------------------------------------%>
                        <fieldset class="subMainFieldSet">
                            <%--<legend>Filter Criteria</legend>--%>

                            <%-- Search Criteria left div --%>
                            <div class="IASFormLeftDiv">

                                <div class="IASFormFieldDiv">
                                    <span class="IASFormDivSpanLabel">
                                        <label>Purpose:</label>
                                    </span>
                                    <span class="IASFormDivSpanInputBox">
                                        <select class="IASComboBoxWide allusers" TABINDEX="1" name="inwardPurpose" id="inwardPurpose" title="Select Inward purpose to filter" onchange="searchInwards()">
                                            <option value ="NULL">All</option>
                                        </select>
                                    </span>
                                </div>
                            </div>
                        </fieldset>

                        <div id="dialog">
                            <%@include file="../subscriber/subscriberlist.jsp" %>
                        </div>



                        <%-----------------------------------------------------------------------------------------------------%>
                        <%-- Search Result Field Set --%>
                        <%-----------------------------------------------------------------------------------------------------%>
                        <fieldset class="subMainFieldSet">
                            <%--<legend>Inwards</legend>--%>

                            <table class="datatable" id="inwardTable"></table>
                            <div id="pager_1"></div>
                        </fieldset>
                        <fieldset class="subMainFieldSet">
                            <div class="IASFormFieldDiv">
                                <div class="singleActionBtnDiv">
                                    <input class="IASButton allusers" TABINDEX="8" type="submit" value="Next" id="btnNext" name="btnNext"/>
                                </div>
                            </div>
                        </fieldset>
                    </fieldset>
                </div>
            </form>
        </div>
        <%--Process Agent Inward dialog box
        <div id="dialog-modal" title="Process Agent Inward"><p>Add Subscription by clicking on one of the option:</p>
            <fieldset class="subMainFieldSet">
                <div class="IASFormFieldDiv">
                    <label>Agent Subscriptions:</label>
                    <input class="IASButton" TABINDEX="9" type="button" value="Manual creation" id="btnManualCreation" name="btnManualCreation"/>
                    <br><br><br>
                    <label>Agent Excel Upload:</label>
                    <input class="IASButton" TABINDEX="10" type="button" value="Mass creation" id="btnAgentXLUpload" name="btnAgentXLUpload"/>
                </div>
            </fieldset>

        </div>--%>
    </body>
</html>