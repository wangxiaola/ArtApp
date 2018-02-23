//
//  YTXPagesViewController.m
//  ShesheDa
//
//  Created by Hongwei Chen on 2016/12/12.
//  Copyright © 2016年 北京艺天下文化科技有限公司. All rights reserved.
//


#import <HTHorizontalSelectionList.h>

#import "YTXPagesViewController.h"

#define TOP_BAR_DEFAULT_HEIGHT          44

@interface YTXPagesViewController ()<UIScrollViewDelegate,HTHorizontalSelectionListDelegate,HTHorizontalSelectionListDataSource>

@property (strong, nonatomic) HTHorizontalSelectionList *selectionList;
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) NSMutableArray *contentViews;

@end

@implementation YTXPagesViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _selectionBarHeight = 40;
        _bottomTrimHidden = YES;
        _selectionTitleNormalColor = [UIColor darkGrayColor];
        _selectionTitleSelectedColor = [UIColor darkGrayColor];
        _selectionIndicatorAnimationMode = HTHorizontalSelectionIndicatorAnimationModeNoBounce;
    }
    return self;
}

#pragma mark - 生命周期

- (void)viewDidLoad {
    [super viewDidLoad];
    _contentViews = [[NSMutableArray alloc] init];
}


#pragma mark - 初始化方法

- (void)setupView
{
    _selectionList = [[HTHorizontalSelectionList alloc] init];
    _selectionList.centerButtons = YES;
    _selectionList.dataSource = self;
    _selectionList.delegate = self;
    _selectionList.bottomTrimHidden = self.bottomTrimHidden;
    _selectionList.selectionIndicatorAnimationMode = self.selectionIndicatorAnimationMode;
    _selectionList.selectionIndicatorColor = self.selectionTitleSelectedColor;
    [_selectionList setTitleColor:self.selectionTitleNormalColor forState:UIControlStateNormal];
    [_selectionList setTitleColor:self.selectionTitleSelectedColor forState:UIControlStateSelected];
    [self.view addSubview:_selectionList];
    
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.delegate = self;
    _scrollView.pagingEnabled = YES;
    [self.view addSubview:_scrollView];
}

- (void)setupLayoutConstraint
{
    [self.selectionList mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.top.and.right.mas_equalTo(0);
        make.height.mas_equalTo(_selectionBarHeight);
    }];
    
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.mas_equalTo(0);
        make.top.mas_equalTo(self.selectionList.mas_bottom);
        make.bottom.mas_equalTo(0);
    }];
}

- (void)loadSubviews
{
    if (self.viewControllers.count == 0) {
        return;
    }
    
    @try {
        UIViewController *viewController = [self.viewControllers objectOrNilAtIndex:self.selectedButtonIndex];
        UIView *contentView = [self.contentViews objectOrNilAtIndex:self.selectedButtonIndex];
        
        if (viewController && !viewController.isViewLoaded && contentView)
        {
            //对UIView做了适配
            if ([viewController isKindOfClass:[UIView class]]) {
                UIView *view = (UIView *)viewController;
                [contentView addSubview:view];
                [view mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(0);
                    make.top.mas_equalTo(0);
                    make.width.mas_equalTo(contentView);
                    make.height.mas_equalTo(contentView);
                }];
            } else if ([viewController isKindOfClass:[UIViewController class]]) {
                [contentView addSubview:viewController.view];
                [self addChildViewController:viewController];
                [viewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(0);
                    make.top.mas_equalTo(0);
                    make.width.mas_equalTo(contentView);
                    make.height.mas_equalTo(contentView);
                }];
            }
        }
    } @catch (NSException *exception) {
        NSLog(@"%@",[exception description]);
    } @finally {
        
    }
}

- (void)reloadData
{
    [self.view setNeedsLayout];
    [self.view layoutIfNeeded];
    [self.selectionList reloadData];
}

#pragma mark - 系统旋转

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [_scrollView setContentOffset:CGPointMake(_selectedButtonIndex * self.scrollView.width, 0)];
}


#pragma mark - ViewControllers

