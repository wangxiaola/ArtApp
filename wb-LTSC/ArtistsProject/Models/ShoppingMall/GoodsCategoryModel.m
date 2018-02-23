//
//  GoodsCategory.m
//  ArtistsProject
//
//  Created by 大锅 on 2017/6/10.
//  Copyright © 2017年 HELLO WORLD. All rights reserved.
//

#import "GoodsCategoryModel.h"

@implementation GoodsCategoryModel

/* 实现该方法，说明数组中存储的模型数据类型 */
+ (NSDictionary *)mj_objectClassInArray{
    return @{ @"child" : @"GoodsCategoryModel",
              };
}

@end
