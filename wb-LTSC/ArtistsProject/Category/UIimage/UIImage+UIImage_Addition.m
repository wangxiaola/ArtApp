//
//  UIImage+UIImage_Addition.m
//  tiangou
//
//  Created by mac on 14-3-10.
//  Copyright (c) 2014年 kedao. All rights reserved.
//

#import "UIImage+UIImage_Addition.h"

@implementation UIImage (UIImage_Addition)

//截屏
+(UIImage *)imageToScreen:(CGSize)size  view:(UIView *)view{
    //1.开启一个图片上下文
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    //获取当前的上下文.
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    //2.把控制器View的内容绘制上下文当中.
    [view.layer renderInContext:ctx];
    //3.从上下文当中取出图片
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    //4.关闭上下文.
    UIGraphicsEndImageContext();
    return newImage;
}

//等比例缩放
-(UIImage*)scaleToSize:(CGSize)size
{
    CGFloat width = CGImageGetWidth(self.CGImage);
    CGFloat height = CGImageGetHeight(self.CGImage);
    
    float verticalRadio = size.height*1.0/height;
    float horizontalRadio = size.width*1.0/width;
    
    float radio = 1;
    if(verticalRadio>1 && horizontalRadio>1)
    {
        radio = verticalRadio > horizontalRadio ? horizontalRadio : verticalRadio;
    }
    else
    {
        radio = verticalRadio < horizontalRadio ? verticalRadio : horizontalRadio;
    }
    
    width = width*radio;
    height = height*radio;
    
    int xPos = (size.width - width)/2;
    int yPos = (size.height-height)/2;
    
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(size);
    
    // 绘制改变大小的图片
    [self drawInRect:CGRectMake(xPos, yPos, width, height)];
    
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    
    // 返回新的改变大小后的图片
    return scaledImage;
}

-(UIImage*)imageWithColor:(UIColor*)color level:(CGFloat)level
{
    CGRect imageRect = CGRectMake(0.0f, 0.0f, self.size.width, self.size.height);
    
    UIGraphicsBeginImageContextWithOptions(imageRect.size, NO, self.scale);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    [self drawInRect:imageRect];
    
    CGContextSetFillColorWithColor(ctx, [color CGColor]);
    CGContextSetAlpha(ctx, level);
    CGContextSetBlendMode(ctx, kCGBlendModeSourceAtop);
    CGContextFillRect(ctx, imageRect);
    
    CGImageRef imageRef = CGBitmapContextCreateImage(ctx);
    UIImage *darkImage = [UIImage imageWithCGImage:imageRef
                                             scale:self.scale
                                       orientation:self.imageOrientation];
    CGImageRelease(imageRef);
    
    UIGraphicsEndImageContext();
    
    return darkImage;
}


//对图片尺寸进行压缩--
-(UIImage*)imageScaledToSize:(CGSize)newSize
{
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);
    
    // Tell the old image to draw in this new context, with the desired
    // new size
    [self drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // End the context
    UIGraphicsEndImageContext();
    
    // Return the new image.
    return newImage;
}


//对图片进行裁剪
-(UIImage*)imageCropedToRect:(CGRect)newRect
{
    CGImageRef imageRef = CGImageCreateWithImageInRect([self CGImage], newRect);
    UIImage *newImg = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    return newImg;
}
@end
