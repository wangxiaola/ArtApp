//
//  HTextField.h
//  HUIKitLib
//
//  Created by HeLiulin on 15/11/5.
//  Copyright © 2015年 上海翔汇网络科技有限公司. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "HBorderDraw.h"

@interface HTextField : UITextField
@property(nonatomic) HViewBorderWidth borderWidth;

@property(nonatomic,strong) UIColor *borderColor;

@property (nonatomic) UIEdgeInsets textEdgeInsets;

@property (nonatomic) UIEdgeInsets clearButtonEdgeInsets;

@property (nonatomic) UIEdgeInsets rightViewInsets;

@property (nonatomic) UIEdgeInsets leftViewInsets;

@end
