<%@ page import="org.isource.beans.Mapping"%>
<%@ page import="java.io.*,java.util.*, javax.servlet.*" %>
<%@ page import="javax.servlet.http.*" %>
<%@ page import="org.apache.commons.fileupload.*" %>
<%@ page import="org.apache.commons.fileupload.disk.*" %>
<%@ page import="org.apache.commons.fileupload.servlet.*" %>
<%@ page import="org.apache.commons.io.output.*" %>
<%@ page import="org.isource.util.CSVUtils" %>

<%@include  file="header.jsp" %>

<%
    File file;
    int maxFileSize = 5000 * 1024;
    int maxMemSize = 5000 * 1024;
    ServletContext context = pageContext.getServletContext();
//  String filePath = context.getInitParameter("file-upload");
    
    String filePath = provider.getUpload_path();
    
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
                    session.setAttribute("filepath", fileName);
                    session.setAttribute("tableName", fileName.substring(0, fileName.indexOf('.')));
                    session.setAttribute("csvData", csvData);

                }
            }
%>



<style>
    .select2-selection__arrow{
        display: none;
    }
    .select-label, .select2{
        width: 100% !important;
    }
    
</style>
<h3>Map the Columns to Module Fields</h3>
<center>
    <form method="post" action="save.jsp" >
        <table cellpadding="5" class="table table-hover" >
            <thead>
                <tr>
                    <th>Header</th>
                    <th>Row 1</th>
                    <th>Module Fields</th>
                </tr>
            </thead>
            <tbody>
                <%  List<String> columns = csvData.get(0);
                    for (int c = 0; c < columns.size(); c++) {
                %>
                <tr>
                    <td><%= columns.get(c)%></td>    
                    <td><%= csvData.get(1).get(c)%></td>    
                    <td>
                        <select name="col_<%=c%>" class="form-control" >
                            <% for (int index = 0; index < Mapping.getMap().size(); index++) { %>
                            <option <%if (db.strip_special_chars(columns.get(c)).equals(db.strip_special_chars(Mapping.getMap().get(index)))) {%> selected="selected" <%}%> value="<%=Mapping.getMap().get(index)%>"><%= Mapping.getMap().get(index)%></option>
                            <% } %>

                        </select>
                    </td>    
                </tr>
                <% } %>
            </tbody>
        </table>
        <br>
        <input type="submit" class="btn btn-primary" name="save" value="Save" style="width:168px" />
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