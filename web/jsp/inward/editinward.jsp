<%--
    Document   : Create Inward
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <jsp:include page="../templates/style.jsp"></jsp:include>
        <link rel="stylesheet" type="text/css" href="<%=request.getContextPath() + "/css/inward/inward.css"%>"/>

        <title>Edit Inward</title>

        <%--------------------------------------------------------------%>
        <%-- Calendar --%>
        <%--------------------------------------------------------------%>
        <script type="text/javascript" src="<%=request.getContextPath() + "/js/inward/editinward.js"%>"></script>
        <script type="text/javascript" src="<%=request.getContextPath()%>/js/city.js"></script>
        <script type="text/javascript" src="<%=request.getContextPath()%>/js/district.js"></script>
        <script type="text/javascript">
            $(document).ready(function() {
                loadData();
                jQueryCalendar("paymentDate", true);
                jQueryCalendar("letterDate", true);
                makeInwardReadOnly();

                // disable the form submit on pressing enter
                $("#subscriberId").bind("keypress", function(e) {
                    if (e.keyCode == 13) {
                        ValidateSubscriber();
                        return false;
                    }
                });

                // bvalidsubscriber has to be set to true, else the
                // subscriber number gets cleared, thinking its an invalid subscriber
                bvalidsubscriber = true;
            });
        </script>

    </head>
    <body>

        <%@include file="../templates/layout.jsp" %>
        <div id="bodyContainer">
            <form method="post" action="<%=request.getContextPath() + "/inward"%>" name="inwardForm" onsubmit="return validateNewInward()">
                <div class="MainDiv">
                    <fieldset class="MainFieldset">
                        <legend>Edit Inward</legend>
                        <%@include file="inward.jsp"%>
                        </fieldset>
                </div>
            </form>
        </div>
    </body>
</html>