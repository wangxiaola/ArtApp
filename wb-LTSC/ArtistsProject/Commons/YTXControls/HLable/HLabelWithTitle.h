//
//  HLabelWithTitle.h
//  HUIKitLib
//
//  Created by by Heliulin on 15/6/1.
//  Copyright (c) 2015年 上海翔汇网络技术有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HView.h"

@interface HLabelWithTitle : HView

@property (nonatomic, readwrite) CGFloat titleWidth;
@property (nonatomic, readwrite) NSTextAlignment titleAlignment;
@property (nonatomic, copy) NSString* title;
@property (nonatomic, strong) UIColor* titleColor;
@property (nonatomic, strong) UIFont* titleFont;
@property (nonatomic, copy) NSString* content;
@property (nonatomic, strong) UIColor* contentColor;
@property (nonatomic, strong) UIFont* contentFont;
@property(nonatomic,readwrite) NSTextAlignment contentAlignment;
@property (nonatomic,readwrite) NSInteger lineNumOfContent;

@end
