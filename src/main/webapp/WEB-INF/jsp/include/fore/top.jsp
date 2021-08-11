<!-- 前台首页中的置顶导航 -->
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false"%>

<link rel="icon" href="${pageContext.request.contextPath}/img/icon/favicon.ico" type="image/x-icon" />

<nav class="top ">
	<a href="${contextPath}">
		<span style="color:#C40000;margin:0px" class=" glyphicon glyphicon-home redColor"></span>
		天猫首页
	</a>

	<span>喵，欢迎来天猫</span>

	<c:if test="${!empty user}">
		<a href="">${user.name}</a>
		<c:if test="${sessionScope.user.name == 'admin'}"><a href="admin">进入后台</a></c:if>
		<a href="foreLogout">退出</a>
	</c:if>

	<c:if test="${empty user}">
		<a href="foreToLoginPage">请登录</a>
		<a href="foreToRegisterPage">免费注册</a>
	</c:if>

	<span class="pull-right">
			<a href="foreBought">我的订单</a>
			<a href="foreCart">
			<span style="color:#C40000;margin:0px" class=" glyphicon glyphicon-shopping-cart redColor"></span>
			购物车<strong>${cartTotalItemNumber}</strong>件</a>
		</span>
</nav>



