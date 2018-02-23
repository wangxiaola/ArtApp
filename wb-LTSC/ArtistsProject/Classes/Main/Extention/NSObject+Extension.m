//
//  NSObject+Extension.m
//  zhenrongbao
//
//  Created by liu on 15/7/29.
//  Copyright (c) 2015年 zhenrongbao. All rights reserved.
//

#import "NSObject+Extension.h"

@implementation NSObject (Extension)

-(NSArray *)properties
{
    unsigned int count;
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    objc_property_t *property_t = class_copyPropertyList([self class], &count);
    
    for (int i = 0; i < count; i++) {
        objc_property_t item = property_t[i];
        const char *tmp = property_getName(item);
        [array addObject:[NSString stringWithCString:tmp encoding:NSUTF8StringEncoding]];
    }
    
    return array;
}

-(NSString *)className
{
    return [NSString stringWithUTF8String:class_getName([self class])];
}

+ (NSString *)identifier {

    return NSStringFromClass(self);
}

@end
