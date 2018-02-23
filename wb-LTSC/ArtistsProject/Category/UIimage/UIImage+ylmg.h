//
//  UIImage+ylmg.h
//  YunLianMeiGou
//
//  Created by mac on 2017/4/18.
//  Copyright © 2017年 namei. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UIImage (ylmg)

+ (UIImage *)ImageWithColor:(UIColor *)backgroundColor;

// 画水印
- (UIImage *) imageWithWaterMask:(UIImage*)mask
                          inRect:(CGRect)rect

                        withName:(NSString *)name;

@end
