<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false"%>

<script>
//变量deleteOrderItem用于记录购物车中将要被删除的订单项的状态，false表示是当前订单项未被删除，true表示当前订单项已被删除
var deleteOrderItem = false;
//变量deleteOrderItemid 用于记录被删除的订单项的id
var deleteOrderItemid = 0;
$(function(){

	//在购物车页面，点击删除订单项链接时，触发该事件
	$("a.deleteOrderItem").click(function(){
		deleteOrderItem = false;
		deleteOrderItemid = $(this).attr("oiid");
		//显示删除模态框/窗口
		$("#deleteConfirmModal").modal('show');	   
	});

	//删除模态框/窗口中的确认删除按钮被点击时，触发该事件
	$("button.deleteConfirmButton").click(function(){
		deleteOrderItem = true;
		//当确认删除按钮被点击,隐藏删除模态框/窗口
		$("#deleteConfirmModal").modal('hide');
	});

	//删除模态框/窗口被隐藏时，触发该事件
	$("#deleteConfirmModal").on('hidden.bs.modal', function (e) {
		if(deleteOrderItem){
			//当删除模态框/窗口被隐藏，向后台发送异步请求，删除当前订单项
			$.post(
					"foreDeleteOrderItem",
				    {"oiid":deleteOrderItemid},
				    function(result){
						if("success" === result){
							//删除成功，隐藏展示当前订单项的div，即被删除的订单项从购物车中消失
							$("tr.cartProductItemTR[oiid="+deleteOrderItemid+"]").hide();
							$("img.cartProductItemIfSelected[oiid="+deleteOrderItemid+"]").attr("selectit","false");
							$("img.cartProductItemIfSelected[oiid="+deleteOrderItemid+"]").attr("delete", "yes");
							//判断结算按钮是否生效
							syncCreateOrderButton();
							//重新计算购买的商品总数及总价格
							calcCartSumPriceAndNumber();
						}
						else{
							location.href = "foreToLoginPage";
						}
				    }
				);
		}
	});
	/**
	 * 拓展
	 * jquery中的on方法（on事件方法），用于在被选元素及子元素上添加一个或多个事件处理程序。
	 * 'hidden.bs.modal' 是当模态框/窗口被隐藏时触发的事件，与其相反的事件是：shown.bs.modal，表示当显示模态框/窗口时触发的事件
	 *  hidden.bs.modal和 show.bs.modalBootstrap 都是Bootstrap中的模态框类提供的事件，用于监听模态框的状态（显示/隐藏）
	 */

	//当购物车中，订单项前面的单选框被点击时，触发该事件
	$("img.cartProductItemIfSelected").click(function(){
		var selectit = $(this).attr("selectit")

		//如果单选框在点击前，就已被勾选，就将勾选去掉
		if("selectit" == selectit){
			$(this).attr("src","img/site/cartNotSelected.png");
			$(this).attr("selectit","false")
			$(this).parents("tr.cartProductItemTR").css("background-color","#fff");
		}
		//如果单选框在点击前，未被勾选，就将其勾选
		else{
			$(this).attr("src","img/site/cartSelected.png");
			$(this).attr("selectit","selectit")
			$(this).parents("tr.cartProductItemTR").css("background-color","#FFF8E1");
		}

		//判断是否要勾选全选框
		syncSelect();
		//让结算按钮生效
		syncCreateOrderButton();
		//计算购买商品的总个数，以及总价格
		calcCartSumPriceAndNumber();
	});

	//当结算按钮前面的全选框被点击时，触发该事件
	$("img.selectAllItem").click(function(){
		var selectit = $(this).attr("selectit")

		//如果全选框在点击前，就已被勾选，就将勾选去掉，同时去除购物车中已勾选的所有订单项
		if("selectit" == selectit){
			$("img.selectAllItem").attr("src","img/site/cartNotSelected.png");
			$("img.selectAllItem").attr("selectit","false")
			$("img.cartProductItemIfSelected[delete='no']").each(function(){
				$(this).attr("src","img/site/cartNotSelected.png");
				$(this).attr("selectit","false");
				$(this).parents("tr.cartProductItemTR").css("background-color","#fff");
			});			
		}
		//如果全选框在点击前，未被勾选，就将其勾选，同时勾选购物车中的所有订单项
		else{
			$("img.selectAllItem").attr("src","img/site/cartSelected.png");
			$("img.selectAllItem").attr("selectit","selectit")
			$("img.cartProductItemIfSelected[delete='no']").each(function(){
				$(this).attr("src","img/site/cartSelected.png");
				$(this).attr("selectit","selectit");
				$(this).parents("tr.cartProductItemTR").css("background-color","#FFF8E1");
			});				
		}

		//让结算按钮生效
		syncCreateOrderButton();
		//计算购买商品的总个数，以及总价格
		calcCartSumPriceAndNumber();
	});
	
	$(".orderItemNumberSetting").keyup(function(){
		var pid=$(this).attr("pid");
		var stock = $("span.orderItemStock[pid="+pid+"]").text();
		var price = $("span.orderItemPromotePrice[pid="+pid+"]").text();
		var num = $(".orderItemNumberSetting[pid="+pid+"]").val();

		num = parseInt(num);
		if(isNaN(num))
			num = 1;
		if(num <= 0)
			num = 1;
		if(num > stock)
			num = stock;
		
		syncPrice(pid, num, price);
	});

	$(".numberPlus").click(function(){
		var pid=$(this).attr("pid");
		var stock= $("span.orderItemStock[pid="+pid+"]").text();
		var price= $("span.orderItemPromotePrice[pid="+pid+"]").text();
		var num= $(".orderItemNumberSetting[pid="+pid+"]").val();

		num++;
		if(num > stock)
			num = stock;
		syncPrice(pid,num,price);
	});

	$(".numberMinus").click(function(){
		var pid=$(this).attr("pid");
		var price= $("span.orderItemPromotePrice[pid="+pid+"]").text();
		var num= $(".orderItemNumberSetting[pid="+pid+"]").val();

		--num;
		if(num <= 0)
			num=1;
		syncPrice(pid,num,price);
	});	

	//结算按钮被点击时，触发该事件
	$("button.createOrderButton").click(function(){
		var params = "";

		$(".cartProductItemIfSelected").each(function(){
			if("selectit" == $(this).attr("selectit")){
				var oiid = $(this).attr("oiid");
				params += "&oiid="+oiid;
			}
		});

		//去掉第一个"&"符号
		params = params.substring(1);
		//重定到确认订单页面
		location.href = "foreBuyFromCart?" + params;
	});
})

