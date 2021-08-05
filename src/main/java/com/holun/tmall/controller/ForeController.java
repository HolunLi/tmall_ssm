package com.holun.tmall.controller;

import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.holun.tmall.entity.*;
import com.holun.tmall.service.*;
import com.holun.tmall.util.Page;
import org.apache.commons.lang3.RandomUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.util.HtmlUtils;
import javax.servlet.http.HttpSession;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

/**
 * 前台控制器
 */
@Controller
public class ForeController {
    private CategoryService categoryService;
    private ProductService productService;
    private ProductImageService productImageService;
    private UserService userService;
    private PropertyValueService propertyValueService;
    private ReviewService reviewService;
    private OrderService orderService;
    private OrderItemService orderItemService;

    @Autowired
    public void setCategoryService(CategoryService categoryService) {
        this.categoryService = categoryService;
    }

    @Autowired
    public void setProductService(ProductService productService) {
        this.productService = productService;
    }

    @Autowired
    public void setProductImageService(ProductImageService productImageService) {
        this.productImageService = productImageService;
    }

    @Autowired
    public void setUserService(UserService userService) {
        this.userService = userService;
    }

    @Autowired
    public void setPropertyValueService(PropertyValueService propertyValueService) {
        this.propertyValueService = propertyValueService;
    }

    @Autowired
    public void setReviewService(ReviewService reviewService) {
        this.reviewService = reviewService;
    }

    @Autowired
    public void setOrderService(OrderService orderService) {
        this.orderService = orderService;
    }

    @Autowired
    public void setOrderItemService(OrderItemService orderItemService) {
        this.orderItemService = orderItemService;
    }

    @RequestMapping({"/foreHome", "fore", "home"})
    public String home (Model model) {
        List<Category> categories = categoryService.list();
        categoryService.setProducts(categories);
        categoryService.setProductsByRow(categories);
        model.addAttribute("categories", categories);

        return "fore/home";
    }

    @PostMapping("/foreRegister")
    public String register(User user, Model model) {
        //因为有人在恶意注册的时候，会使用诸如 <script>alert('哈哈')</script> 这样的名称，会导致网页打开就弹出一个对话框。
        //那么在转义之后，就没有这个问题了。
        user.setName(HtmlUtils.htmlEscape(user.getName()));
        boolean exist = userService.isExist(user.getName());

        //若注册时，输入的用户名已存在，则服务端跳转到register.jsp，并且带上错误提示信息
        if (exist) {
            String msg = "用户名已经被使用,不能使用";
            model.addAttribute("msg", msg);
            return "fore/register";
        }
        //若注册时，输入的用户名不存在，就将这个用户添加到user表中，并重定向到registerSuccess.jsp页面
        userService.addUser(user);

        return "redirect:foreToRegisterSuccessPage";
    }

    @PostMapping("/foreLogin")
    @ResponseBody
    public String login(String name, String pwd, HttpSession session) {
        User user = userService.queryUserByNameAndPwd(HtmlUtils.htmlEscape(name), pwd);

        if (user == null)
            return  "fail";

        session.setAttribute("user", user);
        return "success";
    }

    @RequestMapping("/foreLogout")
    public String logout(HttpSession session) {
        session.removeAttribute("user");

        return "redirect:foreHome";
    }

    @RequestMapping("/foreCart")
    public String cart(Model model, HttpSession session) {
        User user = (User) session.getAttribute("user");
        List<OrderItem> orderItems = orderItemService.listByUid(user.getId());

        model.addAttribute("orderItems", orderItems);

        return "fore/cart";
    }

    @RequestMapping("/foreBought")
    public String bought(HttpSession session, Model model) {
        User user = (User) session.getAttribute("user");
        List<Order> orders = orderService.list(user.getId(), OrderService.delete);

        model.addAttribute("orders", orders);

        return "fore/bought";
    }

    @RequestMapping("/foreProduct")
    public String product(int pid, Model model) {
        Product product = productService.queryProductById(pid);
        List<ProductImage> singleImages = productImageService.list(product.getId(), ProductImageService.type_single);
        List<ProductImage> detailImages = productImageService.list(product.getId(), ProductImageService.type_detail);
        product.setProductSingleImages(singleImages);
        product.setProductDetailImages(detailImages);

        List<PropertyValue> propertyValues = propertyValueService.list(product.getId());
        List<Review> reviews = reviewService.queryReviewByPid(product.getId());

        model.addAttribute("product", product);
        model.addAttribute("propertyValues", propertyValues);
        model.addAttribute("reviews", reviews);

        return "fore/product";
    }

    @RequestMapping("/foreCategory")
    public String category(int cid, String sort, Model model) {
        Category category = categoryService.queryCategoryById(cid);

        if (sort != null) {
            categoryService.sort(category, sort);
        }

        model.addAttribute("category", category);

        return "fore/category";
    }

    @RequestMapping("/foreSearch")
    public String search(String keyword, Page page, Model model) {
        //搜索出来的产品,每页只显示20个
        page.setPageSize(20);
        PageHelper.offsetPage(page.getStart(), page.getPageSize());
        List<Product> products = productService.search(keyword);
        int total = (int) new PageInfo<>(products).getTotal();
        page.setTotal(total);
        page.setParam("&keyword=" + keyword);

        model.addAttribute("page", page);
        model.addAttribute("products", products);

        return "fore/searchResult";
    }

