package com.holun.tmall.controller;

import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.holun.tmall.entity.Category;
import com.holun.tmall.entity.Property;
import com.holun.tmall.service.CategoryService;
import com.holun.tmall.service.PropertyService;
import com.holun.tmall.util.Page;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import java.util.List;

@Controller
public class PropertyController {
    private PropertyService propertyService;
    private CategoryService categoryService;

    @Autowired
    public void setPropertyService(PropertyService propertyService) {
        this.propertyService = propertyService;
    }

    @Autowired
    public void setCategoryService(CategoryService categoryService) {
        this.categoryService = categoryService;
    }

    @RequestMapping("/admin_property_list")
    public String list(int cid, Model model, Page page) {
        Category category = categoryService.queryCategoryById(cid);

        //分页显示一种分类包含的所有属性（一对多）
        PageHelper.offsetPage(page.getStart(), page.getPageSize());
        List<Property> properties = propertyService.list(cid);
        int total = (int) new PageInfo<>(properties).getTotal();
        page.setTotal(total);
        page.setParam("cid=" + category.getId());

        model.addAttribute("category", category);
        model.addAttribute("properties", properties);
        model.addAttribute("page", page);

        return "admin/listProperty";
    }

    @PostMapping("/admin_property_add")
    public String addProperty(Property property) {
        propertyService.addProperty(property);

        return "redirect:admin_property_list?cid=" + property.getCid();
    }

    @RequestMapping("/admin_property_delete")
    public String deleteProperty(int id, int cid) {
        propertyService.deletePropertyById(id);

        return "redirect:admin_property_list?cid=" + cid;
    }

    @RequestMapping("/admin_property_edit")
    public String editProperty(int id, Model model) {
        Property property = propertyService.queryPropertyById(id);
        model.addAttribute("property",property);

        return "admin/editProperty";
    }

    @PostMapping("/admin_property_update")
    public String updateProperty(Property property) {
        propertyService.updateProperty(property);

        return "redirect:admin_property_list?cid=" + property.getCid();
    }
}
