<%--竖状分类菜单--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false"%>
	
<div class="categoryMenu">
		<%--遍历所有的分类--%>
		<c:forEach var="category" items="${categories}" varStatus="st" >
			<%--在竖状分类菜单中，只显示所有分类中的前17个分类--%>
			<c:if test="${st.count <= 17}">
				<div cid="${category.id}" class="eachCategory">
					<span class="glyphicon glyphicon-link"></span>
					<a href="foreCategory?cid=${category.id}">${category.name}</a>
				</div>
			</c:if>
		</c:forEach>
	</div>  