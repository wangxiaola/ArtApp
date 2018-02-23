//
//  YTXOrderConfirmViewModel.m
//  ShesheDa
//
//  Created by Hongwei Chen on 2016/11/12.
//  Copyright © 2016年 北京艺天下文化科技有限公司. All rights reserved.
//

#import "YTXOrderConfirmViewModel.h"
#import "YTXGoodsModel.h"
#import "YTXAddressModel.h"

@implementation YTXOrderConfirmViewModel

+ (instancetype)modelWithGoodsModel:(YTXGoodsModel *)goodsModel
                       addressModel:(YTXAddressModel *)addressModel{
    YTXOrderConfirmViewModel * model = [[YTXOrderConfirmViewModel alloc]init];
    NSArray * array = [goodsModel.photos componentsSeparatedByString:@","];
    model.imageURL = [NSURL URLWithString:array.firstObject];
    if (addressModel) {
        model.name = [NSString stringWithFormat:@"姓名：%@",addressModel.name];
        model.phone = [NSString stringWithFormat:@"电话：%@",addressModel.phone];
        model.address = [NSString stringWithFormat:@"地址：%@",addressModel.address];
    } else {
        model.name = @"未设置默认地址，请点击设置";
        model.phone = @"";
        model.address = @"";
    }
    model.goodsName = goodsModel.topictitle;
    model.price = goodsModel.sellprice;
    model.buyCount = @"1";
    model.freight = goodsModel.yunfei;
    if (!goodsModel.yunfei ||
        goodsModel.yunfei.length == 0 ||
        [goodsModel.yunfei isEqualToString:@"0"]) {
        model.freight = @"卖家承担";
    }
    model.totalPrice = goodsModel.sellprice;
    model.stock = goodsModel.kucun;
    return model;
}

@end
