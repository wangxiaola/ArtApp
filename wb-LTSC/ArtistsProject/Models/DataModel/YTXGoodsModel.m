//
//  YTXGoodsModel.m
//  ShesheDa
//
//  Created by Hongwei Chen on 2016/11/9.
//  Copyright © 2016年 北京艺天下文化科技有限公司. All rights reserved.
//

#import "YTXGoodsModel.h"

@implementation YTXGoodsModel

+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper {
    return @{
             @"gid" : @"id",
             @"goodslong" : @"long"
             };
}

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass {
    return @{
             @"user" : [YTXUser class],
             @"photoscbk" : [YTXPhoto class],
             @"likeuser" : [YTXUser class]
             };
}

@end

@implementation YTXPhoto


@end
