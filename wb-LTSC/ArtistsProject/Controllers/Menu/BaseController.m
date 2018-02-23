//
//  BaseController.m
//  ArtistProject
//
//  Created by HELLO WORLD on 2017/3/27.
//  Copyright © 2017年 HELLO WORLD. All rights reserved.
//

#import "BaseController.h"
#import "AlertLoginVc.h"
#import "LogonVc.h"

@interface BaseController ()
{
    UIView *menuView;
    BOOL isShowMenu;
}
@property (nonatomic, strong) UIImageView* imgLoading;
@property (nonatomic, strong) UIImageView* imgCustom;
@end

@implementation BaseController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self addLeftBtnByImageNamed:@"navi_menu"];
    [self getMenuList];
    [self addRightBarItem];
    [self getHomeArticleCategoryList];
    [self setNavigationBarWithColor:[UIColor whiteColor]];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"app_logo"]forBarMetrics:UIBarMetricsDefault];
}
- (void)getHomeArticleCategoryList
{
    [[LLRequestServer shareInstance]requestHomeArticleCategoryWithSuccess:^(LLResponse *response, id data) {
    } failure:^(LLResponse *response) {
        
    } error:^(NSError *error) {
        
    }];
}

- (void)getMenuList
{
    menuView = [[UIView alloc] initWithFrame:CGRectMake(15, 10, 200, 180)];
    menuView.backgroundColor = RGBA_COLOR(100, 100, 100, 0.5);
    NSArray *titleArr = @[@[@"国内头条",@"新闻时评"],@[@"批评家专栏",@"艺术财富"],@[@"艺术机构",@"艺术设计"],@[@"城外艺术",@"艺术人文"],@[@"艺术家",@"艺术教育"]];
    for (NSInteger i = 0; i < 5; i ++) {
        for (NSInteger j = 0; j < 2; j ++) {
            UIButton *btn = [UIButton buttonWithType:(UIButtonTypeSystem)];
            [btn setTitle:titleArr[i][j] forState:(UIControlStateNormal)];
            btn.frame = CGRectMake(10 + j * 90, 10 + i * 35, 80, 25);
            [btn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
            btn.backgroundColor = RGBCOLOR(169, 33, 41);
            btn.tag = 2*i + j;
            [btn addTarget:self action:@selector(btnAction:) forControlEvents:(UIControlEventTouchUpInside)];
            [menuView addSubview:btn];
        }
    }
    menuView.alpha = 0;
    [self.view addSubview:menuView];
}

- (void)btnAction:(UIButton *)btn
{
    if (btn.tag == 0) {//国内头条
        HeadlineBaseController *lineBaseVC = [[HeadlineBaseController alloc] init];
        lineBaseVC.term_id = @"13";
        [self.navigationController pushViewController:lineBaseVC animated:YES];
    }else if (btn.tag == 1) {//新闻时评
        HeadlineBaseController *lineBaseVC = [[HeadlineBaseController alloc] init];
        lineBaseVC.term_id = @"15";
        [self.navigationController pushViewController:lineBaseVC animated:YES];
    }else if (btn.tag == 2) {//批评家专栏
        HeadlineBaseController *lineBaseVC = [[HeadlineBaseController alloc] init];
        lineBaseVC.term_id = @"17";
        [self.navigationController pushViewController:lineBaseVC animated:YES];
    }else if (btn.tag == 3) {//艺术财富
        HeadlineBaseController *lineBaseVC = [[HeadlineBaseController alloc] init];
        lineBaseVC.term_id = @"4";
        [self.navigationController pushViewController:lineBaseVC animated:YES];
    }else if (btn.tag == 4) {//艺术机构
        HeadlineBaseController *lineBaseVC = [[HeadlineBaseController alloc] init];
        lineBaseVC.term_id = @"15";
        [self.navigationController pushViewController:lineBaseVC animated:YES];
    }else if (btn.tag == 5) {//艺术设计
        HeadlineBaseController *lineBaseVC = [[HeadlineBaseController alloc] init];
        lineBaseVC.term_id = @"8";
        [self.navigationController pushViewController:lineBaseVC animated:YES];
    }else if (btn.tag == 6) {//域外艺术
        HeadlineBaseController *lineBaseVC = [[HeadlineBaseController alloc] init];
        lineBaseVC.term_id = @"15";
        [self.navigationController pushViewController:lineBaseVC animated:YES];
    }else if (btn.tag == 7) {//艺术人文
        HeadlineBaseController *lineBaseVC = [[HeadlineBaseController alloc] init];
        lineBaseVC.term_id = @"7";
        [self.navigationController pushViewController:lineBaseVC animated:YES];
    }else if (btn.tag == 8) {//艺术家
        HeadlineBaseController *lineBaseVC = [[HeadlineBaseController alloc] init];
        lineBaseVC.term_id = @"8";
        [self.navigationController pushViewController:lineBaseVC animated:YES];
    }else if (btn.tag == 9) {//艺术教育
        HeadlineBaseController *lineBaseVC = [[HeadlineBaseController alloc] init];
        lineBaseVC.term_id = @"15";
        [self.navigationController pushViewController:lineBaseVC animated:YES];
    }
    RecommendViewController *commendVC = [[RecommendViewController alloc] init];
    commendVC.title = btn.titleLabel.text;
    [self.navigationController pushViewController:commendVC animated:YES];
}
- (void)leftBtnByImageNamedAction
{
    isShowMenu = !isShowMenu;//显示菜单栏与隐藏菜单栏
    if (isShowMenu) {
        menuView.alpha = 1;
        [self.view bringSubviewToFront:menuView];
    }else{
        menuView.alpha = 0;
    }
}

- (void)addRightBarItem {
    UIBarButtonItem *search = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"navi_search"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style: UIBarButtonItemStylePlain target:self action:@selector(changeSearch)];
    // 扫一扫
    UIBarButtonItem *contact=[[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"navi_contact"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style: UIBarButtonItemStylePlain target:self action:@selector(changeContact)];
    
    self.navigationItem.rightBarButtonItems = @[search,contact];
}

- (void)changeSearch
{
    
}
- (void)changeContact
{
    
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    
    return UIStatusBarStyleLightContent;
}
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

#pragma mark - 加载动画HUD
- (MBProgressHUD*)hudLoading
{
    if (!_hudLoading) {
        _hudLoading = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        _hudLoading.backgroundColor = [UIColor clearColor];
        _hudLoading.mode = MBProgressHUDModeIndeterminate;
        _hudLoading.customView=self.imgLoading;
        
        _hudLoading.activityIndicatorColor = [UIColor grayColor];
        _hudLoading.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
        _hudLoading.backgroundView.color =  [UIColor colorWithWhite:0.f alpha:.2f];
        _hudLoading.label.text=@"加载中...";
        _hudLoading.label.textColor = kWhiteColor;

        _hudLoading.label.font = [UIFont systemFontOfSize:15];
        _hudLoading.removeFromSuperViewOnHide = NO;
    }
    return _hudLoading;
}
#pragma mark - 自定义提示HUD
- (MBProgressHUD*)hudCustom
{
    if (!_hudCustom) {
        _hudCustom = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        _hudCustom.mode = MBProgressHUDModeCustomView;
        _hudCustom.customView = self.imgCustom;
        _hudCustom.backgroundView.color =  [[UIColor blackColor]colorWithAlphaComponent:0.5];
        _hudCustom.label.textColor = [UIColor whiteColor];
        _hudCustom.label.font = [UIFont systemFontOfSize:15];
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

- (void)showOkHUDNotAutoHideWithTitle:(NSString*)title SubTitle:(NSString*)subTitle
{
    self.hudCustom.label.text = title;
    self.hudCustom.detailsLabel.text = subTitle;
    self.imgCustom.image = [UIImage imageNamed:@"icon_ok"];
    [self.hudCustom showAnimated:YES];
}

- (void)showOkHUDWithTitle:(NSString*)title SubTitle:(NSString*)subTitle
{
    [self showOkHUDNotAutoHideWithTitle:title SubTitle:subTitle];
    [self.hudCustom hideAnimated:YES afterDelay:1];
}
- (void)showOkHUDWithTitle:(NSString*)title SubTitle:(NSString*)subTitle Complete:(void (^)())complete
{
    [self showOkHUDWithTitle:title SubTitle:subTitle];
    
    [self.hudCustom showAnimated:YES whileExecutingBlock:^{
        sleep(1);
    }completionBlock:^{
                     if (complete) {
                         complete();
                     }
                 }];
}

- (void)showLoadingHUDWithTitle:(NSString*)title SubTitle:(NSString*)subTitle;
{
    self.hudLoading.label.text = title;
    self.hudLoading.detailsLabel.text = subTitle;
    [self.view bringSubviewToFront:self.hudLoading];
    [self.hudLoading showAnimated:YES];
}
- (void)showErrorHUDWithTitle:(NSString*)title SubTitle:(NSString*)subTitle Complete:(void (^)())complete
{
    [self showErrorHUDNotAutoHideWithTitle:title SubTitle:subTitle];
    
    [self.hudCustom showAnimated:YES whileExecutingBlock:^{
        sleep(1);
    }completionBlock:^{
                     if (complete) {
                         complete();
                     }
    }];

        NSString* msg = [subTitle copy];
    if (msg.length>0) {
        if([msg rangeOfString:@"其它手机登录"].location!=NSNotFound) {
            [self logonAgain];
        }
    }
}
- (void)showErrorHUDNotAutoHideWithTitle:(NSString*)title SubTitle:(NSString*)subTitle
{
    self.hudCustom.label.text = title;
    self.hudCustom.detailsLabel.text = subTitle;
    self.imgCustom.image = [UIImage imageNamed:@"icon_error"];
    [self.hudCustom showAnimated:YES];
}

-(void )hideHUD{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
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
    return;

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
- (void)hideKeyBoard
{
    for (UIWindow* window in [UIApplication sharedApplication].windows) {
        for (UIView* view in window.subviews) {
            [self dismissAllKeyBoardInView:view];
        }
    }
}
- (BOOL)showCheckErrorHUDWithTitle:(NSString*)title SubTitle:(NSString*)subTitle checkTxtField:(UITextField*)txt
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
- (NSString*)urlEncodedString:(NSString*)string
{
    NSString* encodedString = (__bridge_transfer NSString*)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (__bridge CFStringRef)string, NULL, (__bridge CFStringRef) @"!*'();:@&=+$,/?%#[]", kCFStringEncodingUTF8);
    
    return encodedString;
}
-(NSArray*)stringToJSON:(NSString*)jsonStr
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

////判断请求数据是否为空
//-(NSString*)judgeWithObj:(id)obj{
//    if ([obj isKindOfClass:[NSDictionary class]]) {
//        NSArray* arr = [obj allKeys];
//        for (NSString* keyStr in arr) {
//            if ([keyStr isEqualToString:@"res"]) {
//                if ([[NSString stringWithFormat:@"%@",obj[keyStr]] isEqualToString:@"0"]) {
//                    
//                }
//            }
//        }
//    }
//    return @"";
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    [[SDImageCache sharedImageCache] setValue:nil forKey:@"memCache"];
    [[SDImageCache sharedImageCache]clearMemory];
    [[SDImageCache sharedImageCache]clearDisk];
    // Dispose of any resources that can be recreated.
}

@end
