//
//  UIColor+UIrgb.h
//  YunLianMeiGou
//
//  Created by namei on 16/3/15.
//  Copyright © 2016年 namei.com. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UIColor (UIRBG)

+ (UIColor *)mgColorWithRGB:(NSString *)rgb alpha:(float)alpha;

+ (UIColor *)rgb:(NSString *)rgb alpha:(float)alpha;

+ (UIColor *)rgbfrom:(NSString *)from to:(NSString *)to value:(float)value;

+ (UIColor *)rgbColorForm:(UIColor *)from to:(UIColor *)to value:(float)value;


@end
