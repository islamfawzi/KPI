<%-- 
    Document   : kpi
    Created on : Nov 14, 2016, 12:04:19 PM
    Author     : islam
--%>

<%@page import="org.isource.beans.*"%>
<%@ page import="java.io.*,java.util.*, javax.servlet.*" %>
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
    #cols{
        left: -5px;
        position: relative;
    }
</style>
<h3>Edit KPI</h3>
<%
    int kpi_id = Integer.parseInt(request.getParameter("k"));
%>

<% if (request.getParameter("edit_kpi") != null) {%>
<jsp:useBean id="kpiId" class="org.isource.beans.Kpi" scope="request" ></jsp:useBean>
<jsp:setProperty name="kpiId" property="id" value="<%=kpi_id%>" ></jsp:setProperty>
<jsp:setProperty name="kpiId" property="*" />
<%
    if (db.updateKpi(kpiId) == 1) {
%>
<div class="alert alert-success">
    <strong>Success!</strong> KPI Updated successfully.
</div>    
<%      } else {
%>
<div class="alert alert-danger">
    <strong>Oops!</strong> something wrong happened, please try again!.
</div>
<%      }
    }
    KPI_Formula_Table kpi = db.getKpi(kpi_id);
    List<Formula> formulaes = db.getFormulaes();
    List<Files> files = db.getFiles();
%>


<div>

    <form method="post" action="" >
        <input type="text" name="title" value="<%=kpi.getKpiTitle()%>" class="form-control" />
        <select name="formula_id" class="form-control">
            <option value="0">Select Formula</option>
            <% for (int i = 0; i < formulaes.size(); i++) {%>
            <option <%if (kpi.getFormula_id() == formulaes.get(i).getId()) {%>selected='true'<%}%> value="<%=formulaes.get(i).getId()%>"><%= formulaes.get(i).getTitle()%></option>
            <% } %>
        </select>

        <select name="table_id" class="form-control">
            <option value="0">Select File</option>
            <% for (int i = 0; i < files.size(); i++) {%>
            <option <%if (kpi.getTable_id() == files.get(i).getId()) {%>selected="true"<%}%> tablename="<%=files.get(i).getTablename()%>" value="<%=files.get(i).getId()%>"> <%= files.get(i).getTablename()%> </option>
            <% }%>
        </select> 
        <div id="cols">
            <%
              List<String> cols = db.getTableCols(kpi.getTableName());
            %>
            <select name="x_axis" class="form-control x_axis_field">
                <option value="0">Select X Axis Field</option>
                <% for(String c : cols){ %>
                <option 
                    <% if(kpi.getX_axis().equals(c)){%> selected="true" <%}%> 
                    value="<%=c%>" >
                    <%= Mapping.getFullLabel(c) %>
                </option>
                <%} %>
            </select>
        </div>
        <input type="submit" value="Update KPI" name="edit_kpi" class="btn btn-primary" />
    </form>
</div>

<script type="text/javascript">

    $("select[name=table_id]").change(function (e) {

        if ($(this).val() == 0) {
            $("select[name=x_axis]").empty().hide();
            return false;
        }
        var tablename = $('option:selected', this).attr('tablename');
        $.ajax({
            method: "POST",
            url: "ajax.jsp",
            data: {tablename: tablename}
        }).done(function (columns) {
            
            var select = $("select[name=x_axis]");
            select.empty();
            select.append($("<option/>", {
                value: 0,
                text: "Select X Axis Field"
            }));
            columns = JSON.parse(columns);
            $.each(columns, function (k, v) {
                console.log(i + " : " + v);
                select.append($("<option/>", {
                    value: k,
                    text: v
                }));
            });

           select.show(); 

        });
    });

    $('select').select2({
        tags: true,
        width: 'element'
    });
    
    $("#cols select").select2('destroy'); 
</script>

<%@ include file="footer.jsp" %>