/**
 * 该方法用于判断在什么情况下，将结算按钮前面的全选框勾上
 */
function syncSelect(){
	var selectAll = true;
	$(".cartProductItemIfSelected").each(function(){
		if("false"==$(this).attr("selectit")){
			selectAll = false;
		}
	});

	if(selectAll)
		//只有当购物车中，所有订单项前面的单选框都被勾上时，结算按钮前面的全选框才会被勾上
		$("img.selectAllItem").attr("src","img/site/cartSelected.png");
	else
		$("img.selectAllItem").attr("src","img/site/cartNotSelected.png");
}

/**
 * 该方法用于判断在什么情况下，让结算按钮生效
 */
function syncCreateOrderButton(){
	var selectAny = false;
	$(".cartProductItemIfSelected").each(function(){
		if("selectit" == $(this).attr("selectit")){
			selectAny = true;
		}
	});

	//只要购物车中，有一个订单项前面的单选框被勾上，结算按钮就会生效
	if(selectAny){
		//将结算按钮的背景颜色改为:#C40000
		$("button.createOrderButton").css("background-color","#C40000");
		//移除结算按钮中的disabled属性，结算按钮就会生效（亮起来）
		$("button.createOrderButton").removeAttr("disabled");
	}
	else{
		$("button.createOrderButton").css("background-color","#AAAAAA");
		$("button.createOrderButton").attr("disabled","disabled");		
	}
		
}

/**
 * 该方法用于计算购买的商品个数，以及总价格
 */
function calcCartSumPriceAndNumber(){
	var sum = 0;
	var totalNumber = 0;

	$("img.cartProductItemIfSelected[selectit='selectit']").each(function(){
		var oiid = $(this).attr("oiid");
		var price =$(".cartProductItemSmallSumPrice[oiid="+oiid+"]").text();

		//去掉已选订单项价格中的 "," 符号
		price = price.replace(/,/g, "");
		//去掉已选订单项价格中的 "￥" 符号
		price = price.replace(/￥/g, "");
		//计算购买的商品的总价格
		sum += new Number(price);

		//计算购买的商品个数
		var num = parseInt($(".orderItemNumberSetting[oiid="+oiid+"]").val());
		totalNumber += num;
	});

	$("span.cartTitlePrice").html("￥"+formatMoney(sum));
	$("span.cartSumNumber").html(totalNumber);
	$("span.cartSumPrice").html("￥"+formatMoney(sum));
}

/**
 * 该方法用于监听当前订单项中的商品个数变化，同步更改当前订单项的价格
 */
