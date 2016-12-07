<%-- 
    Document   : formula
    Created on : Nov 13, 2016, 11:03:34 PM
    Author     : islam
--%>

<%@page import="org.isource.beans.Mapping"%>
<%@page import="org.isource.beans.Formula"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="header.jsp" %>


<script src="https://ajax.googleapis.com/ajax/libs/angularjs/1.4.8/angular.min.js"></script>
<script src="js/formula.js"></script>

<h3>Edit Formula</h3>

<%   
    int formula_id = Integer.parseInt(request.getParameter("fid"));
%>

<jsp:useBean id="formulaId" class="org.isource.beans.Formula" scope="request"></jsp:useBean>
<jsp:setProperty name="formulaId" property="id" value="<%=formula_id%>" ></jsp:setProperty>   
<jsp:setProperty name="formulaId" property="*" />

<%

    if (request.getParameter("update_formula") != null) {
        if (db.updateFormula(formulaId) == 1) { 
%>

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

<div ng-app="app">

    <form method="post" action="" id="formula-form" ng-controller="formulaCtrl" ng-submit="validate($event)">
        <div>
            <input value="<%=formula.getTitle()%>" type="text" name="title" class="form-control" placeholder="Title" />
            <p id="title_error" class="error"></p>
        </div>

        <div>
            <input type="hidden" id="old-formula" value="<%=formula.getFormula()%>" />
            <textarea ng-model="formula" name="formula" cols="70" rows="10" class="form-control" placeholder="{Formula}" ><%=formula.getFormula()%></textarea>
            <p id="formula_error" class="error"></p>
        </div>

        <div>
            <select id="columns" class="form-control" ng-model="field" ng-change="addField()" >
                <option value="">Select Field</option>
                <% for (int index = 0; index < Mapping.getMap().size(); index++) {%>
                <option value="<%=Mapping.getMap().get(index)%>"><%= Mapping.getMap().get(index)%></option>
                <% }%>
            </select>
        </div>


        <div class="row">

            <div class="col-md-5 no-padding" >

                <select class="form-control" ng-model="category">
                    <option value="">Select Category</option>
                    <option ng-repeat="cat in categorys" value="{{cat}}" >{{cat}}</option>
                </select>

            </div>

            <div class="col-md-7">
                <select id="formula" class="form-control" ng-model="function" ng-change="addFunction()" >
                    <option value="">Select Function</option>
                    <option ng-repeat="function in json[category]" value="{{function}}">{{function}}</option>
                </select>
            </div>

        </div>

        <div class="row">

            <select class="col-md-5" id="operator" ng-model="operator" ng-change="addOperator()">
                <option value="0"  > Select Operator</option>
                <option value="+"  > + </option>
                <option value="-"  > - </option>
                <option value="*"  > * </option>
                <option value="/"  > / </option>
                <option value="%"  > % </option>
                <option value="^"  > ^ </option>
                <option value="="  > = </option>
                <option value=">"  > > </option>
                <option value="<"  > < </option>
                <option value=">=" > >= </option>
                <option value="<=" > <= </option>
                <option value="<>" > <> Not equal </option>
                <option value="&"  > &  </option>
                <option value=":"  > : (colon)</option>
                <option value=","  > , (comma)</option>
                <option value=" "  > (space)</option>
                <option value="("  > ( </option>
                <option value=")"  > ) </option>
                <option value="#"  > # </option>
            </select>
        </div>

        <div class="clear"></div>

        <input type="submit" name="update_formula" class="btn btn-primary" value="Save" />
    </form>
</div>

<%@include file="footer.jsp" %>
