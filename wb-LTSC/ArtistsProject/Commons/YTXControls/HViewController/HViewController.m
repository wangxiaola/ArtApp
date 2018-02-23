//
//  HViewController.m
//  Hospital
//
//  Created by by Heliulin on 15/5/19.
//  Copyright (c) 2015年 上海翔汇网络技术有限公司. All rights reserved.
//
#import "HNavigationBar.h"
#import "HViewController.h"
#import "AlertLoginVc.h"
#import "LogonVc.h"
//#import "CartVC.h"

@interface HViewController () <UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIImageView* imgLoading;
@property (nonatomic, strong) UIImageView* imgCustom;
@property (nonatomic, assign) BOOL isVisible;
@end

@implementation HViewController
@synthesize navBarHight;
@synthesize navBottomY;

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.view.backgroundColor = [UIColor whiteColor];
    // [(HNavigationBar*)self.navigationController.navigationBar setNavigationBarWithColor:kWhiteColor];
    //    //设定导航栏为非隐藏
    //    [(HNavigationBar*)self.navigationController.navigationBar setHidden:NO];
    //    //设定导航栏为非透明
    //    [(HNavigationBar*)self.navigationController.navigationBar setTranslucent:NO];
    //
    //    [self.tabBarController.tabBar setBackgroundImage:[UIImage imageWithColor:[UIColor blackColor]]];
    //    [self.tabBarController.tabBar setShadowImage:[UIImage imageWithColor:[UIColor blackColor]]];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    [[UIApplication sharedApplication] setStatusBarHidden:NO]; //防止使用拍照控件后导致状态栏隐藏
    //设置导航栏标题字体和颜色
    NSDictionary* dictTitle = @{ NSFontAttributeName : [UIFont systemFontOfSize:18.0f],
                                 NSForegroundColorAttributeName : kTitleColor };
    self.navigationController.navigationBar.titleTextAttributes = dictTitle;
    //设置导航栏左右按钮字体和颜色
    NSDictionary* dicLeftRight = @{ NSFontAttributeName : [UIFont systemFontOfSize:15.0f],
                                    NSForegroundColorAttributeName : kTitleColor };
    [[UIBarButtonItem appearance] setTitleTextAttributes:dicLeftRight forState:UIControlStateNormal];
    
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    _isVisible = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer*)gestureRecognizer
{
    if (self.navigationController.viewControllers.count == 1) //关闭主界面的右滑返回
    {
        return NO;
    }
    else {
        return YES;
    }
}

- (void)leftBarItem_Click
{
    //    NSMutableArray *vcs=[[NSMutableArray alloc] initWithArray:self.navigationController.viewControllers];
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];//隐藏键盘如果有键盘
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tabBarController.tabBar.hidden =YES;
    self.isFristLaunch = YES;
    //导航栏高度
    self.navBarHight = self.navigationController.navigationBar.frame.size.height;
    self.navBottomY = kStatusBarH + navBarHight;
    [self.view setBackgroundColor:[UIColor colorWithHexString:@"f4f4f4"]];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    //设置导航栏返回按钮样式
    UIButton *customButton = [UIButton buttonWithType:UIButtonTypeCustom];
    customButton.frame = CGRectMake(0, 0, 14, 60);
    [customButton addTarget:self action:@selector(leftBarItem_Click) forControlEvents:UIControlEventTouchUpInside];
    [customButton setImage:[UIImage imageNamed:@"icon_navigationbar_back"] forState:UIControlStateNormal];
    customButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    UIBarButtonItem* leftBarItem = [[UIBarButtonItem alloc] initWithCustomView:customButton];
    self.navigationItem.leftBarButtonItem = leftBarItem;
}
#pragma mark - 加载动画HUD
- (MBProgressHUD*)hudLoading
{
    if (!_hudLoading) {
        _hudLoading = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        _hudLoading.color = [UIColor colorWithHexString:@"#666666"];
        _hudLoading.backgroundColor = [UIColor clearColor];
        _hudLoading.mode = MBProgressHUDModeIndeterminate;
        //        _hudLoading.customView=self.imgLoading;
        _hudLoading.activityIndicatorColor = [UIColor grayColor];
        _hudLoading.dimBackground = NO;
        //        _hudLoading.labelText=@"加载中...";
        _hudLoading.labelColor = kWhiteColor; //[UIColor colorWithHexString:@"#999999"];
        _hudLoading.labelFont = [UIFont systemFontOfSize:15];
        _hudLoading.removeFromSuperViewOnHide = NO;
    }
    return _hudLoading;
}

