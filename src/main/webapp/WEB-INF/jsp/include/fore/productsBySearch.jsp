<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false"%>

<div class="searchProducts">
		<c:forEach var="product" items="${products}" >
				<div class="productUnit">
					<a href="foreProduct?pid=${product.id}">
						<img class="productImage" src="img/productimage/single/${product.firstProductImage.id}.jpg">
					</a>
					<span class="productPrice">¥<fmt:formatNumber type="number" value="${product.promotePrice}" minFractionDigits="2"/></span>
					<a class="productLink" href="foreProduct?pid=${product.id}">
							${fn:substring(product.name, 0, 50)}
					</a>

					<a class="tmallLink" href="foreProduct?pid=${product.id}">天猫专卖</a>

					<div class="show1 productInfo">
						<span class="monthDeal ">月成交 <span class="productDealNumber">${product.saleCount}笔</span></span>
						<span class="productReview">评价<span class="productReviewNumber">${product.reviewCount}</span></span>
						<span class="wangwang"><img src="img/site/wangwang.png"></span>
					</div>
				</div>
		</c:forEach>

		<c:if test="${empty products}">
			<div class="noMatch">没有满足条件的产品<div>
				<div style="clear:both"></div>
			</div>
		</c:if>
</div>

<div align="center">
	<%@include file="forePage.jsp" %>
</div>