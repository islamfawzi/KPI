<%-- 
    Document   : formula
    Created on : Nov 13, 2016, 11:03:34 PM
    Author     : islam
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="header.jsp" %>

<style type="text/css">
    div{
        width: 600px; 
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
</style>
<h3>Add Formula</h3>
<jsp:useBean id="formulaId" class="org.isource.beans.Formula" scope="request"></jsp:useBean>
<jsp:setProperty name="formulaId" property="*" />
<%
    String formula = request.getParameter("formula");
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


<div>
    
    <form method="post" action="" >
        <input type="text" name="title" class="form-control" placeholder="Title" />
        <textarea name="formula" cols="70" rows="10" class="form-control" placeholder="{Formula}" ></textarea>
        <input type="submit" class="btn btn-primary" value="Save" />
    </form>
</div>


<%@include file="footer.jsp" %>
