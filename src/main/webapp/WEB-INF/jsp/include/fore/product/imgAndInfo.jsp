<%--单个图片和基本信息--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false"%>

<script>
 
$(function(){
    //获取当前产品的库存
    var stock = ${product.stock};

    //keyup表示键盘松开时，触发该事件（与keyup相反的事件是keydown，表示键盘按下时时，触发该事件）
    $(".productNumberSetting").keyup(function(){
        var num = parseInt($(".productNumberSetting").val());
        if (stock > 0) {
            //在产品页面，购买的产品数量必须是整数
            if(isNaN(num))
                num = 1;
            //在产品页面，购买的产品数量必须大于0
            if(num <= 0)
                num = 1;
            //在产品页面，购买的产品数量不能大于库存数量
            if(num > stock)
                num = stock;
            $(".productNumberSetting").val(num);
        }
        else {
            //在产品页面，购买的产品数量必须是整数
            if(isNaN(num))
                num = 0;
            //在产品页面，购买的产品数量必须大于0
            if(num <= 0)
                num = 0;
            //在产品页面，购买的产品数量不能大于库存数量
            if(num > stock)
                num = stock;
            $(".productNumberSetting").val(num);
        }
    });

    //点击增加购买的产品数量的链接时，触发该事件
    $(".increaseNumber").click(function(){
        var num = parseInt($(".productNumberSetting").val());
        //每点击一次产品数量+1
        num++;
        if(num > stock)
            num = stock;
        $(".productNumberSetting").val(num);
    });

    //点击减少购买的产品数量的链接时，触发该事件
    $(".decreaseNumber").click(function(){
        if (stock > 0) {
            var num= parseInt($(".productNumberSetting").val());
            //每点击一次产品数量-1
            --num;
            if(num <= 0)
                num = 1;
            $(".productNumberSetting").val(num);
        }
    });

    //点击加入购物车链接时，触发该事件。
    $(".addCartLink").click(function(){
        //只有在登录状态才能将产品加入购物车，所以必须进行登录验证，通过ajax发送异步请求，验证点击加入购物车链接时，是否处于已登录状态
        $.get(
                "foreCheckLogin",
                function(result){
                    if("success" === result){
                        //如果点击加入购物车链接时处于已登录状态，再通过ajax发送异步请求，将产品加入到购物车
                        $.post(
                                "foreAddCart",
                                {
                                    "pid":${product.id}, //购买的产品id
                                    "number":$(".productNumberSetting").val() //购买的产品数量
                                },
                                function(result){
                                    //如果产品加入购物车成功，需要对 "加入购物车按钮" 进行以下几个操作
                                    if("success" === result){
                                        //将这个按钮上的内容改为已加入购物车
                                        $(".addCartButton").html("已加入购物车");
                                        //将这个按钮置灰，即不能再点击
                                        $(".addCartButton").attr("disabled","disabled");
                                        //将这个按钮的背景颜色改为：lightgray
                                        $(".addCartButton").css("background-color","lightgray")
                                        //将这个按钮的边框颜色改为：lightgray
                                        $(".addCartButton").css("border-color","lightgray")
                                        //将这个按钮上的内容文本的字体颜色改为黑色
                                        $(".addCartButton").css("color","black")
                                         
                                    }
                                    else{
                                         //加入购物车失败，不做任何处理
                                    }
                                }
                        );                          
                    }
                    else{
                        //如果点击加入购物车链接时处于未登录状态，显示登录模态框/窗口
                        $("#loginModal").modal('show');
                        /**
                         * 拓展：
                         * Bootstrap模态框（Modal）是覆盖在父窗体上的子窗体。
                         * 通常，目的是显示来自一个单独的源的内容，可以在不离开父窗体的情况下提供一些互动。因此，子窗体可提供信息、交互等。
                         * .modal('show'); 显示模态框
                         * .modal('hide'); 隐藏模态框
                         */
                    }
                }
        );
    });

    //立即购买链接点击时，触发该事件
    $(".buyLink").click(function(){
        //只有在登录状态才能将购买产品，所以必须进行登录验证，通过ajax发送异步请求，验证点击立即购买链接时，是否处于已登录状态
        $.get(
                "foreCheckLogin",
                function(result){
                    //如果已登陆，将"立即购买"按钮的href属性值赋予location对象的href属性
                    if("success" === result){
                        var number = $(".productNumberSetting").val();
                        location.href = "foreBuyFromProductPage?pid=${product.id}&number=" + number;
                    }
                    else{
                        //未登录，显示登录模态框/窗口
                        $("#loginModal").modal('show');                     
                    }
                }
        );
    });

    //登录模态框中的登录按钮被点击时，触发该事件
    $("button.loginSubmitButton").click(function(){
        var name = $("#name").val();
        var pwd = $("#pwd").val();

        if(0 === name.length){
            $("span.errorMessage").html("请输入账号");
            $("div.loginErrorMessageDiv").show();
            return false;
        }

        if (0 === pwd.length) {
            $("span.errorMessage").html("请输入密码");
            $("div.loginErrorMessageDiv").show();
            return false;
        }

        $.post(
                "foreLogin",
                {"name":name,"pwd":pwd},
                function(result){
                    //登录成功，重新加载当前产品页面
                    if("success" === result){
                        location.reload();
                    }
                    else{  //登录失败显示错误提示
                        $("span.errorMessage").html("账号或密码错误");
                        $("div.loginErrorMessageDiv").show();                       
                    }
                }
        );
    });

    //当鼠标移到产品的小图片上时，用当前的小图片替换上面的大图片
    $("img.smallImage").mouseenter(function(){
        $("img.bigImg").attr("src", $(this).attr("bigImageURL"));
    });

    $("img.bigImg").load(
        function(){
            $("img.smallImage").each(function(){
                var bigImageURL = $(this).attr("bigImageURL");
                img = new Image();
                img.src = bigImageURL;
                 
                img.onload = function(){
                    $("div.img4load").append($(img));
                };
            });     
        }
    );
});
 
