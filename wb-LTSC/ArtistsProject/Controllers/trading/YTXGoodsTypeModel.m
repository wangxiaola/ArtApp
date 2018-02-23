//
//  YTXGoodsTypeModel.m
//  ShesheDa
//
//  Created by Hongwei Chen on 2016/11/9.
//  Copyright © 2016年 北京艺天下文化科技有限公司. All rights reserved.
//

#import "YTXGoodsTypeModel.h"

@implementation YTXGoodsTypeModel

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass {
    return @{
             @"child" : [YTXGoodsTypeModel class]
             };
}

@end
