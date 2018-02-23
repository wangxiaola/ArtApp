//
//  HPopVC.m
//  HUIKitLib_Demo
//
//  Created by HeLiulin on 15/11/11.
//  Copyright © 2015年 上海翔汇网络科技有限公司. All rights reserved.
//

#import "HPopVC.h"
//#import "UIViewController+KNSemiModal.h"

@implementation HPopVC
@synthesize navBar,navItem,scrollView,viewContent;

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}
- (void) viewDidLoad
{
    [super viewDidLoad];
    [self hideKeyBoard];
    [self.view setFrame:CGRectMake(0, 0, kScreenW, kScreenW)];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    navBar=[[UINavigationBar alloc] init];
    navItem=[[UINavigationItem alloc] init];
    navBar.items=@[navItem];
    [self.view addSubview:navBar];
    [navBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.top.and.right.equalTo(self.view);
        make.height.mas_equalTo(45);
    }];
    navItem.backBarButtonItem=nil;
    //设置导航栏标题字体和颜色
    NSDictionary * dictTitle=@{NSFontAttributeName:[UIFont systemFontOfSize:17.0f],
                               NSForegroundColorAttributeName:[UIColor blackColor]};
    navBar.titleTextAttributes=dictTitle;
    //设置导航栏左右按钮字体和颜色
    NSDictionary * dicLeftRight=@{NSFontAttributeName:[UIFont systemFontOfSize:15.0f],
                                  NSForegroundColorAttributeName:[UIColor blueColor]};
    [[UIBarButtonItem appearance] setTitleTextAttributes:dicLeftRight forState:UIControlStateNormal];
    


    scrollView=[UIScrollView new];
    [self.view addSubview:scrollView];
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(navBar.mas_bottom);
        make.left.and.right.and.bottom.equalTo(self.view);
    }];
    scrollView.alwaysBounceHorizontal=YES;
    scrollView.scrollEnabled=NO;
    scrollView.showsHorizontalScrollIndicator=NO;
    scrollView.pagingEnabled=YES;
    
    viewContent=[UIView new];
    [scrollView addSubview:viewContent];
    [viewContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(scrollView);
        make.height.equalTo(scrollView);
    }];
}
- (NSDictionary*) dicBarItemAttr
{
    if (!_dicBarItemAttr){
        _dicBarItemAttr= @{NSFontAttributeName:[UIFont systemFontOfSize:18.0f],
                           NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#0075ba"]};
    }
    return _dicBarItemAttr;
}
/**
 *  取消
 */
- (void) dismiss
{
    UIViewController * parent = [self.view containingViewController];
    if ([parent isKindOfClass:[UINavigationController class]]){
        UINavigationController *nav=(UINavigationController*)parent;
        UIViewController *vc=nav.viewControllers[nav.viewControllers.count-1];
        if ([vc respondsToSelector:@selector(dismissSemiModalView)]) {
            [vc dismissSemiModalView];
        }
        return;
    }
    if ([parent respondsToSelector:@selector(dismissSemiModalView)]) {
        [parent dismissSemiModalView];
    }
}

- (void)hideKeyBoard
{
    for (UIWindow* window in [UIApplication sharedApplication].windows)
    {
        for (UIView* view in window.subviews)
        {
            [self dismissAllKeyBoardInView:view];
        }
    }
}

-(BOOL) dismissAllKeyBoardInView:(UIView *)view
{
    if([view isFirstResponder])
    {
        [view resignFirstResponder];
        return YES;
    }
    for(UIView *subView in view.subviews)
    {
        if([self dismissAllKeyBoardInView:subView])
        {
            return YES;
        }
    }
    return NO;
}
- (UIBarButtonItem*) btnSpace
{
    return [[UIBarButtonItem alloc] initWithCustomView:[[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 40)]];
}
@end
