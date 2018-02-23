//
//  UIView+ApViewAttr.m
//  wer_chen
//
//  Created by 黄兵 on 14/8/8.
//  Copyright (c) 2015年 黄兵. All rights reserved.
//

#import "UIView+ApViewAttr.h"
#import <objc/runtime.h>

@implementation UIView (ApViewAttr)


#pragma mark  ------------ 自身 ------------


#pragma mark  ------------ 自身宽度 ------------

- (CGFloat)ownWidth
{
	return self.frame.size.width;
}

- (void)setOwnWidth:(CGFloat)newWidth
{
	CGRect newFrame = self.frame;

    newFrame.size.width = newWidth;
	self.frame = newFrame;
}


#pragma mark  ------------ 自身高度 ------------

- (CGFloat)ownHeight
{
	return self.frame.size.height;
}

- (void)setOwnHeight:(CGFloat)newHeight
{
	CGRect newFrame = self.frame;
    
	newFrame.size.height = newHeight;
	self.frame = newFrame;
}


#pragma mark  ------------ 自身x坐标 ------------

- (CGFloat)ownX
{
	return self.frame.origin.x;
}

- (void)setOwnX:(CGFloat)newX
{
	CGRect newFrame = self.frame;

	newFrame.origin.x = newX;
	self.frame = newFrame;
}


#pragma mark  ------------ 自身y坐标 ------------

- (CGFloat)ownY
{
	return self.frame.origin.y;
}

- (void)setOwnY:(CGFloat)newY
{
	CGRect newFrame = self.frame;

	newFrame.origin.y = newY;
	self.frame = newFrame;
}


#pragma mark  ------------ 结束x坐标 ------------

- (CGFloat)endX
{
	return self.frame.origin.x + self.frame.size.width;
}

- (void)setEndX:(CGFloat)newEndX
{
	CGRect newFrame = self.frame;

	newFrame.origin.x = newEndX - self.frame.size.width;
	self.frame = newFrame;
}


#pragma mark  ------------ 结束y坐标 ------------

- (CGFloat)endY
{
	return self.frame.origin.y + self.frame.size.height;
}

- (void)setEndY:(CGFloat)newEndY
{
	CGRect newFrame = self.frame;

	newFrame.origin.y = newEndY - self.frame.size.height;
	self.frame = newFrame;
}


#pragma mark  ------------ 中心点x坐标 ------------

- (CGFloat)centerX
{
    return self.center.x;
}

- (void)setCenterX:(CGFloat)newCenterX
{
    CGPoint newCenter = self.center;
    
    newCenter.x = newCenterX;
    self.center = newCenter;
}


#pragma mark  ------------ 中心点y坐标 ------------

- (CGFloat)centerY
{
    return self.center.y;
}

- (void)setCenterY:(CGFloat)newCenterY
{
    CGPoint newCenter = self.center;
    
    newCenter.y = newCenterY;
    self.center = newCenter;
}

#pragma mark  ------------ 自身尺寸 ------------

- (CGSize)size {
    return self.frame.size;
}

- (void)setSize:(CGSize)size {
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
    return;
}

#pragma mark  ------------ 自身坐标 ------------

- (CGPoint)origin {
    return self.frame.origin;
}

- (void)setOrigin:(CGPoint)origin {
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
    return;
}


#pragma mark  ------------ 是否圆形 ------------

@dynamic isCircle;
static const void *isCircleKey = &isCircleKey;

- (BOOL)isCircle
{
    return objc_getAssociatedObject(self, isCircleKey);
}

- (void)setIsCircle:(BOOL)isCircle
{
    if (isCircle) {
        objc_setAssociatedObject(self, isCircleKey, @(isCircle), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        CGFloat length = self.ownWidth < self.ownHeight ? self.ownWidth : self.ownHeight;
        self.layer.allowsEdgeAntialiasing = YES;
        self.layer.cornerRadius = length / 2;
    }
}


#pragma mark  ------------ 父视图 ------------


#pragma mark  ------------ 父视图宽度 ------------

- (CGFloat)supWidth
{
    return self.superview.ownWidth;
}


#pragma mark  ------------ 父视图高度 ------------

- (CGFloat)supHeight
{
    return self.superview.ownHeight;
}


#pragma mark  ------------ 父视图x坐标 ------------

- (CGFloat)supX
{
    return self.superview.ownX;
}


#pragma mark  ------------ 父视图y坐标 ------------

- (CGFloat)supY
{
    return self.superview.ownY;
}


#pragma mark  ------------ 父视图结束x坐标 ------------

- (CGFloat)supEndX
{
    return self.superview.ownX + self.superview.ownWidth;
}


#pragma mark  ------------ 父视图结束y坐标 ------------

- (CGFloat)supEndY
{
    return self.superview.ownY + self.superview.ownHeight;
}


#pragma mark  ------------ 父视图中心点 ------------

- (CGPoint)supCenter
{
    return self.superview.center;
}



@end
