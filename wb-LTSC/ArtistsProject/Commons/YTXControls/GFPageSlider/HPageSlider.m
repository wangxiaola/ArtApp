//
//  GFPageSlider.m
//  GFPageSlider
//
//  Created by Mercy on 15/6/30.
//  Copyright (c) 2015年 Mercy. All rights reserved.
//

#import "HPageSlider.h"


@interface HPageSlider() <UIScrollViewDelegate>

@property (strong, nonatomic) UIScrollView *menuScrollView; //!< 菜单栏
@property (strong, nonatomic) UIScrollView *contentScrollView; //!< 滑动页部分
@property (strong, nonatomic) UIButton *formerButton; //!< 前一次选择的MenuButton
@property (nonatomic) int pageCount; //!< 页面数量
@property(nonatomic,strong) UIView *content;

@end


@implementation HPageSlider


#pragma mark -

- (instancetype)initWithFrame:(CGRect)frame
                 numberOfPage:(int)pageCount
             menuButtonTitles:(NSArray *)titles {
    
    self = [super initWithFrame:frame];
    if (self) {
        _pageCount = pageCount;
        _currentPage = 0; // 初始为第一页
        
        _menuHeight = 40.0f; // 默认Menu高度为35.0f
        _menuNumberPerPage = 3; // 默认屏幕可见Menu为3个
        _menuSelectedTitleColor=kSubTitleColor;
        
        [self initMenuScrollView];
        [self initContentScrollView];
        [self setupMenuButtonsWithFormerPageCount:0];
        // 如果初始化的时候定义了MenuButton的Title，则设置，否则使用默认值[NSString stringWithFormat:@"第%d页",i + 1]
        if (titles) {
            [self setupTitles:titles withFormerPageCount:0];
        }
    }
    
    return self;
}


#pragma mark - Initialization

- (void)initMenuScrollView {
    _menuScrollView = [UIScrollView new];
    [self addSubview:_menuScrollView];
    [_menuScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.left.and.right.equalTo(self);
        make.height.mas_equalTo(_menuHeight);
    }];
    _menuScrollView.contentSize = CGSizeMake(kScreenW / _menuNumberPerPage * _pageCount, _menuHeight);
    _menuScrollView.backgroundColor = [UIColor whiteColor];
    _menuScrollView.bounces = YES;
    _menuScrollView.alwaysBounceHorizontal = YES;
    _menuScrollView.showsHorizontalScrollIndicator = NO;
    _menuScrollView.showsVerticalScrollIndicator = NO;

}

- (void)initContentScrollView {
    _contentScrollView = [UIScrollView new];
    [self addSubview:_contentScrollView];
    [_contentScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_menuScrollView.mas_bottom);
        make.left.and.right.and.bottom.equalTo(self);
    }];
    _contentScrollView.alwaysBounceHorizontal=YES;
    _contentScrollView.scrollEnabled=YES;
    _contentScrollView.showsHorizontalScrollIndicator=NO;
    _contentScrollView.pagingEnabled=YES;
    _contentScrollView.delegate=self;

    
    self.content=[UIView new];
    [_contentScrollView addSubview:self.content];
    [self.content mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_contentScrollView);
        make.height.equalTo(_contentScrollView);
    }];

}


#pragma mark - Settings

//设置标题栏背景色
- (void) setMenuBackColor:(UIColor *)menuBackColor
{
    _menuBackColor=menuBackColor;
    _menuScrollView.backgroundColor=menuBackColor;
}

- (void) setMenuTitleColor:(UIColor *)menuTitleColor
{
    _menuTitleColor=menuTitleColor;
    for (int i=1; i<_menuScrollView.subviews.count; i++) {
        UIView *view=_menuScrollView.subviews[i];
        if ([view isKindOfClass:[UIButton class]]){
            if (self.menuTitleColor){
                [(UIButton*)view setTitleColor:self.menuTitleColor forState:UIControlStateNormal];
            }
        }
    }
}

