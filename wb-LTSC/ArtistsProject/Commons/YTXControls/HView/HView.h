//
//  UIViewEx.h
//  Common
//
//  Created by by Heliulin on 15/6/3.
//  Copyright (c) 2015年 上海翔汇网络技术有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HBorderDraw.h"
@interface HView : UIView
@property(nonatomic) HViewBorderWidth borderWidth;
@property(nonatomic,strong) UIColor *borderColor;
@property(nonatomic,readwrite) UIEdgeInsets topBorderEdgeInsets,bottomBorderEdgeInsets,leftBorderEdgeInsets,rightBorderEdgeInsets;
@end