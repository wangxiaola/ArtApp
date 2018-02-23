//
//  orderDetailView.h
//  ShesheDa
//
//  Created by XICHUNZHAO on 15/12/22.
//  Copyright © 2015年 上海翔汇网络有限公司. All rights reserved.
//

#import "HView.h"

@interface orderDetailView : HView

@property (nonatomic, copy) NSString* title;
@property (nonatomic, copy) NSString* content;
@property (nonatomic) CGFloat contentFont;
@property (nonatomic, strong) UIColor* contentColor;
@property (nonatomic) NSTextAlignment contentAligent;

@property (nonatomic) CGFloat lineLeft;

@property (nonatomic) BOOL topLine;
@property (nonatomic, strong) NSString* imgRightName;

@property (nonatomic, copy) void (^didTapBlock)();
@end
