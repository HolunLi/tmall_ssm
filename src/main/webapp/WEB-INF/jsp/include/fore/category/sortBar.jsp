<!-- 排序条 -->
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false"%>

<script>
$(function(){
	$("input.sortBarPrice").keyup(function(){
		var num= $(this).val();
		if(num.length == 0){
			$("div.productUnit").show();
			return;
		}
			
		num = parseInt(num);
		if(isNaN(num))
			num = 1;
		if(num <= 0)
			num = 1;
		$(this).val(num);		

		var begin = parseInt($("input.beginPrice").val());
		var end = parseInt($("input.endPrice").val());
		if(!isNaN(begin) && !isNaN(end)){
			//先将当前分类页面所有的产品都隐藏起来
			$("div.productUnit").hide();
			$("div.productUnit").each(function(){
				var price = $(this).attr("price");
				//将一个数字格式的字符串转化成对应的数字
				price = new Number(price);
				//只显示价格处于查找区间的产品
				if(price>=begin && price<=end)
					$(this).show();
			});
		}
	});
});
</script>	
<div class="categorySortBar">

	<table class="categorySortBarTable categorySortTable">
		<tr>
			<td <c:if test="${'all'==param.sort||empty param.sort}">class="grayColumn"</c:if> ><a href="?cid=${cid}&sort=all&start=${page.start}">综合<span class="glyphicon glyphicon-arrow-down"></span></a></td>
			<td <c:if test="${'review'==param.sort}">class="grayColumn"</c:if> ><a href="?cid=${cid}&sort=review&start=${page.start}">人气<span class="glyphicon glyphicon-arrow-down"></span></a></td>
			<td <c:if test="${'date'==param.sort}">class="grayColumn"</c:if>><a href="?cid=${cid}&sort=date&start=${page.start}">新品<span class="glyphicon glyphicon-arrow-down"></span></a></td>
			<td <c:if test="${'saleCount'==param.sort}">class="grayColumn"</c:if>><a href="?cid=${cid}&sort=saleCount&start=${page.start}">销量<span class="glyphicon glyphicon-arrow-down"></span></a></td>
			<td <c:if test="${'price'==param.sort}">class="grayColumn"</c:if>><a href="?cid=${cid}&sort=price&start=${page.start}">价格<span class="glyphicon glyphicon-resize-vertical"></span></a></td>
		</tr>
	</table>
	
	<table class="categorySortBarTable">
		<tr>
			<td><input class="sortBarPrice beginPrice" type="text" placeholder="请输入"></td>
			<td class="grayColumn priceMiddleColumn">-</td>
			<td><input class="sortBarPrice endPrice" type="text" placeholder="请输入"></td>
		</tr>
	</table>

</div>