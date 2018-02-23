//
//  NSDateEx.h
//  HUIKitLib_Demo
//
//  Created by HeLiulin on 15/11/17.
//  Copyright © 2015年 上海翔汇网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Extension)
/**
 *  格式化时间
 *
 *  @param format 格式（yyyy/MM/dd）
 *
 *  @return 字符串
 */
- (NSString*) formatWithString:(NSString *)format;

/**
 *  通过时间字符串创建一个NSDate对象
 *
 *  @param format     时间格式（默认:yyyy/MM/dd HH:mm:ss)
 *
 *  @return NSDate对象
 */
+ (NSDate*) dateWithString:(NSString*)dateString withFormat:(NSString*)format;

@end
