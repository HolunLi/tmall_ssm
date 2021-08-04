<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@include file="../include/admin/adminHeader.jsp"%>
<%@include file="../include/admin/adminNavigator.jsp"%>

<title>编辑产品属性值</title>

<script>
    $(function() {
        $("input.pvValue").keyup(function(){  //keyup表示当键盘键被松开时，触发该事件
           /* var value = $(this).val();
            var page = "admin_propertyValue_update";
            var pvid = $(this).attr("pvid");
            */
            var parentSpan = $(this).parent("span"); //获取当前被选标记的父标记，也就是<span>标记。
			//当上诉事件被触发时（也就是前台页面正在修改属性值时），将<span>的边框颜色改为黄色
            parentSpan.css("border","1px solid yellow");

            //通过ajax向后台发送异步请求，与后台进行交互
            $.post(
				"admin_propertyValue_update",

                {
                	"value": $(this).val(), //this表示被jquery选择器选中的当前元素
					"id":$(this).attr("pvid")
				},

                function(result){
					//异步请求成功（属性值修改成功）时，将<span>的边框颜色改为蓝色
                    if("success" == result)
                        parentSpan.css("border","1px solid blue");
                    else
                    	//异步请求失败时（属性值修改失败），将<span>的边框颜色改为红色
                        parentSpan.css("border","1px solid red");
                }
            );
        });
    });
</script>

<div class="workingArea">
	<ol class="breadcrumb">
		<li><a href="admin_category_list">所有分类</a></li>
		<li><a href="admin_product_list?cid=${product.category.id}">${product.category.name}</a></li>
		<li class="active">${product.name}</li>
		<li class="active">编辑产品属性</li>
	</ol>

	<div class="editPVDiv">
		<c:forEach var="pv" items="${propertyValues}" >
			<div class="eachPV">
				<span class="pvName" >${pv.property.name}</span>
				<!--<span>标记是<input>标记的父标记，因为<input>标记嵌套在<span>标记里面 -->
				<span class="pvValue"><input class="pvValue" pvid="${pv.id}" type="text" value="${pv.value}"></span>
			</div>
		</c:forEach>
		<div style="clear:both"></div>
	</div>

</div>

