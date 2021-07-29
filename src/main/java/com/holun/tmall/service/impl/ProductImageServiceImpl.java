package com.holun.tmall.service.impl;

import com.holun.tmall.entity.ProductImage;
import com.holun.tmall.entity.ProductImageExample;
import com.holun.tmall.mapper.ProductImageMapper;
import com.holun.tmall.service.ProductImageService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.util.List;

@Service
public class ProductImageServiceImpl implements ProductImageService {
    private ProductImageMapper productImageMapper;

    @Autowired
    public void setProductImageMapper(ProductImageMapper productImageMapper) {
        this.productImageMapper = productImageMapper;
    }

    @Override
    public int addProductImage(ProductImage productImage) {
        return productImageMapper.insertSelective(productImage);
    }

    @Override
    public int deleteProductImageById(int id) {
        return productImageMapper.deleteByPrimaryKey(id);
    }

    @Override
    public ProductImage queryProductImageById(int id) {
        return productImageMapper.selectByPrimaryKey(id);
    }

    @Override
    public List<ProductImage> list(int pid, String type) {
        ProductImageExample example = new ProductImageExample();
        //根据pid（产品id），图片类型（type）查找对应的产品图片
        example.createCriteria().andPidEqualTo(pid).andTypeEqualTo(type);

        return productImageMapper.selectByExample(example);
    }
}
