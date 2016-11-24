<%@ page import="java.io.*,java.util.*, javax.servlet.*" %>
<%@ page import="javax.servlet.http.*" %>
<%@ page import="org.apache.commons.fileupload.*" %>
<%@ page import="org.apache.commons.fileupload.disk.*" %>
<%@ page import="org.apache.commons.fileupload.servlet.*" %>
<%@ page import="org.apache.commons.io.output.*" %>
<%@ page import="org.isource.util.CSVUtils" %>
<%
    File file;
    int maxFileSize = 5000 * 1024;
    int maxMemSize = 5000 * 1024;
    ServletContext context = pageContext.getServletContext();
    String filePath = context.getInitParameter("file-upload");
    System.out.println(filePath);

    // Verify the content type
    String contentType = request.getContentType();
    if ((contentType.indexOf("multipart/form-data") >= 0)) {

        DiskFileItemFactory factory = new DiskFileItemFactory();
        // maximum size that will be stored in memory
        factory.setSizeThreshold(maxMemSize);
        // Location to save data that is larger than maxMemSize.
        factory.setRepository(new File("/home/Desktop/"));

        // Create a new file upload handler
        ServletFileUpload upload = new ServletFileUpload(factory);
        // maximum file size to be uploaded.
        upload.setSizeMax(maxFileSize);
        try {
            // Parse the request to get file items.
            List fileItems = upload.parseRequest(request);

            // Process the uploaded file items
            Iterator i = fileItems.iterator();

            // csv file data 
            List<List> csvData = new ArrayList<List>();

            while (i.hasNext()) {
                FileItem fi = (FileItem) i.next();
                if (!fi.isFormField()) {
                    // Get the uploaded file parameters
                    String fieldName = fi.getFieldName();
                    String fileName = fi.getName();
                    boolean isInMemory = fi.isInMemory();
                    long sizeInBytes = fi.getSize();
                    // Write the file
                    if (fileName.lastIndexOf("\\") >= 0) {
                        file = new File(filePath
                                + fileName.substring(fileName.lastIndexOf("\\")));
                    } else {
                        file = new File(filePath
                                + fileName.substring(fileName.lastIndexOf("\\") + 1));
                    }
                    fi.write(file);

                    //CSVUtils.updateSheet(filePath + fileName);
                    csvData = CSVUtils.readCsv(filePath + fileName);
                    session.setAttribute("filepath", filePath + fileName);
                    session.setAttribute("tableName", fileName.substring(0, fileName.indexOf('.')));
                    session.setAttribute("csvData", csvData);
                }
            }
%>

<style type="text/css">
    table{
        width: 100% !important;
        height: 100% !important;
        overflow: auto;
        display: block;
    }
    table, table * {
        text-align: center;
    }
    table tr:first-child td {
        text-align: left;
    }
    table input {
        font-weight: bold;
        font-size: 20px !important;
    }
    table td{
        padding: 10px;
    }
    .select2-selection__arrow{
        display: none;
    }
    .select-label, .select2{
        width: 100% !important;
    }
</style>
<%@include  file="header.jsp" %>
<link href="https://cdnjs.cloudflare.com/ajax/libs/select2/4.0.3/css/select2.min.css" rel="stylesheet" />
<script src="https://cdnjs.cloudflare.com/ajax/libs/select2/4.0.3/js/select2.min.js"></script>
<center>
    <form method="post" action="save.jsp" >
        <table border="1" cellpadding="5" >
            <% for (int c = 0; c < csvData.size(); c++) {
                    List line = csvData.get(c);
            %>
            <tr>
                <% for (int s = 0; s < line.size(); s++) { %>
                <td>
                    <% if (c == 0) {%>
                    <label class="select-label" for="id_select">
                        <%= line.get(s)%>
                        <input type="hidden" name="col_<%=s%>" value="<%=line.get(s)%>" />
                    </label>
                    <%-- <input class="form-control" type="text" value="<%= line.get(s)%>" name="col_<%= s%>" /> --%>
                    <% } else {%>
                    <%= line.get(s)%> </td>
                    <% }
                        } %>
            </tr>
            <% } %>
        </table>
        <br>
        <input type="submit" class="btn btn-primary" name="save" value="Save" />
    </form>
</center>
<script type="text/javascript">
    $('select').select2({
        tags: true,
        width: 'element'
    });
</script>
<%@include file="footer.jsp" %>
<%

        } catch (Exception ex) {
            System.out.println(ex);
        }
    } else {
        out.println("<html>");
        out.println("<head>");
        out.println("<title>Servlet upload</title>");
        out.println("</head>");
        out.println("<body>");
        out.println("<p>No file uploaded</p>");
        out.println("</body>");
        out.println("</html>");
    }
%>