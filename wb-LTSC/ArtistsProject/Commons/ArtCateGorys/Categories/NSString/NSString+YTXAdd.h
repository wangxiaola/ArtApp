//
//  NSString+YTXAdd.h
//  ShesheDa
//
//  Created by Hongwei Chen on 2016/11/8.
//  Copyright © 2016年 北京艺天下文化科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (YTXAdd)

/**
 过滤NSNull

 @return 过滤NSNull后的字符串
 */
+ (NSString *)stripNullWithString:(NSString *)string;

/**
 Returns a formatted string representing this date.
@param format    String representing the desired date format.
 e.g. @"yyyy-MM-dd HH:mm:ss"
 @return NSString representing the formatted date string.
 */
- (NSString *)stringWithFormat:(NSString *)Format;

@end
