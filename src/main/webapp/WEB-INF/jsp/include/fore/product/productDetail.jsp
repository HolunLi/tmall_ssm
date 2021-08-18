<%--详情图片--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false"%>
	
<div class="productDetailDiv" >
	<div class="productDetailTopPart">
		<a href="#null" class="productDetailTopPartSelectedLink selected">商品详情</a>
		<a href="#null" class="productDetailTopReviewLink">累计评价 <span class="productDetailTopReviewLinkNumber">${product.reviewCount}</span> </a>
	</div>

	<div class="productParamterPart">
		<div class="productParamter">产品参数：</div>
		
		<div class="productParamterList">
			<%--遍历当前产品的所有属性的值--%>
			<c:forEach var="propertyValue" items="${propertyValues}" >
				<span>${propertyValue.property.name}:  ${fn:substring(propertyValue.value, 0, 10)} </span>
			</c:forEach>
		</div>
		<div style="clear:both"></div>
	</div>
	
	<div class="productDetailImagesPart">
		<!--遍历当前产品的所有详情图片-->
		<c:forEach items="${product.productDetailImages}" var="pi">
			<img src="img/productimage/detail/${pi.id}.jpg">
		</c:forEach>
	</div>
</div>

