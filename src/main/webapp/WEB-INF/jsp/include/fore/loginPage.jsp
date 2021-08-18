<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false"%>

<script>
    $(function(){

        $("#loginButton").click(function(){
            if(0==$("#name").val().length){
                $("span.errorMessage").html("请输入账号");
                $("div.loginErrorMessageDiv").show();
                return false;
            }
            if (0==$("#pwd").val().length) {
				$("span.errorMessage").html("请输入密码");
				$("div.loginErrorMessageDiv").show();
				return false;
			}

            $.post(
            		"foreLogin",
					{
						"name":$("#name").val(),
						"pwd":$("#pwd").val()
					},
					function (result) {
            			if (result === "fail") {
							$("span.errorMessage").html("用户名或密码错误");
							$("div.loginErrorMessageDiv").show();
						}
						else
							window.location.href = "foreHome";
					}
			)
        });

        $("input").keyup(function () {
			$("div.loginErrorMessageDiv").hide();
		});

        var left = window.innerWidth/2+162;
        $("div.loginSmallDiv").css("left",left);
    })
</script>


<div id="loginDiv" style="position: relative">

	<div class="simpleLogo">
		<a href="${contextPath}"><img src="img/site/simpleLogo.png"></a>
	</div>


	<img id="loginBackgroundImg" class="loginBackgroundImg" src="img/site/loginBackground.png">

		<div id="loginSmallDiv" class="loginSmallDiv">
			<div class="loginErrorMessageDiv">
				<div class="alert alert-danger" >
					<span class="errorMessage"></span>
				</div>
			</div>

			<div class="login_acount_text">账户登录</div>
			<div class="loginInput " >
				<span class="loginInputIcon ">
					<span class=" glyphicon glyphicon-user"></span>
				</span>
				<input id="name" name="name" placeholder="手机/会员名/邮箱" type="text">
			</div>

			<div class="loginInput " >
				<span class="loginInputIcon ">
					<span class=" glyphicon glyphicon-lock"></span>
				</span>
				<input id="pwd" name="pwd" type="password" placeholder="密码" >
			</div>
			<span class="text-danger">不要输入真实的天猫账号密码</span><br><br>

			<div>
				<a href="#notImplementLink">忘记登录密码</a> <!--该功能暂未做-->
				<a href="foreToRegisterPage" class="pull-right">免费注册</a>
			</div>
			<div style="margin-top:20px">
				<button id="loginButton" class="btn btn-block redButton" >登录</button>
			</div>
		</div>

</div>	