//
//  AppDelegate.m
//  ArtistProject
//
//  Created by HELLO WORLD on 2017/3/27.
//  Copyright © 2017年 HELLO WORLD. All rights reserved.
//

#import "AppDelegate.h"
#import "HomeListDetailVc.h"
#import "GuanzhuDockerVC.h"
#import "KaiShiJiandingVC.h"
#import "SiXinVC.h"

#import "AppDelegate+ShareSDK.h"
#import <SMS_SDK/SMSSDK.h>
#import <AlipaySDK/AlipaySDK.h>

#import "OpenShareHeader.h"

#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import "WXApi.h"
#import "WeiboSDK.h"

#import "MBScrolViewController.h"
#import "UMessage.h"
#import <UserNotifications/UserNotifications.h>
#import <UserNotifications/UserNotifications.h>
#import <Bugly/Bugly.h>
@interface AppDelegate ()<WXApiDelegate,UNUserNotificationCenterDelegate>

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.tab = [[ArtTabBarController alloc]init];
    MBScrolViewController* scrVC = [[MBScrolViewController alloc]init];
    UINavigationController* nav = [[UINavigationController alloc]initWithRootViewController:scrVC];
    self.window.rootViewController = nav;
    self.window.backgroundColor=[UIColor whiteColor];
    [self.window makeKeyAndVisible];
    [ApiMap initConfig];
    [self setAppFirstLaunch];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];//设置状态栏字体为白色
    
    // 网络请求  通常放在appdelegate就可以了
    //    [HYBNetworking updateBaseUrl:BaseUrl];
    [HYBNetworking enableInterfaceDebug:YES];
    // 配置请求和响应类型，由于部分伙伴们的服务器不接收JSON传过去，现在默认值改成了plainText
    [HYBNetworking configRequestType:kHYBRequestTypeJSON
                        responseType:kHYBResponseTypeJSON
                 shouldAutoEncodeUrl:YES
             callbackOnCancelRequest:NO];
    [HYBNetworking cacheGetRequest:YES shoulCachePost:YES];
    //短信服务
//    [SMSSDK registerApp:shareAppID //13a42dab59ee3 //f3fc6baa9ac4 //1548eb3d0d378
//             withSecret:shareAppSecret]; //6e4f7396ffab6900b32d1fd32572dffc //7f3dedcb36d92deebcb373af921d635a //fe95a42f35d3fd52da8771587a179fa
    //微信支付初始化wxd81798aa61fd50b7
    [WXApi registerApp:@"wx09435b6cf2d9876a"];
    [self initOpenShare];
    //注册shareSdk
    [self registerShareSdk];
    
    //初始化方法,也可以使用(void)startWithAppkey:(NSString *)appKey launchOptions:(NSDictionary * )launchOptions httpsenable:(BOOL)value;这个方法，方便设置https请求。
    //设置 AppKey 及 LaunchOptions
    
    
   
    [UMessage startWithAppkey:UMPushAppKey launchOptions:launchOptions httpsEnable:YES];
//    1.3.0版本开始简化初始化过程。如不需要交互式的通知，下面用下面一句话注册通知即可。
    [UMessage registerForRemoteNotifications];
    [UMessage openDebugMode:YES];// 打开调试模式
    [UMessage setLogEnabled:YES];

    [Bugly startWithAppId:@"83ce97e8c0"];
//m24vPZADmhpwWuioAoHW+A6kdHtG0tlyDHsO6jzHMDOuvoWFeX5EsvGSNtfEU7WsFYzKColHdLSbzgO8T9aS8A==
    //iOS10必须加下面这段代码。
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    center.delegate = self;
    UNAuthorizationOptions types10=UNAuthorizationOptionBadge|  UNAuthorizationOptionAlert|UNAuthorizationOptionSound;
    [center requestAuthorizationWithOptions:types10     completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (granted) {
            kPrintLog(@"友盟推送注册正常");
            //点击允许
            //这里可以添加一些自己的逻辑
        } else {
            kPrintLog(@"友盟推送注册不正常");
            //点击不允许
            //这里可以添加一些自己的逻辑
        }
    }];
//    如果要在iOS10显示交互式的通知，必须注意实现以下代码
        if ([[[UIDevice currentDevice] systemVersion]intValue]>=10) {
            UNNotificationAction *action1_ios10 = [UNNotificationAction actionWithIdentifier:@"action1_ios10_identifier" title:@"打开应用" options:UNNotificationActionOptionForeground];
            UNNotificationAction *action2_ios10 = [UNNotificationAction actionWithIdentifier:@"action2_ios10_identifier" title:@"忽略" options:UNNotificationActionOptionForeground];
    
            //UNNotificationCategoryOptionNone
            //UNNotificationCategoryOptionCustomDismissAction  清除通知被触发会走通知的代理方法
            //UNNotificationCategoryOptionAllowInCarPlay       适用于行车模式
            UNNotificationCategory *category1_ios10 = [UNNotificationCategory categoryWithIdentifier:@"category101" actions:@[action1_ios10,action2_ios10]   intentIdentifiers:@[] options:UNNotificationCategoryOptionCustomDismissAction];
            NSSet *categories_ios10 = [NSSet setWithObjects:category1_ios10, nil];
            [center setNotificationCategories:categories_ios10];
        }
    //打开日志，方便调试
