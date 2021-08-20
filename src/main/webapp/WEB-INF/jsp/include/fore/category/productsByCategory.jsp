<%--产品列表--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false"%>

<div class="categoryProducts">
	<!-- 在分类页面，遍历当前分类包含的全部产品，每页显示20个产品 -->
	<c:forEach var="product" items="${products}">
		<div class="productUnit" price="${product.promotePrice}">
			<div class="productUnitFrame">
				<a href="foreProduct?pid=${product.id}">
					<img class="productImage" src="img/productimage/single_middle/${product.firstProductImage.id}.jpg">
				</a>
				<span class="productPrice">¥<fmt:formatNumber type="number" value="${product.promotePrice}" minFractionDigits="2"/></span>
				<a class="productLink" href="foreProduct?pid=${product.id}">
				 ${fn:substring(product.name, 0, 50)}
				</a>
				
				<a  class="tmallLink" href="foreProduct?pid=${product.id}">天猫专卖</a>
	
				<div class="show1 productInfo">
					<span class="monthDeal ">月成交 <span class="productDealNumber">${product.saleCount}笔</span></span>
					<span class="productReview">评价<span class="productReviewNumber">${product.reviewCount}</span></span>
					<span class="wangwang">
					<a class="wangwanglink">
						<img src="img/site/wangwang.png">
					</a>
					
					</span>
				</div>
			</div>
		</div>
	</c:forEach>

	<div style="clear:both"></div>
	<div align="center">
		<%@include file="../forePage.jsp" %>
	</div>
</div>