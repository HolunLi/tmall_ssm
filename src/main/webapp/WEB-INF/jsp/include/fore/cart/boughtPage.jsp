<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false"%>

<script>
//变量deleteOrder用于记录我的订单页面中将要被删除的订单的状态，false表示是当前订单未被删除，true表示当前订单已被删除
var deleteOrder = false;
//变量deleteOrderid 用于记录被删除的订单的id
var deleteOrderid = 0;

$(function(){
	//点击订单状态链接（所有订单、待付款、代发货、待收获、待评价），触发该事件
	$("a[orderStatus]").click(function(){  //$("a[orderStatus]")是选择当前页面所有包含orderStatus属性的<a>元素
		var orderStatus = $(this).attr("orderStatus");

		//如果点击是所有订单链接，就显示所有的订单（不包括被删除的订单）
		if("all" === orderStatus){
			//显示当前页面所有yin属性值等于"no"的<table>元素
			$("table[yin='no']").show();
		}
		else{
			//如果点击是其它状态的链接，先将所有订单隐藏，再显示符合当前状态的订单
			$("table[orderStatus]").hide();
			$("table[orderStatus]").each(function () {
				var os = $(this).attr("orderStatus");
				var yin = $(this).attr("yin");
				if (os === orderStatus && yin === "no")
					$(this).show()
			});
		}
		
		$("div.orderType div").removeClass("selectedOrderType");
		$(this).parent("div").addClass("selectedOrderType");
	});

	//当删除订单链接被点击时，触发该事件
	$("a.deleteOrderLink").click(function(){
		deleteOrderid = $(this).attr("oid");
		deleteOrder = false;
		//显示删除模态框/窗口
		$("#deleteConfirmModal").modal("show");
	});

	//删除模态框/窗口中的确认删除按钮被点击时，触发该事件
	$("button.deleteConfirmButton").click(function(){
		deleteOrder = true;
		//当确认删除按钮被点击,隐藏删除模态框/窗口
		$("#deleteConfirmModal").modal('hide');
	});

	//删除模态框/窗口被隐藏时，触发该事件
	$("#deleteConfirmModal").on('hidden.bs.modal', function (e) {
		if(deleteOrder){
			//当删除模态框/窗口被隐藏，向后台发送异步请求，删除当前订单
			$.post(
					"foreDeleteOrder",
				    {"oid":deleteOrderid},
				    function(result){
						if("success" === result){
							//删除成功，隐藏展示当前订单的table，即被删除的订单从我的订单页面中消失
							$("table.orderListItemTable[oid="+deleteOrderid+"]").hide();
							//隐藏展示当前订单的table后，再将该table的属性yin置为true
							$("table.orderListItemTable[oid="+deleteOrderid+"]").attr("yin", "yes");
						}
						else{
							location.href="foreToLoginPage";
						}
				    }
				);
		}
	});

	//当催卖家发货按钮被点击时，触发该事件
	$(".ask2delivery").click(function(){
		//催卖家发货按钮被点击后，就立即隐藏
		$(this).hide();

		//向后台发送异步请求，对当前订单进行发货
		$.ajax({
			   url: $(this).attr("link"),
			   success: function(result){
				alert("卖家已秒发，刷新当前页面，即可进行确认收货")
			   }
			});
	});
});

</script>
	
