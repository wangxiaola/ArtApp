//
//  UIImage+UIImage_Addition.h
//  tiangou
//
//  Created by mac on 14-3-10.
//  Copyright (c) 2014年 kedao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (UIImage_Addition)

//等比例缩放
-(UIImage*)scaleToSize:(CGSize)size;

// 增加亮度和颜色
-(UIImage*)imageWithColor:(UIColor*)color level:(CGFloat)level;

//对图片尺寸进行压缩
-(UIImage*)imageScaledToSize:(CGSize)newSize;

//对图片进行裁剪
-(UIImage*)imageCropedToRect:(CGRect)newRect;


//截屏
+(UIImage *)imageToScreen:(CGSize)size view:(UIView *)view;

@end
