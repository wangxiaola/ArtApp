//
//  YTXAddressViewModel.m
//  ShesheDa
//
//  Created by Hongwei Chen on 2016/11/12.
//  Copyright © 2016年 北京艺天下文化科技有限公司. All rights reserved.
//

#import "YTXAddressViewModel.h"

@implementation YTXAddressViewModel

+ (instancetype)modelWithAddressModel:(YTXAddressModel *)addressModel {
    YTXAddressViewModel * model = [[YTXAddressViewModel alloc]init];
    model.isDefault = [addressModel.defaultStr isEqualToString:@"1"];
    model.name = addressModel.name;
    model.phone = addressModel.phone;
    model.address = addressModel.address;
    model.aid = addressModel.aid;
    model.model = addressModel.modelCopy;
    return model;
}

@end
