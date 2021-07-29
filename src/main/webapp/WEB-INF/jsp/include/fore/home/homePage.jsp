<%--前台首页中的首页业务页面--%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" isELIgnored="false"%>

<!--为了方便维护，将首页业务页面拆分成两个小的jsp页面  -->
<div class="homepageDiv">
	<%@include file="categoryAndcarousel.jsp"%>
	<%@include file="homepageCategoryProducts.jsp"%>	
</div>

<%--
在homePage中要显示如下内容
1 天猫超市连接右侧有6个分类数据
2 竖状导航栏显示17个分类数据
3 每个分类又再对应不同的推荐产品集合
4 中部会显示17个分类
5 每个分类又显示前5款产品
6 每款产品又会显示第一张图片，标题，价格等信息
--%>





