package com.holun.tmall.service.impl;

import com.holun.tmall.entity.OrderItem;
import com.holun.tmall.entity.OrderItemExample;
import com.holun.tmall.entity.Product;
import com.holun.tmall.mapper.OrderItemMapper;
import com.holun.tmall.service.OrderItemService;
import com.holun.tmall.service.OrderService;
import com.holun.tmall.service.ProductService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.util.List;

@Service
public class OrderItemServiceImpl implements OrderItemService {
    private OrderItemMapper orderItemMapper;
    private OrderService orderService;
    private ProductService productService;

    @Autowired
    public void setOrderItemMapper(OrderItemMapper orderItemMapper) {
        this.orderItemMapper = orderItemMapper;
    }

    @Autowired
    public void setProductService(ProductService productService) {
        this.productService = productService;
    }

    @Autowired
    public void setOrderService(OrderService orderService) {
        this.orderService = orderService;
    }

    @Override
    public int addOrderItem(OrderItem orderItem) {
        return orderItemMapper.insertSelective(orderItem);
    }

    @Override
    public int deleteOrderItemById(int id) {
        return orderItemMapper.deleteByPrimaryKey(id);
    }

    @Override
    public int updateOrderItem(OrderItem orderItem) {
        return orderItemMapper.updateByPrimaryKeySelective(orderItem);
    }

    @Override
    public OrderItem queryOrderItemById(int id) {
        OrderItem orderItem = orderItemMapper.selectByPrimaryKey(id);
        //为orderItem对象的product属性注入值
        setProduct(orderItem);

        return orderItem;
    }

    @Override
    public List<OrderItem> queryOrderItemByOid(int oid) {
        OrderItemExample example = new OrderItemExample();
        example.createCriteria().andOidEqualTo(oid);
        example.setOrderByClause("id desc");
        List<OrderItem> orderItems = orderItemMapper.selectByExample(example);
        //为orderItems集合中的所有orderItem对象的product属性注入值
        setProduct(orderItems);

        return orderItems;
    }

    @Override
    public List<OrderItem> listByUid(int uid) {
        OrderItemExample example = new OrderItemExample();
        example.createCriteria().andUidEqualTo(uid).andOidIsNull();
        example.setOrderByClause("id desc");
        List<OrderItem> orderItems = orderItemMapper.selectByExample(example);
        setProduct(orderItems);

        return orderItems;
    }

    @Override
    public List<OrderItem> list() {
        OrderItemExample example = new OrderItemExample();
        example.setOrderByClause("id desc");
        List<OrderItem> orderItems = orderItemMapper.selectByExample(example);
        //为orderItems集合中的所有orderItem对象的product属性注入值
        setProduct(orderItems);
        return orderItems;
    }

    @Override
    public int getSaleCount(int pid) {
        OrderItemExample example = new OrderItemExample();
        //注意这里查询出来的订单项的oid不能为null
        example.createCriteria().andPidEqualTo(pid).andOidIsNotNull();
        List<OrderItem> orderItems = orderItemMapper.selectByExample(example);

        int saleCount = 0;
        if (!orderItems.isEmpty()) {
            for (OrderItem orderItem : orderItems) {
                if ("yes".equals(orderItem.getPaymentStatus()))
                    saleCount += orderItem.getNumber();
            }
        }

        return saleCount;
    }

    @Override
    public void setProduct(List<OrderItem> orderItems) {
        for (OrderItem orderItem : orderItems)
            setProduct(orderItem);
    }

    @Override
    public void setProduct(OrderItem orderItem) {
        Product product = productService.queryProductById(orderItem.getPid());
        orderItem.setProduct(product);
    }
}
