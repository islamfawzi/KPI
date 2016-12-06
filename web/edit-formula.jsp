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

    <form method="post" action="" id="formula-form" >
        
        <input value="<%=formula.getTitle()%>" type="text" name="title" class="form-control" placeholder="Title" />
        <p id="title_error" class="error"></p>
        
        <textarea name="formula" cols="70" rows="10" class="form-control" placeholder="{Formula}" ><%=formula.getFormula()%></textarea>
        <p id="formula_error" class="error"></p>
        
        <div>
        <select id="columns" class="form-control" >
            <option value="">Select Field</option>
            <% for (int index = 0; index < Mapping.getMap().size(); index++) {%>
            <option value="<%=Mapping.getMap().get(index)%>"><%= Mapping.getMap().get(index)%></option>
            <% }%>
        </select>
        </div>
        
        <div class="col-lg-12">
            <div class="col-lg-6" style="margin-left: -32px !important;">
                <select id="formula" class="form-control" >
                    <option value="0" >Select Formula</option>
                    <option>ABS</option>
                    <option>ACOS</option>
                    <option>ACOSH</option>
                    <option>AGGREGATE</option>
                    <option>ASIN</option>
                    <option>ASINH</option>
                    <option>ATAN</option>
                    <option>ATAN2</option>
                    <option>ATANH</option>
                    <option>Atn</option>
                    <option>Atn</option>
                    <option>CEILING</option>
                    <option>CEILING.PRECISE</option>
                    <option>COMBIN</option>
                    <option>COS</option>
                    <option>COS</option>
                    <option>COSH</option>
                    <option>DEGREES</option>
                    <option>EVEN</option>
                    <option>EXP</option>
                    <option>FACT</option>
                    <option>Fix</option>
                    <option>FLOOR</option>
                    <option>Format</option>
                    <option>INT</option>
                    <option>LN</option>
                    <option>LOG</option>
                    <option>LOG10</option>
                    <option>MDETERM</option>
                    <option>MINVERSE</option>
                    <option>MMULT</option>
                    <option>MOD</option>
                    <option>ODD</option>
                    <option>PI</option>
                    <option>POWER</option>
                    <option>PRODUCT</option>
                    <option>RADIANS</option>
                    <option>RAND</option>
                    <option>RANDBETWEEN</option>
                    <option>RANDOMIZE</option>
                    <option>RND</option>
                    <option>ROMAN</option>
                    <option>ROUND</option>
                    <option>ROUND</option>
                    <option>ROUNDDOWN</option>
                    <option>ROUNDUP</option>
                    <option>SGN</option>
                    <option>SIGN</option>
                    <option>SIN</option>
                    <option>SINH</option>
                    <option>SQR</option>
                    <option>SQRT</option>
                    <option>SUBTOTAL</option>
                    <option>SUM</option>
                    <option>SUMIF</option>
                    <option>SUMIFS</option>
                    <option>SUMPRODUCT</option>
                    <option>SUMSQ</option>
                    <option>SUMX2MY2</option>
                    <option>SUMX2PY2</option>
                    <option>SUMXMY2</option>
                    <option>TAN</option>
                    <option>TANH</option>
                    <option>TRUNC</option>
                </select>
            </div>
            <div class="col-lg-6">
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
        
        <input type="submit" name="update_formula" class="btn btn-primary" value="Save" />
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
        var field = $(this).val() + "(";
        $('textarea[name=formula]').val(function (i, text) {
            return text + field;
        });
    });
    
    $("#operator").change(function(){
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
        }else{ v = false; }
        
        return v;
    }
</script>
<%@include file="footer.jsp" %>
