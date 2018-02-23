//
//  ArtTabBarController.m
//  ArtistProject
//
//  Created by HELLO WORLD on 2017/3/5.
//  Copyright © 2017年 HELLO WORLD. All rights reserved.
//

#import "ArtTabBarController.h"
#import "MemberMallController.h"
#import "HomeController.h"
#import "ClassifyController.h"
#import "MessageController.h"
#import "UserController.h"
#import "AlertLoginVc.h"
#import "ShoppingMallViewController.h"
#import "NavigationController.h"
#import "LogonVc.h"
#import "LiveListController.h"
#import "AcademyViewController.h"
#import "ShopCityViewController.h"
#import "RecentVc.h"
#define BUTTONWIDTH (SCREEN_WIDTH/5)

@interface ArtTabBarController ()
@property (nonatomic,strong) NSMutableArray *tabbarButtonArray;
@property (nonatomic,strong) NSArray *tabbarNormalImageArray;
@property (nonatomic,strong) NSArray *tabbarHlImageArray;
@property (nonatomic,strong) NSMutableArray *navArr;
@end

@implementation ArtTabBarController

-(NSMutableArray *)navArr{
    if (!_navArr) {
        _navArr = [NSMutableArray array];
    }
    return _navArr;
}

- (NSArray *)imageArray
{
    return @[@"首页1",@"商城1",@"会员1",@"业务线1",@"我1",@"首页2",@"商城2",@"会员2",@"业务线2",@"我2"];
}

- (NSArray *)titleArray {
    return @[[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"],@"直播",@"展览",@"美城",@"美院"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.selectedIndex = 0;
    [self createTabBarBackground];
    [self createViewControllers];
    [self createTabBarItems];
}

-(void)createTabBarBackground{
    UIImageView  *customView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0, self.tabBar.frame.size.width, self.tabBar.frame.size.height)];
    [customView setImage:[UIImage imageNamed:@"tabbar_"]];
    customView.userInteractionEnabled = YES;
    [self.tabBar addSubview:customView];
}

-(void)createViewControllers
{
//    // 老斯特城
//    HomeController * homevc = [[HomeController alloc] init];
//    [self tabBarAddViewController:homevc];
    // 首页
    LiveListController *recentVc = [[UIStoryboard storyboardWithName:@"RencentVC" bundle:nil]  instantiateViewControllerWithIdentifier:@"RecentVC"];
    [self tabBarAddViewController:recentVc];
    // 直播
    LiveListController *liveListVC = [[UIStoryboard storyboardWithName:@"LiveListController" bundle:nil]  instantiateViewControllerWithIdentifier:@"LiveListController"];
    [self tabBarAddViewController:liveListVC];
    
    ;
    
    // 会员区
//    MemberMallController * memberAreavc = [[MemberMallController alloc] init];
//    [self tabBarAddViewController:memberAreavc];
    
    // 展览
    HotShowController *hotShowVC = [[HotShowController alloc] init];
    hotShowVC.navigationItem.title = @"展览";
    [self tabBarAddViewController:hotShowVC];
    
//    // 商城
//    ShoppingMallViewController * shoppingMallVC = [[ShoppingMallViewController alloc] init];
//    [self tabBarAddViewController:shoppingMallVC];

    // 美城
    ShopCityViewController *shopCityVC = [[UIStoryboard storyboardWithName:@"ShopCity" bundle:nil]instantiateViewControllerWithIdentifier:@"ShopCity"];
    [self tabBarAddViewController:shopCityVC];

//    // 业务线
//    ClassifyController * lookvc = [[ClassifyController alloc] init];
//    [self tabBarAddViewController:lookvc];
    // 美院
    AcademyViewController *academyVC = [[UIStoryboard storyboardWithName:@"AcademyViewController" bundle:nil]  instantiateViewControllerWithIdentifier:@"AcademyViewController"];
//    // 我的
//    UserController * minevc = [[UserController alloc] init];
//    [self tabBarAddViewController:minevc];
   
    [self tabBarAddViewController:academyVC];

    self.viewControllers = _navArr;
}

