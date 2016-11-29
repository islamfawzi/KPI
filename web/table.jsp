<%-- 
    Document   : kpi
    Created on : Nov 14, 2016, 12:04:19 PM
    Author     : islam
--%>

<%@page import="org.isource.beans.*"%>
<%@page import="java.io.*,java.util.*, javax.servlet.*" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ include file="header.jsp"  %>

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
    .select2-selection__arrow{
        display: none;
    }
    .select-label, .select2{
        width: 100% !important;
    }
    .select2-container .select2-selection--single{
        height: 37px;
        width: 100%;
    }
    .select2-container{
        display: inline !important;
    }
    .select2-dropdown{
        top: -25px; 
        left: 5px !important;
        width: 600px !important;
    }
    .select2-container--open .select2-dropdown--below{
        border-top: 3px solid #ccc;
    }
    .select2-results__options{
        max-height: 216px !important;
    }
    .x_axis_field{
        left: -5px;
        position: relative;
    }
    .x_axis_field option{
        margin-top: 5px;
    }
</style>
<h3>Apply Formula</h3>
<%
    int table_id = Integer.parseInt(request.getParameter("table"));

    if (request.getParameter("apply") != null) {
        
        String title = request.getParameter("title");
        int formula_id = Integer.parseInt(request.getParameter("formula_id"));
        
        
    }

    List<Formula> formulaes = db.getFormulaes();

%>


<div class="alert alert-success">
    <strong>Success!</strong> KPI Added successfully.
</div>    

<div class="alert alert-danger">
    <strong>Oops!</strong> something wrong happened, please try again!.
</div>


<div>

    <form method="post" action="" >
        <input onClick="$('input[name=title]').toggle()" type='checkbox' name="new_table" value="1" /> New Table
        <br />
        <input style="display: none" type="text" name="title" class="form-control" />

        <select name="formula_id" class="form-control">
            <option value="0">Select Formula</option>
            <% for (int i = 0; i < formulaes.size(); i++) {%>
            <option value="<%= formulaes.get(i).getId()%>"><%= formulaes.get(i).getTitle()%></option>
            <% }%>
        </select>

    
        <input type="submit" value="Apply" name="apply" class="btn btn-primary" />
    </form>
</div>

<script type="text/javascript">



    $('select').select2({
        tags: true,
        width: 'element'
    });
</script>

<%@ include file="footer.jsp" %>
