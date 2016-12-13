<%-- 
    Document   : kpi
    Created on : Nov 14, 2016, 12:04:19 PM
    Author     : islam
--%>

<%@page import="org.isource.beans.*"%>
<%@ page import="java.io.*,java.util.*, javax.servlet.*" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ include file="header.jsp"  %>

<script src="https://ajax.googleapis.com/ajax/libs/angularjs/1.4.8/angular.min.js"></script>
<script src="js/kpi.js"></script>

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

<% }else{ %>

<div class="alert alert-danger">
    <strong>Oops!</strong> something wrong happened, please try again!.
</div>

<%      }
    }
%>


<div ng-app="app">

    <form method="post" action="" ng-controller="kpiCtrl" >
        <div>
            <input type="text" name="title" class="form-control" />
        </div>
        
        <div>
            <select name="formula_id" class="form-control" >
                <option value="0">Select Formula</option>
                <% for (int i = 0; i < formulaes.size(); i++) {%>
                <option value="<%= formulaes.get(i).getId()%>"><%= formulaes.get(i).getTitle()%></option>
                <% } %>
            </select>
        </div>

        <div>
            <select name="table_id" class="form-control" ng-model="table_id" ng-change="onChangeSheet()">
                <option value="0">Select File</option>
                <% for (int i = 0; i < files.size(); i++) {%>
                <option tablename="<%=files.get(i).getTablename()%>" value="<%=files.get(i).getId()%>"> <%= files.get(i).getTitle()%> </option>
                <% }%>
            </select> 
        </div>

        <div ng-hide="x_axis | isEmpty">
            <select name="x_axis" class="form-control"  >
                <option value="0">Select X axis</option>
                <option ng-repeat="(key, value) in x_axis" value="{{key}}">{{value}}</option>
            </select>
        </div>

        <input type="submit" value="Create KPI" name="add_kpi" class="btn btn-primary" />
    </form>
</div>
<%@ include file="footer.jsp" %>
