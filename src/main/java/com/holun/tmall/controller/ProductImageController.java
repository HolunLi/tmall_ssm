package com.holun.tmall.controller;

import com.holun.tmall.entity.Product;
import com.holun.tmall.entity.ProductImage;
import com.holun.tmall.service.ProductImageService;
import com.holun.tmall.service.ProductService;
import com.holun.tmall.util.CopyData;
import com.holun.tmall.util.ImageUtil;
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
public class ProductImageController {
    private ProductImageService productImageService;
    private ProductService productService;

    @Autowired
    public void setProductImageService(ProductImageService productImageService) {
        this.productImageService = productImageService;
    }

    @Autowired
    public void setProductService(ProductService productService) {
        this.productService = productService;
    }

    @RequestMapping("/admin_productImage_list")
    public String list(int pid, Model model) {
        Product product = productService.queryProductById(pid);

        List<ProductImage> singleImages = productImageService.list(pid, ProductImageService.type_single);
        List<ProductImage> detailImages = productImageService.list(pid, ProductImageService.type_detail);

        model.addAttribute("product", product);
        model.addAttribute("singleImages", singleImages);
        model.addAttribute("detailImages", detailImages);

        return "admin/listProductImage";
    }

    @Transactional
    @PostMapping("/admin_productImage_add")
    public String addProductImage(ProductImage productImage, MultipartFile image, HttpSession session) {
        productImageService.addProductImage(productImage);
        String imageName = productImage.getId() + ".jpg";
        String imageFolder;
        String imageFolder_small = null;
        String imageFolder_middle = null;

        if (ProductImageService.type_single.equals(productImage.getType())) {
            imageFolder = session.getServletContext().getRealPath("img/productimage/single");
            imageFolder_middle = session.getServletContext().getRealPath("img/productimage/single_middle");
            imageFolder_small = session.getServletContext().getRealPath("img/productimage/single_small");
        }
        else
            imageFolder = session.getServletContext().getRealPath("img/productimage/detail");

        File file = new File(imageFolder, imageName);
        if (!file.getParentFile().exists())
            file.getParentFile().mkdirs();
        ImageUtil.uploadImageToDestination(image, file);
        //复制一份到对应的webapp路径下
        CopyData.copyUploadImageToWebapp(file);

        //如果产品图片的类型是单个类型，还需要更改产品图片的大小尺寸
        if (ProductImageService.type_single.equals(productImage.getType())) {
            //将上传的单个产品图片大小改为小尺寸，并写入到指定路径下存储
            ImageUtil.resizeImage(file, 56, 56, new File(imageFolder_small + "/" + imageName));
            //将上传的单个产品图片大小改为中尺寸，并写入到指定路径下存储
            ImageUtil.resizeImage(file, 217, 190, new File(imageFolder_middle + "/" + imageName));
        }

        return "redirect:admin_productImage_list?pid=" + productImage.getPid();
    }

    @Transactional
    @RequestMapping("/admin_productImage_delete")
    public String deleteProductImage(int id, HttpSession session) {
        ProductImage productImage = productImageService.queryProductImageById(id);
        productImageService.deleteProductImageById(id);

        File file;
        File file_webapp;
        String imageName = id + ".jpg";
        if (ProductImageService.type_single.equals(productImage.getType())) {
            //删除小号图片
            file = new File(session.getServletContext().getRealPath("img/productimage/single_small"), imageName);
            file_webapp = new File(ImageUtil.getImageFromWebapp(file));
            file.delete();
            file_webapp.delete();

            //删除中号图片
            file = new File(session.getServletContext().getRealPath("img/productimage/single_middle"), imageName);
            file_webapp = new File(ImageUtil.getImageFromWebapp(file));
            file.delete();
            file_webapp.delete();

            file = new File(session.getServletContext().getRealPath("img/productimage/single"), imageName);
        }
        else
            file = new File(session.getServletContext().getRealPath("img/productimage/detail"), imageName);

        file_webapp = new File(ImageUtil.getImageFromWebapp(file));
        file.delete();
        file_webapp.delete();

        return "redirect:admin_productImage_list?pid=" + productImage.getPid();
    }

}