- (UIImageView*)imgLoading
{
    if (!_imgLoading) {
        _imgLoading = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 65)];
        // 设置即将刷新状态的动画图片（一松开就会刷新的状态）
        NSMutableArray* refreshingImages = [NSMutableArray array];
        for (NSUInteger i = 1; i <= 11; i++) {
            NSString* imgName = @"";
            if (i > 9) {
                imgName = [NSString stringWithFormat:@"%lu", (unsigned long)i];
            }
            else {
                imgName = [NSString stringWithFormat:@"0%lu", (unsigned long)i];
            }
            
            UIImage* image = [UIImage imageNamed:[NSString stringWithFormat:@"dropdown_loading_0%@", imgName]];
            [refreshingImages addObject:image];
        }
        
        _imgLoading.animationImages = refreshingImages;
        _imgLoading.animationDuration = 1.1;
        _imgLoading.animationRepeatCount = 3000;
    }
    [_imgLoading stopAnimating];
    [_imgLoading startAnimating];
    return _imgLoading;
}
- (void)showLoadingHUDWithTitle:(NSString*)title SubTitle:(NSString*)subTitle;
{
    self.hudLoading.labelText = title;
    self.hudLoading.detailsLabelText = subTitle;
    [self.view bringSubviewToFront:self.hudLoading];
    [self.hudLoading show:YES];
}
#pragma mark - 自定义提示HUD
- (MBProgressHUD*)hudCustom
{
    if (!_hudCustom) {
        _hudCustom = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        _hudCustom.color = [UIColor colorWithHexString:@"#666666"];
        _hudCustom.mode = MBProgressHUDModeCustomView;
        _hudCustom.customView = self.imgCustom;
        _hudCustom.dimBackground = YES;
        _hudCustom.labelColor = [UIColor whiteColor];
        _hudCustom.labelFont = [UIFont systemFontOfSize:15];
        _hudCustom.removeFromSuperViewOnHide = NO;
    }
    return _hudCustom;
}

- (UIImageView*)imgCustom
{
    if (!_imgCustom) {
        _imgCustom = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 32, 32)];
    }
    return _imgCustom;
}

- (void)showOkHUDWithTitle:(NSString*)title SubTitle:(NSString*)subTitle
{
    [self showOkHUDNotAutoHideWithTitle:title SubTitle:subTitle];
    [self.hudCustom hide:YES afterDelay:1];
}

- (void)showOkHUDWithTitle:(NSString*)title SubTitle:(NSString*)subTitle Complete:(void (^)())complete
{
    [self showOkHUDWithTitle:title SubTitle:subTitle];
    [self.hudCustom showAnimated:YES whileExecutingBlock:^{
        sleep(1);
    }
                 completionBlock:^{
                     if (complete) {
                         complete();
                     }
                 }];
}

- (void)showErrorHUDWithTitle:(NSString*)title SubTitle:(NSString*)subTitle Complete:(void (^)())complete
{
    [self showErrorHUDNotAutoHideWithTitle:title SubTitle:subTitle];
    [self.hudCustom showAnimated:YES whileExecutingBlock:^{
        sleep(1);
    }
                 completionBlock:^{
                     if (complete) {
                         complete();
                     }
                 }];
}

- (BOOL)showCheckErrorHUDWithTitle:(NSString*)title SubTitle:(NSString*)subTitle checkTxtField:(HTextField*)txt
{
    NSString* strTxtCheck = txt.text;
    strTxtCheck = strTxtCheck ? strTxtCheck : @"";
    if ([strTxtCheck checkIsEmpty]) {
        
        [self showErrorHUDWithTitle:title SubTitle:subTitle Complete:^{
            [txt becomeFirstResponder];
        }];
        return YES;
    }
    else {
        return NO;
    }
}