#pragma mark - Functions
// 设置传入的ViewController
- (void) setViewControllers:(NSMutableArray *)viewControllers
{
    
    for (UIView *view in self.content.subviews) {
        [view removeFromSuperview];
    }
    
    UIViewController *tempVC=nil;
    for (int i = 0; i < _pageCount; ++ i) {
        UIViewController *vc = (UIViewController *)[viewControllers objectAtIndex:i];
        if ([vc isKindOfClass:[UIViewController class]]) {
            // 填充contentScrollView
            [self.content addSubview:vc.view];
            [vc.view mas_makeConstraints:^(MASConstraintMaker *make) {
                if (tempVC){
                    make.left.equalTo(tempVC.view.mas_right);
                }else{
                    make.left.equalTo(self.content);
                }
                make.top.and.bottom.equalTo(self.content);
                make.width.mas_equalTo(kScreenW);
            }];
            tempVC=vc;
        }
    }
    [self.content mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(tempVC.view.mas_right);
    }];

}

// 设置MenuButton
- (void)setupMenuButtonsWithFormerPageCount:(int)formerPageCount {
    for (int i = formerPageCount; i < _pageCount; ++ i) {
        UIButton *menuButton = [[UIButton alloc] initWithFrame:CGRectMake(i * (kScreenW / _menuNumberPerPage), 0, kScreenW / _menuNumberPerPage, _menuHeight)];
        [self configButton:menuButton withTag:(i + 1000) text:[NSString stringWithFormat:@"第%d页",i + 1]];
        
        // 第一次设置MenuButton的时候第一个MenuButton特殊处理
        if (formerPageCount == 0) {
            if (i == 0) {
                [menuButton setTitleColor:self.menuSelectedTitleColor forState:UIControlStateNormal];
                _formerButton = menuButton; // 初始的formerButton为第一个menuButton
            }
        }
    }
}

- (void) setMenuSelectedTitleColor:(UIColor *)menuSelectedTitleColor
{
    _menuSelectedTitleColor=menuSelectedTitleColor;
    _currentPage = self.contentScrollView.contentOffset.x / self.frame.size.width;
    
}

// 设置菜单按钮名称
- (void)setupTitles:(NSArray *)titles withFormerPageCount:(int)formerPageCount {
    for (int i = formerPageCount; i < _pageCount ; ++ i) {
        UIButton *button = (UIButton *)[self.menuScrollView viewWithTag:i + 1000];
        [button.titleLabel setFont:[[Global sharedInstance] fontWithSize:14]];
        [button setTitle:[titles objectAtIndex:(i - formerPageCount)] forState:UIControlStateNormal];
        if (self.menuTitleColor){
            [button setTitleColor:self.menuTitleColor forState:UIControlStateNormal];
        }
    }
}

// MenuButton属性设定
- (void)configButton:(UIButton *)menuButton withTag:(int)tag text:(NSString *)text {
    menuButton.tag = tag;
    [menuButton setTitle:text forState:UIControlStateNormal];
    if (self.menuTitleColor){
        [menuButton setTitleColor:self.menuTitleColor forState:UIControlStateNormal];
    }else{
        [menuButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    menuButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [menuButton addTarget:self action:@selector(clickMenuButton:) forControlEvents:UIControlEventTouchUpInside];
    [_menuScrollView addSubview:menuButton];
    
}


#pragma mark - Actions

// 点击MenuButton触发事件
- (void)clickMenuButton:(UIButton *)menuButton {
    [self changePageWithSelectedButton:menuButton];
}

- (void)changePageWithSelectedButton:(UIButton *)menuButton {
    _currentPage = menuButton.tag - 1000;
    [self selectedButton];
    [_contentScrollView setContentOffset:CGPointMake(_currentPage * kScreenW, 0) animated:YES];
    if (self.didPageChangedBlock){
        self.didPageChangedBlock(_currentPage);
    }
}

- (void) selectedButton
{
    
    for (UIView *view in _menuScrollView.subviews) {

        if([view isKindOfClass:[UIButton class]]) {
            UIButton *menuButton = (UIButton *)view;
            if (menuButton.tag==_currentPage+1000){
                [menuButton setTitleColor:self.menuSelectedTitleColor forState:UIControlStateNormal];
            }else{
                if (self.menuTitleColor){
                    [menuButton setTitleColor:self.menuTitleColor forState:UIControlStateNormal];
                }else{
                    [menuButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                }
                
            }
            
        }
    }

}

#pragma mark - <UIScrollViewDelegate>

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    _currentPage = scrollView.contentOffset.x / self.frame.size.width;
    [self selectedButton];
    if (self.didPageChangedBlock){
        self.didPageChangedBlock(_currentPage);
    }
}

@end
