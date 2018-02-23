//
//  ZJSliderView.m
//  MyDamai
//
//  Created by mac on 14-10-18.
//  Copyright (c) 2014年 zhang jian. All rights reserved.
//

#import "ZJSliderView.h"

#define TOP_TAG 200
#define CONTENT_TAG 201


@interface ZJSliderView ()<UIScrollViewDelegate>
{
    UIScrollView *_topScrollView;
    NSMutableArray *_titleLabelArray;
    UIImageView *_topIndicatorView;
    
    UIScrollView *_contentScrollView;
    
    
}
@property (strong,nonatomic) NSArray *viewControllers;
@property (weak,nonatomic) UIViewController *parentViewController;
@property (nonatomic) float titleLabelWidth;
@end

@implementation ZJSliderView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    
        // Initialization code
    }
    return self;
}

-(void)setViewControllers:(NSArray *)viewControllers owner:(UIViewController *)parentViewController;
{
    self.parentViewController = parentViewController;
    self.viewControllers = viewControllers;
    

    //创建view
    _contentScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    _contentScrollView.pagingEnabled = YES;
    _contentScrollView.tag = CONTENT_TAG;
    _contentScrollView.showsHorizontalScrollIndicator = NO;
    _contentScrollView.showsVerticalScrollIndicator = NO;
    _contentScrollView.delegate = self;
    _contentScrollView.bounces = NO;
    [self addSubview:_contentScrollView];
    for (int i=0; i<viewControllers.count; i++) {
        
        UIViewController *vc = viewControllers[i];
        vc.view.frame = CGRectMake(i*_contentScrollView.frame.size.width, 0, _contentScrollView.frame.size.width, _contentScrollView.frame.size.height);
        [_contentScrollView addSubview:vc.view];
        
        //非常关键的一句
        [self.parentViewController addChildViewController:vc];
    }
    _contentScrollView.contentSize = CGSizeMake(_contentScrollView.frame.size.width * viewControllers.count, 0);
    //显示第0页
    [self contentScrollViewShowPage:0];
}


//获取顶部的控制滚动视图
-(UIView *)topControlViewWithFrame:(CGRect)frame titleLabelWidth:(CGFloat)titleLabelWidth;
{
    
    //设置label宽度
    if(titleLabelWidth == 0)
    {
        titleLabelWidth = 80;
    }
    _titleLabelWidth = titleLabelWidth;
    
    
    //滚动视图
    _topScrollView = [[UIScrollView alloc] initWithFrame:frame];
    _topScrollView.tag = TOP_TAG;
    _topScrollView.showsHorizontalScrollIndicator = NO;
    _topScrollView.showsVerticalScrollIndicator = NO;
    _topScrollView.delegate = self;
    [self addSubview:_topScrollView];
    
    
    //添加view
    _titleLabelArray = [[NSMutableArray alloc] init];
    for (int i=0; i<_viewControllers.count; i++) {
        
        UIViewController *vc = _viewControllers[i];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(titleLabelWidth *i, 0, titleLabelWidth, _topScrollView.frame.size.height)];
        label.text = vc.title;
        label.userInteractionEnabled = YES;
        label.tag = i+100;
        label.font = [UIFont systemFontOfSize:14];
        
        label.textAlignment = NSTextAlignmentCenter;
        [_titleLabelArray addObject:label];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dealTap:)];
        [label addGestureRecognizer:tap];
        [_topScrollView addSubview:label];
    }
    _topScrollView.contentSize = CGSizeMake(titleLabelWidth * _viewControllers.count, _topScrollView.frame.size.height);
    
    //添加提示视图
    _topIndicatorView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, titleLabelWidth, _topScrollView.frame.size.height)];
    _topIndicatorView.image = [UIImage imageNamed:@"red_line_and_shadow.png"];
    [_topScrollView addSubview:_topIndicatorView];
    
    [self topScrollViewShowPage:0];
    return _topScrollView;
}

#pragma mark - 处理动画结束
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if(scrollView.tag == CONTENT_TAG)
    {
        //注意0除
        int page = scrollView.contentOffset.x / self.frame.size.width;
        [self topScrollViewShowPage:page];
        [self contentScrollViewShowPage:page];
    }
}

-(void)dealTap:(UITapGestureRecognizer *)tap
{
    int page = tap.view.tag - 100;
    [self topScrollViewShowPage:page];
    [self contentScrollViewShowPage:page];
}
-(void)topScrollViewShowPage:(int)page
{
    for (UILabel *label in _titleLabelArray) {
        label.textColor = [UIColor blackColor];
    }
    UILabel *selectLabel = _titleLabelArray[page];
    selectLabel.textColor = [UIColor blackColor];
    
    [UIView animateWithDuration:0.2 animations:^{
        _topIndicatorView.frame = selectLabel.frame;
    }];
//
    //
    //获取当前显示范围
    int currentPage = _topScrollView.contentOffset.x / _titleLabelWidth;
    
    int pageCount = _topScrollView.frame.size.width / _titleLabelWidth;
    if(page > currentPage+pageCount-1)
    {
        [_topScrollView setContentOffset:CGPointMake(_topScrollView.contentOffset.x + _titleLabelWidth, 0) animated:YES];
    }
    if(page < currentPage)
    {
        [_topScrollView setContentOffset:CGPointMake(_topScrollView.contentOffset.x - _titleLabelWidth, 0) animated:YES];
    }
}
-(void)contentScrollViewShowPage:(int)page
{
    [_contentScrollView setContentOffset:CGPointMake(page * _contentScrollView.frame.size.width, 0) animated:YES];
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
