<%--评价信息--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false"%>

	
<div class="productReviewDiv" >
	<div class="productReviewTopPart">
		<a  href="#nowhere" class="productReviewTopPartSelectedLink">商品详情</a>
		<a  href="#nowhere" class="selected">累计评价 <span class="productReviewTopReviewLinkNumber">${product.reviewCount}</span> </a>
	</div>
		
	<div class="productReviewContentPart">
		<%--将当前产品包含的所有评价遍历出来--%>
		<c:forEach var="review" items="${reviews}" >
		<div class="productReviewItem">
		
			<div class="productReviewItemDesc">
				<div class="productReviewItemContent">
					${review.content }
				</div>
					<%--格式化标签库中的<fmt:formatDate>标签用于格式化日期。--%>
				<div class="productReviewItemDate"><fmt:formatDate value="${review.createDate}" pattern="yyyy-MM-dd"/></div>
			</div>
			<div class="productReviewItemUserInfo">
			
				${review.user.anonymousName}<span class="userInfoGrayPart">（匿名）</span>
			</div>
			
			<div style="clear:both"></div>
		
		</div>
		</c:forEach>
	</div>

</div>
