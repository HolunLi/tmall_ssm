<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false"%>

<c:if test="${empty param.categoryCount}">
	<!-- 前台首页，默认显示前100个分类，变量categoryCount是显示的分类数量 -->
	<c:set var="categoryCount" scope="page" value="100"/>
</c:if>
<c:if test="${!empty param.categoryCount}">
	<c:set var="categoryCount" scope="page" value="${param.categoryCount}"/>
</c:if>

<div class="homepageCategoryProducts">
	<!-- 遍历所有的分类 -->
	<c:forEach var="category" items="${categories}" varStatus="stc">
		<!-- 但只显示前categoryCount个分类（categoryCount默认值为100） -->
		<c:if test="${stc.count <= categoryCount}">
			<div class="eachHomepageCategoryProducts">
				<div class="left-mark"></div>
				<span class="categoryTitle">${category.name}</span>
				<br>
				<%--遍历当前分类的所有产品，--%>
				<c:forEach  var="product" items="${category.products}" varStatus="st">
					<!-- 但每个分类只选出前5个产品，放到前台首页中显示 -->
					<c:if test="${st.count <= 5}">
						<div class="productItem" >
							<a href="foreProduct?pid=${product.id}"><img width="100px" src="img/productimage/single_middle/${product.firstProductImage.id}.jpg"></a>
							<a class="productItemDescLink" href="foreProduct?pid=${product.id}">
								<span class="productItemDesc">[热销]
								${fn:substring(product.name, 0, 20)}
								</span>
						    </a>
							<span class="productPrice">
								<fmt:formatNumber type="number" value="${product.promotePrice}" minFractionDigits="2"/>
							</span>
						</div>
					</c:if>				
				</c:forEach>
				<div style="clear:both"></div>
			</div>
		</c:if>
	</c:forEach>
	
	
	<img id="endpng" class="endpng" src="img/site/end.png">

</div>