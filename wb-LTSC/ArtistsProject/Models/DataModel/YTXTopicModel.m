//
//  YTXTopicModel.m
//  ShesheDa
//
//  Created by 徐建波 on 2016/11/17.
//  Copyright © 2016年 北京艺天下文化科技有限公司. All rights reserved.
//

#import "YTXTopicModel.h"
#import "YTXUser.h"

@implementation YTXTopicModel

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass {
    return @{
             @"user" : [YTXUser class]
             };
}

@end
