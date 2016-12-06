<%@page import="org.isource.providers.Provider"%>
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
<h1>Sheets <a href="import.jsp" class="btn btn-primary">
        <span class="glyphicon glyphicon-cloud-upload" aria-hidden="true"></span>
        Import Sheet </a></h1> 
<%

    if (request.getParameter("del_files") != null) {

        int deleted = 0;

        String[] files_ids = request.getParameterValues("files_ids");
        for (String file_id : files_ids) {
            if (db.delFile(Integer.parseInt(file_id))) {
                deleted++;
            }
        }
%>

<% if (deleted == files_ids.length) {%>
<div class="alert alert-success">
    <strong>Success!</strong> Tables deleted successfully.
</div> 
<% } else { %>
<div class="alert alert-danger">
    <strong>Oops!</strong> something wrong happened, please try again!.
</div>
<% }
    } %>

<form method="post" action="" />
<table class="table">
    <thead>
        <th></th>    
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
            List<Formula> formulaes = db.getFormulaes();
            List<Files> files = db.getFiles();
            for (Files file : files) {
        %>
        <tr>
        <td class="kpi-cb">
            <input  type="checkbox" name="files_ids" value="<%=file.getId()%>" />    
        </td>
        <td class="kpis">
            <a  href="table.jsp?k=<%=file.getId()%>" target="_blank"><%= file.getTitle()%></a>
        </td>
        <td style="width:20%"> <%= file.getFormula_title() != null ? file.getFormula_title() : ""%> </td>
        <td style="width: 1px">
            <a href="table.jsp?table=<%=file.getId()%>" class="apply-formula-btn btn btn-primary" style="margin-bottom:10px;"/>
            Apply Formula
            </a>
        </td>
        
        <td>
            <a class="btn btn-default"  href="${pageContext.request.contextPath}<%=Provider.getUpload_folder()+file.getFilepath()%>" >
                <span class="glyphicon glyphicon-download-alt" ></span>
                Export
            </a>    
        </td>
        
        </tr>
        <% }%>
        <tr>
        <td><input type="checkbox" id="checkall" /></td>    
        <td><span style="font-weight:bold;color:#f00">All</span></td>    
        <td></td>
        <td colspan="2">
            <input style="width:75%;" type="submit" value="Delete" name="del_files" class="btn btn-danger" />
        </td>
        </tr>
    </tbody>
</table>
</form>
<script type="text/javascript">

    $("#checkall").click(function () {
        var checkall = $(this).is(":checked");
        $("input[type=checkbox]").prop("checked", checkall);
    });

</script>
<%@ include file="footer.jsp" %>