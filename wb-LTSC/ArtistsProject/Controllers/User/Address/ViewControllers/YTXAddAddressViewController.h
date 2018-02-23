//
//  YTXAddAddressViewController.h
//  ShesheDa
//
//  Created by Hongwei Chen on 2016/11/12.
//  Copyright © 2016年 北京艺天下文化科技有限公司. All rights reserved.
//

#import "HViewController.h"

@class YTXAddressViewModel;

@interface YTXAddAddressViewController : HViewController

@property (nonatomic, assign) BOOL isSetDefault;//是否设置为默认

@property (nonatomic, strong) YTXAddressViewModel * model;

@property (nonatomic, copy) void(^didAddSucessBlock)(NSArray *);//回调最新地址

@end
