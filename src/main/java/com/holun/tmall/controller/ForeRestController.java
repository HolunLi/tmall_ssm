package com.holun.tmall.controller;

import com.holun.tmall.entity.Order;
import com.holun.tmall.entity.OrderItem;
import com.holun.tmall.entity.User;
import com.holun.tmall.service.OrderItemService;
import com.holun.tmall.service.OrderService;
import com.holun.tmall.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.util.HtmlUtils;
import javax.servlet.http.HttpSession;
import java.util.List;

/**
 * 前台控制器（Rest）
 */
@RestController
public class ForeRestController {
    private UserService userService;
    private OrderService orderService;
    private OrderItemService orderItemService;

    @Autowired
    public void setUserService(UserService userService) {
        this.userService = userService;
    }

    @Autowired
    public void setOrderService(OrderService orderService) {
        this.orderService = orderService;
    }

    @Autowired
    public void setOrderItemService(OrderItemService orderItemService) {
        this.orderItemService = orderItemService;
    }

    @PostMapping("/foreLogin")
    public String login(String name, String pwd, HttpSession session) {
        User user = userService.queryUserByNameAndPwd(HtmlUtils.htmlEscape(name), pwd);

        if (user == null)
            return  "fail";

        session.setAttribute("user", user);
        return "success";
    }

    @PostMapping("/foreAddCart")
    public String addCart(int pid, int number, HttpSession session) {
        User user = (User) session.getAttribute("user");
        orderItemService.addProductToCart(pid, number, user.getId());

        return "success";
    }

    @PostMapping("/foreDeleteOrder")
    public String deleteOrder(int oid, HttpSession session) {
        User user = (User) session.getAttribute("user");
        //这里对user进行判断，是为了防止由于当前页面可能停留时间过久，导致session失效。
        if (user == null)
            return "fail";

        Order order = orderService.queryOrderById(oid);
        //设置订单状态为已删除
        order.setStatus(OrderService.delete);
        orderService.updateOrder(order);
        return "success";
    }

    @PostMapping("/foreDeleteOrderItem")
    public String deleteOrderItem(int oiid, HttpSession session) {
        User user = (User) session.getAttribute("user");
        //这里对user进行判断，是为了防止由于当前页面可能停留时间过久，导致session失效。
        if (user == null)
            return "fail";

        orderItemService.deleteOrderItemById(oiid);
        return "success";
    }

    @PostMapping("/foreChangeOrderItem")
    public String changeOrderItem(int pid, int number, HttpSession session) {
        User user = (User) session.getAttribute("user");
        //这里对user进行判断，是为了防止由于当前页面可能停留时间过久，导致session失效。
        if (user == null)
            return "fail";

        List<OrderItem> orderItems = orderItemService.listByUid(user.getId());
        for (OrderItem orderItem : orderItems) {
            if (orderItem.getPid() == pid) {
                orderItem.setNumber(number);
                orderItemService.updateOrderItem(orderItem);
                break;
            }
        }

        return "success";
    }

    @RequestMapping("/foreCheckLogin")
    public String checkLogin(HttpSession session) {
        User user = (User) session.getAttribute("user");

        if (user == null)
            return "fail";
        return "success";
    }
}
