//
//  NSString+ToString.m
//  NSStringToExample
//
//  Created by yangliu on 15/3/23.
//  Copyright (c) 2015年 yangliu. All rights reserved.
//

#import "NSString+ToString.h"

@implementation NSString (ToString)

- (NSString *)toValidString {

    if (self && (NSNull *)self != [NSNull null] && ![self isEqualToString:@"(null)"] && ![self isEqualToString:@"<null>"] && self.length > 0) {
        
        return self;
    }
    
    return nil;
}

/*! 1000(千)以上换算成k，100000(十万)以上换算成w */
- (NSString *)numberTransfer {
    
    float num = [self floatValue];
    
    if (num >= 100000) {
        
        return [NSString stringWithFormat:@"%.1fm", num / 10000.f];
    } else if (num >= 1000) {
        
        return [NSString stringWithFormat:@"%.1fk", num / 1000.f];
    }
    
    return self;
}

+ (NSString *)validString:(NSString *)string {
    
    if (string != nil &&
        (NSNull *)string != [NSNull null] &&
        [string isKindOfClass:[NSString class]] &&
        ![string isEqualToString:@"(null)"] &&
        ![string isEqualToString:@"<null>"] && string.length > 0) {
        
        return string;
    }
    
    return nil;
}

+ (BOOL)isNull:(NSString *)string {
    
    string = [NSString validString:string];
    
    if (string == nil) {
        
        return YES;
    }
    
    return NO;
}

+ (NSString *)notNilString:(NSString *)string {
    
    string = [NSString validString:string];
    
    if (string == nil) {
        
        return @"";
    }
    
    return string;
}

+ (NSString *)filterHTML:(NSString *)html{
        NSScanner * scanner = [NSScanner scannerWithString:html];
        NSString * text = nil;
        while([scanner isAtEnd]==NO){
            [scanner scanUpToString:@"<" intoString:nil];
            [scanner scanUpToString:@">" intoString:&text];
            html = [html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>",text] withString:@""];
        }
    html = [html stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@" "];
    html = [html stringByReplacingOccurrencesOfString:@"&quot;" withString:@" "];
    html = [html stringByReplacingOccurrencesOfString:@"&apos;" withString:@" "];
    html = [html stringByReplacingOccurrencesOfString:@"&lt;" withString:@" "];
    html = [html stringByReplacingOccurrencesOfString:@"&gt;" withString:@" "];
    html = [html stringByReplacingOccurrencesOfString:@"&amp;" withString:@" "];
    return html;
}

+ (BOOL)isPureNumandCharacters:(NSString *)string
{
    string = [string stringByTrimmingCharactersInSet:[NSCharacterSet decimalDigitCharacterSet]];
    if(string.length > 0)
    {
        return NO;
    }
    return YES;
}

@end
