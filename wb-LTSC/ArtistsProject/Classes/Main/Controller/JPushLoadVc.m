//
//  JPushLoadVc.m
//  manager
//
//  Created by sks on 16/7/7.
//  Copyright © 2016年 benbun. All rights reserved.
//

#import "JPushLoadVc.h"
#import <UIKit/UIKit.h>
#import "TOWebViewController.h"
#import "MSBArticleDetailController.h"

//#import "HDActiveDetailController.h"
//#import "BBBaseNavigationController.h"
//#import "BBNotiConst.h"
#pragma mark - JumpExplore 子类
// 主营
typedef enum {
    JPushLoadVcJumpSubTypeExpolre           = 1, // 直接跳转到内嵌浏览器的推送类型
    JPushLoadVcJumpSubTypeSystemNoti        = 2, // 系统纯文本通知
    JPushLoadVcJumpSubTypeArticle = 3, // 推荐文章推送
    JPushLoadVcJumpSubTypeVideo = 4 // 推荐视频推送
}JPushLoadVcJumpSubTypeOperation;

@implementation JPushLoadVc

+ (instancetype)getInstance{
    static JPushLoadVc *jpushLoadVc = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        jpushLoadVc = [[JPushLoadVc alloc] init];
    });
    return jpushLoadVc;
}


// 程序启动
- (void)loadRemoteVc:(NSDictionary *)launchOptions{
    if (launchOptions == nil)return;
    NSString *maincate = launchOptions[@"maincate"];
    NSString *subcate = launchOptions[@"subcate"];
    NSString *payload = launchOptions[@"payload"];
    NSDictionary *responseData = nil;
    if (payload.length>0) {
        NSData *jsonData = [payload dataUsingEncoding:NSUTF8StringEncoding];
        responseData = [NSJSONSerialization JSONObjectWithData:jsonData
                                                       options:NSJSONReadingMutableContainers
                                                         error:NULL];
    }
    [self loadVcMain:[maincate integerValue] subType:[subcate integerValue] response:responseData];
}

- (void)loadVcMain:(NSInteger)maincate subType:(NSInteger)subType response:(NSDictionary *)response{
    
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    
    if (maincate == JPushLoadVcMainTypeOperation) {   // 运营类
        if (subType == JPushLoadVcJumpSubTypeExpolre) { // 跳转浏览器
            NSString *url = response[@"url"];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunused-variable"
            NSString *title = response[@"title"];
#pragma clang diagnostic pop
            NSString *httpurl = [@"http://" stringByAppendingString:url];
            [self presentViewControllerWithPushInfo:httpurl andTitle:title];
            return;
        }
        
        if (subType == JPushLoadVcJumpSubTypeSystemNoti) { // 系统通知
            return;
         }
        
        if (subType == JPushLoadVcJumpSubTypeArticle) { // 文章详情
            UITabBarController *tabVC = (UITabBarController *)keyWindow.rootViewController;
            UINavigationController *sourceViewController = (UINavigationController *)tabVC.viewControllers[tabVC.selectedIndex];
            MSBArticleDetailController *articleVC = [MSBArticleDetailController new];
            articleVC.tid = response[@"post_id"];
            [sourceViewController pushViewController:articleVC animated:YES];
            return;
        }

        if (subType == JPushLoadVcJumpSubTypeVideo) { // 视频详情
            return;
        }

    }
}

#pragma mark - presentViewController
- (void)presentViewController:(UIViewController *)vc{
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:vc animated:YES completion:nil];
}

// 程序由后台进入前台
- (void)loadEnterForegroundRemoteVc:(NSDictionary *)launchOptions{
    if (launchOptions == nil)return;
    
    NSString *maincate = launchOptions[@"maincate"];
    NSString *subcate = launchOptions[@"subcate"];
    NSString *payload = launchOptions[@"payload"];
    NSDictionary *responseData = nil;
    if (payload.length>0) {
        NSData *jsonData = [payload dataUsingEncoding:NSUTF8StringEncoding];
        responseData = [NSJSONSerialization JSONObjectWithData:jsonData
                                                       options:NSJSONReadingMutableContainers
                                                         error:NULL];
    }
    
    
    
    [self loadVcMain:[maincate integerValue] subType:[subcate integerValue] response:responseData];
    
}


#pragma mark - presentViewControllerWithPushInfo
- (void)presentViewControllerWithPushInfo:(NSString *)url andTitle:(NSString *)title {
    TOWebViewController *webVc = [[TOWebViewController alloc ]initWithURL:[NSURL URLWithString:url]];
    webVc.title = title;
    webVc.showPageTitles = NO;
    UINavigationController *pushVc = [[UINavigationController alloc] initWithRootViewController:webVc];
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:pushVc animated:YES completion:nil];
}

@end
