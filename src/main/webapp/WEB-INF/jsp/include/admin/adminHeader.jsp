<!DOCTYPE html>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!--jstl中的format标签库，提供了数字，日期格式化等功能-->
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix='fmt' %>

<%--adminHeader.jsp不是一个具体的前端页面，在adminHeader中包含了一些自定义函数和事件监听，并且引入了一些外部的js文件和css样式。--%>
<html>

<head>
	<script src="js/jquery/2.0.0/jquery.min.js"></script>
	<link href="css/bootstrap/3.3.6/bootstrap.min.css" rel="stylesheet">
	<script src="js/bootstrap/3.3.6/bootstrap.min.js"></script>
	<link href="css/back/style.css" rel="stylesheet">
	
	<script>
	//判断id为"id"的元素是否为空，若为空，返回false,不为空，返回true
	function checkEmpty(id, name){
		var value = $("#"+id).val();
		if(value.length==0){
			alert(name+ "不能为空");
			$("#"+id)[0].focus();
			return false;
		}
		return true;
	}
	function checkNumber(id, name){
		var value = $("#"+id).val();
		if(value.length==0){
			alert(name+ "不能为空");
			$("#"+id)[0].focus();
			return false;
		}
		if(isNaN(value)){  //javascript中的 isNaN() 函数用于检查其参数是否是非数字值,如果是非数字返回true，如果是数字返回false。
			alert(name+ "必须是数字");
			$("#"+id)[0].focus(); //在listProduct页面只有一个id为"id"的元素，因此也可改为:$("#"+id).focus();
			return false;
		}

		return true;
	}
	function checkInt(id, name){
		var value = $("#"+id).val();
		if(value.length==0){
			alert(name+ "不能为空");
			$("#"+id)[0].focus();
			return false;
		}
		if(parseInt(value)!=value){
			alert(name+ "必须是整数");
			$("#"+id)[0].focus();
			return false;
		}

		return true;
	}

	$(function(){
		$("a").click(function(){
			var deleteLink = $(this).attr("deleteLink");
			console.log(deleteLink);

			//只有执行删除操作时（删除分类，属性，产品）,才会弹出确认框,选择是否要删除
			if("true"==deleteLink){
				var confirmDelete = confirm("确认要删除");
				if(confirmDelete)
					return true;
				return false;
			}
		});
	})
	</script>
</head>
<body>

