<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@include file="header.jsp" %>
<FORM  ENCTYPE="multipart/form-data" ACTION="upload.jsp" METHOD=POST>
    <br><br><br>
    <center>
        <table border="2" >
            <tr>
            <center>
                <td colspan="2">
                    <p align="center">
                        <B>Import Your File</B>
                    </p>  
                </td>
            </center>
            </tr>
            <tr>
                <td>
                    <b>Choose the file To Upload:</b>
                </td>
                <td>
                    <input type="file"  name="file" size="50" />
                </td>
            </tr>
            <tr>
                <td colspan="2">
                    <p align="right">
                        <input type="submit" style="margin: 10px" class="btn btn-primary" value="Upload File" />
                    </p>
                </td>
            </tr>
        </table>
    </center>      
</FORM>

<%@include file="footer.jsp" %>