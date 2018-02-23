//
//  HScrollViewController.m
//  HUIKitLib_Demo
//
//  Created by HeLiulin on 15/11/17.
//  Copyright © 2015年 上海翔汇网络科技有限公司. All rights reserved.
//

#import "HScrollViewController.h"

@implementation HScrollViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.scrollView = [[UIScrollView alloc] init];
    [self.view addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.edges.equalTo(self.view);
    }];
    self.scrollView.alwaysBounceVertical = YES;
    self.scrollView.scrollEnabled = YES;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.scrollsToTop = YES;

    self.viewContent = [[UIView alloc] init];

    [self.scrollView addSubview:self.viewContent];
    [self.viewContent mas_makeConstraints:^(MASConstraintMaker* make) {
        make.edges.equalTo(self.scrollView);
        make.width.equalTo(self.scrollView);

    }];
    [self createView:self.viewContent];
    [self addCreateView:self.scrollView];

    if (self.viewContent.subviews.count > 0) {
        [self.viewContent mas_makeConstraints:^(MASConstraintMaker* make) {
            make.bottom.equalTo(self.viewContent.subviews.lastObject.mas_bottom).offset(10);
        }];
    }
}
- (void)createView:(UIView*)contentView
{
    
}
-(void)addCreateView:(UIScrollView *)contentView{

}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 0;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
    }
    return cell;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //    if ([scrollView isKindOfClass:[UITableView class]] && self.isHome && _isVisible) {
    //scrollView已经有拖拽手势，直接拿到scrollView的拖拽手势
    UIPanGestureRecognizer *pan = scrollView.panGestureRecognizer;
    //获取到拖拽的速度 >0 向下拖动 <0 向上拖动
    CGFloat velocity = [pan velocityInView:scrollView].y;
    
    if (velocity <- 5) {
        //向上拖动，隐藏导航栏
        [self.navigationController setNavigationBarHidden:YES animated:YES];
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    }else if (velocity > 5) {
        //向下拖动，显示导航栏
        [self.navigationController setNavigationBarHidden:NO animated:YES];
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    }else if(velocity == 0){
        //停止拖拽
    }
    //    }
}



@end
