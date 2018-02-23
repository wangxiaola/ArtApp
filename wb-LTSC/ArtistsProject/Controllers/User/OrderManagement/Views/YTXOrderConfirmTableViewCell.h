//
//  YTXOrderConfirmTableViewCell.h
//  ShesheDa
//
//  Created by Hongwei Chen on 2016/11/12.
//  Copyright © 2016年 北京艺天下文化科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YTXOrderConfirmViewModel.h"

extern NSString * const kYTXOrderConfirmTableViewCell;

@interface YTXOrderConfirmTableViewCell : UITableViewCell

@property (nonatomic, strong) YTXOrderConfirmViewModel * model;

@property (nonatomic, copy) void(^selectAddressActionBlock)();

@property (nonatomic, copy) void(^confirmOrderActionBlock)();

@property (nonatomic, copy) void(^buyCountChangeAction)(NSInteger);

@end
