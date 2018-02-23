//
//  HLine.m
//  ShaManager
//
//  Created by by Heliulin on 15/7/1.
//  Copyright (c) 2015年 上海翔汇网络科技有限公司. All rights reserved.
//

#import "HLine.h"

@implementation HLine
- (id) init
{
    if (self=[super init]){
        [self defaultInit];
    }
    return self;
}

- (void) defaultInit
{
    self.lineColor=kLineColor;
    self.lineWidth=1;
    self.lineStyle=UILineStyleVertical;
    self.backgroundColor=[UIColor clearColor];
}
- (void) setLineColor:(UIColor *)lineColor
{
    _lineColor=lineColor;
}
- (void) setLineWidth:(CGFloat)lineWidth
{
    _lineWidth=lineWidth;
}
- (void) setLineStyle:(UILineStyle)lineStyle
{
    _lineStyle=lineStyle;
}
- (void) drawRect:(CGRect)rect
{
    CGFloat viewWidth=self.frame.size.width;
    CGFloat viewHeight=self.frame.size.height;
    
    CGContextRef context =UIGraphicsGetCurrentContext();
    CGContextBeginPath(context);
    CGContextSetLineWidth(context, self.lineWidth);
    CGContextSetStrokeColorWithColor(context, self.lineColor.CGColor);
    //分割线
    CGContextMoveToPoint(context, 0,0);
    if (self.lineMode==HLineModeDash){
        CGFloat lengths[] = {3,3};
        CGContextSetLineDash(context, 0, lengths,2);
    }
    if (self.lineStyle==UILineStyleVertical){
        CGContextAddLineToPoint(context, 0,viewHeight);
        CGContextStrokePath(context);
    }else{
        CGContextAddLineToPoint(context, viewWidth,0);
        CGContextStrokePath(context);
    }
}
@end
