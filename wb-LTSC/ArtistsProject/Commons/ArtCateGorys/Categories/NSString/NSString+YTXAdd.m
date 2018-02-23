//
//  NSString+YTXAdd.m
//  ShesheDa
//
//  Created by Hongwei Chen on 2016/11/8.
//  Copyright © 2016年 北京艺天下文化科技有限公司. All rights reserved.
//

#import "NSString+YTXAdd.h"

@implementation NSString (YTXAdd)

+ (NSString *)stripNullWithString:(NSString *)string {
    if ([string isKindOfClass:[NSString class]]) {
        return string;
    } else if ([string isKindOfClass:[NSNumber class]]) {
        NSNumber *sNumber = (NSNumber *)string;
        return sNumber.stringValue;
    }
    return @"";
}

- (NSString *)stringWithFormat:(NSString *)Format {
    NSTimeInterval timeInterval = [self unsignedLongLongValue];
    NSDate * date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    return [date stringWithFormat:Format timeZone:[NSTimeZone localTimeZone] locale:[NSLocale currentLocale]];
}

@end
