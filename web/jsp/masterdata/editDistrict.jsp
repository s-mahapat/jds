<%--
    Document   : Edit District
    Author     : Deepali
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <jsp:include page="../templates/style.jsp"></jsp:include>
        <link rel="stylesheet" type="text/css" href="css/masterdata/district.css"/>
        <title>Edit District</title>
        <script type="text/javascript" src="js/masterdata/editDistrict.js"></script>
        <script type="text/javascript" src="js/masterdata/validateDistrict.js"></script>
        <script type="text/javascript" src="js/common.js"></script>
        <script>
            $(document).ready(function() {
                makeEditReadOnly();
            });
        </script>
    </head>
    <body>

        <%@include file="../templates/layout.jsp" %>
        <div id="bodyContainer">
            <form method="post" action="<%=request.getContextPath() + "/district"%>" name="districtForm" onsubmit="return validateDistrict()">
                <div class="MainDiv">
                    <fieldset class="MainFieldset">
                        <legend>Edit District</legend>
                        <%@include file="district.jsp"%>
                        </fieldset>
                </div>
            </form>
        </div>
    </body>
</html>