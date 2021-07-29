package com.holun.tmall.controller;

import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.holun.tmall.entity.Category;
import com.holun.tmall.service.CategoryService;
import com.holun.tmall.util.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.multipart.MultipartFile;
import javax.servlet.http.HttpSession;
import java.io.File;
import java.util.List;

@Controller
public class CategoryController {

    private CategoryService categoryService;

    @Autowired
    public void setCategoryService(CategoryService categoryService) {
        this.categoryService = categoryService;
    }

    @RequestMapping("/admin_category_list")
    public String list(Model model, Page page) {

        /*使用pageHelp插件进行分页显示所有的分类，以下三个步骤必须严格按照顺序*/
        //第一步：通过分页插件指定分页参数（从第几条数据开始，每页显示几条数据）
        PageHelper.offsetPage(page.getStart(), page.getPageSize());
        //第二步：查询出category表中所有的数据
        List<Category> cs = categoryService.list();
        //第三步：通过PageInfo计算总共有几条数据
        int total = (int) new PageInfo<>(cs).getTotal();
        page.setTotal(total);
        model.addAttribute("cs", cs);
        model.addAttribute("page", page);

        return "admin/listCategory";
    }

    /**
     *MultipartFile是spring框架提供的类型，代表表单中以"multipart/form-data"方式上传的文件，包含二进制数据+文件名称。
     * 使用org.springframework.mock.web.MockMultipartFile类型 需要导入spring-test.jar
     * 因此在addCategory方法中使用MultipartFile对象用来接收从前端页面上传的文件（图片，文本等类型的文件）
     * 这里需要注意是MultipartFile对象的名字image,必须和页面中的增加分类部分中的type="file"的 name属性值保持一致。
     */
    @Transactional
    @PostMapping("/admin_category_add")
    public String addCategory(Category c, HttpSession session, MultipartFile image) {
        categoryService.addCategory(c);

        //获取图片存放的路径（图片上传到G:\myproject\tmall_ssm_rebuild\target\tmall_ssm_rebuild_war_exploded\img\category路径下）
        String path = session.getServletContext().getRealPath("img/category");
        //c.getId()+".jpg" 是上传到img/category路径下的图片的名字
        File file = new File(path,c.getId()+".jpg");
        if(!file.getParentFile().exists())
            file.getParentFile().mkdirs();

        //将图片上传到指定的路径下
        ImageUtil.uploadImageToDestination(image, file);

        return "redirect:admin_category_list";
    }

    @Transactional
    @RequestMapping("/admin_category_delete")
    public String deleteCategory(int id, HttpSession session) {
        categoryService.deleteCategoryById(id);

        String path = session.getServletContext().getRealPath("img/category");
        File file1 = new File(path, id + ".jpg");
        File file2 = new File(ImageUtil.getImageFromWebapp(file1));
        file1.delete();
        file2.delete();

        return "redirect:admin_category_list";
    } 
    
    @RequestMapping("/admin_category_edit")
    public String editCategory(int id, Model model) {
        Category category = categoryService.queryCategoryById(id);
        model.addAttribute("category", category);

        return "admin/editCategory";
    }

    @Transactional
    @PostMapping("/admin_category_update")
    public String updateCategory(Category category, HttpSession session, MultipartFile image) {
        categoryService.updateCategory(category);

        //如果更新分类时，重新上传了图片，就将新上传的图片覆盖 G:\myproject\tmall_ssm_rebuild\target\tmall_ssm_rebuild_Web_exploded\img\category路径下 的原图片
        if(image != null && !image.isEmpty()){
            String path = session.getServletContext().getRealPath("img/category");
            File  file = new File(path,category.getId() + ".jpg");

            //将图片上传到指定的路径下
            ImageUtil.uploadImageToDestination(image, file);
        }

        return "redirect:admin_category_list";
    }
}
