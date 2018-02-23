//
//  NSString+ToString.h
//  NSStringToExample
//
//  Created by yangliu on 15/3/23.
//  Copyright (c) 2015年 yangliu. All rights reserved.
//

#import <Foundation/Foundation.h>

/*!
 @brief 检测是否是实际合法字符串
 @create by yangliu
 */
@interface NSString (ToString)

/*!
 @methods
 @brief 输出实际合法字符串
 @return nil | 实际值
 */
+ (NSString *)validString:(NSString *)string;

/*!
 @methods
 @brief 检测是否是空字符串，nil、@""
 */
+ (BOOL)isNull:(NSString *)string;

+ (NSString *)notNilString:(NSString *)string;

+ (NSString *)filterHTML:(NSString *)html;

+ (BOOL)isPureNumandCharacters:(NSString *)string;
@end