- (void)showOkHUDNotAutoHideWithTitle:(NSString*)title SubTitle:(NSString*)subTitle
{
    self.hudCustom.labelText = title;
    self.hudCustom.detailsLabelText = subTitle;
    self.imgCustom.image = [UIImage imageNamed:@"icon_ok"];
    [self.hudCustom show:YES];
}
- (void)showErrorHUDNotAutoHideWithTitle:(NSString*)title SubTitle:(NSString*)subTitle
{
    self.hudCustom.labelText = title;
    self.hudCustom.detailsLabelText = subTitle;
    self.imgCustom.image = [UIImage imageNamed:@"icon_error"];
    [self.hudCustom show:YES];
}
- (void)hideKeyBoard
{
    for (UIWindow* window in [UIApplication sharedApplication].windows) {
        for (UIView* view in window.subviews) {
            [self dismissAllKeyBoardInView:view];
        }
    }
}

- (BOOL)dismissAllKeyBoardInView:(UIView*)view
{
    if ([view isFirstResponder]) {
        [view resignFirstResponder];
        return YES;
    }
    for (UIView* subView in view.subviews) {
        if ([self dismissAllKeyBoardInView:subView]) {
            return YES;
        }
    }
    return NO;
}
-(void)logonAgain{
//    AlertLoginVc* login = [[AlertLoginVc alloc] initWithNibName:@"AlertLoginVc" bundle:nil];
//    login.navTitle = @"用户验证";
//    //        login.state = @"push";
//    login.hidesBottomBarWhenPushed = YES;
//    login.whichControl = [NSString stringWithFormat:@"%@",self.class];
//    [self.navigationController pushViewController:login animated:YES];
    LogonVc* login = [[LogonVc alloc] initWithNibName:@"LogonVc" bundle:nil];
    login.navTitle = @"用户验证";
    login.hidesBottomBarWhenPushed = YES;
    login.whichControl = [NSString stringWithFormat:@"%@",self.class];
    [self.navigationController pushViewController:login animated:YES];
    
}
- (BOOL)isLogin
{
    if (![[Global sharedInstance] userID]) {
//        AlertLoginVc* login = [[AlertLoginVc alloc] initWithNibName:@"AlertLoginVc" bundle:nil];
//        login.navTitle = @"用户验证";
//        //        login.state = @"push";
//        login.hidesBottomBarWhenPushed = YES;
//        login.whichControl = [NSString stringWithFormat:@"%@",self.class];
//        [self.navigationController pushViewController:login animated:YES];
        LogonVc* login = [[LogonVc alloc] initWithNibName:@"LogonVc" bundle:nil];
        login.navTitle = @"用户验证";
        login.hidesBottomBarWhenPushed = YES;
        login.whichControl = [NSString stringWithFormat:@"%@",self.class];
        [self.navigationController pushViewController:login animated:YES];
        return NO;
    }
    return YES;

}

- (BOOL)isNavLogin
{
    if (![[Global sharedInstance] userID]) {
//        AlertLoginVc* login = [[AlertLoginVc alloc] initWithNibName:@"AlertLoginVc" bundle:nil];
//        login.navTitle = @"用户验证";
//        //        login.state = @"push";
//        login.hidesBottomBarWhenPushed = YES;
//        login.whichControl = [NSString stringWithFormat:@"%@",self.class];
//        [self.navigationController pushViewController:login animated:YES];
        LogonVc* login = [[LogonVc alloc] initWithNibName:@"LogonVc" bundle:nil];
        login.navTitle = @"用户验证";
        login.hidesBottomBarWhenPushed = YES;
        login.whichControl = [NSString stringWithFormat:@"%@",self.class];
        [self.navigationController pushViewController:login animated:YES];
        return NO;
    }
    return YES;
}

- (NSString*)dictionaryToJson:(NSDictionary*)dic

