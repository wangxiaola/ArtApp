//
//  UIFont+YTXAdd.m
//  ShesheDa
//
//  Created by Hongwei Chen on 2016/11/8.
//  Copyright © 2016年 北京艺天下文化科技有限公司. All rights reserved.
//

#import "UIFont+YTXAdd.h"

@implementation UIFont (YTXAdd)

+ (UIFont *)lightFontOfSize:(CGFloat)fontSize
{
    CGFloat size = fontSize + [UIScreen screenScale];
    UIFont *font = [UIFont systemFontOfSize:size];
    return font;
}

+ (UIFont *)boldFontOfSize:(CGFloat)fontSize
{
    CGFloat size = fontSize + [UIScreen screenScale];
    UIFont *font = [UIFont boldSystemFontOfSize:size];
    return font;
}

@end
