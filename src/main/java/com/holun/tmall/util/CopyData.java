package com.holun.tmall.util;

/*
*用于文件和目录的复制
*/
import java.io.*;

public class CopyData{

    public static void copy(String source, String target){
        if((new File(source)).isFile()){
            copyFile(new File(source),new File(target));
        }else if((new File(source)).isDirectory()){
            copyDirectory(source,target);
        }
    }

    //将某个文件复制到指定的位置
    private static void copyFile(File sourceFile,File targetFile){
        if(!sourceFile.canRead()){
            System.out.println("源文件" + sourceFile.getAbsolutePath() + "不可读，无法复制！");
            return;
        }else{
            System.out.println("开始复制文件 " + sourceFile.getAbsolutePath() + " 到 " + targetFile.getAbsolutePath());
            FileInputStream fis = null;
            BufferedInputStream bis = null;
            FileOutputStream fos = null;
            BufferedOutputStream bos = null;

            try{
                fis = new FileInputStream(sourceFile);
                bis = new BufferedInputStream(fis);
                fos = new FileOutputStream(targetFile);
                bos = new BufferedOutputStream(fos);
                int len = 0;
                while((len = bis.read()) != -1){
                    bos.write(len);
                }
                bos.flush();

            }catch(FileNotFoundException e){
                e.printStackTrace();
            }catch(IOException e){
                e.printStackTrace();
            }finally{
                try{
                    if(fis != null){
                        fis.close();
                    }
                    if(bis != null){
                        bis.close();
                    }
                    if(fos != null){
                        fos.close();
                    }
                    if(bos != null){
                        bos.close();
                    }
                    System.out.println("文件 " + sourceFile.getAbsolutePath() + " 复制到 " + targetFile.getAbsolutePath() + " 完成");
                }catch(IOException e){
                    e.printStackTrace();
                }
            }
        }
    }

    //将某个目录中所有数据复制到指定的目录
    private static void copyDirectory(String sourcePathString,String targetPathString){
        if(!new File(sourcePathString).canRead()){
            System.out.println("源文件夹" + sourcePathString + "不可读，无法复制！");
            return;
        }else{
            (new File(targetPathString)).mkdirs();
            System.out.println("开始复制文件夹 " + sourcePathString + " 到 " + targetPathString);
            File[] files = new File(sourcePathString).listFiles();
            for(int i = 0; i < files.length; i++){
                if(files[i].isFile()){
                    copyFile(new File(sourcePathString + File.separator + files[i].getName()),new File(targetPathString + File.separator + files[i].getName()));
                }else if(files[i].isDirectory()){
                    copyDirectory(sourcePathString + File.separator + files[i].getName(),targetPathString + File.separator + files[i].getName());
                }
            }
            System.out.println("复制文件夹 " + sourcePathString + " 到 " + targetPathString + " 结束");
        }
    }

    //将上传的图片复制一份到webapp路径下对应的目录下
    public static void copyUploadImageToWebapp(File file) {
        CopyData.copy(file.getAbsolutePath(), ImageUtil.getImageFromWebapp(file));
    }
}


