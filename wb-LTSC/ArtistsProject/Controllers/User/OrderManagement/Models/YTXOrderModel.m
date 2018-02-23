//
//  YTXOrderModel.m
//  ShesheDa
//
//  Created by Hongwei Chen on 2016/11/14.
//  Copyright © 2016年 北京艺天下文化科技有限公司. All rights reserved.
//

#import "YTXOrderModel.h"

@implementation YTXOrderModel

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass {
    return @{
             @"user" : [YTXUser class],
             @"seller" : [YTXUser class],
             @"goods" : [YTXGoodsModel class],
             @"huiping" : [YTXHuiPingOrderModel class],
             @"zhuiping" : [YTXHuiPingOrderModel class],
             @"pinglun" : [YTXHuiPingOrderModel class]
             };
}

@end
