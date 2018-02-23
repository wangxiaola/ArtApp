//
//  YTXPagesViewController.h
//  ShesheDa
//
//  Created by Hongwei Chen on 2016/12/12.
//  Copyright © 2016年 北京艺天下文化科技有限公司. All rights reserved.
//

#import <HTHorizontalSelectionList/HTHorizontalSelectionList.h>

#import "HViewController.h"

@interface YTXPagesViewController : HViewController

//选择栏
@property (strong, nonatomic, readonly) HTHorizontalSelectionList *selectionList;

//滚动栏
@property (strong, nonatomic, readonly) UIScrollView *scrollView;

//控制器
@property (strong, nonatomic) NSArray *viewControllers;

//顶部选择栏高度
@property (assign, nonatomic) CGFloat selectionBarHeight;

//选择栏标题字体颜色
@property (strong, nonatomic) UIColor *selectionTitleNormalColor;

//选择栏标题字体颜色
@property (strong, nonatomic) UIColor *selectionTitleSelectedColor;

//选择栏滑动动画形式
@property (assign, nonatomic) HTHorizontalSelectionIndicatorAnimationMode selectionIndicatorAnimationMode;

//选择栏底部线条是否显示
@property (assign, nonatomic) BOOL bottomTrimHidden;

//按钮是否居中
@property (assign, nonatomic) BOOL centerButtons;

//当前选择标题的按钮
@property (assign, nonatomic) NSInteger selectedButtonIndex;

- (void)setTitleColor:(UIColor *)color forState:(UIControlState)state;
- (void)setTitleFont:(UIFont *)font forState:(UIControlState)state;

//初始化视图方法
- (void)setupView;

//初始化约束
- (void)setupLayoutConstraint;

//加载子视图
- (void)loadSubviews;

//刷新视图
- (void)reloadData;

//选择当前要显示的视图，是否动画展示
- (void)setSelectedButtonIndex:(NSInteger)selectedButtonIndex animated:(BOOL)animated;

//滚动的时候调用这个方法，并且返回一个BOOL代表是否取消滚动
- (BOOL)scrollViewWillScrollAtIndex:(NSInteger)index viewController:(UIViewController *)viewController;

@end
