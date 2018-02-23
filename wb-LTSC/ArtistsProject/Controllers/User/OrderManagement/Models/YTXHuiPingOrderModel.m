//
//  YTXHuiPingOrderModel.m
//  ArtistsProject
//
//  Created by 黄兵 on 2017/7/10.
//  Copyright © 2017年 HELLO WORLD. All rights reserved.
//

#import "YTXHuiPingOrderModel.h"

@implementation YTXHuiPingOrderModel
+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass {
    return @{
             @"user" : [YTXUser class]
             };
}

@end
