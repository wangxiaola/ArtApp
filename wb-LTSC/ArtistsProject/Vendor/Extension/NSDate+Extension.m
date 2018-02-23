//
//  NSDateEx.m
//  HUIKitLib_Demo
//
//  Created by HeLiulin on 15/11/17.
//  Copyright © 2015年 上海翔汇网络科技有限公司. All rights reserved.
//

#import "NSDate+Extension.h"

@implementation NSDate (Extension)
- (NSString*)formatWithString:(NSString*)format;
{
    NSDateFormatter* dateformatter = [[NSDateFormatter alloc] init];
    
    [dateformatter setDateFormat:format];
    
    NSString* locationString = [dateformatter stringFromDate:self];
    return locationString;
}
+ (NSDate*) dateWithString:(NSString*)dateString withFormat:(NSString*)format
{
    if (!format) format=@"yyyy/MM/dd HH:mm:ss";
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSTimeZone *timeZone = [NSTimeZone localTimeZone];
    [dateFormatter setTimeZone:timeZone];
    [dateFormatter setDateFormat: format];
    NSDate *destDate= [dateFormatter dateFromString:dateString];
    return destDate;
}
@end
