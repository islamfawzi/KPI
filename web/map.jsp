<%-- 
    Document   : map
    Created on : Nov 22, 2016, 3:27:33 PM
    Author     : islam
--%>

<%@page import="org.isource.beans.*"%>
<%@ page import="java.io.*,java.util.*, javax.servlet.*" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ include file="header.jsp"  %>
<style>
    .label-input{
        width: 50%;
        float: left;
        margin-right: 12px;
    }
    .column-input{
        width: 8%;
    }
    .btn{
        margin-top: 15px;
    }
    
</style>
<h3>Add KPI</h3>

<div>

    <form method="post" action="" >
        <input type="text" name="label" class="label-input form-control" />
        <select name="column" class="column-input form-control">
            <option value="a">A</option>
            <option value="b">B</option>
            <option value="c">C</option>
            <option value="d">D</option>
            <option value="e">E</option>
            <option value="f">F</option>
            <option value="g">G</option>
            <option value="h">H</option>
            <option value="i">I</option>
            <option value="j">J</option>
            <option value="k">K</option>
            <option value="l">L</option>
            <option value="m">M</option>
            <option value="n">N</option>
            <option value="o">O</option>
            <option value="p">P</option>
            <option value="q">Q</option>
            <option value="r">R</option>
            <option value="s">S</option>
            <option value="t">T</option>
            <option value="u">U</option>
            <option value="v">V</option>
            <option value="w">W</option>
            <option value="x">X</option>
            <option value="y">Y</option>
            <option value="z">Z</option>
        </select>
        <div class="clear"></div>
        <input type="submit" value="Submit" name="add_map" class="btn btn-primary" />
    </form>
</div>


