<%@page import="org.isource.beans.Formula"%>
<%@page import="org.isource.beans.Files"%>
<%@page import="java.util.Arrays"%>
<%@page import="java.util.List"%>
<%@page import="org.isource.beans.KPI_Formula_Table"%>
<%@ include file="header.jsp"  %>

<style type="text/css">
    .kpis{
        width: 44%;
    }
    .kpi-cb{
        width: 20px;
    }
    .apply-formula-div{
        display: none;
    }
</style>
<h1>Tables <a href="import.jsp" class="btn btn-primary"> Import Sheet </a></h1> 
<%
    if (request.getParameter("del_files") != null) {

        String[] del_files = request.getParameterValues("del_files");
        for (String file_id : del_files) {
            db.delFile(Integer.parseInt(file_id));
        }
%>

<div class="alert alert-success">
    <strong>Success!</strong> Tables deleted successfully.
</div> 

<% } %>

<form method="post" action="" />
<table class="table">
    <thead>
        <th></th>    
        <th>Table</th>
        <th>Formula</th>
    </thead>
    <tbody>
        <%
            List<Formula> formulaes = db.getFormulaes();
            List<Files> files = db.getFiles();
            for (Files file : files) {
        %>
        <tr>
        <td class="kpi-cb">
            <input  type="checkbox" name="tables_ids" value="<%=file.getId()%>" />    
        </td>
        <td class="kpis">
            <a  href="table.jsp?k=<%=file.getId()%>" target="_blank"><%= file.getTitle()%></a>
        </td>
        <td style="width:20%"> <%= file.getFormula_title() != null ? file.getFormula_title() : ""%> </td>
        <td>
            <a href="table.jsp?table=<%=file.getId()%>" class="apply-formula-btn btn btn-primary" style="margin-bottom:10px;"/>Apply Formula</a>
<!--            <div class="apply-formula-div" > 
                <select style="width:60%;float:left;margin-right: 10px;" name="formula_id" class="form-control" >
                    <option value="0">Select Formula</option>

                    <% for (int i = 0; i < formulaes.size(); i++) {%>
                    <option value="<%= formulaes.get(i).getId()%>">
                        <%= formulaes.get(i).getTitle()%>
                    </option>
                    <% } %>

                </select>
                <input style="width:70px;" class="apply-formula-submit btn btn-primary" value="apply" />-->
            </div>
        </td>
        </tr>
        <% }%>
        <tr>
        <td colspan="3"></td> 
        <td>
            <input type="submit" value="Delete" name="del_files" class="btn btn-danger" />
        </td>
        </tr>
    </tbody>
</table>
</form>
<!--<script type="text/javascript">

    $(".apply-formula-btn").click(function () {

        $(".apply-formula-div").toggle();

    });

</script>-->
<%@ include file="footer.jsp" %>