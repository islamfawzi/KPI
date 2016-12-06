<!DOCTYPE html>
<html lang="en">

    <head>

        <meta charset="utf-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="width=device-width, shrink-to-fit=no, initial-scale=1">
        <meta name="description" content="">
        <meta name="author" content="">

        <title>KPIs</title>

        <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.1.1/jquery.min.js"></script>
        <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
        
        <!-- Custom CSS -->
        <link href="simple-sidebar.css" rel="stylesheet">

        <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">

        <script type="text/javascript" src="http://pubnub.github.io/eon/v/eon/0.0.10/eon.js"></script>
        <link type="text/css" rel="stylesheet" href="http://pubnub.github.io/eon/v/eon/0.0.10/eon.css"/>

        <!-- HTML5 Shim and Respond.js IE8 support of HTML5 elements and media queries -->
        <!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
        <!--[if lt IE 9]>
            <script src="https://oss.maxcdn.com/libs/html5shiv/3.7.0/html5shiv.js"></script>
            <script src="https://oss.maxcdn.com/libs/respond.js/1.4.2/respond.min.js"></script>
        <![endif]-->

        <link href="https://cdnjs.cloudflare.com/ajax/libs/select2/4.0.3/css/select2.min.css" rel="stylesheet" />
        <script src="https://cdnjs.cloudflare.com/ajax/libs/select2/4.0.3/js/select2.min.js"></script>

        
    </head>

    <jsp:useBean id="db" class="org.isource.util.ConnectionProvider" scope="application" ></jsp:useBean>
    <jsp:useBean id="provider" class="org.isource.providers.Provider" scope="application" ></jsp:useBean>
    <%
        if(provider.getUpload_path() == null){
            provider.setUpload_path(getServletContext().getRealPath(provider.getUpload_folder()) + "/");
        }
      
    %>
        <body>
            <style>
                
                .glyphicon{
                    display: inline;
                }
            </style>
            <div id="wrapper">

                <!-- Sidebar -->
                <div id="sidebar-wrapper">
                    <ul class="sidebar-nav">
                        <li class="sidebar-brand">
                            <a href="${pageContext.request.contextPath}">
                                <span class="glyphicon glyphicon-signal" aria-hidden="true"></span>
                                KPIs</a>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/import.jsp">
                            <span class="glyphicon glyphicon-cloud-upload" aria-hidden="true"></span>
                            Import Sheet</a>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/formulas.jsp">
                            <span class="glyphicon glyphicon-baby-formula" aria-hidden="true"></span>
                            Formulas</a>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/tables.jsp">
                            <span class="glyphicon glyphicon-th-list" aria-hidden="true"></span>
                            Sheets</a>
                    </li>
                    
                </ul>
            </div>
            <!-- /#sidebar-wrapper -->
            <a href="#menu-toggle" class="btn btn-default btn-sm" id="menu-toggle">
                <span class="glyphicon glyphicon-circle-arrow-left"></span>
            </a>

            <!-- Page Content -->
            <div id="page-content-wrapper">

                <div class="container-fluid">
                    <div class="row">

                        <div class="col-lg-12">