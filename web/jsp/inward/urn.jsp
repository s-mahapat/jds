<!DOCTYPE HTML>
<html lang="en">
    <head>
        <meta charset="utf-8">
        <title>Update Receipt Numbers</title>
        <%@include file="../templates/style.jsp"%>
        <%@include file="../fileupload/fileupload.jsp"%>
        <link rel="stylesheet" type="text/css" href="<%=request.getContextPath() + "/css/inward/inward.css"%>" />
        <script type="text/javascript">
            var selectedInward = 0;
            var selectedSubscriberId = 0;
            var isPageLoaded = false;
            
            $(function(){
                
                _fileuploader = new jdsfileuploader("uploader");
                _fileuploader.url = "fileupload?action=urn";
                _fileuploader.filters = [{title : "XML files", extensions : "xml"}];
                _fileuploader.success = function(up, file, info){                    
                    alert($(info.response).find("message").text());
                    if($(info.response).find("results").find("row") != null){
                        loadErrorGrid(info.response);
                    }else{
                        alert($(info.response).find("message").text());
                    }                    
                };
                _fileuploader.error = function(up, args){
                    alert("Error in uploading XML file");
                }
                _fileuploader.draw();

            });
            
            
            function loadErrorGrid(xml){
                $("#urnTable").jqGrid({
                    datatype: 'xmlstring',
                    datastr: xml,
                    //mtype: 'GET',
                    width: '100%',
                    height: 240,
                    autowidth: true,
                    forceFit: true,
                    sortable: true,
                    loadonce: true,
                    rownumbers: true,
                    emptyrecords: "No records to view",
                    loadtext: "Loading...",
                    colNames:['Inward#','Subscriber#', 'Reciept#','Cheque#','Date'],
                    colModel :[
                        {name:'Inward#', index:'inward_id', width:50, align:'center', xmlmap:'inwardno'},
                        {name:'Subscriber#', index:'subscriber_id', width:50, align:'center', xmlmap:'subno'},
                        {name:'Reciept#', index:'reciept_no', width:50, align:'center', xmlmap:'reciept_no'},
                        {name:'Cheque#', index:'cheque_no', width:50, align:'center', xmlmap:'chqno'},
                        {name:'Date', index:'date', width:30, align:'center', sortable: true, sorttype: 'int',xmlmap:'chqdate'},
                    ],
                    xmlReader : {
                        root: "results",
                        row: "row",
                        page: "results>page",
                        total: "results>total",
                        records : "results>records",
                        repeatitems: false,
                        id: "inwardno"
                    },
                    pager: '#pager',
                    rowNum:10,
                    rowList:[10,20,30],
                    viewrecords: true,
                    gridview: true,
                    caption: '&nbsp;',
                    gridComplete: function() {},

                    loadError: function(xhr,status,error){
                        alert("Failed getting data from server" + status);
                    }
                });
            }
        </script>

    </head>
    <body>
        <%@include file="../templates/layout.jsp" %>
        <div id="bodyContainer">
            <form action="" method="POST" enctype="multipart/form-data">
                <div class="MainDiv">
                    <fieldset class="MainFieldset">
                        <legend>Update Receipt Numbers</legend>
                        <fieldset class="subMainFieldSet">
                            <legend>File Upload</legend>
                            <div class="IASFormLeftDiv">
                                <div id="uploader">
                                    <p>You browser doesn't have Flash, Silverlight, Gears, BrowserPlus or HTML5 support.</p>
                                </div>
                            </div>
                            <div class="IASFormRightDiv">
                                <div class="IASFormFieldDiv">
                                    <b>Note:</b>
                                    <ul style="margin-top: 0">
                                        <li>The maximum file size for uploads is unlimited.</li>
                                        <li>Only xml files (<strong>.XML</strong>) are allowed.</li>
                                        <li>The receipt numbers will be updated in the respective inwards.</li>
                                    </ul>
                                </div>
                            </div>
                        </fieldset>

                        <fieldset class="subMainFieldSet">
                            <legend>Failures</legend>
                            <div class="IASFormFieldDiv">
                                <table class="datatable" id="urnTable"></table>
                                <div id="pager"></div>
                            </div>
                        </fieldset>
                    </fieldset>
                </div>
            </form>
        </div>
    </body>
</html>