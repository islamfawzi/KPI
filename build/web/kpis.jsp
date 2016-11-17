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
<h1>KPIs <a href="add-kpi.jsp" class="btn btn-primary"> Add Kpi </a></h1> 
<%
    if (request.getParameter("del_kpis") != null) {

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
    <th>KPI</th>
    <th>File</th>
    <th>Formula</th>
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
            <td> <%= k.getTableName() %> </td>
            <td> <%= k.getFormula()%> </td>
            <td class="kpi-cb">
                <a class="btn btn-primary" href="edit-kpi.jsp?k=<%=k.getKpiId()%>" />Edit</a>
            </td>
            <td>
                <a class="btn btn-default"  href="kpi.jsp?k=<%=k.getKpiId()%>" target="_blank">View</a>
            </td>
        </tr>
        <% }%>
        <tr>
            <td colspan="4"></td> <td><input type="submit" value="Delete" name="del_kpis" class="btn btn-danger" /></td>
        </tr>
    </tbody>
</table>
</form>
<%@ include file="footer.jsp" %>