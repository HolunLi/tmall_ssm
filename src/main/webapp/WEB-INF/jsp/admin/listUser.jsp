<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@include file="../include/admin/adminHeader.jsp"%>
<%@include file="../include/admin/adminNavigator.jsp"%>

<title>用户管理</title>

<div class="workingArea">
	<h1 class="label label-info" >用户管理</h1>

	<br>
	<br>

	<div class="listDataTableDiv">
		<table class="table table-striped table-bordered table-hover  table-condensed">
			<thead>
			<tr class="success">
				<th>ID</th>
				<th>用户名称</th>
			</tr>
			</thead>
			<tbody>
			<c:forEach var="user" items="${users}" >
				<tr>
					<td>${user.id}</td>
					<td>${user.name}</td>
				</tr>
			</c:forEach>
			</tbody>
		</table>
	</div>

	<div class="pageDiv">
		<%@include file="../include/admin/adminPage.jsp" %>
	</div>

</div>

<%@include file="../include/admin/adminFooter.jsp"%>
