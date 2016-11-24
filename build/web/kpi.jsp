<%-- 
    Document   : kpi
    Created on : Nov 14, 2016, 2:21:16 PM
    Author     : islam
--%>

<%@page import="java.sql.ResultSet"%>
<%@page import="java.util.ArrayList"%>
<%@ page import="java.io.*,java.util.*, javax.servlet.*" %>
<%@page import="org.isource.beans.KPI_Formula_Table"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="header.jsp" %>

<style>
    .imgs-div{
        text-align: center; 
        margin-bottom: 40px;
    }
    .charts-imgs{
        width: 100px;
        padding: 10px;
    }
    .border{
        border: 3px solid #000;
    }
    
</style>

<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.1.1/jquery.min.js"></script>

<%
    int kId = request.getParameter("k") != null ? Integer.parseInt(request.getParameter("k")) : 1;
    String kpi_json = "";
    
    KPI_Formula_Table kpi = db.getKpi(kId);
    kpi_json = db.calc2(kpi.getX_axis(), kpi.getFormula(), kpi.getTableName());
    
%>

<div class="imgs-div">
    <img id="chart-img1" src="images/1.png" class="charts-imgs" />
    <img id="chart-img2" src="images/2.jpg" class="charts-imgs border" />
    <img id="chart-img3" src="images/3.gif" class="charts-imgs" />
</div>
<input type="hidden" id="kpi_inp" value='<%= kpi_json%>' />


<div style="display: none" class="chart" id="chart1"></div>
<div class="chart" id="chart2"></div>
<div style="display: none" class="chart" id="chart3"></div>
<!--<div id="chart4"></div>-->

<script type="text/javascript">

    var pubnub = PUBNUB.init({
        publish_key: 'demo',
        subscribe_key: 'demo'
    });

    /* ------------------------------------------------------------------------- */
    $(document).ready(function () {

        var channel = "c3-spline" + Math.random();
        eon.chart({
            channel: channel,
            history: true,
            flow: true,
            pubnub: pubnub,
            generate: {
                bindto: '#chart1',
                data: {
                    labels: false
                }
            }
        });

        setInterval(function () {
            var kpi = getKpi(1);

            pubnub.publish({
                channel: channel,
                message: {
                    eon: kpi
                }
            });

        }, 1000);
        /* ------------------------------------------------------------------------- */

        var channel2 = "c3-bar" + Math.random();
        eon.chart({
            channel: channel2,
            pubnub: pubnub,
            generate: {
                bindto: '#chart2',
                data: {
                    labels: true,
                    type: 'bar'
                },
                bar: {
                    width: {
                        ratio: 0.5
                    }
                },
                tooltip: {
                    show: false
                }
            }
        });

        setInterval(function () {
            var kpi = getKpi(1);

            pubnub.publish({
                channel: channel2,
                message: {
                    eon: kpi
                }
            });

        }, 1000);

        /* ------------------------------------------------------------------------- */

        var channel3 = "c3-donut" + Math.random();
        eon.chart({
            channel: channel3,
            generate: {
                bindto: '#chart3',
                data: {
                    labels: true,
                    type: 'donut'
                }
            }
        });

        setInterval(function () {
            var kpi = getKpi(1);
            pubnub.publish({
                channel: channel3,
                message: {
                    eon: kpi
                }
            });

        }, 1000);

        /* ------------------------------------------------------------------------- */


        var channel4 = "c3-gauge" + Math.random();
        eon.chart({
            channel: channel4,
            pubnub: pubnub,
            generate: {
                bindto: '#chart4',
                data: {
                    type: 'gauge',
                },
                gauge: {
                    min: 0,
                    max: 100
                },
                color: {
                    pattern: ['#FF0000', '#F6C600', '#60B044'],
                    threshold: {
                        values: [30, 60, 90]
                    }
                }
            }
        });

        setInterval(function () {

            pubnub.publish({
                channel: channel4,
                message: {
                    eon: {
                        'data': Math.random() * 99
                    }
                }
            })

        }, 1000);

    });


    function getKpi_ajax(table_id) {
        $.ajax({
            method: "POST",
            url: "ajax.jsp",
            data: {tableid: table_id}
        }).done(function (output) {
            $("#kpi_inp").val(output.trim());
        });
    }

    function getKpi() {
        getKpi_ajax(<%= kId%>);
        var kpi = $("#kpi_inp").val();
        return JSON.parse(kpi);
    }
    
    $("#chart-img1").click(function(){
        $(".chart").hide();
        $("#chart1").show();
        $(".charts-imgs").removeClass("border");
        $(this).addClass("border");
    });
    $("#chart-img2").click(function(){
        $(".chart").hide();
        $("#chart2").show();
        $(".charts-imgs").removeClass("border");
        $(this).addClass("border");
    });
    $("#chart-img3").click(function(){
        $(".chart").hide();
        $("#chart3").show();
        $(".charts-imgs").removeClass("border");
        $(this).addClass("border");
    });
</script>

<%@include file="footer.jsp" %>