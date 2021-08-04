package com.holun.tmall.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

/**
 * 页面控制器（用于重定向到指定的页面）
 */
@Controller
public class PageController {

    @RequestMapping("/foreToLoginPage")
    public String toLoginPage() {
        return "fore/login";
    }

    @RequestMapping("/foreToRegisterPage")
    public String toRegisterPage() {
        return "fore/register";
    }

    @RequestMapping("/foreToRegisterSuccessPage")
    public String toRegisterSuccessPage() {
        return "fore/registerSuccess";
    }

    @RequestMapping("/foreToBuyPage")
    public String toBuyPage() {
        return "fore/buy";
    }

    @RequestMapping("/foreToAlipayPage")
    public String toAlipayPage(){
        return "fore/alipay";
    }

    @RequestMapping("/admin")
    public String admin() {
        return "redirect:admin_category_list";
    }
}
