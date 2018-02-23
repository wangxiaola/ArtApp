//
//  UIFont+YTXAdd.h
//  ShesheDa
//
//  Created by Hongwei Chen on 2016/11/8.
//  Copyright © 2016年 北京艺天下文化科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIFont (YTXAdd)

/**
 默认字体

 @param fontSize 字体大小
 @return 字体
 */
+ (UIFont *)lightFontOfSize:(CGFloat)fontSize;

/**
 默认粗体

 @param fontSize 字体大小
 @return 字体
 */
+ (UIFont *)boldFontOfSize:(CGFloat)fontSize;

@end
