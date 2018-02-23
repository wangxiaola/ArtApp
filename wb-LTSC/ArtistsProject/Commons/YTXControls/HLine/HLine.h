//
//  HLine.h
//  ShaManager
//
//  Created by by Heliulin on 15/7/1.
//  Copyright (c) 2015年 上海翔汇网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface HLine : UIView
typedef enum{
    UILineStyleVertical,
    UILineStyleHorizon
}UILineStyle;

typedef enum {
    HLineModeSolid,
    HLineModeDash,
}HLineMode;
@property(nonatomic,strong) UIColor *lineColor;
@property(nonatomic,readwrite) CGFloat lineWidth;
@property(nonatomic,readwrite) UILineStyle lineStyle;
@property(nonatomic,readwrite) HLineMode lineMode;
@end