function syncPrice(pid, num, price){
	$(".orderItemNumberSetting[pid="+pid+"]").val(num);
	var cartProductItemSmallSumPrice = formatMoney(num * price);
	//在购物车页面同步更新更改后的订单项价格
	$(".cartProductItemSmallSumPrice[pid="+pid+"]").html("￥" + cartProductItemSmallSumPrice);
	//重新计算购买的商品个数，以及总价格
	calcCartSumPriceAndNumber();

	//发送异步请求，更新数据库表中的当前订单项
	$.post(
			"foreChangeOrderItem",
		    {"pid":pid,"number":num},
		    function(result){
				if("success" != result){
					location.href="foreToLoginPage";
				}
		    }
		);
}
</script>	

<div class="cartDiv">
	<div class="cartTitle pull-right">
		<span>已选商品  (不含运费)</span>
		<span class="cartTitlePrice">￥0.00</span>
		<button class="createOrderButton" disabled="disabled">结 算</button>
	</div>

	<div class="cartProductList">
		<table class="cartProductTable">
			<thead>
				<tr>
					<th class="selectAndImage">
							<img selectit="false" class="selectAllItem" src="img/site/cartNotSelected.png">				
					全选
					</th>
					<th>商品信息</th>
					<th>单价</th>
					<th>数量</th>
					<th width="120px">金额</th>
					<th class="operation">操作</th>
				</tr>
			</thead>
			<tbody>
				<c:forEach var="orderItem" items="${orderItems}">
					<%--class为cartProductItemTR的div，用于展示一个订单项--%>
					<tr oiid="${orderItem.id}" class="cartProductItemTR">
						<td>
							<img selectit="false" oiid="${orderItem.id}" delete="no" class="cartProductItemIfSelected" src="img/site/cartNotSelected.png">
							<img class="cartProductImg"  src="img/productimage/single_middle/${orderItem.product.firstProductImage.id}.jpg">
						</td>
						<td>
							<div class="cartProductLinkOutDiv">
								<a href="foreProduct?pid=${orderItem.product.id}" class="cartProductLink">${orderItem.product.name}</a>
								<div class="cartProductLinkInnerDiv">
									<img src="img/site/creditcard.png" title="支持信用卡支付">
									<img src="img/site/7day.png" title="消费者保障服务,承诺7天退货">
									<img src="img/site/promise.png" title="消费者保障服务,承诺如实描述">
								</div>
							</div>
							
						</td>
						<td>
							<span class="cartProductItemOringalPrice">￥${orderItem.product.originalPrice}</span>
							<span  class="cartProductItemPromotionPrice">￥${orderItem.product.promotePrice}</span>
						</td>
						<td>
						
							<div class="cartProductChangeNumberDiv">
								<span class="hidden orderItemStock" pid="${orderItem.product.id}">${orderItem.product.stock}</span>
								<span class="hidden orderItemPromotePrice" pid="${orderItem.product.id}">${orderItem.product.promotePrice}</span>
								<!--减少产品数量链接-->
								<a  pid="${orderItem.product.id}" class="numberMinus" href="#null">-</a>
								<input pid="${orderItem.product.id}" oiid="${orderItem.id}" class="orderItemNumberSetting" value="${orderItem.number}" autocomplete="off">
								<!--增加产品数量链接-->
								<a  stock="${orderItem.product.stock}" pid="${orderItem.product.id}" class="numberPlus" href="#null">+</a>
							</div>					
						
						 </td>
						<td>
							<span class="cartProductItemSmallSumPrice" oiid="${orderItem.id}" pid="${orderItem.product.id}" >
							￥<fmt:formatNumber type="number" value="${orderItem.product.promotePrice * orderItem.number}" minFractionDigits="2"/>
							</span>
						</td>
						<td>
							<a class="deleteOrderItem" oiid="${orderItem.id}" href="#null">删除</a>
						</td>
					</tr>
				</c:forEach>				
			</tbody>
		
		</table>
	</div>
	
	<div class="cartFoot">
		<img selectit="false" class="selectAllItem" src="img/site/cartNotSelected.png">
		<span>全选</span>
		
		<div class="pull-right">
			<span>已选商品 <span class="cartSumNumber" >0</span> 件</span>
			<span>合计 (不含运费): </span> 
			<span class="cartSumPrice" >￥0.00</span>
			<!-- 结算按钮，在未勾选任何一个订单项时，默认置灰，不能点击 -->
			<button class="createOrderButton" disabled="disabled" >结  算</button>
		</div>
		
	</div>
	
</div>