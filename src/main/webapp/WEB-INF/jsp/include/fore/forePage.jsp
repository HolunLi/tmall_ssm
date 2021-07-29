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
          <span aria-hidden="true">首页</span>
        </a>
      </li>

      <%-- 上一页超链接--%>
      <li <c:if test="${!page.hasPrevious}"> class="disabled"</c:if>>  <%-- hasPrevious会的导致isHasPrevious()方法被调用--%>
        <a href="?start=${page.start - page.pageSize}${page.param}" aria-label="Previous" >
          <span aria-hidden="true">上一页</span>
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
          <span aria-hidden="true">下一页</span>
        </a>
      </li>

      <%--尾页超链接--%>
      <li <c:if test="${!page.hasNext}"> class="disabled"</c:if>> <%--hasNext会的导致isHasNext()方法被调用--%>
        <a href="?start=${page.lastPage}${page.param}" aria-label="Next">
          <span aria-hidden="true">尾页</span>
        </a>
      </li>
    </ul>
  </nav>

