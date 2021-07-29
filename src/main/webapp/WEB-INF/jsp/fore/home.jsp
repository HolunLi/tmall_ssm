<%--home.jsp是前台首页，前台首页由置顶导航、搜索栏、首页业务页面、页脚组成--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false"%>

<title>天猫tmall.com--理想生活上天猫</title>

<%--在header.jsp并不是一个具体的前端页面，在header.jsp中引入标准标签库，js,css，自定义javascript函数等--%>
<%@include file="../include/fore/header.jsp"%>
<%--置顶导航--%>
<%@include file="../include/fore/top.jsp"%>
<%--搜索栏--%>
<%@include file="../include/fore/search.jsp"%>
<%--首页业务页面--%>
<%@include file="../include/fore/home/homePage.jsp"%>
<%--页脚--%>
<%@include file="../include/fore/footer.jsp"%>
	