//
//  OrderStateView.h
//  ShesheDa
//
//  Created by XICHUNZHAO on 16/2/19.
//  Copyright © 2016年 上海翔汇网络有限公司. All rights reserved.
//

#import "HView.h"

@interface UserIndex_OrderStateView : HView

//数量
@property (strong, nonatomic) NSString *number;

//图片
@property (strong, nonatomic) NSString *image;

//标题
@property (strong, nonatomic) NSString *title;

@property (nonatomic, copy) void(^didTapBlock)();
@property (strong, nonatomic) UIColor *titleColor;

@end
