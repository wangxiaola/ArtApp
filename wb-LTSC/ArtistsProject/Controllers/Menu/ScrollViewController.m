//
//  ScrollViewController.m
//  ArtistProject
//
//  Created by HELLO WORLD on 2017/3/28.
//  Copyright © 2017年 HELLO WORLD. All rights reserved.
//

#import "ScrollViewController.h"
#import "HomeController.h"
#import "MyHomePageDockerVC.h"
@interface ScrollViewController ()<UIGestureRecognizerDelegate>

@end

@implementation ScrollViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 遍历获取字体名称
//    for(NSString *fontFamilyName in [UIFont familyNames])
//    {
//        NSLog(@"family:'%@'",fontFamilyName);
//        for(NSString *fontName in [UIFont fontNamesForFamilyName:fontFamilyName])
//        {
//            NSLog(@"\tfont:'%@'",fontName);
//        }
//        NSLog(@"-------------");
//    }
    //设置导航栏标题字体和颜色
    NSDictionary* dictTitle = @{ NSFontAttributeName : ART_FONT(ARTFONT_OE),
        NSForegroundColorAttributeName : kTitleColor };
    kPrintLog(dictTitle);
    self.navigationController.navigationBar.titleTextAttributes = dictTitle;
    //设置导航栏左右按钮字体和颜色
    NSDictionary* dicLeftRight = @{ NSFontAttributeName : [UIFont systemFontOfSize:15.0f],
                                    NSForegroundColorAttributeName : kTitleColor };
    [[UIBarButtonItem appearance] setTitleTextAttributes:dicLeftRight forState:UIControlStateNormal];
    
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.dataDic = [[NSMutableDictionary alloc]init];
    self.pageIndex = 1;
    self.tabView = [[UITableView alloc]init];
    self.tabView.showsVerticalScrollIndicator = NO;

    self.tabView.tableFooterView = [UIImageView new];
    self.tabView.delegate = self;
    self.tabView.dataSource = self;
//    if (ISIOS7Later) {//ios7之前
//        [self.tabView setSeparatorInset:UIEdgeInsetsZero];
//    }
//    if (ISIOS8Later) {//iOS8之前
//        [self.tabView setLayoutMargins:UIEdgeInsetsZero];
//    }

    if (self.isOpenHeaderRefresh){
        __weak typeof(self)weakSelf = self;
        self.tabView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [weakSelf refreshData];
        }];
    }
    
    if (self.isOpenFooterRefresh){
        __weak typeof(self)weakSelf = self;
        self.tabView.mj_footer = [MJRefreshAutoStateFooter footerWithRefreshingBlock:^{
            [weakSelf loadMoreData];
        }];
    }
    [self.view addSubview:self.tabView];
    [self createView];
    [self loadData];
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer*)gestureRecognizer
{
    if (self.navigationController.viewControllers.count == 1) //关闭主界面的右滑返回
    {
        return NO;
    }else {
        return YES;
    }
}
-(void)createView{
    [self setNavigationBarWithColor:[UIColor whiteColor]];
    
}
-(void)loadData{

}
-(void)loadMoreData{
 [self.tabView.mj_footer endRefreshing];
}
-(void)refreshData{
 [self.tabView.mj_header endRefreshing];
}
-(void)loadAgain{

}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 0;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    if (cell==nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%ld",indexPath.row];
    return cell;
}
//- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
//
//{
//    if (indexPath.section==0) {
//        if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
//
//            [cell setSeparatorInset:UIEdgeInsetsMake(0, SCREEN_WIDTH, 0, 0)];
//
//        }
//
//        if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
//
//            [cell setLayoutMargins:UIEdgeInsetsMake(0, SCREEN_WIDTH, 0, 0)];
//
//        }
//
//    }
//}

-(void)setNavigationBarWithColor:(UIColor *)color
{
    UIImage *image = [[UIImage alloc]init];
   
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setBarStyle:UIBarStyleDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
     self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTranslucent:NO];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if ([scrollView isKindOfClass:[UITableView class]]||[scrollView isKindOfClass:[UICollectionView class]]) {
        //scrollView已经有拖拽手势，直接拿到scrollView的拖拽手势
        UIPanGestureRecognizer *pan = scrollView.panGestureRecognizer;
        //获取到拖拽的速度 >0 向下拖动 <0 向上拖动
        CGFloat velocity = [pan velocityInView:scrollView].y;
        
        if (velocity <- 10){
            //向上拖动，隐藏导航栏
            if (![Global sharedInstance].isHideState){
                [Global sharedInstance].isHideState = YES;
                if(self.obj && [_obj isKindOfClass:[HomeController class]]){ // 判断是否为首页控制器
                HomeController* homeVc= (HomeController*)self.obj;
                [homeVc hideStateView];
               }
                else if(self.obj && [_obj isKindOfClass:[MyHomePageDockerVC class]]){ // 判断是否为首页控制器
                    MyHomePageDockerVC* homeVc= (MyHomePageDockerVC*)self.obj;
                    [homeVc hideStateView];
                }
            }
//            if (![Global sharedInstance].isHideState){
//                [Global sharedInstance].isHideState = YES;
//                if(self.obj && [_obj isKindOfClass:[MyHomePageDockerVC class]]){ // 判断是否为首页控制器
//                    MyHomePageDockerVC* homeVc= (MyHomePageDockerVC*)self.obj;
//                    [homeVc hideStateView];
//                }
//            }
        }else if (velocity > 10){
            //向下拖动，显示导航栏
            if ([Global sharedInstance].isHideState){
                [Global sharedInstance].isHideState = NO;
                if(self.obj && [_obj isKindOfClass:[HomeController class]]){// 判断是否为首页控制器
                HomeController* homeVc= (HomeController*)self.obj;
                [homeVc showStateView];
              }
                else if(self.obj && [_obj isKindOfClass:[MyHomePageDockerVC class]]){ // 判断是否为首页控制器
                    MyHomePageDockerVC* homeVc= (MyHomePageDockerVC*)self.obj;
                    [homeVc showStateView];
                }
           }
        }else if(velocity == 0){
            //停止拖拽
        }
    }
}
@end
