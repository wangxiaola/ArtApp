//
//  WebTimeStamp.m
//  meishubao
//
//  Created by benbun－mac on 17/3/2.
//  Copyright © 2017年 benbun. All rights reserved.
//

#import "WebTimeStamp.h"

@implementation WebTimeStamp

+ (NSString *)webUrlWithTimeStamp:(NSString *)url
{
    if (!url||url.length == 0) {
        return url;
    }
    NSRange range = [url rangeOfString:@"?"];
    NSMutableString * newUrl = [NSMutableString stringWithString:url];
    if (range.location != NSNotFound) {
        if (![newUrl hasSuffix:@"/"]) {
            [newUrl appendString:[NSString stringWithFormat:@"&_=%ld",time(NULL)]];
        }
    }else{
        if (![newUrl hasSuffix:@"/"]) {
            [newUrl appendString:[NSString stringWithFormat:@"?_=%ld",time(NULL)]];
        }
    }
    
    return newUrl;
}

@end
