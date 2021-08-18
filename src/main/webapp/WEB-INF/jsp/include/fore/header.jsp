<!DOCTYPE html>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false"%>
<%--引入jstl核心标签库--%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%--引入jstl格式化标签库，format标签库，提供了数字，日期格式化等功能--%>
<%@ taglib prefix='fmt' uri="http://java.sun.com/jsp/jstl/fmt" %>
<%--引入jstl函数标签库--%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%--header.jsp不是一个具体的前端页面，在header.jsp中包含了一些自定义函数和事件监听，并且引入了一些外部的js文件和css样式。--%>

<html>

<head>
	<link rel="icon" href="${pageContext.request.contextPath}/img/icon/favicon.ico" type="image/x-icon" />
	<script src="js/jquery/2.0.0/jquery.min.js"></script>
	<link href="css/bootstrap/3.3.6/bootstrap.min.css" rel="stylesheet">
	<script src="js/bootstrap/3.3.6/bootstrap.min.js"></script>
	<link href="css/fore/style.css" rel="stylesheet">
	<script>

		//该函数，在购物车页面，更改某个订单项的价格时会用到
        function formatMoney(num){
            num = num.toString().replace(/\$|\,/g,'');
            if(isNaN(num))
                num = "0";
            sign = (num == (num = Math.abs(num)));
            num = Math.floor(num*100+0.50000000001);
            cents = num%100;
            num = Math.floor(num/100).toString();
            if(cents<10)
                cents = "0" + cents;
            for (var i = 0; i < Math.floor((num.length-(1+i))/3); i++)
                num = num.substring(0,num.length-(4*i+3))+','+
                    num.substring(num.length-(4*i+3));
            return (((sign)?'':'-') + num + '.' + cents);
        }

        function checkEmpty(id, name){
            var value = $("#"+id).val();
            if(value.length==0){

                $("#"+id)[0].focus();
                return false;
            }
            return true;
        }

        $(function(){

			//产品页面中的“累计评论”链接被点击时，触发该事件
            $("a.productDetailTopReviewLink").click(function(){
				//将产品页面中，显示对该产品的评论
                $("div.productReviewDiv").show();
                //隐藏产品详情信息（产品属性，产品详情图片）
                $("div.productDetailDiv").hide();
            });

			//产品页面中的“商品详情”链接被点击时，触发该事件
			$("a.productReviewTopPartSelectedLink").click(function(){
				//将产品页面中，隐藏对该产品的评论
                $("div.productReviewDiv").hide();
                //显示产品详情信息（产品属性，产品详情图片）
                $("div.productDetailDiv").show();
            });

            $("span.leaveMessageTextareaSpan").hide();
            //确认订单页面中，留言图片被点击时触发该事件
            $("img.leaveMessageImg").click(function(){
            	//将留言图片隐藏
                $(this).hide();
                //显示留言板（一个文本域）
                $("span.leaveMessageTextareaSpan").show();
                $("div.orderItemSumDiv").css("height","100px");
            });

            $("a[href$=#nowhere]").click(function(){
                alert("模仿天猫的连接，并没有跳转到实际的页面");
            });

            $("a.wangwanglink").click(function(){
                alert("模仿旺旺的图标，并不会打开旺旺");
            });

            $("a[href='#notImplementLink']").click(function(){
                alert("这个功能没做，蛤蛤~");
            });

        });

	</script>
</head>

<body>

