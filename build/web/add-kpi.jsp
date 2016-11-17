<%-- 
    Document   : kpi
    Created on : Nov 14, 2016, 12:04:19 PM
    Author     : islam
--%>

<%@page import="org.isource.beans.*"%>
<%@ page import="java.io.*,java.util.*, javax.servlet.*" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ include file="header.jsp"  %>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.1.1/jquery.min.js"></script>
<style type="text/css">
    div{
        width: 600px; 
    }
    h3{
        text-align: left;
    }
    form *{
        margin: 5px !important;
    }
    .cols-btn{
        padding: 5px;
    }
</style>
<h3>Add KPI</h3>
<%
    List<Formula> formulaes = db.getFormulaes();
    List<Files> files = db.getFiles();
%>

<% if (request.getParameter("add_kpi") != null) { %>
<jsp:useBean id="kpiId" class="org.isource.beans.Kpi" scope="request" ></jsp:useBean>
<jsp:setProperty name="kpiId" property="*" />
<%
    if (db.addKpi(kpiId) == 1) {
%>
<div class="alert alert-success">
    <strong>Success!</strong> KPI Added successfully.
</div>    
<%      } else {
%>
<div class="alert alert-danger">
    <strong>Oops!</strong> something wrong happened, please try again!.
</div>
<%      }
    }
%>

<div>

    <form method="post" action="" >
        <input type="text" name="title" class="form-control" />
        <select name="formula_id" class="form-control">
            <option value="0">Select Formula</option>
            <% for (int i = 0; i < formulaes.size(); i++) {%>
            <option value="<%= formulaes.get(i).getId()%>"><%= formulaes.get(i).getTitle()%></option>
            <% } %>
        </select>

        <select name="table_id" class="form-control">
            <option value="0">Select File</option>
            <% for (int i = 0; i < files.size(); i++) {%>
            <option tablename="<%=files.get(i).getTablename()%>" value="<%=files.get(i).getId()%>"> <%= files.get(i).getTablename()%> </option>
            <% }%>
        </select> 
        <div id="cols"></div>
        <input type="submit" value="Create KPI" name="add_kpi" class="btn btn-primary" />
    </form>
</div>

<script type="text/javascript">

    $("select[name=table_id]").change(function () {
        var tablename = $('option:selected', this).attr('tablename');
        $.ajax({
            method: "POST",
            url: "ajax.jsp",
            data: {tablename: tablename}
        }).done(function (output) {
            $("#cols").html(output);
        });
    });

</script>

<%@ include file="footer.jsp" %>