//    [UMessage setLogEnabled:YES];
    return YES;
}

- (void)setAppFirstLaunch
{
    if (![[UserDefaults objectForKey:@"everLaunched"] boolValue]) {
        [UserDefaults setObject:@"1" forKey:@"everLaunched"];
        [UserDefaults setObject:@"1" forKey:@"firstLaunch"];
        [UserDefaults setObject:@"1" forKey:@"APP_WEBVIEW_FONTSIZE"];
        [UserDefaults synchronize];
    }else{
        [UserDefaults setObject:@"0" forKey:@"firstLaunch"];
    }
}
/**
 *  分享初始化
 */
- (void)initOpenShare
{
//    [OpenShare connectWeiboWithAppKey:@"3671016885"];
    [OpenShare connectWeiboWithAppKey:weiboAppID];
//    [OpenShare connectWeixinWithAppId:@"wxbbd5c62da1ae8466"];
    [OpenShare connectWeixinWithAppId:wechatAppID];

}

/**********************友盟推送*************************/

- (void)application:(UIApplication*)application didRegisterUserNotificationSettings:(UIUserNotificationSettings*)notificationSettings
{
    // register to receive notifications
    [application registerForRemoteNotifications];
}

- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
    kPrintLog(deviceToken);
    [UMessage registerDeviceToken:deviceToken];
    //友盟推送处理
    NSString* token =
    [[[[deviceToken description] stringByReplacingOccurrencesOfString:@"<" withString:@""]
      stringByReplacingOccurrencesOfString:@">"
      withString:@""]
     stringByReplacingOccurrencesOfString:@" "
     withString:@""];
    NSLog(@"%@", token);
}

- (void)application:(UIApplication*)application didReceiveRemoteNotification:(NSDictionary*)userInfo
{
    [UMessage didReceiveRemoteNotification:userInfo];
}
//iOS10新增：处理前台收到通知的代理方法
-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler{
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //应用处于前台时的远程推送接受
        //关闭U-Push自带的弹出框
        [UMessage setAutoAlert:NO];
        //必须加这句代码
        [UMessage didReceiveRemoteNotification:userInfo];
//        [self dealRemoteNotification:userInfo];
        kPrintLog(@"1");
        
    }else{
        //应用处于前台时的本地推送接受
        kPrintLog(@"2");
    }
    //当应用处于前台时提示设置，需要哪个可以设置哪一个
    completionHandler(UNNotificationPresentationOptionSound|UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionAlert);
}

//iOS10新增：处理前台点击通知的代理方法
-(void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler{
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //应用处于后台时的远程推送接受
        //必须加这句代码
        [UMessage didReceiveRemoteNotification:userInfo];
        [self dealRemoteNotification:userInfo];
        kPrintLog(@"3");
    }else{
        //应用处于后台时的本地推送接受
        kPrintLog(@"4");
    }
}

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_7_0
// ios7.0以后才有此功能
- (void)application:(UIApplication*)application didReceiveRemoteNotification:(NSDictionary*)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    completionHandler(UIBackgroundFetchResultNewData);
    
    // 应用正处理前台状态下，不会收到推送消息，因此在此处需要额外处理一下
    if (application.applicationState == UIApplicationStateActive){
        kPrintLog(@"新消息");
        SIAlertView *alert=[[SIAlertView alloc] initWithTitle:@"新消息" andMessage:userInfo[@"aps"][@"alert"]];
        [alert addButtonWithTitle:@"取消" type:SIAlertViewButtonTypeCancel handler:^(SIAlertView *alertView) {
        
        }];
        [alert addButtonWithTitle:@"确定" type:SIAlertViewButtonTypeDestructive handler:^(SIAlertView *alertView) {
            [self dealRemoteNotification:userInfo];
        }];
        
        [alert show];
    }
    else {
        kPrintLog(@"新消息");
        [self dealRemoteNotification:userInfo];
    }
    return;
}
#endif
/**
 *  推送消息处理
 *
 *  @param userInfo 消息体
 */
