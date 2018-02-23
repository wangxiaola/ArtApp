//
//  YTXOrderListTableViewCell.h
//  ShesheDa
//
//  Created by Hongwei Chen on 2016/11/14.
//  Copyright © 2016年 北京艺天下文化科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YTXOrderViewModel;

extern NSString * const kYTXOrderListTableViewCell;

@interface YTXOrderListTableViewCell : UITableViewCell



@property (nonatomic, strong) YTXOrderViewModel * model;

@property (nonatomic, copy) void(^btnActionBlock)(NSString * title);

+ (CGFloat)getCellHeightWithModel:(YTXOrderViewModel *)model;

@end
