//
//  UIImage+ylmg.m
//  YunLianMeiGou
//
//  Created by mac on 2017/4/18.
//  Copyright © 2017年 namei. All rights reserved.
//

#import "UIImage+ylmg.h"

@implementation UIImage (ylmg)
+ (UIImage *)ImageWithColor:(UIColor *)backgroundColor {
    
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    
    UIGraphicsBeginImageContext(rect.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, backgroundColor.CGColor);
    
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}


// 画水印
- (UIImage *) imageWithWaterMask:(UIImage*)mask
                          inRect:(CGRect)rect
       
                        withName:(NSString *)name{
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 40000
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 4.0)
    {
        UIGraphicsBeginImageContextWithOptions([self size], NO, 0.0); // 0.0 for scale means "scale for device's main screen".
    }
#else
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 4.0)
    {
        UIGraphicsBeginImageContext([self size]);
    }
#endif
    //原图
    [self drawInRect:CGRectMake(0, 0, self.size.width, self.size.height)];
    //水印图
    [mask drawInRect:rect];
    NSMutableParagraphStyle *ps = [[NSMutableParagraphStyle alloc] init];
    [ps setAlignment:NSTextAlignmentCenter];
    
    NSDictionary *attr = @{
                           
                           NSFontAttributeName: [UIFont boldSystemFontOfSize:rect.size.height/3-4],  //设置字体
                           NSForegroundColorAttributeName : COLOR_FROM_RGB(@"#f7bb01", 1),   //设置字体颜色
                           NSParagraphStyleAttributeName :ps
                           };
    
   
    
    
    // 右下角
    [name drawInRect:CGRectMake(self.size.width - rect.size.height ,self.size.height-rect.size.height/3.0, rect.size.width, rect.size.height/3.0) withAttributes:attr];
    
    
    
    UIImage *newPic = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newPic;


}




@end
