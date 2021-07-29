package com.holun.tmall.interceptor;

import com.holun.tmall.entity.Category;
import com.holun.tmall.entity.OrderItem;
import com.holun.tmall.entity.User;
import com.holun.tmall.service.CategoryService;
import com.holun.tmall.service.OrderItemService;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.servlet.HandlerInterceptor;
import org.springframework.web.servlet.ModelAndView;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.util.Arrays;
import java.util.List;

/**
 * 前台拦截器
 * 对访问购物车页面的请求和访问我的订单页面的请求进行拦截，确保这两个个页面只有在已登录的情况下才能访问
 * 对其它前台页面的请求拦截后，不做处理直接放行
 * 拦截器实际也是AOP思想的实现
 */
public class ForeInterceptor implements HandlerInterceptor {
    private CategoryService categoryService;
    private OrderItemService orderItemService;

    @Autowired
    public void setCategoryService(CategoryService categoryService) {
        this.categoryService = categoryService;
    }

    @Autowired
    public void setOrderItemService(OrderItemService orderItemService) {
        this.orderItemService = orderItemService;
    }

    //拦截器中的preHandle方法，会在处理器处理请求之前被调用
    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        HttpSession session = request.getSession();
        //需要登录后，才能访问的页面（比如购物车页面，我的订单页面）
        String[] needAuthPage = new String[]{"Cart", "Bought"};
        //获取上下文路径
        String contextPath = session.getServletContext().getContextPath();
        //获取请求的uri
        String requestURI = request.getRequestURI();
        //StringUtils是org.apache.commons.lang3包中提供给的类，使用时需要导入commons.lang3依赖
        requestURI = StringUtils.remove(requestURI, contextPath);
        String method = StringUtils.substringAfterLast(requestURI, "/fore");

        //Arrays类中的asList方法可以将一个数组转化成ArrayList集合
        if (Arrays.asList(needAuthPage).contains(method)) {
            User user = (User) session.getAttribute("user");
            if (user == null) {
                //未登录，重定向到登录页面
                response.sendRedirect("foreToLoginPage");
                return false;
            }
        }

        //对于其它前台页面的请求直接放行
        return true;
    }

    /**
     * postHandle方法会在处理器处理请求完成后,生成视图之前被调用
     * 因此可以在将数据渲染到视图之前，往modelAndView中再添加一些数据
     */
    @Override
    public void postHandle(HttpServletRequest request, HttpServletResponse response, Object handler, ModelAndView modelAndView) throws Exception {
        HttpSession session = request.getSession();

        String contextPath = session.getServletContext().getContextPath();
        modelAndView.addObject("contextPath", contextPath);

        String requestURI = StringUtils.remove(request.getRequestURI(), contextPath);
        String method = StringUtils.substringAfterLast(requestURI, "/fore");
        if ("Home".equals(method)) {
            System.out.println("不做处理");
        }
        else {
            List<Category> categories = categoryService.list();
            modelAndView.addObject("categories", categories);
        }

        User user = (User) session.getAttribute("user");
        //该变量用于记录购物车中商品的个数
        int cartTotalItemNumber = 0;
        if (user != null) {
            List<OrderItem> orderItems = orderItemService.listByUid(user.getId());
            for (OrderItem orderItem : orderItems) {
                cartTotalItemNumber += orderItem.getNumber();
            }
        }
        modelAndView.addObject("cartTotalItemNumber", cartTotalItemNumber);
    }
}
