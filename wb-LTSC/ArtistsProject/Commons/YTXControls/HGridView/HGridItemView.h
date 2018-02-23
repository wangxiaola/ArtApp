//
//  HGridItem.h
//  HUIKitLib_Demo
//
//  Created by HeLiulin on 15/11/4.
//  Copyright © 2015年 上海翔汇网络科技有限公司. All rights reserved.
//

#import "HView.h"
#import "HKeyValuePair.h"

@interface HGridItemView : HView
@property(nonatomic,strong) HKeyValuePair *item;
@property(nonatomic,readwrite) BOOL selected;
@property(nonatomic,strong) UIColor *titleColor;
@property(nonatomic,readwrite) NSTextAlignment itemTitleAlignment;
@end
