<%--分类和轮播--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false"%>

<script>
function showProductsAsideCategorys(cid){
	//将被选中的div的背景颜色改为白色
	$("div.eachCategory[cid="+cid+"]").css("background-color","white");
	//将被选中的div里面的超链接的颜色改为:#87CEFA
	$("div.eachCategory[cid="+cid+"] a").css("color","#87CEFA");
	//显示当前分类被隐藏的推荐产品列表
	$("div.productsAsideCategorys[cid="+cid+"]").show();
}

function hideProductsAsideCategorys(cid){
	//将被选中的div的背景颜色改为:#e2e2e3
	$("div.eachCategory[cid="+cid+"]").css("background-color","#e2e2e3");
	//将被选中的div里面的超链接的颜色改为:#000
	$("div.eachCategory[cid="+cid+"] a").css("color","#000");
	//隐藏当前分类被隐藏的推荐产品列表
	$("div.productsAsideCategorys[cid="+cid+"]").hide();
}

$(function(){
	//mouseenter表示当鼠标移动到被选元素上时，触发该事件
    $("div.eachCategory").mouseenter(function(){
        var cid = $(this).attr("cid");
        showProductsAsideCategorys(cid);
    });

    //mouseleave表示当鼠标从被选元素上移开时，触发该事件
    $("div.eachCategory").mouseleave(function(){
        var cid = $(this).attr("cid");
        hideProductsAsideCategorys(cid);
    });

    $("div.productsAsideCategorys").mouseenter(function(){
    	var cid = $(this).attr("cid");
    	showProductsAsideCategorys(cid);
    });

    $("div.productsAsideCategorys").mouseleave(function(){
    	var cid = $(this).attr("cid");
    	hideProductsAsideCategorys(cid);
    });
	
	$("div.rightMenu span").mouseenter(function(){
		var left = $(this).position().left;
		var top = $(this).position().top;
		var width = $(this).css("width");
		var destLeft = parseInt(left) + parseInt(width)/2;
		$("img#catear").css("left",destLeft);
		$("img#catear").css("top",top-20);
		$("img#catear").fadeIn(500);
				
	});

	$("div.rightMenu span").mouseleave(function(){
		$("img#catear").hide();
	});
	
	var left = $("div#carousel-of-product").offset().left;
	$("div.categoryMenu").css("left",left-20);
	$("div.categoryWithCarousel div.head").css("margin-left",left);
	$("div.productsAsideCategorys").css("left",left-20);
	
});

</script>

<img src="img/site/catear.png" id="catear" class="catear"/>
	
<div class="categoryWithCarousel">

<div class="headbar show1">
	<div class="head ">
	
		<span style="margin-left:10px" class="glyphicon glyphicon-th-list"></span>
		<span style="margin-left:10px" >商品分类</span>
		
	</div>

	<%--在首页中，商品分类右边显示6个分类的链接--%>
	<div class="rightMenu">
		<span><a href=""><img src="img/site/chaoshi.png"/></a></span>
		<span><a href=""><img src="img/site/guoji.png"/></a></span>

		<c:forEach var="category" items="${categories}" varStatus="st">
			<%--只显示categories集合中，前6个分类的超链接--%>
			<c:if test="${st.count<=6}">
				<span>
				<a href="foreCategory?cid=${category.id}">
					${category.name}
				</a></span>			
			</c:if>
		</c:forEach>
	</div>
	
</div>

<div style="position: relative">
	<!--竖状分类菜单--%> -->
	<%@include file="categoryMenu.jsp" %>
</div>

<div style="position: relative;left: 0;top: 0;">
	<%--竖状分类菜单右侧的推荐产品列表--%>
	<%@include file="productsAsideCategorys.jsp" %>
</div>

	<%--轮播--%>
<%@include file="carousel.jsp" %>

<div class="carouselBackgroundDiv">
</div>

</div>





