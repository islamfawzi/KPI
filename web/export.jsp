<%@page import="java.io.FileOutputStream"%>
<%@page import="java.io.FileInputStream"%>
<%@page import="java.io.File"%>
<%@page import="java.io.File"%>
<%@page import="org.apache.poi.hssf.usermodel.HSSFWorkbook"%>
<%@page import="org.isource.beans.Files"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 3.2 Final//EN">
<jsp:useBean id="db" class="org.isource.util.ConnectionProvider" scope="application" ></jsp:useBean>
<%

    int file_id = Integer.parseInt(request.getParameter("file"));
    Files file = db.getFile(file_id);

%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title><%= file.getTitle()%></title>
    </head>
    <body>
        <%

            response.setContentType("APPLICATION/OCTET-STREAM");
//          response.setContentType("application/vnd.ms-excel");
            response.setHeader("Content-Disposition", "attachment; filename=\"" + file.getTitle()+".xls" + "\"");

            FileInputStream fis = new FileInputStream(new File(file.getFilepath()));

            //Get the workbook instance for XLS file 
            HSSFWorkbook workbook = new HSSFWorkbook(fis);
//            FileOutputStream fos = new FileOutputStream(new File("/media/islam/55247aa2-2234-4e48-8a62-c1fabcb5c84d/opt/apache-tomcat-7.0.70/webapps/data/qualitys22.xls"));
            
            //workbook.write(response.getOutputStream()); // Write workbook to response.
            workbook.write(response.getOutputStream()); // Write workbook to response.
            workbook.close();
            fis.close();
            
//            int i;   
//            while ((i=fis.read()) != -1) {  
//              out.write(i);   
//            }   
  

        %>
    </body>
</html>
