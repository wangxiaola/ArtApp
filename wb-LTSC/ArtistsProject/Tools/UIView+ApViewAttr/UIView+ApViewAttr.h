//
//  UIView+ApViewAttr.h
//  wer_chen
//
//  Created by 黄兵 on 15/8/8.
//  Copyright (c) 2014年 黄兵. All rights reserved.
//

#import <UIKit/UIKit.h>

#pragma mark  ------------ 屏幕 ------------
//  屏幕尺寸(宽 + 高)
#define kScreenBounds	[UIScreen mainScreen].bounds
//  屏幕宽
#define kScreenWidth	[UIScreen mainScreen].bounds.size.width
//  屏幕高
#define kScreenHeight	[UIScreen mainScreen].bounds.size.height
// 屏幕中心点
#define kScreenCenter   CGPointMake(kScreenWidth / 2, kScreenHeight / 2)


@interface UIView (ApViewAttr)


#pragma mark  ------------ 自身 ------------

//  自身宽度
@property (nonatomic, assign) CGFloat ownWidth;
//  自身高度
@property (nonatomic, assign) CGFloat ownHeight;

//  自身x坐标
@property (nonatomic, assign) CGFloat ownX;
//  自身y坐标
@property (nonatomic, assign) CGFloat ownY;

//  结束x坐标(selfX + selfWidth)
@property (nonatomic, assign) CGFloat endX;
//  结束y坐标(selfY + selfHeight)
@property (nonatomic, assign) CGFloat endY;

//  自身中心点x坐标
@property (nonatomic, assign) CGFloat centerX;
//  自身中心点y坐标
@property (nonatomic, assign) CGFloat centerY;

//  自身坐标
@property (nonatomic) CGPoint origin;
//  自身尺寸
@property (nonatomic, assign) CGSize size;

//  是否圆形
@property (nonatomic, assign) BOOL isCircle;


#pragma mark  ------------ 父视图 ------------

//  父视图宽度
@property (nonatomic, assign, readonly) CGFloat supWidth;
//  父视图高度
@property (nonatomic, assign, readonly) CGFloat supHeight;

//  父视图x坐标
@property (nonatomic, assign, readonly) CGFloat supX;
//  父视图y坐标
@property (nonatomic, assign, readonly) CGFloat supY;

//  父视图结束x坐标
@property (nonatomic, assign, readonly) CGFloat supEndX;
//  父视图结束y坐标
@property (nonatomic, assign, readonly) CGFloat supEndY;

//  父视图中心点
@property (nonatomic, assign, readonly) CGPoint supCenter;




@end