</script>
 
<div class="imgAndInfo">

    <%--左侧显示1张大图片，5张单个小图片--%>
    <div class="imgInimgAndInfo">
        <img src="img/productimage/single/${product.firstProductImage.id}.jpg" class="bigImg">
        <div class="smallImageDiv">
            <!-- 遍历当前产品的5张单个小图片 -->
            <c:forEach var="pi" items="${product.productSingleImages}" >
                <img src="img/productimage/single_small/${pi.id}.jpg" bigImageURL="img/productimage/single/${pi.id}.jpg" class="smallImage">
            </c:forEach>
        </div>
        <div class="img4load hidden" ></div>
    </div>

    <%--右边显示产品的基本信息（产品名，产品标题，价格，销量，库存等等）--%>
    <div class="infoInimgAndInfo">
         
        <div class="productTitle">
            ${product.name}
        </div>
        <div class="productSubTitle">
            ${product.subTitle}
        </div>

        <div class="productPrice">
            <div class="juhuasuan">
                <span class="juhuasuanBig" >聚划算</span>
                <span>此商品即将参加聚划算，<span class="juhuasuanTime">1天19小时</span>后开始，</span>
            </div>

            <div class="productPriceDiv">
                <div class="gouwujuanDiv"><img height="16px" src="img/site/gouwujuan.png">
                <span> 全天猫实物商品通用</span>
                 
                </div>
                <div class="originalDiv">
                    <span class="originalPriceDesc">价格</span>
                    <span class="originalPriceYuan">¥</span>
                    <span class="originalPrice">
                        <%--格式化标签库中的<fmt:formatNumber>标签用于格式化数字，百分比，货币。--%>
                        <fmt:formatNumber type="number" value="${product.originalPrice}" minFractionDigits="2"/>
                    </span>
                </div>

                <div class="promotionDiv">
                    <span class="promotionPriceDesc">促销价 </span>
                    <span class="promotionPriceYuan">¥</span>
                    <span class="promotionPrice">
                        <fmt:formatNumber type="number" value="${product.promotePrice}" minFractionDigits="2"/>
                    </span>
                </div>
            </div>
        </div>

        <div class="productSaleAndReviewNumber">
            <div>销量 <span class="redColor boldWord"> ${product.saleCount }</span></div>
            <div>累计评价 <span class="redColor boldWord"> ${product.reviewCount}</span></div>
        </div>
        <div class="productNumber">
            <span>数量</span>
            <span>
                <span class="productNumberSettingSpan">
                <%--输入需要购买的产品数量--%>
                <c:if test="${product.stock > 0}">
                    <input class="productNumberSetting" type="text" value="1">
                </c:if>
                <c:if test="${product.stock == 0}">
                    <input class="productNumberSetting" type="text" value="0">
                </c:if>
                </span>

                <span class="arrow">
                    <%--点击该链接可以增加购买的产品数量--%>
                    <a class="increaseNumber">
                    <span class="updown">
                            <img src="img/site/increase.png">
                    </span>
                    </a>
                     
                    <span class="updownMiddle"> </span>
                    <%--点击该链接可以减少购买的产品数量--%>
                    <a class="decreaseNumber">
                    <span class="updown">
                            <img src="img/site/decrease.png">
                    </span>
                    </a>
                </span>
            件</span>
            <span>库存${product.stock}件</span>
        </div>
        <div class="serviceCommitment">
            <span class="serviceCommitmentDesc">服务承诺</span>
            <span class="serviceCommitmentLink">
                <a href="#nowhere">正品保证</a>
                <a href="#nowhere">极速退款</a>
                <a href="#nowhere">赠运费险</a>
                <a href="#nowhere">七天无理由退换</a>
            </span>
        </div>    
         
        <div class="buyDiv">
            <c:if test="${product.stock != 0}">
                <a class="buyLink" ><button class="buyButton">立即购买</button></a>
                <a class="addCartLink"><button class="addCartButton"><span class="glyphicon glyphicon-shopping-cart"></span>加入购物车</button></a>
            </c:if>
            <c:if test="${product.stock == 0}">
                <h3 style="color: red; font-weight: bold">当前商品暂时无货，看看其他商品吧!</h3>
            </c:if>
        </div>
    </div>
     
    <div style="clear:both"></div>
     
</div>