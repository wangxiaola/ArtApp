//
//  CategoryInfoModel.m
//  Car
//
//  Created by HeLiulin on 15/8/10.
//  Copyright (c) 上海翔汇网络科技有限公司. All rights reserved.
//

#import "CategoryInfoModel.h"

@implementation CategoryInfoModel
+ (NSDictionary *)objectClassInArray
{
    return @{
             @"subCategoryList" : [CategoryInfoModel class]
             };
}

@end
