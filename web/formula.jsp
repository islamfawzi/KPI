<%-- 
    Document   : formula
    Created on : Nov 13, 2016, 11:03:34 PM
    Author     : islam
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="header.jsp" %>
<%@ page import="org.isource.beans.Mapping"%>


<script src="https://ajax.googleapis.com/ajax/libs/angularjs/1.4.8/angular.min.js"></script>
<script src="js/formula.js"></script>

<h3>Add Formula</h3>

<jsp:useBean id="formulaId" class="org.isource.beans.Formula" scope="request"></jsp:useBean>
<jsp:setProperty name="formulaId" property="*" />

<%  String formula = request.getParameter("formula");
    if (formula != null) {
        if (db.addFormula(formulaId) == 1) { %>

<div class="alert alert-success">
    <strong>Success!</strong> Formula Added successfully.
</div> 

<%      } else { %>

<div class="alert alert-danger">
    <strong>Oops!</strong> something wrong happened, please try again!.
</div>

<%      }
    }
%>



<div class="container" ng-app="app">

    <form id="formula-form" method="post" action="" ng-controller="formulaCtrl" ng-submit="validate($event)">

        <div>
            <input type="text" name="title" class="form-control" placeholder="Title" />
            <p id="title_error" class="error"></p>
        </div>

        <div>
            <textarea ng-model="formula" name="formula" cols="70" rows="10" class="form-control" placeholder="{Formula}" ></textarea>
            <p id="formula_error" class="error"></p>
        </div>

        <div>
            <select id="columns" class="form-control" ng-model="field" ng-change="addField()">
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
            
            <div class="col-md-7" >
                
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
        <input type="submit" class="btn btn-primary" value="Save" />
    </form>
</div>


<%@include file="footer.jsp" %>
