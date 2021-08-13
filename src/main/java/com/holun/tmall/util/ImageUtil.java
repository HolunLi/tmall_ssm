package com.holun.tmall.util;
import org.springframework.web.multipart.MultipartFile;
import javax.imageio.ImageIO;
import java.awt.*;
import java.awt.image.*;
import java.io.File;
import java.io.IOException;

/**
 * 处理上传的图片
 */
public class ImageUtil {
    //项目名
    private static String projectName = "tmall_ssm";
    //项目名的长度
    private static int projectNameLength = projectName.length();

    //将上传的图片的格式转换成.jpg格式（该方法是将图片格式真正的改为jpg格式，而不是简单的直接将图片的后缀改为jpg）
    public static BufferedImage changeToJpg(File f) {
        try {
            Image i = Toolkit.getDefaultToolkit().createImage(f.getAbsolutePath());
            //BufferedImage bImg = ImageIO.read(f);
            PixelGrabber pg = new PixelGrabber(i, 0, 0, -1, -1, true);
            pg.grabPixels();
            int width = pg.getWidth(), height = pg.getHeight();
            final int[] RGB_MASKS = { 0xFF0000, 0xFF00, 0xFF };
            final ColorModel RGB_OPAQUE = new DirectColorModel(32, RGB_MASKS[0], RGB_MASKS[1], RGB_MASKS[2]);
            DataBuffer buffer = new DataBufferInt((int[]) pg.getPixels(), pg.getWidth() * pg.getHeight());
            WritableRaster raster = Raster.createPackedRaster(buffer, width, height, width, RGB_MASKS, null);
            BufferedImage img = new BufferedImage(RGB_OPAQUE, raster, false, null);
            return img;
        } catch (InterruptedException e) {
            e.printStackTrace();
            return null;
        }
    }

    //改变上传图片的大小后，并将其写入到指定路径下存放
    public static void resizeImage(File srcFile, int width,int height, File destFile) {
        try {
            if(!destFile.getParentFile().exists())
                destFile.getParentFile().mkdirs();
            //将File对象转换成Image对象，前提是这个File对象指向的是一个图片文件
            Image image = ImageIO.read(srcFile);
            image = resizeImage(image, width, height);
            ImageIO.write((RenderedImage) image, "jpg", destFile);
            //将大小更改后的单个类型的产品图片复制一份到对应的webapp路径下
            copyUploadImageToWebapp(destFile);
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    //改变上传图片的大小
    public static Image resizeImage(Image srcImage, int width, int height) {
        try {
            BufferedImage buffImg = null;
            buffImg = new BufferedImage(width, height, BufferedImage.TYPE_INT_RGB);
            buffImg.getGraphics().drawImage(srcImage.getScaledInstance(width, height, Image.SCALE_SMOOTH), 0, 0, null);
            return buffImg;
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    //将图片上传到指定路径下
    public static void uploadImageToDestination(MultipartFile image, File file) {
        try {
            //将上传的图片文件写入到指定路径下存放（这一步就已经将图片写入到了指定路径下存储，后面两步只是将已存储的图片转换成jpg格式后，再重新存储）
            image.transferTo(file);
            //将已写入指定路径下的图片转换成jpg格式
            BufferedImage img = ImageUtil.changeToJpg(file);
            //将转换后的图片再以jpg格式，重新写入到指定的路径下存放（会将转换前的原图片覆盖）
            ImageIO.write(img, "jpg", file);

            //将上传的图片再复制一份到webapp路径下对应的目录
            copyUploadImageToWebapp(file);

        } catch (IOException e) {
            System.out.println("图片上传失败!");
            e.printStackTrace();
        }
    }

    //删除已上传的图片
    public static void deleteUploadImage(String... imagesLocations) {
        File file, file_webapp;

        for (String imagesLocation : imagesLocations) {
            file = new File(imagesLocation);
            file_webapp = new File(getImageFromWebapp(file));
            file.delete();
            file_webapp.delete();
        }
    }

    //将上传的图片复制一份到webapp路径下对应的目录下
    public static void copyUploadImageToWebapp(File file) {
        CopyData.copy(file.getAbsolutePath(), ImageUtil.getImageFromWebapp(file));
    }

    //获取上传的图片，在webapp路径下对应的图片的绝对路径
    public static String getImageFromWebapp(File file) {
        //项目名（tmall_ssm_rebuild），在绝对路径中第1次出现的下标
        int index_1 = file.getAbsolutePath().indexOf(projectName);
        System.out.println(index_1);
        //字符串img，在绝对路径中第1次出现的下标
        int index_2 = file.getAbsolutePath().indexOf("img");
        System.out.println(index_2);

        //target是需要替换的部分路径
        String target = file.getAbsolutePath().substring(index_1 + projectNameLength, index_2);
        System.out.println(target);
        //最终路径
        String webAppPath = file.getAbsolutePath().replace(target,"\\src\\main\\webapp\\");
        System.out.println(webAppPath);

        return webAppPath;
    }

}
