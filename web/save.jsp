<%@page import="org.isource.util.ConnectionProvider"%>
<%@ page import="java.io.*,java.util.*, javax.servlet.*" %>
<jsp:useBean id="db" class="org.isource.util.ConnectionProvider" scope="application" ></jsp:useBean>

<%
  String tableName = (String) session.getAttribute("tableName");
  String filepath = (String) session.getAttribute("filepath");
  List<List> csvData = (List<List>) session.getAttribute("csvData");
  
   List<String> cols = new ArrayList<String>();
   for(int i=0; i<csvData.get(0).size(); i++){
       cols.add(request.getParameter("col_"+i));
   }
   
   //tableName = tableName.trim().toLowerCase().replace(' ', '_');
   db.createTable(tableName, cols);
   db.insertData(tableName, csvData);
   db.addFile(filepath, tableName, 0);
   
%>
<jsp:forward page="kpis.jsp"></jsp:forward>


