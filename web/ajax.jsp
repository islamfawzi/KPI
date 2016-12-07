<%-- 
    Document   : ajax
    Created on : Nov 14, 2016, 3:58:28 PM
    Author     : islam
--%>
<%@page import="org.isource.beans.Formula"%>
<%@page import="org.isource.util.CSVUtils"%>
<%@page import="org.isource.beans.Mapping"%>
<%@page import="org.json.simple.JSONObject"%>
<%@page import="org.json.simple.parser.JSONParser"%>
<%@page import="org.isource.beans.KPI_Formula_Table"%>
<%@ page import="java.io.*,java.util.*, javax.servlet.*" %>
<jsp:useBean id="db" class="org.isource.util.ConnectionProvider" scope="application" ></jsp:useBean>

<%     
    // parse angular request payload
    JSONParser parser = new JSONParser();
    JSONObject jsonObject = (JSONObject) parser.parse(request.getReader());

    
    if (jsonObject.get("tablename") != null  || request.getParameter("tablename") != null) {
  
        String tablename = (jsonObject.get("tablename") != null) ? jsonObject.get("tablename").toString() : request.getParameter("tablename");
        
        List<String> cols = db.getTableCols(tablename);
        
        JSONObject obj = new JSONObject();
        for (String c : cols) {
            obj.put(c, Mapping.getFullLabel(c));
        }
        
        
        /*for(int i = 0; i < cols.size();i++){
            output += "   <input class='cols-btn' type='radio' name='x_axis' value='" + cols.get(i) + "' />" + Mapping.getFullLabel(cols.get(i));
        }*/
        out.print(obj.toJSONString());
    }
    
    else if(request.getParameter("tableid") != null){
        int table_id = Integer.parseInt(request.getParameter("tableid"));
        KPI_Formula_Table kpi = db.getKpi(table_id);
        String kpi_json = db.calc2(kpi.getX_axis(), kpi.getFormula_id(), kpi.getTableName());
        out.print(kpi_json);
    }
    
    else if(request.getParameter("formula") != null){
        
        String valid = CSVUtils.validate_formula(request.getParameter("formula"));
        out.print(valid);
        
    }
%>