<div class="boughtDiv">
	<div class="orderType">
		<div class="selectedOrderType"><a orderStatus="all" href="#nowhere">所有订单</a></div>
		<div><a orderStatus="waitPay" href="#nowhere">待付款</a></div>
		<div><a orderStatus="waitDelivery" href="#nowhere">待发货</a></div>
		<div><a orderStatus="waitConfirm" href="#nowhere">待收货</a></div>
		<div><a orderStatus="waitReview" href="#nowhere">待评价</a></div>
		<div><a orderStatus="finish" href="#nowhere" class="noRightborder">交易完成</a></div>
		<div class="orderTypeLastOne"><a class="noRightborder">&nbsp;</a></div>
	</div>

	<div style="clear:both"></div>

	<div class="orderListTitle">
		<table class="orderListTitleTable">
			<tr>
				<td>宝贝</td>
				<td width="100px">单价</td>
				<td width="100px">数量</td>
				<td width="120px">实付款</td>
				<td width="100px">交易操作</td>
			</tr>
		</table>
	</div>
	
	<div class="orderListItem">
		<!-- 遍历所有的订单 -->
		<c:forEach var="order" items="${orders}">
			<%--class为orderListItemTable的<table>，用于展示一个订单--%>
			<table class="orderListItemTable" orderStatus="${order.status}" oid="${order.id}" yin="no">
				<tr class="orderListItemFirstTR">
					<td colspan="2">
					<b><fmt:formatDate value="${order.createDate}" pattern="yyyy-MM-dd HH:mm:ss"/></b>
					<span>订单号: ${order.orderCode}
					</span>
					</td>
					<td  colspan="2"><img width="13px" src="img/site/orderItemTmall.png">天猫商场</td>
					<td colspan="1">
						<a class="wangwanglink" href="#nowhere">
							<div class="orderItemWangWangGif"></div>
						</a>
					</td>
					<td class="orderItemDeleteTD">
						<a class="deleteOrderLink" oid="${order.id}" href="#nowhere">
							<span class="orderListItemDelete glyphicon glyphicon-trash"></span>
						</a>
					</td>
				</tr>
				<!-- 遍历当前订单包含的所有订单项 -->
				<c:forEach var="oi" items="${order.orderItems}" varStatus="st">
					<tr class="orderItemProductInfoPartTR">
						<td class="orderItemProductInfoPartTD"><img width="80" height="80" src="img/productimage/single_middle/${oi.product.firstProductImage.id}.jpg"></td>
						<td class="orderItemProductInfoPartTD" >
							<div class="orderListItemProductLinkOutDiv">
								<a href="foreProduct?pid=${oi.product.id}">${oi.product.name}</a>
								<div class="orderListItemProductLinkInnerDiv">
											<img src="img/site/creditcard.png" title="支持信用卡支付">
											<img src="img/site/7day.png" title="消费者保障服务,承诺7天退货">
											<img src="img/site/promise.png" title="消费者保障服务,承诺如实描述">						
								</div>
							</div>
						</td>
						<td class="orderItemProductInfoPartTD" width="100px">
							<div class="orderListItemProductOriginalPrice">￥<fmt:formatNumber type="number" value="${oi.product.originalPrice}" minFractionDigits="2"/></div>
							<div class="orderListItemProductPrice">￥<fmt:formatNumber type="number" value="${oi.product.promotePrice}" minFractionDigits="2"/></div>
						</td>
						<td class="orderItemProductInfoPartTD" width="100px" align="center">
							<span class="orderListItemNumber">${oi.number}</span>
						</td>
						<c:if test="${st.count == 1}">
							<td valign="top" rowspan="${fn:length(order.orderItems)}" width="120px" class="orderListItemProductRealPriceTD orderItemOrderInfoPartTD">
								<div class="orderListItemProductRealPrice">￥<fmt:formatNumber  minFractionDigits="2" maxFractionDigits="2" type="number" value="${order.total}"/></div>
								<div class="orderListItemPriceWithTransport">(含运费：￥0.00)</div>
							</td>
							<c:if test="${order.status == 'waitConfirm' }">
								<td valign="top" rowspan="${fn:length(order.orderItems)}" class="orderListItemButtonTD orderItemOrderInfoPartTD" width="100px">
									<a href="foreConfirmPay?oid=${order.id}">
										<button class="orderListItemConfirm">确认收货</button>
									</a>
								</td>
							</c:if>
							<c:if test="${order.status == 'waitPay' }">
								<td valign="top" rowspan="${fn:length(order.orderItems)}" class="orderListItemButtonTD orderItemOrderInfoPartTD" width="100px">
									<a href="foreToAlipayPage?oid=${order.id}&total=${order.total}">
										<button class="orderListItemConfirm">付款</button>
									</a>
								</td>
							</c:if>
							<c:if test="${order.status == 'waitDelivery' }">
								<td valign="top" rowspan="${fn:length(order.orderItems)}" class="orderListItemButtonTD orderItemOrderInfoPartTD" width="100px">
									<span>待发货</span>
									<%--<button class="btn btn-info btn-sm ask2delivery" link="admin_order_delivery?id=${o.id}">催卖家发货</button> --%>
								</td>
							</c:if>
							<c:if test="${order.status == 'finish' }">
								<td valign="top" rowspan="${fn:length(order.orderItems)}" class="orderListItemButtonTD orderItemOrderInfoPartTD" width="100px">
									<span>交易完成</span>
								</td>
							</c:if>
						</c:if>
						<c:if test="${order.status == 'waitReview' }">
							<c:if test="${oi.reviewStatus == 'no'}">
								<td class="orderItemProductInfoPartTD" width="100px" align="center">
									<a href="foreReview?oid=${order.id}&pid=${oi.pid}&oiid=${oi.id}">
										<button class="orderListItemReview">评价</button>
									</a>
								</td>
							</c:if>
							<c:if test="${oi.reviewStatus == 'yes'}">
								<td class="orderItemProductInfoPartTD" width="100px" align="center">
									<span>已评价</span>
								</td>
							</c:if>
						</c:if>
					</tr>
				</c:forEach>
			</table>
		</c:forEach>
	</div>
</div>