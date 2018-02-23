//
//  YTXTagsModel.m
//  ShesheDa
//
//  Created by Hongwei Chen on 2016/11/13.
//  Copyright © 2016年 北京艺天下文化科技有限公司. All rights reserved.
//

#import "YTXTagsModel.h"
#import "YTXTagsViewModel.h"

@implementation YTXTagsModel

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass {
    return @{
             @"biaoqian" : [YTXTagsViewModel class],
             @"rzlx" : [YTXTagsViewModel class],
             @"czlx" : [YTXTagsViewModel class]
             };
}

@end
