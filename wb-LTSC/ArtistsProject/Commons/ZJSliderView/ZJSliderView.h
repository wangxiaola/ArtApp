//
//  ZJSliderView.h
//  MyDamai
//
//  Created by mac on 14-10-18.
//  Copyright (c) 2014年 zhang jian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZJSliderView : UIView

//执行执行此方法之前必须要设定ZJSliderView的frame
-(void)setViewControllers:(NSArray *)viewControllers owner:(UIViewController *)parentViewController;

//获取顶部的控制滚动视图
-(UIView *)topControlViewWithFrame:(CGRect)frame titleLabelWidth:(CGFloat)titleLabelWidth;

@end
