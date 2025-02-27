<%--
    Document   : Create Inward
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <%@include file="../templates/style.jsp" %>
        <link rel="stylesheet" type="text/css" href="<%=request.getContextPath() + "/css/inward/inward.css"%>"/>
        <title>View Inward</title>
        <script type="text/javascript" src="<%=request.getContextPath() + "/js/inward/viewinward.js"%>"></script>
        <script>
            $(document).ready(function(){
                makeReadOnly();
                makeInwardReadOnly();
                // bvalidsubscriber has to be set to true, else the
                // subscriber number gets cleared, thinking its an invalid subscriber
                bvalidsubscriber = true;
            });
        </script>
    </head>
    <body>

        <%@include file="../templates/layout.jsp" %>
        <div id="bodyContainer">
            <form method="GET" action="<%=request.getContextPath() + "/inward"%>" name="inwardForm">
                <div class="MainDiv">
                    <fieldset class="MainFieldset">
                        <legend>View Inward</legend>
                        <%@include file="inward.jsp"%>
                        </fieldset>
                </div>
            </form>
        </div>
    </body>
</html>