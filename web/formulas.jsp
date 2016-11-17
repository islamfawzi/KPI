<%@page import="org.isource.beans.Formula"%>
<%@page import="java.util.List"%>
<%@ include file="header.jsp"  %>

<style type="text/css">
    .kpis{
        width: 450px;
    }
    .kpi-cb{
        width: 20px;
    }
</style>
<h1>Formulas <a href="formula.jsp" class="btn btn-primary"> Add Formula </a></h1> 
<%
    if (request.getParameter("del_formulas") != null) {

        String[] formulas_ids = request.getParameterValues("formulas_ids");
        for (String formula_id : formulas_ids) {
            db.delFormula(Integer.parseInt(formula_id));
        }
%>

<div class="alert alert-success">
    <strong>Success!</strong> Formulas deleted successfully.
</div> 

<% } %>

<form method="post" action="" />
<table class="table">
    <tbody>
        <%
            List<Formula> formulas = db.getFormulaes();
            for (Formula formula : formulas) {
        %>
        <tr>
            <td class="kpi-cb">
                <input  type="checkbox" name="formulas_ids" value="<%=formula.getId() %>" />    
            </td>
            <td class="kpis">
                <a  href="edit-formula.jsp?fid=<%=formula.getId()%>" ><%= formula.getTitle() %></a>
            </td>
            <td class="kpi-cb">
                <a class="btn btn-primary" href="edit-formula.jsp?fid=<%=formula.getId()%>" />Edit</a>
            </td>
        </tr>
        <% }%>
        <tr>
            <td colspan="2"></td> <td><input type="submit" value="Delete" name="del_formulas" class="btn btn-danger" /></td>
        </tr>
    </tbody>
</table>
</form>
<%@ include file="footer.jsp" %>
