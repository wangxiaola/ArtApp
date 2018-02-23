//
//  AppDelegate+ShareSDK.m
//  ShesheDa
//
//  Created by gengyuanyuan on 2017/1/18.
//  Copyright © 2017年 北京艺天下文化科技有限公司. All rights reserved.
//
#import "AppDelegate+ShareSDK.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>
//微信SDK头文件
#import "WXApi.h"
//新浪微博SDK头文件
#import "WeiboSDK.h"
//wb568898243
@implementation AppDelegate (ShareSDK)

- (void)registerShareSdk
{
    //耿园园d_3b8c4a20c668
    [ShareSDK registerActivePlatforms:@[
                            @(SSDKPlatformTypeSinaWeibo),
                            @(SSDKPlatformTypeMail),
                            @(SSDKPlatformSubTypeWechatSession),
                            @(SSDKPlatformSubTypeWechatTimeline),
                            @(SSDKPlatformTypeCopy),
                            @( SSDKPlatformTypeSMS)]
                 onImport:^(SSDKPlatformType platformType)
     {
         switch (platformType)
         {
             case SSDKPlatformTypeWechat:
                 [ShareSDKConnector connectWeChat:[WXApi class]];
                 break;
             case SSDKPlatformTypeSinaWeibo:
                 [ShareSDKConnector connectWeibo:[WeiboSDK class]];
                 break;
             default:
                 break;
         }
     }
          onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo)
     {
         
         switch (platformType)
         {
             case SSDKPlatformTypeSinaWeibo:
                 //设置新浪微博应用信息,其中authType设置为使用SSO＋Web形式授权
//                 @"3558267497"  @"947297cd98bd04c28ce740ba665dba0f"
//                 @"http://www.sharesdk.cn"
                 [appInfo SSDKSetupSinaWeiboByAppKey:weiboAppID
                                           appSecret:weiboAppSecret
                                         redirectUri:@"http://www.lotuschen.com"
                                            authType:SSDKAuthTypeSSO];
                 break;
             case SSDKPlatformTypeWechat:
//                 @"wxbbd5c62da1ae8466" @"3ca02b8f99da67e216022356f6df9700"
                 [appInfo SSDKSetupWeChatByAppId:wechatAppID
                                       appSecret:wechatAppSecret];//
                 break;
                 
             default:
                 break;
         }
     }];
    
}

@end
