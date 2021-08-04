<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@include file="../include/admin/adminHeader.jsp"%>
<%@include file="../include/admin/adminNavigator.jsp"%>

<title>编辑产品</title>

<script>
    $(function() {
		$("#editForm").submit(function() {
			if (!checkEmpty("name", "产品名称"))
				return false;
			//在新增产品时，产品的小标题可以为空
//          if (!checkEmpty("subTitle", "小标题"))
//              return false;
			//输入的原价和优惠价格必须是数字
			if (!checkNumber("originalPrice", "原价格"))
				return false;
			if (!checkNumber("promotePrice", "优惠价格"))
				return false;
			//输入的库存必须是整型
			if (!checkInt("stock", "库存"))
				return false;
			return true;
		});
    });
</script>

<div class="workingArea">
	<ol class="breadcrumb">
		<li><a href="admin_category_list">所有分类</a></li>
		<li><a href="admin_product_list?cid=${product.category.id}">${product.category.name}</a></li>
		<li class="active">${product.name}</li>
		<li class="active">编辑产品</li>
	</ol>

	<div class="panel panel-warning editDiv">
		<div class="panel-heading">编辑产品</div>
		<div class="panel-body">
			<form id="editForm" action="admin_product_update" method="post">
				<table class="editTable">
					<tr>
						<td>产品名称</td>
						<td><input id="name" name="name" value="${product.name}"
								   type="text" class="form-control"></td>
					</tr>
					<tr>
						<td>产品小标题</td>
						<td><input id="subTitle" name="subTitle" type="text"
								   value="${product.subTitle}"
								   class="form-control"></td>
					</tr>
					<tr>
						<td>原价格</td>
						<td><input id="originalPrice" value="${product.originalPrice}" name="originalPrice" type="text"
								   class="form-control"></td>
					</tr>
					<tr>
						<td>优惠价格</td>
						<td><input id="promotePrice"  value="${product.promotePrice}" name="promotePrice" type="text"
								   class="form-control"></td>
					</tr>
					<tr>
						<td>库存</td>
						<td><input id="stock"  value="${product.stock}" name="stock" type="text"
								   class="form-control"></td>
					</tr>

					<tr class="submitTR">
						<td colspan="2" align="center">
							<input type="hidden" name="id" value="${product.id}">
							<input type="hidden" name="cid" value="${product.category.id}">
							<button type="submit" class="btn btn-success">提 交</button></td>
					</tr>
				</table>
			</form>
		</div>
	</div>
</div>