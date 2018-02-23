//
//  UIViewEx.m
//  Common
//
//  Created by by Heliulin on 15/6/3.
//  Copyright (c) 2015年 上海翔汇网络技术有限公司. All rights reserved.
//

#import "HView.h"
#import "HBorderDraw.h"
@implementation HView
- (id) init
{
    if (self==[super init]){
        self.borderWidth=HViewBorderWidthMake(0, 0, 0, 0);
        self.backgroundColor=[UIColor clearColor];
    }
    return self;
}

- (void) drawRect:(CGRect)rect
{
    [super drawRect:rect];
    HBorderDraw *test=[HBorderDraw new];
    test.topBorderEdgeInsets=self.topBorderEdgeInsets;
    test.bottomBorderEdgeInsets=self.bottomBorderEdgeInsets;
    test.leftBorderEdgeInsets=self.leftBorderEdgeInsets;
    test.rightBorderEdgeInsets=self.rightBorderEdgeInsets;
    [test drawBorder:rect andViewBorderWidth:self.borderWidth andViewBorderColor:self.borderColor];
}
@end
