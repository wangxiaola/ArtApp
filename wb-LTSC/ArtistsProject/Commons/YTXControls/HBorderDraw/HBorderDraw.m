//
//  TestClass.m
//  HUIKitLib_Demo
//
//  Created by HeLiulin on 15/10/20.
//  Copyright © 2015年 上海翔汇网络科技有限公司. All rights reserved.
//

#import "HBorderDraw.h"

@implementation HBorderDraw

- (void) drawBorder:(CGRect)rect
 andViewBorderWidth:(HViewBorderWidth)borderWidth
 andViewBorderColor:(UIColor*)borderColor;
{

    CGFloat viewWidth = rect.size.width;
    CGFloat viewHeight = rect.size.height;

    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextBeginPath(context);
    CGContextSetStrokeColorWithColor(context, borderColor.CGColor);

    if (borderWidth.top > 0) {
        CGContextSetLineWidth(context, borderWidth.top);
        CGContextMoveToPoint(context, self.topBorderEdgeInsets.left, self.topBorderEdgeInsets.top);
        CGContextAddLineToPoint(context, viewWidth-self.topBorderEdgeInsets.right, self.topBorderEdgeInsets.top);
        CGContextStrokePath(context);
    }
    if (borderWidth.bottom > 0) {
        CGContextSetLineWidth(context, borderWidth.bottom);
        CGContextMoveToPoint(context, self.bottomBorderEdgeInsets.left, viewHeight-self.bottomBorderEdgeInsets.bottom);
        CGContextAddLineToPoint(context, viewWidth-self.bottomBorderEdgeInsets.right, viewHeight-self.bottomBorderEdgeInsets.bottom);
        CGContextStrokePath(context);
    }
    if (borderWidth.left > 0) {
        CGContextSetLineWidth(context, borderWidth.left);
        CGContextMoveToPoint(context, self.leftBorderEdgeInsets.left, self.leftBorderEdgeInsets.top);
        CGContextAddLineToPoint(context, self.leftBorderEdgeInsets.left, viewHeight-self.leftBorderEdgeInsets.bottom);
        CGContextStrokePath(context);
    }
    if (borderWidth.right > 0) {
        CGContextSetLineWidth(context, borderWidth.right);
        CGContextMoveToPoint(context, viewWidth-self.rightBorderEdgeInsets.right, self.rightBorderEdgeInsets.top);
        CGContextAddLineToPoint(context, viewWidth-self.rightBorderEdgeInsets.right, viewHeight-self.rightBorderEdgeInsets.bottom);
        CGContextStrokePath(context);
    }
}

@end
