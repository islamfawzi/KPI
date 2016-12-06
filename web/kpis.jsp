<%@page import="java.util.Arrays"%>
<%@page import="java.util.List"%>
<%@page import="org.isource.beans.KPI_Formula_Table"%>
<%@ include file="header.jsp"  %>

<style type="text/css">
    .kpis{
        width: 450px;
    }
    .kpi-cb{
        width: 20px;
    }
</style>
<h1>KPIs <a href="add-kpi.jsp" class="btn btn-primary">
        <span class="glyphicon glyphicon-plus" aria-hidden="true"></span>
        Add Kpi </a></h1> 
        <%    if (request.getParameter("del_kpis") != null) {

                String[] kpi_ids = request.getParameterValues("kpi_ids");
                for (String kpi_id : kpi_ids) {
                    db.delKpi(Integer.parseInt(kpi_id));
                }
        %>

<div class="alert alert-success">
    <strong>Success!</strong> KPIs deleted successfully.
</div> 

<% } %>

<form method="post" action="" />
<table class="table">
    <thead>
        <th></th>    
        <th>
            <span class="glyphicon glyphicon-signal" aria-hidden="true"></span>
            KPI
        </th>
        <th>
            <span class="glyphicon glyphicon-th-list" aria-hidden="true"></span>
            Sheet
        </th>
        <th>
            <span class="glyphicon glyphicon-baby-formula" aria-hidden="true"></span>
            Formula
        </th>
    </thead>
    <tbody>
        <%
            List<KPI_Formula_Table> kpis = db.getKpis();
            for (KPI_Formula_Table k : kpis) {
        %>
        <tr>
        <td class="kpi-cb">
            <input  type="checkbox" name="kpi_ids" value="<%=k.getKpiId()%>" />    
        </td>
        <td class="kpis">
            <a  href="kpi.jsp?k=<%=k.getKpiId()%>" target="_blank"><%= k.getKpiTitle()%></a>
        </td>
        <td> <%= k.getTableName()%> </td>
        <td> <%= k.getFormulaTitle()%> </td>
        <td class="kpi-cb">
            <a class="btn btn-primary" href="edit-kpi.jsp?k=<%=k.getKpiId()%>" />
            Edit</a>
        </td>
        <td>
            <a class="btn btn-default"  href="kpi.jsp?k=<%=k.getKpiId()%>" target="_blank">View</a>
        </td>
        </tr>
        <% }%>
        <tr>
        <td> <input type="checkbox" id="checkall" /> </td>
        <td> <span style="font-weight:bold;color:#f00;"> All </span> </td> 
        <td colspan="2"></td> 
        <td colspan="2">
            <input style="width: 74%" type="submit" value="Delete" name="del_kpis" class="btn btn-danger" />
        </td>
        </tr>
    </tbody>
</table>
</form>
<script>

    $("#checkall").click(function () {
        var checkall = $(this).is(":checked");
        $("input[type=checkbox]").prop("checked", checkall);
    });

</script>
<%@ include file="footer.jsp" %>