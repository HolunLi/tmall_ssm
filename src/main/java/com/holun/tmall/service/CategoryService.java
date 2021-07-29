package com.holun.tmall.service;

import com.holun.tmall.entity.Category;
import java.util.List;

public interface CategoryService {

    //增加分类
    int addCategory(Category category);

    //根据id,删除某个分类
    int deleteCategoryById(int id);

    //修改某个分类（根据id,修改某个分类）
    int updateCategory(Category category);

    //根据id,查找某个分类
    Category queryCategoryById(int id);

    //查找所有的分类
    List<Category> list();

    //根据排序条件，对当前分类包含的所有产品进行排序
    void sort(Category category, String sort);

    //为查询出来的categories集合中的每个category对象的products属性注入值
    void setProducts(List<Category> categories);

    //为查询出来的category对象的products属性注入值
    void setProducts(Category category);

    //为查询出来的categories集合中的每个category对象的productsByRow属性注入值
    void setProductsByRow(List<Category> categories);

}