- (void)dealRemoteNotification:(NSDictionary*)userInfo
{
    NSNotification* notification = [NSNotification notificationWithName:@"JPUSH_NOTIFICATION" object:nil userInfo:userInfo];
    [[NSNotificationCenter defaultCenter] postNotification:notification];

    //    UINavigationController* nav = tabBarVC.viewControllers[3];
    //    tabBarVC.selectedIndex = 3;
    //    {"type":3,"tid":1231251,"uid":676,"touid":"742"}
    NSDictionary* dic = userInfo[@"aps"];
    NSMutableString* responseString = [NSMutableString stringWithString:dic[@"custom"]];
    NSString* character = nil;
    for (int i = 0; i < responseString.length; i++) {
        character = [responseString substringWithRange:NSMakeRange(i, 1)];
        if ([character isEqualToString:@"\\"])
            [responseString deleteCharactersInRange:NSMakeRange(i, 1)];
    }

    NSDictionary* dict = [self dictionaryWithJsonString:responseString];

    NSLog(@"%@", userInfo);
//    2017-07-14 16:54:25.245156 ArtistsProject[3841:1351994] {
//        aps =     {
//            "after_open" = "go_custom";
//            alert = "181****6491\U8d5e\U4e86\U4f60\U7684\U52a8\U6001";
//            badge = 1;
//            custom = "{\"type\":4,\"tid\":\"1310949\",\"uid\":\"9887\",\"touid\":\"9887\"}";
//            sound = chime;
//        };
//        d = uu51079150002243028001;
//        p = 0;
//    }
    NSLog(@"%@", dict);
//    2017-07-14 16:54:30.467490 ArtistsProject[3841:1351994] {
//        tid = 1310949;
//        touid = 9887;
//        type = 4;
//        uid = 9887;
//    }
    //     1为a 艾特b，2为a 关注了b，3为a评论了b，4 为a 喜欢了b，7为a对b发送了私信，6 为a 发送了新动态
    switch ([dict[@"type"] intValue]) {
        case 1: { // 艾特
            UINavigationController* nav = self.tab.viewControllers[0];
            _tab.selectedIndex = 0;
            HomeListDetailVc * vc = [[HomeListDetailVc alloc] init];
            vc.topicid = [NSString stringWithFormat:@"%@",dict[@"tid"]];
            vc.topictype = [NSString stringWithFormat:@"%@",dict[@"type"]];
            [nav pushViewController:vc animated:YES];
        } break;
        case 2: { // 关注、粉丝
            self.tab.selectedIndex = 3;
//            self.tab.tabBar.selectedItem = 3;
            UINavigationController* nav = self.tab.viewControllers[3];
            GuanzhuDockerVC * vc = [[GuanzhuDockerVC alloc]init];
            [nav pushViewController:vc animated:YES];
        } break;
        case 3: { // 评论
            UINavigationController* nav = self.tab.viewControllers[0];
            _tab.selectedIndex = 0;
            HomeListDetailVc * vc = [[HomeListDetailVc alloc] init];
            vc.topicid = [NSString stringWithFormat:@"%@",dict[@"tid"]];
            vc.topictype = [NSString stringWithFormat:@"%@",dict[@"type"]];
            [nav pushViewController:vc animated:YES];
        } break;
        case 4: {// 喜欢
            UINavigationController* nav = self.tab.viewControllers[0];
            _tab.selectedIndex = 0;
            HomeListDetailVc * vc = [[HomeListDetailVc alloc] init];
            vc.topicid = [NSString stringWithFormat:@"%@",dict[@"tid"]];
            vc.topictype = [NSString stringWithFormat:@"%@",dict[@"type"]];
            [nav pushViewController:vc animated:YES];
        } break;
        case 5: {

        } break;
        case 6: {// 新动态
            UINavigationController* nav = self.tab.viewControllers[0];
            _tab.selectedIndex = 0;
            HomeListDetailVc * vc = [[HomeListDetailVc alloc] init];
            vc.topicid = [NSString stringWithFormat:@"%@",dict[@"tid"]];
            vc.topictype = [NSString stringWithFormat:@"%@",dict[@"type"]];
            [nav pushViewController:vc animated:YES];        } break;
        case 7: {// 私信
            NSDictionary* d = @{ @"uid" : dict[@"uid"] };
            //    //2.开始请求
            HHttpRequest *request = [[HHttpRequest alloc] init];
            [request httpGetRequestWithActionName:@"userinfo" andPramater:d andDidDataErrorBlock:^(NSURLSessionTask* operation, id responseObject) {
            }
                        andDidRequestSuccessBlock:^(NSURLSessionTask* operation, id responseObject) {
                            UINavigationController* nav = _tab.viewControllers[3];
                            _tab.selectedIndex = 3;
                            SiXinVC* vc = [[SiXinVC alloc] init];
                            vc.cID = dict[@"uid"];
                            vc.navTitle = [UserInfoModel objectWithKeyValues:responseObject].nickname;
                            [nav pushViewController:vc animated:YES];
                        }
                         andDidRequestFailedBlock:^(NSURLSessionTask* operation, NSError* error) {
                             UINavigationController* nav = _tab.viewControllers[3];
                             _tab.selectedIndex = 3;
                             SiXinVC* vc = [[SiXinVC alloc] init];
                             vc.cID = dict[@"uid"];
                             vc.navTitle = @"好友";
                             [nav pushViewController:vc animated:YES];
                         }];

        } break;
        case 8: {
            UINavigationController* nav = _tab.viewControllers[4];
            _tab.selectedIndex = 4;
            KaiShiJiandingVC* vc = [[KaiShiJiandingVC alloc] init];
            [nav pushViewController:vc animated:YES];
        } break;
        case 9: {

            UINavigationController* nav = self.tab.viewControllers[0];
            _tab.selectedIndex = 0;
            HomeListDetailVc * vc = [[HomeListDetailVc alloc] init];
            vc.topicid = [NSString stringWithFormat:@"%@",dict[@"tid"]];
            vc.topictype = [NSString stringWithFormat:@"%@",dict[@"type"]];
            [nav pushViewController:vc animated:YES];
        } break;
        default:
            break;
    }
}
- (NSDictionary*)dictionaryWithJsonString:(NSString*)jsonString
{
    if (jsonString == nil) {
        return nil;
    }
    
    NSData* jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError* err;
    NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if (err) {
        NSLog(@"json解析失败：%@", err);
        return nil;
    }
    return dic;
}

