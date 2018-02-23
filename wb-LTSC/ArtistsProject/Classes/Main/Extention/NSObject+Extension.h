//
//  NSObject+Extension.h
//  zhenrongbao
//
//  Created by liu on 15/7/29.
//  Copyright (c) 2015年 zhenrongbao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

@interface NSObject (Extension)

-(NSArray *)properties;

-(NSString *)className;

+ (NSString *)identifier;

@end