-(void)tabBarAddViewController:(UIViewController *)viewController{
    
    NavigationController * nav = [[NavigationController alloc]initWithRootViewController:viewController];
    [nav.navigationBar setBackgroundImage:[UIImage imageNamed:@"tabbar_"]forBarMetrics:UIBarMetricsDefault];
    UIImageView *statusBarView = [[UIImageView alloc] initWithFrame:CGRectMake(0, -20, self.view.bounds.size.width, 20)];
    [statusBarView setBackgroundColor:RGB_COLOR(169, 33, 41)];
    [nav.navigationBar addSubview:statusBarView];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [self.navArr addObject:nav];
}

-(void)createTabBarItems
{
    _tabbarButtonArray = [NSMutableArray array];
    for (int i=0 ; i<5; i++)
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(i*BUTTONWIDTH,0,BUTTONWIDTH, self.tabBar.frame.size.height);
        [button setTitle:[self titleArray][i] forState:UIControlStateNormal];
        
         [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
         [button setTitleColor:RGB(50, 50, 50) forState:UIControlStateSelected];
                button.titleLabel.textAlignment = NSTextAlignmentCenter;
                button.titleLabel.font = ART_FONT(ARTFONT_OZ);
        [button setImage:[UIImage imageNamed:[[self imageArray] objectAtIndex:i]] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:[[self imageArray] objectAtIndex:i+5]] forState:UIControlStateSelected];
        
        [button setTitleEdgeInsets:UIEdgeInsetsMake( (35.0),-button.imageView.frame.size.width, 0.0,0.0)];
         [button setImageEdgeInsets:UIEdgeInsetsMake((-5.0), 0.0,(5.0), -button.titleLabel.bounds.size.width)];
        
        
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.tabBar addSubview:button];
        button.tag = i;
        [_tabbarButtonArray addObject:button];
        if (button.tag == self.selectedIndex) {
            button.selected = YES;
        }
    }
}
- (void)buttonClick:(UIButton *)sender
{
    [_tabbarButtonArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UIButton *bt = (UIButton *)obj;
        bt.selected = NO;
    }];
    self.selectedIndex = sender.tag;
    sender.selected = YES;
    if (sender.tag==2)
    {
       // [self isLogin];//判断登录
//        if([[Global sharedInstance].userInfo.verified integerValue] != 1){
//            [ArtUIHelper addHUDInView:self.view text:@"会员专区,请先认证会员" hideAfterDelay:1.0];
//            return;
//        }
    }
}
- (BOOL)isLogin
{
    if (![[Global sharedInstance] userID]) {
        LogonVc* login = [[LogonVc alloc] initWithNibName:@"LogonVc" bundle:nil];
        login.navTitle = @"用户验证";
        login.hidesBottomBarWhenPushed = YES;
        login.whichControl = @"tabBar";
        UINavigationController* nav  = (UINavigationController*)self.selectedViewController;
        nav.hidesBottomBarWhenPushed = YES;
        [nav pushViewController:login animated:NO];
        return NO;
    }
    return YES;
    
}
-(void)JumpToControlForIndex:(NSInteger)index TransitionType:(UISSTransitionType)type whichControl:(NSString *)whichControl
{
    [_tabbarButtonArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UIButton *bt = (UIButton *)obj;
        bt.selected = NO;
    }];
    
    self.selectedIndex = index;
    UIButton *bt = _tabbarButtonArray[index];
    bt.selected = YES;
    
    if (whichControl.length>0) {
        UINavigationController* nav = self.selectedViewController;
        [nav pushViewController:[[NSClassFromString(whichControl) alloc]init] animated:YES];
        [self StartAnimation:type];
    }
}
-(void)StartAnimation:(UISSTransitionType)type{
    CATransition *transition = [CATransition animation];
    transition.duration = 0.3f;
    transition.type = kCATransitionPush;
    if (type==UISSTransitionFromLeft) {
        transition.subtype = kCATransitionFromLeft;
    }else if(type==UISSTransitionFromRight){
        transition.subtype = kCATransitionFromRight;
    }else if(type==UISSTransitionFromBottom){
        transition.subtype = kCATransitionFromBottom;
    }else{
        transition.subtype = kCATransitionFromTop;
    }
    [self.view.layer addAnimation:transition forKey:nil];
}

@end