/**********************支付*************************/

#pragma - mark - 支付宝回调
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

}
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return [self application:application openURL:url sourceApplication:nil annotation:@{}];
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options {
    return [self application:app openURL:url sourceApplication:[options objectForKey:UIApplicationOpenURLOptionsSourceApplicationKey] annotation:@{}];
}
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    
    if ([url.host isEqualToString:@"safepay"]) {
        // 支付跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
        }];
        
        // 授权跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processAuth_V2Result:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
            // 解析 auth code
            NSString *result = resultDic[@"result"];
            NSString *authCode = nil;
            if (result.length>0) {
                NSArray *resultArr = [result componentsSeparatedByString:@"&"];
                for (NSString *subResult in resultArr) {
                    if (subResult.length > 10 && [subResult hasPrefix:@"auth_code="]) {
                        authCode = [subResult substringFromIndex:10];
                        break;
                    }
                }
            }
            NSLog(@"授权结果 authCode = %@", authCode?:@"");
        }];
    }if ([url.host isEqualToString:@"platformapi"]){//支付宝钱包快登授权返回authCode
        
        [[AlipaySDK defaultService] processAuthResult:url standbyCallback:^(NSDictionary *resultDic) {
            //【由于在跳转支付宝客户端支付的过程中，商户app在后台很可能被系统kill了，所以pay接口的callback就会失效，请商户对standbyCallback返回的回调结果进行处理,就是在这个方法里面处理跟callback一样的逻辑】
            NSLog(@"result = %@",resultDic);
        }];
    }

    //第二步：添加回调
    if ([OpenShare handleOpenURL:url] && [url.absoluteString rangeOfString:@"wechat"].length > 0) {
        return YES;
    }
    
    //微信支付
    if ([WXApi handleOpenURL:url delegate:self] && url) {
        return YES;
    }
    return YES;
}
#pragma mark - 微信回调方法
- (void)onResp:(BaseResp*)resp
{
    NSString* strMsg = [NSString stringWithFormat:@"errcode:%d", resp.errCode];
    NSString* strTitle;
    
    if ([resp isKindOfClass:[SendMessageToWXResp class]]) {
        strTitle = [NSString stringWithFormat:@"发送媒体消息结果"];
    }
    
    //支付返回
    if ([resp isKindOfClass:[PayResp class]]) {
        //支付返回结果，实际支付结果需要去微信服务器端查询
        strTitle = [NSString stringWithFormat:@"支付结果"];
        
        switch (resp.errCode) {
            case WXSuccess: {
                strMsg = @"支付结果：成功！";
                NSLog(@"支付成功－PaySuccess，retcode = %d", resp.errCode);
                NSNotification* notification = [NSNotification notificationWithName:@"WX_PAY_NOTIFICATION" object:nil userInfo:@{ @"payResult" : @"success" }];
                [[NSNotificationCenter defaultCenter] postNotification:notification];
                break;
            }
            default: {
                strMsg = [NSString stringWithFormat:@"支付结果：失败！retcode = %d, retstr = %@", resp.errCode, resp.errStr];
                NSNotification* notification = [NSNotification notificationWithName:@"WX_PAY_NOTIFICATION" object:nil userInfo:@{ @"payResult" : @"fail" }];
                [[NSNotificationCenter defaultCenter] postNotification:notification];
                break;
            }
        }
    }
}


- (void)applicationWillResignActive:(UIApplication *)application {
    
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [application setApplicationIconBadgeNumber:0];
    return;
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
