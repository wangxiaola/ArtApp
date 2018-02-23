//
//  NSString+Extension.h
//  airport
//
//  Created by T on 16/5/4.
//  Copyright © 2016年 T. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (Extension)

- (CGSize)sizeWithFont:(UIFont *)font;

+ (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxSize:(CGSize)maxSize;

+(NSString *)dictionaryToJson:(NSDictionary *)dic;

+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;

+ (NSString *)formatTimeStamp:(double)timeStamp;

+ (NSString *)timeForReadHistory;

+ (NSString *)distanceTimeWithBeforeTime:(double)beTime;

+(NSString *)filterHTML:(NSString *)html;
//七牛带水印的图片地址处理
+ (NSString *)imageUrlString:(NSString *)url;

@end