{
    
    NSError* parseError = nil;
    
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

//json字符串转为数组
- (NSArray*)stringToJSON:(NSString*)jsonStr
{
    if (jsonStr) {
        id tmp = [NSJSONSerialization JSONObjectWithData:[jsonStr dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments | NSJSONReadingMutableLeaves | NSJSONReadingMutableContainers error:nil];
        
        if (tmp) {
            if ([tmp isKindOfClass:[NSArray class]]) {
                
                return tmp;
            }
            else if ([tmp isKindOfClass:[NSString class]]
                     || [tmp isKindOfClass:[NSDictionary class]]) {
                
                return [NSArray arrayWithObject:tmp];
            }
            else {
                return nil;
            }
        }
        else {
            return nil;
        }
    }
    else {
        return nil;
    }
}

- (NSArray*)stringToJSON1:(NSString*)jsonStr
{
    NSArray* array1 = [jsonStr componentsSeparatedByString:@","];
    NSMutableArray* array2 = [[NSMutableArray alloc] init];
    for (int i = 0; i < array1.count; i++) {
        NSString* str = array1[i];
        NSDictionary* dic = [self parseJSONStringToNSDictionary:str];
        [array2 addObject:dic];
    }
    return [array2 mutableCopy];
}

//把多个json字符串转为一个json字符串
- (NSString*)objArrayToJSON:(NSArray*)array
{
    
    NSString* jsonStr = @"[";
    
    for (NSInteger i = 0; i < array.count; ++i) {
        if (i != 0) {
            jsonStr = [jsonStr stringByAppendingString:@","];
        }
        jsonStr = [jsonStr stringByAppendingString:array[i]];
    }
    jsonStr = [jsonStr stringByAppendingString:@"]"];
    
    return jsonStr;
}

- (NSDictionary*)parseJSONStringToNSDictionary:(NSString*)JSONString
{
    NSData* JSONData = [JSONString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary* responseJSON = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingMutableLeaves error:nil];
    return responseJSON;
}

- (NSString*)getVideoIDWithVideoUrl:(NSString*)strVideo
{
    NSString* sub = @"";
    NSUInteger i = 0;
    NSUInteger iMoren = 4;
    NSRange start = [strVideo rangeOfString:@"vid="];
    i = start.location + iMoren;
    if (start.length == 0) {
        start = [strVideo rangeOfString:@"id_"];
        iMoren = 3;
        i = start.location + iMoren;
    }
    if (start.length == 0) {
        return @"";
    }
    NSLog(@"%lu", (unsigned long)strVideo.length);
    for (; i < strVideo.length; i++) {
        NSString* strCoin = [strVideo substringWithRange:NSMakeRange(i, 1)];
        int asciiCode = [strCoin characterAtIndex:0]; //65
        if (!((47 < asciiCode && asciiCode < 58) || (64 < asciiCode && asciiCode < 91) || (96 < asciiCode && asciiCode < 123) || asciiCode == 61)) {
            break;
        }
    }
    sub = [strVideo substringWithRange:NSMakeRange(start.location + iMoren, i - start.location - iMoren)];
    return sub;
}

- (NSString*)urlEncodedString:(NSString*)string
{
    NSString* encodedString = (__bridge_transfer NSString*)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (__bridge CFStringRef)string, NULL, (__bridge CFStringRef) @"!*'();:@&=+$,/?%#[]", kCFStringEncodingUTF8);
    
    return encodedString;
}

#pragma mark - DZNEmptyDataSetSource Methods

//- (UIImage*) buttonImageForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state
//{
//    return [UIImage imageNamed:@"icon_Default_Refresh"];
//}

- (UIImage*)imageForEmptyDataSet:(UIScrollView*)scrollView
{
    
    switch (self.noDataMode) {
        case HNoDataModeDefault: //无数据
        {
            return [UIImage imageNamed:@"NotDataicon"];//NotDataicon bg_noData
        }
        case HNoDataModeNoCartData: //购物车空
        {
            return [UIImage imageNamed:@"NotDataicon"];//bg_noCart
        }
        case HNoDataModeNoOrderData: //无订单
        {
            return [UIImage imageNamed:@"NotDataicon"];//bg_noOrder
        }
        case HNoDataModeNoSearchResult: //搜索无结果
        {
            return [UIImage imageNamed:@"NotDataicon"];//bg_noSearch
        }
        default:
            return [UIImage imageNamed:@"NotDataicon"];//bg_noData
    }
}

- (UIColor*)backgroundColorForEmptyDataSet:(UIScrollView*)scrollView
{
    return [UIColor whiteColor];
}

#pragma mark - DZNEmptyDataSetSource Methods

- (BOOL)emptyDataSetShouldAllowTouch:(UIScrollView*)scrollView
{
    return YES;
}

- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView*)scrollView
{
    return NO;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if ([scrollView isKindOfClass:[UITableView class]] && _isHome && _isVisible) {
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
    }
}

@end