    @PostMapping("/foreAddCart")
    @ResponseBody
    public String addCart(int pid, int number, HttpSession session) {
        User user = (User) session.getAttribute("user");
        orderItemService.addProductToCart(pid, number, user.getId());

        return "success";
    }

    @RequestMapping("/foreBuyFromProductPage")
    public String buyFromProductPage(int pid, int number, HttpSession session) {
        Product product = productService.queryProductById(pid);

        OrderItem orderItem = new OrderItem();
        orderItem.setNumber(number);
        orderItem.setPid(pid);
        orderItem.setUid(((User) session.getAttribute("user")).getId());
        orderItem.setProduct(product);

        session.setAttribute("orderItem", orderItem);
        session.setAttribute("from", "productPage");

        return "redirect:foreToBuyPage?total=" + product.getPromotePrice() * number;
    }

    @RequestMapping("/foreBuyFromCart")
    public String buyFromCart(int[] oiid, HttpSession session) {
        List<OrderItem> orderItems = new ArrayList<>();
        int total = 0;

        for (int id : oiid) {
            OrderItem orderItem = orderItemService.queryOrderItemById(id);
            total += orderItem.getNumber() * orderItem.getProduct().getPromotePrice();
            orderItems.add(orderItem);
        }

        session.setAttribute("orderItems", orderItems);
        session.setAttribute("from", "cart");

        return "redirect:foreToBuyPage?total=" + total;
    }

    @PostMapping("/foreCreateOrder")
    public String createOrder(Order order, HttpSession session) {
        //设置订单的键uid
        order.setUid(((User) session.getAttribute("user")).getId());
        //设置订单编号（订单编号由当前日期+四位随机数组成）
        order.setOrderCode(new SimpleDateFormat("yyyyMMddHHmmssSSS").format(new Date()) + RandomUtils.nextInt(0, 10000));
        //设置订单状态为待付款
        order.setStatus(OrderService.waitPay);
        //设置创建订单的日期
        order.setCreateDate(new Date());

        float total;
        String from = (String) session.getAttribute("from");
        if ("cart".equals(from))
            total = orderService.addOrderAndUpdateOrderItem(order, (List<OrderItem>) session.getAttribute("orderItems"));
        else
            total = orderService.addOrderAndOrderItem(order, (OrderItem) session.getAttribute("orderItem"));

        return "redirect:foreToAlipayPage?oid="+order.getId()+"&total="+total;
    }

    @RequestMapping("/forePayed")
    public String payed(int oid, Model model) {
        Order order = orderService.queryOrderById(oid);
        //设置订单的状态为待发货
        order.setStatus(OrderService.waitDelivery);
        //设置订单的付款日期
        order.setPayDate(new Date());
        //修改当前订单的信息,订单项的信息并且修改产品库存
        orderService.updateOrderAndOrderItemAndProductStock(order);
        model.addAttribute("order", order);

        return "fore/payed";
    }

    @RequestMapping("/foreConfirmPay")
    public String confirmPay(int oid, Model model) {
        Order order = orderService.queryOrderById(oid);
        model.addAttribute("order", order);

        return "fore/confirmPay";
    }

    @RequestMapping("/foreOrderConfirmed")
    public String orderConfirmed(int oid) {
        Order order = orderService.queryOrderById(oid);
        //设置订单状态为待评价
        order.setStatus(OrderService.waitReview);
        //设置收货日期
        order.setConfirmDate(new Date());
        orderService.updateOrder(order);

        return "fore/orderConfirmed";
    }

    @RequestMapping("/foreReview")
    public String review(int oid, int pid, Model model) {
        Order order = orderService.queryOrderById(oid);
        Product product = productService.queryProductById(pid);
        List<Review> reviews = reviewService.queryReviewByPid(product.getId());

        model.addAttribute("order", order);
        model.addAttribute("product", product);
        model.addAttribute("reviews", reviews);

        return "fore/review";
    }

    @PostMapping("/foreDoReview")
    public String doReview(int oid, int pid, int oiid, String content, HttpSession session) {
        Order order = orderService.queryOrderById(oid);
        OrderItem orderItem = orderItemService.queryOrderItemById(oiid);

        Review review = new Review();
        review.setContent(HtmlUtils.htmlEscape(content));
        review.setUid(((User) session.getAttribute("user")).getId());
        review.setPid(pid);
        review.setCreateDate(new Date());

        orderService.updateOrderAndOrderItemAndAddReview(order, orderItem, review);

        return "redirect:foreReview?oid="+oid+"&pid="+pid+"&showonly=true";
    }

    @PostMapping("/foreDeleteOrder")
    @ResponseBody
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
    @ResponseBody
    public String deleteOrderItem(int oiid, HttpSession session) {
        User user = (User) session.getAttribute("user");
        //这里对user进行判断，是为了防止由于当前页面可能停留时间过久，导致session失效。
        if (user == null)
            return "fail";

        orderItemService.deleteOrderItemById(oiid);
        return "success";
    }

    @PostMapping("/foreChangeOrderItem")
    @ResponseBody
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
    @ResponseBody
    public String checkLogin(HttpSession session) {
        User user = (User) session.getAttribute("user");

        if (user == null)
            return "fail";
        return "success";
    }

    @PostMapping("/foreLoginAjax")
    @ResponseBody
    public String loginAjax(String name, String pwd, HttpSession session) {
        User user = userService.queryUserByNameAndPwd(HtmlUtils.htmlEscape(name), pwd);

        if (user == null)
            return "fail";
        session.setAttribute("user", user);
        return "success";
    }

}
