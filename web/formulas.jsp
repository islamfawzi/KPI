<%@page import="org.isource.beans.Formula"%>
<%@page import="java.util.List"%>
<%@ include file="header.jsp"  %>

<style type="text/css">
    .kpis{
        width: 26%;
    }
    .kpi-cb{
        width: 1%;
    }
</style>
<h1>Formulas <a href="formula.jsp" class="btn btn-primary"> 
        <span class="glyphicon glyphicon-plus" aria-hidden="true"></span>
        Add Formula </a></h1> 
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
    <thead>
        <th></th>
        <th>Title</th>
        <th>Formula</th>
        
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
            <td style="width:60%"><%= (formula.getFormula().length() > 80) ? formula.getFormula().substring(0, 80) + " .." : formula.getFormula()  %></td>
            <td style="width:24%">
                <a class="btn btn-primary" href="edit-formula.jsp?fid=<%=formula.getId()%>" />Edit</a>
            </td>
        </tr>
        <% }%>
        <tr>
            <td> <input type="checkbox" id="checkall" /> </td>
            <td> <span style="font-weight:bold;color:#f00;"> All </span> </td> 
            <td></td>
            <td><input type="submit" value="Delete" name="del_formulas" class="btn btn-danger" /></td>
        </tr>
    </tbody>
</table>
</form>
        <script>
            $("#checkall").click(function(){
                var checkall = $(this).is(":checked");
                $("input[type=checkbox]").prop("checked", checkall);
            });
        </script>
<%@ include file="footer.jsp" %>
