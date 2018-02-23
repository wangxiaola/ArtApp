//
//  YTXGoodsViewModel.m
//  ShesheDa
//
//  Created by Hongwei Chen on 2016/11/9.
//  Copyright © 2016年 北京艺天下文化科技有限公司. All rights reserved.
//

#import "YTXGoodsViewModel.h"

@implementation YTXGoodsViewModel

+ (instancetype)modelWithGoodsModel:(YTXGoodsModel *)goodsModel {
    YTXGoodsViewModel * model = [[YTXGoodsViewModel alloc]init];
    NSArray * array = [goodsModel.photos componentsSeparatedByString:@","];
    model.goodsImageURL = [NSURL URLWithString:array.firstObject];
    model.gid = goodsModel.gid;
    return model;
}

@end
