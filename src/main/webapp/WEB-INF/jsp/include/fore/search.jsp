<%--前台首页中的搜索栏--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false"%>

<a href="${contextPath}">
	<img id="logo" src="img/site/logo.gif" class="logo">
</a>

<form action="foreSearch" method="get" >
	<div class="searchDiv">
		<input name="keyword" type="text" value="${param.keyword}" placeholder="时尚男鞋  太阳镜 ">
		<button  type="submit" class="searchButton">搜索</button>
		<div class="searchBelow">
			<c:forEach var="category" items="${categories}"  varStatus="st">
				<%--在搜索框下面显示categories集合中，第5个到第8个分类的超链接，共4个超链接。--%>
				<c:if test="${st.count>=5 and st.count<=8}">  <%--st.count表示当前循环是第几次循环--%>
						<span>
							<a href="foreCategory?cid=${category.id}">
									${category.name}
							</a>
							<c:if test="${st.count!=8}">
								<span>|</span>
							</c:if>
						</span>
				</c:if>
			</c:forEach>
		</div>
	</div>
</form>
