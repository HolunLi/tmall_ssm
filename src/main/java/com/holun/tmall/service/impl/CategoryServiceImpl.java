package com.holun.tmall.service.impl;

import com.holun.tmall.comparator.*;
import com.holun.tmall.entity.Category;
import com.holun.tmall.entity.CategoryExample;
import com.holun.tmall.entity.Product;
import com.holun.tmall.mapper.CategoryMapper;
import com.holun.tmall.service.CategoryService;
import com.holun.tmall.service.ProductService;
import com.holun.tmall.util.ImageUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

@Service
public class CategoryServiceImpl implements CategoryService {

    private CategoryMapper categoryMapper;
    private ProductService productService;

    @Autowired
    public void setCategoryMapper(CategoryMapper categoryMapper) {
        this.categoryMapper = categoryMapper;
    }

    @Autowired
    public void setProductService(ProductService productService) {
        this.productService = productService;
    }

    @Override
    public int addCategory(Category category) {
        return categoryMapper.insertSelective(category);
    }

    @Transactional(propagation = Propagation.REQUIRED, rollbackForClassName = "Exception")
    @Override
    public void uploadCategoryImage(Category category, MultipartFile image, String path) {
        addCategory(category);

        //c.getId()+".jpg" 是上传到img/category路径下的图片的名字
        File file = new File(path,category.getId()+".jpg");
        if(!file.getParentFile().exists())
            file.getParentFile().mkdirs();
        //将图片上传到指定的路径下
        ImageUtil.uploadImageToDestination(image, file);
    }

    @Override
    public int deleteCategoryById(int id) {
        return categoryMapper.deleteByPrimaryKey(id);
    }

    @Transactional(propagation = Propagation.REQUIRED, rollbackForClassName = "Exception")
    @Override
    public void deleteUploadCategoryImage(int id, String path) {
        deleteCategoryById(id);
        ImageUtil.deleteUploadImage(path + "/" + id + ".jpg");
    }

    @Override
    public int updateCategory(Category category) {
        return categoryMapper.updateByPrimaryKeySelective(category);
    }

    @Transactional(propagation = Propagation.REQUIRED, rollbackForClassName = "Exception")
    @Override
    public void updateCategoryImage(Category category, MultipartFile image, String path) {
        updateCategory(category);

        //如果更新分类时，重新上传了图片，就将新上传的图片覆盖 G:\github_repository\tmall_ssm\target\tmall_ssm-1.0-SNAPSHOT\img\category路径下 的原图片
        if(image != null && !image.isEmpty()){
            File file = new File(path,category.getId()+".jpg");
            //将图片上传到指定的路径下
            ImageUtil.uploadImageToDestination(image, file);
        }
    }

    @Override
    public Category queryCategoryById(int id) {
        Category category = categoryMapper.selectByPrimaryKey(id);
        setProducts(category);

        return category;
    }

    @Override
    public List<Category> list() {
        CategoryExample example = new CategoryExample();
        example.setOrderByClause("id desc");

        return categoryMapper.selectByExample(example);
    }

    @Override
    public void sort(Category category, String sort) {

        switch (sort) {
            case "review":
                //Collections工具类中的sort方法可以为List集合中的元素排序，前提是需要提供一个比较器
                Collections.sort(category.getProducts(), new ProductReviewComparator());
                break;
            case "date" :
                Collections.sort(category.getProducts(), new ProductDateComparator());
                break;

            case "saleCount" :
                Collections.sort(category.getProducts(), new ProductSaleCountComparator());
                break;

            case "price":
                Collections.sort(category.getProducts(), new ProductPriceComparator());
                break;

            case "all":
                Collections.sort(category.getProducts(), new ProductAllComparator());
                break;
        }

    }

    @Override
    public void setProducts(List<Category> categories) {
        for (Category category : categories)
            setProducts(category);
    }

    @Override
    public void setProducts(Category category) {
        List<Product> products = productService.list(category.getId());
        category.setProducts(products);
    }

    @Override
    public void setProductsByRow(List<Category> categories) {
        //productNumberEachRow是首页竖状分类菜单右侧的推荐产品区域，每行显示的产品数量
        int productNumberEachRow = 8;
        for (Category category : categories) {
            //查询当前分类包含多少个产品
            List<Product> products = productService.list(category.getId());
            List<List<Product>> productsByRow =  new ArrayList<>();
            for (int i = 0; i < products.size(); i += productNumberEachRow) {
                int size = i + productNumberEachRow;
                size = size > products.size() ? products.size() : size;
                //将当前分类包含的所有产品，每8个截取一次，组成一个新的列表，作为推荐产品区域一行显示的产品。
                List<Product> productsOfEachRow = products.subList(i, size);
                productsByRow.add(productsOfEachRow);
            }
            category.setProductsByRow(productsByRow);
        }
    }
}
