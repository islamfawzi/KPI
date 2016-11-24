<%-- 
    Document   : formula
    Created on : Nov 13, 2016, 11:03:34 PM
    Author     : islam
--%>

<%@page import="org.isource.beans.Mapping"%>
<%@page import="org.isource.beans.Formula"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="header.jsp" %>

<style type="text/css">
    div{
        width: 587px; 
    }
    h3{
        text-align: left;
    }
    textarea.form-control{
        margin-bottom: 10px;
    }
    form * {
        margin: 5px !important;
    }

    .select2-selection__arrow{
        display: none;
    }
    .select-label, .select2{
        width: 100% !important;
    }
    .select2-container .select2-selection--single{
        height: 37px;
    }
    .select2-dropdown{
        top: -25px; 
        left: 5px !important;
    }
    .select2-container--open .select2-dropdown--below{
        border-top: 3px solid #ccc;
    }
    .select2-results__options{
        max-height: 216px !important;
    }

</style>
<h3>Edit Formula</h3>
<%
    int formula_id = Integer.parseInt(request.getParameter("fid"));
%>
<jsp:useBean id="formulaId" class="org.isource.beans.Formula" scope="request"></jsp:useBean>
<jsp:setProperty name="formulaId" property="id" value="<%=formula_id%>" ></jsp:setProperty>   
<jsp:setProperty name="formulaId" property="*" />
<%

    if (request.getParameter("update_formula") != null) {
        if (db.updateFormula(formulaId) == 1) { %>
<div class="alert alert-success">
    <strong>Success!</strong> Formula Updated successfully.
</div>

<% } else { %>
<div class="alert alert-danger">
    <strong>Oops!</strong> something wrong happened, please try again!.
</div>
<% }
    }
    Formula formula = db.getFormula(formula_id);
%>

<div>

    <form method="post" action="" >
        <input value="<%=formula.getTitle()%>" type="text" name="title" class="form-control" placeholder="Title" />
        <textarea name="formula" cols="70" rows="10" class="form-control" placeholder="{Formula}" ><%=formula.getFormula()%></textarea>
        <select id="columns" class="form-control" >
            <option value="">Select Field</option>
            <% for (int index = 0; index < Mapping.getMap().size(); index++) {%>
            <option value="<%=Mapping.getMap().get(index)%>"><%= Mapping.getMap().get(index)%></option>
            <% }%>
        </select>
        <input type="submit" name="update_formula" class="btn btn-primary" value="Save" />
    </form>
</div>

<script>
    $("#columns").change(function () {
        var field = "{" + $(this).val() + "}";
        console.log(field);

        $('textarea[name=formula]').val(function (i, text) {
            return text + field;
        });
    });
    $('select').select2({
        tags: true,
        width: 'element'
    });

</script>
<%@include file="footer.jsp" %>
