<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false"%>

<%--登录模态框/窗口（当用户在未登录状态，于产品页面点击"立即购买"或"加入购物车"链接时，会弹出该模态框）--%>
<div class="modal " id="loginModal" tabindex="-1" role="dialog" >
	<div class="modal-dialog loginDivInProductPageModalDiv">
		<div class="modal-content">
			<div class="loginDivInProductPage">
				<div class="loginErrorMessageDiv">
					<div class="alert alert-danger" >
						<button type="button" class="close" data-dismiss="alert" aria-label="Close"></button>
						<span class="errorMessage"></span>
					</div>
				</div>

				<div class="login_acount_text">账户登录</div>
				<div class="loginInput " >
							<span class="loginInputIcon ">
								<span class=" glyphicon glyphicon-user"></span>
							</span>
					<input id="name" type="text" placeholder="手机/会员名/邮箱"  >
				</div>

				<div class="loginInput " >
							<span class="loginInputIcon ">
								<span class=" glyphicon glyphicon-lock"></span>
							</span>
					<input id="pwd" type="password" placeholder="密码" >
				</div>
				<span class="text-danger">不要输入真实的天猫账号密码</span><br><br>
				<div>
					<a href="#notImplementLink">忘记登录密码</a> <!-- 该功能没有做 -->
					<a href="foreToRegisterPage" class="pull-right">免费注册</a>
				</div>
				<div style="margin-top:20px">
					<button class="btn btn-block redButton loginSubmitButton" type="submit">登录</button>
				</div>
			</div>
		</div>
	</div>
</div>

<%--删除模态框/窗口（当用户在我的订单页面,和购物车页面进行删除操作的时候，就会弹出该模态框。）--%>
<div class="modal" id="deleteConfirmModal" tabindex="-1" role="dialog" >
	<div class="modal-dialog deleteConfirmModalDiv">
		<div class="modal-content">
			<div class="modal-header">
				<button data-dismiss="modal" class="close" type="button"><span aria-hidden="true">×</span><span class="sr-only">Close</span></button>
				<h4 class="modal-title">确认删除？</h4>
			</div>
			<div class="modal-footer">
				<button data-dismiss="modal" class="btn btn-default" type="button">关闭</button>
				<button class="btn btn-primary deleteConfirmButton" id="submit" type="button">确认</button>
			</div>
		</div>
	</div>
</div>
</div>