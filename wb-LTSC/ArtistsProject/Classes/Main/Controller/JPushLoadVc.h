//
//  JPushLoadVc.h
//  manager
//
//  Created by sks on 16/7/7.
//  Copyright © 2016年 benbun. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark - 主分类
typedef enum {
    JPushLoadVcMainTypeOperation    = 1,   // 运营类
}JPushLoadVcMainType;

@interface JPushLoadVc : NSObject
+ (instancetype)getInstance;
- (void)loadRemoteVc:(NSDictionary *)launchOptions;
- (void)loadEnterForegroundRemoteVc:(NSDictionary *)launchOptions;
@end
