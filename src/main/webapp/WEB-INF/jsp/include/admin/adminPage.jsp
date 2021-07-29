<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false"%>

<script>

$(function(){
	$("ul.pagination li.disabled a").click(function(){
		return false;
	});
});

</script>

<nav>
  <ul class="pagination">

      <%--首页超链接--%>
    <li <c:if test="${!page.hasPrevious}"> class="disabled"</c:if>>
      <a href="?start=0${page.param}" aria-label="Previous" >
        <span aria-hidden="true">&laquo;</span>
      </a>
    </li>

         <%--
          <a href="?start=0${page.param}" aria-label="Previous" > 等价于
          <a href="http://localhost:8888/tmall_ssm/admin_category_list?start=0${page.param}" aria-label="Previous" >
              ?号前面省略url，, 默认就是当前页面的地址。
         --%>

      <%-- 上一页超链接--%>
    <li <c:if test="${!page.hasPrevious}"> class="disabled"</c:if>>  <%-- hasPrevious会的导致isHasPrevious()方法被调用--%>
      <a href="?start=${page.start - page.pageSize}${page.param}" aria-label="Previous" >
        <span aria-hidden="true">&lsaquo;</span>
      </a>
    </li>

      <%--中间页超链接--%>
    <c:forEach begin="0" end="${page.totalPage - 1}" varStatus="status">
    	
		    <li <c:if test="${status.index * page.pageSize == page.start}"> class="disabled"</c:if>>
		    	<a href="?start=${status.index * page.pageSize}${page.param}">${status.count}</a>
		    </li>

    </c:forEach>

      <%--下一页超链接--%>
    <li <c:if test="${!page.hasNext}"> class="disabled"</c:if>>
      <a href="?start=${page.start+page.pageSize}${page.param}" aria-label="Next">
        <span aria-hidden="true">&rsaquo;</span>
      </a>
    </li>

      <%--尾页超链接--%>
    <li <c:if test="${!page.hasNext}"> class="disabled"</c:if>> <%--hasNext会的导致isHasNext()方法被调用--%>
      <a href="?start=${page.lastPage}${page.param}" aria-label="Next">
        <span aria-hidden="true">&raquo;</span>
      </a>
    </li>
  </ul>
</nav>
