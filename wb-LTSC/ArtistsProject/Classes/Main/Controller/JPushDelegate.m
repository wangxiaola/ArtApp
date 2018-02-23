//
//  JPushDelegate.m
//  evtmaster
//
//  Created by sks on 16/7/7.
//  Copyright © 2016年 benbun. All rights reserved.
//

#import "JPushDelegate.h"
#import "JPUSHService.h"
#import "GeneralConfigure.h"
#import "JPushLoadVc.h"
@implementation JPushDelegate

static NSString *const APPKEY = @"7c44929a3fbd424bba00b947";
static NSString *const CHANNEL = @"Publish cahnnel";

+ (instancetype)getInstance {
    static JPushDelegate *jpushDelegate = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        jpushDelegate = [[JPushDelegate alloc] init];
    });
    return jpushDelegate;
}

- (void)setupJpush:(NSDictionary *)launchOptions {
    [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                      UIUserNotificationTypeSound |
                                                      UIUserNotificationTypeAlert)
                                                      categories:nil];
    
    [JPUSHService setupWithOption:launchOptions
                           appKey:APPKEY
                          channel:CHANNEL
                 apsForProduction:YES];
    
    // 当应用注册成功之后，获取registration id
    [[NSNotificationCenter defaultCenter] addObserver:self
                      selector:@selector(networkDidLogin:)
                          name:kJPFNetworkDidLoginNotification
                        object:nil];
}

// JPUSH 登录成功的回调，将registrationID发送到服务器
- (void)networkDidLogin:(NSNotification *)notification {
    NSString *registrationID = [JPUSHService registrationID];
    if (registrationID.length == 0)return;
    if([NSString isNull:[MSBAccount getToken]])return;
    
    [[LLRequestServer shareInstance] requestJPUSHIDWithRegId:registrationID success:^(LLResponse *response, id data) {
        [[NSUserDefaults standardUserDefaults] setObject:registrationID forKey:JPUSH_REGISTRATIONID];
        [[NSUserDefaults standardUserDefaults] synchronize];
    } failure:nil error:nil];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    [JPUSHService registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    // 取得 APNs 标准信息内容
    [JPUSHService handleRemoteNotification:userInfo];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void(^)(UIBackgroundFetchResult))completionHandler {
    NDLog(@"******************************推送信息%@******************************", userInfo);
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
     [[JPushLoadVc getInstance] loadEnterForegroundRemoteVc:userInfo];
    UIApplicationState appState = [[UIApplication sharedApplication] applicationState];
    if (appState == UIApplicationStateActive) {
    } else if (appState == UIApplicationStateBackground) {
    } else if (appState == UIApplicationStateInactive) {
        [[JPushLoadVc getInstance] loadEnterForegroundRemoteVc:userInfo];
    }
}

@end