- (void)setViewControllers:(NSArray *)viewControllers
{
    NSAssert(_scrollView, @"scrollView不能为空，必须在setViewControllers之前调用setupView");
    _viewControllers = viewControllers;
    [self.contentViews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.contentViews removeAllObjects];
    
    UIView *oldView = nil;
    for (int i = 0; i < viewControllers.count; i++)
    {
        UIView *contentView = [[UIView alloc] init];
        contentView.backgroundColor = [UIColor whiteColor];
        [self.scrollView addSubview:contentView];
        
        [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            if (!i) {
                make.left.and.top.mas_equalTo(0);
            } else if (i == viewControllers.count - 1) {
                make.left.mas_equalTo(oldView.mas_right);
                make.right.mas_equalTo(0);
                make.top.mas_equalTo(0);
            } else {
                make.left.mas_equalTo(oldView.mas_right);
                make.top.mas_equalTo(0);
            }
            make.width.mas_equalTo(self.view);
            make.height.mas_equalTo(self.scrollView);
        }];
        
        [self.contentViews addObject:contentView];
        oldView = contentView;
    }
}


#pragma mark - UIScrollView代理

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (![scrollView isEqual:_scrollView]) {
        return;
    }
    
    _selectedButtonIndex = scrollView.contentOffset.x / scrollView.frame.size.width;
    
    [self.selectionList setSelectedButtonIndex:_selectedButtonIndex animated:YES];
    
    if ([self respondsToSelector:@selector(scrollViewWillScrollAtIndex:viewController:)]) {
        [self scrollViewWillScrollAtIndex:_selectedButtonIndex viewController:[self.viewControllers objectAtIndex:_selectedButtonIndex]];
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self loadSubviews];
    });
}


#pragma mark - 选择栏代理

- (NSInteger)numberOfItemsInSelectionList:(HTHorizontalSelectionList *)selectionList
{
    return self.viewControllers.count;
}

- (NSString *)selectionList:(HTHorizontalSelectionList *)selectionList titleForItemWithIndex:(NSInteger)index
{
    UIViewController *vc = [self.viewControllers objectOrNilAtIndex:index];
    return vc.title ? : vc.navigationItem.title;
}

- (void)selectionList:(HTHorizontalSelectionList *)selectionList didSelectButtonWithIndex:(NSInteger)index
{
    _selectedButtonIndex = index;
    [self.scrollView setContentOffset:CGPointMake(index * self.scrollView.frame.size.width, 0) animated:YES];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self loadSubviews];
    });
}


#pragma mark - Public

- (void)setTitleColor:(UIColor *)color forState:(UIControlState)state
{
    [self.selectionList setTitleColor:color forState:state];
}

- (void)setTitleFont:(UIFont *)font forState:(UIControlState)state
{
    [self.selectionList setTitleFont:font forState:state];
}

- (void)setSelectedButtonIndex:(NSInteger)selectedButtonIndex
{
    [self setSelectedButtonIndex:selectedButtonIndex animated:NO];
}

- (void)setSelectedButtonIndex:(NSInteger)selectedButtonIndex animated:(BOOL)animated
{
    _selectedButtonIndex = selectedButtonIndex;
    [self.selectionList setSelectedButtonIndex:selectedButtonIndex animated:animated];
    
    [self.scrollView setContentOffset:CGPointMake(selectedButtonIndex * self.scrollView.frame.size.width, 0) animated:YES];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self loadSubviews];
    });
    if ([self respondsToSelector:@selector(scrollViewWillScrollAtIndex:viewController:)]) {
        [self scrollViewWillScrollAtIndex:_selectedButtonIndex viewController:[self.viewControllers objectOrNilAtIndex:_selectedButtonIndex]];
    }
}

- (void)setSelectionBarHeight:(CGFloat)selectionBarHeight
{
    _selectionBarHeight = selectionBarHeight;
    
    if (!_selectionList) {
        return;
    }
    
    [self.selectionList mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(_selectionBarHeight);
    }];
    [self.view setNeedsLayout];
    [self.view layoutIfNeeded];
}



#pragma mark - Override
- (BOOL)scrollViewWillScrollAtIndex:(NSInteger)index viewController:(UIViewController *)viewController { return  YES; }

@end
