<%--竖状分类菜单右侧的推荐产品列表--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false"%>

<script>
$(function(){
	$("div.productsAsideCategorys div.row a").each(function(){
		var v = Math.round(Math.random() *6);
		if(v == 1)
			$(this).css("color","#87CEFA");
	});
});
</script>

<%--
三层遍历
1. 先取出每个分类
2. 然后取出每个分类的productsByRow集合
3. 遍历productsByRow集合，取出每个产品，把产品的subTitle信息里的第一个单词取出来显示。
--%>

<c:forEach var="category" items="${categories}" >

	<!-- 这个div用于显示当前分类的推荐产品列表（只有当鼠标移到首页竖状分类菜单中的某个分类链接上时，才会显示当前分类对应的推荐产品列表） -->
	<div cid="${category.id}" class="productsAsideCategorys">

		<c:forEach var="rowList" items="${category.productsByRow}" >
			<!-- 当前分类的所有推荐产品，每8个产品作为一个列表，放在一行中显示 -->
			<div class="row">
				<c:forEach var="product" items="${rowList}" >
					<c:if test="${!empty product.subTitle}">
						<a href="foreProduct?pid=${product.id}">
							<!--jstl函数标签库中的split函数，用于将一个字符串以某个字符作为分隔符，将对当前字符串进行拆分，并将拆分后得到的多个子字符串放在一个数组返回-->
							<c:forEach var="title" items="${fn:split(product.subTitle, ' ')}" varStatus="st">
								<%--将产品的subTitle信息里的第一个单词取出来显示。--%>
								<c:if test="${st.index==0}">
									${title}
								</c:if>
							</c:forEach>
						</a>
					</c:if>
				</c:forEach>
				<!-- 一行显示完8个推荐产品后加上一条分隔线，继续遍历显示下一行推荐产品-->
				<div class="seperator"></div>
			</div>		
		</c:forEach>

	</div>

</c:forEach>
	
