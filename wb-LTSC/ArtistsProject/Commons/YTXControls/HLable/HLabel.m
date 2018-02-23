//
//  HLable.m
//  HUIKitLib
//
//  Created by HeLiulin on 15/11/5.
//  Copyright © 2015年 上海翔汇网络科技有限公司. All rights reserved.
//

#import "HLabel.h"

@implementation HLabel
@synthesize verticalTextAlignment = _verticalTextAlignment;

- (void)setVerticalTextAlignment:(HLabelVerticalTextAlignment)verticalTextAlignment {
    _verticalTextAlignment = verticalTextAlignment;
    
    [self setNeedsLayout];
}

@synthesize textEdgeInsets = _textEdgeInsets;

- (void)setTextEdgeInsets:(UIEdgeInsets)textEdgeInsets {
    _textEdgeInsets = textEdgeInsets;
    
    [self setNeedsLayout];
}


#pragma mark - UIView

- (id) init
{
    if (self=[super init]){
        [self initialize];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if ((self = [super initWithCoder:aDecoder])) {
        [self initialize];
    }
    return self;
}


- (id)initWithFrame:(CGRect)aFrame {
    if ((self = [super initWithFrame:aFrame])) {
        [self initialize];
    }
    return self;
}


#pragma mark - UILabel

- (void)drawTextInRect:(CGRect)rect {
    rect = UIEdgeInsetsInsetRect(rect, self.textEdgeInsets);
    
    if (self.verticalTextAlignment == HLabelVerticalTextAlignmentTop) {
        CGSize sizeThatFits = [self sizeThatFits:rect.size];
        rect = CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, sizeThatFits.height);
    } else if (self.verticalTextAlignment == HLabelVerticalTextAlignmentBottom) {
        CGSize sizeThatFits = [self sizeThatFits:rect.size];
        rect = CGRectMake(rect.origin.x, rect.origin.y + (rect.size.height - sizeThatFits.height), rect.size.width, sizeThatFits.height);
    }
    
    [super drawTextInRect:rect];
    HBorderDraw *draw=[HBorderDraw new];
    [draw drawBorder:rect andViewBorderWidth:self.borderWidth andViewBorderColor:self.borderColor];

    CGFloat viewWidth = rect.size.width;
    CGFloat viewHeight = rect.size.height;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextBeginPath(context);
    CGContextSetStrokeColorWithColor(context, self.textColor.CGColor);
    
    if (self.showBreakLine){
        CGContextSetLineWidth(context, 1);
        CGContextMoveToPoint(context, 2, viewHeight/2);
        CGContextAddLineToPoint(context, viewWidth+2, viewHeight/2);
        CGContextStrokePath(context);
    }
}

- (void ) setShowBreakLine:(BOOL)showBreakLine
{
    _showBreakLine=showBreakLine;
    [self layoutIfNeeded];
}

//- (void) drawRect:(CGRect)rect
//{
//    [super drawRect:rect];
//    HBorderDraw *draw=[HBorderDraw new];
//    [draw drawBorder:rect andViewBorderWidth:self.borderWidth andViewBorderColor:self.borderColor];
//
//}


#pragma mark - Private

- (void)initialize {
    self.verticalTextAlignment = HLabelVerticalTextAlignmentMiddle;
    self.textEdgeInsets = UIEdgeInsetsZero;
    self.borderWidth = HViewBorderWidthMake(0, 0, 0, 0);
    self.borderColor = [UIColor blackColor];
    self.backgroundColor = [UIColor clearColor];
}

@end
