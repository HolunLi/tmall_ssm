package com.holun.tmall.interceptor;

import com.holun.tmall.entity.User;
import org.springframework.web.servlet.HandlerInterceptor;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;


/**
 * 后台拦截器
 * 只有管理员用户具备后台页面的访问权限
 */
public class AdminInterceptor implements HandlerInterceptor {

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        User user = (User) request.getSession().getAttribute("user");

        if (user == null) {
            response.sendRedirect("foreToLoginPage");
            return false;
        } else if (!"admin".equals(user.getName())) {
            response.sendRedirect("foreHome");
            return false;
        }

        return true;
    }
}
