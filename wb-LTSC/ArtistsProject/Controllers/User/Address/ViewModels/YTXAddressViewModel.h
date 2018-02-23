//
//  YTXAddressViewModel.h
//  ShesheDa
//
//  Created by Hongwei Chen on 2016/11/12.
//  Copyright © 2016年 北京艺天下文化科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YTXAddressModel.h"

@interface YTXAddressViewModel : NSObject

@property (nonatomic, copy) NSString * aid;

@property (nonatomic, copy) NSString * name;

@property (nonatomic, copy) NSString * phone;

@property (nonatomic, copy) NSString * address;

@property (nonatomic, assign) BOOL isDefault;

@property (nonatomic, strong) YTXAddressModel * model;

+ (instancetype)modelWithAddressModel:(YTXAddressModel *)addressModel;

@end
