<%-- 
    Document   : kpi
    Created on : Nov 14, 2016, 12:04:19 PM
    Author     : islam
--%>

<%@page import="org.isource.beans.*"%>
<%@page import="java.io.*,java.util.*, javax.servlet.*" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ include file="header.jsp"  %>


<h3>Apply Formula</h3>

<%    int file_id = Integer.parseInt(request.getParameter("table"));

    if (request.getParameter("apply") != null) {

        String title = request.getParameter("title");
        int formula_id = Integer.parseInt(request.getParameter("formula_id"));

        boolean applied = db.apply_formula(formula_id, file_id, title);

        if (applied) {
%>

<div class="alert alert-success">
    <strong>Success!</strong> Formula applied successfully.
</div>    

<%} else {%>

<div class="alert alert-danger">
    <strong>Oops!</strong> something wrong happened, please try again!.
</div>

<%    }
    }

    Files file = db.getFile(file_id);
    List<Formula> formulaes = db.get_unapplied_Formulaes(file_id);

%>



<div>

    <form method="post" action="" >
        <div>
            <input id="newtable" type='checkbox' name="new_table" value="1" /> New Table
        </div>

        <div>
            <input style="display: none" type="text" name="title" value="<%=file.getTitle()%>" placeholder="Title" class="form-control" />
        </div>

        <div>
            <select name="formula_id" class="form-control">
                <option value="0">Select Formula</option>
                <% for (int i = 0; i < formulaes.size(); i++) {%>
                <option value="<%= formulaes.get(i).getId()%>"><%= formulaes.get(i).getTitle()%></option>
                <% }%>
            </select>
        </div>

        <div>
            <input type="submit" value="Apply" name="apply" class="btn btn-primary" />
        </div>
    </form>
</div>

<script type="text/javascript">

    $("#newtable").click(function () {

        var title_input = $('input[name=title]')

        var title = title_input.val();

        if ($(this).is(':checked')) {
            title_input.val('');
        } else {
            title_input.val("<%=file.getTitle()%>");
        }

        title_input.toggle();

    });

    
</script>

                    
<%@ include file="footer.jsp" %>
