<%-- 
    Document   : formula
    Created on : Nov 13, 2016, 11:03:34 PM
    Author     : islam
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="header.jsp" %>
<%@ page import="org.isource.beans.Mapping"%>


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
        height: 60px !important;
        margin-top: -12px !important;
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
    .red-alert{
        border: 1px solid #930202 !important;
    }
    .error{
        color: #930202;
    }
</style>
<h3>Add Formula</h3>
<jsp:useBean id="formulaId" class="org.isource.beans.Formula" scope="request"></jsp:useBean>
<jsp:setProperty name="formulaId" property="*" />
<%    String formula = request.getParameter("formula");
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

<script src="https://ajax.googleapis.com/ajax/libs/angularjs/1.4.8/angular.min.js"></script>
<script src="js/formula.js"></script>

<div>

    <form id="formula-form" method="post" action="" ng-app="app">

        <input type="text" name="title" class="form-control" placeholder="Title" />
        <p id="title_error" class="error"></p>

        <textarea name="formula" cols="70" rows="10" class="form-control" placeholder="{Formula}" ></textarea>
        <p id="formula_error" class="error"></p>

        <div>
            <select id="columns" class="form-control" >
                <option value="">Select Field</option>
                <% for (int index = 0; index < Mapping.getMap().size(); index++) {%>
                <option value="<%=Mapping.getMap().get(index)%>"><%= Mapping.getMap().get(index)%></option>
                <% }%>
            </select>
        </div>

        <div class="col-lg-12" ng-controller="Ctrl" >
            <div class="col-lg-6" style="margin-left: -32px !important;">
                
                <select class="form-control" ng-model="category">
                    <option value="">Select Category</option>
                    <option ng-repeat="cat in categorys" value="{{cat}}" >{{cat}}</option>
                </select>
                
            </div>
            <div class="col-lg-6" >
                <select id="formula" class="form-control" ng-model="function" >
                    <option value="">Select Function</option>
                    <option ng-repeat="function in json[category]" value="{{function}}">{{function}}</option>
                </select>
            </div>
            <div class="col-lg-6" style="margin-left: -32px !important;">
                <select id="operator">
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
        </div>
        <div class="clear"></div>
        <input type="submit" class="btn btn-primary" value="Save" />
    </form>
</div>

<script>

    $("#columns").change(function () {
        var field = "{" + $(this).val() + "}";
        $('textarea[name=formula]').val(function (i, text) {
            return text + field;
        });
    });

    $("#formula").change(function () {
        var field = $(this).val();
        $('textarea[name=formula]').val(function (i, text) {
            return text + field;
        });
    });

    $("#operator").change(function () {
        var field = $(this).val();
        $('textarea[name=formula]').val(function (i, text) {
            return text + field;
        });
    });

    $('select').select2({
        tags: true,
        width: 'element'
    });


    $("#formula-form").submit(function (e) {
        $(".form-control").removeClass("red-alert");
        $(".error").empty();

        var title = $("input[name=title]");
        var formula = $('textarea[name=formula]');

        // validate formula
        var valid = validate_formula(formula.val());

        if (title.val() == "") {
            title.addClass("red-alert");
            $("#title_error").text("Title Required");
            valid = false;
        }
        if (formula.val() == "") {
            formula.addClass("red-alert");
            $("#formula_error").text("Formula Required");
            valid = false;
        }


        if (!valid) {
            e.preventDefault();
        } else {
            console.log("valid");
        }

    });

    function validate_formula(formula) {
        $('textarea[name=formula]').removeClass("red-alert");
        var v = true;
        if (formula != "") {
            $.ajax({
                method: "POST",
                url: "ajax.jsp",
                data: {formula: formula},
                async: false
            }).done(function (v_msg) {

                if (v_msg.indexOf("valid") <= -1) {
                    $('textarea[name=formula]').addClass("red-alert");
                    $("#formula_error").text(v_msg);
                    v = false;
                }
            });
        } else {
            v = false;
        }
        return v;
    }

    $(".unselect2").select2('destroy');
</script>

<%@include file="footer.jsp" %>
