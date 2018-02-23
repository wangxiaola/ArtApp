//
//  BBNetworkTool.m
//  EventMaster
//
//  Created by sks on 16/5/5.
//  Copyright © 2016年 benbun. All rights reserved.
//

#import "BBNetworkTool.h"
#import "AFNetworking.h"
#import "GeneralConfigure.h"
#import "UIView+MBProgressHUD.h"

#define errorUser_notExist     10102
#define errorCodeToken_expired 10111 // token 过期
#define codeToken_error        10110 // token 错误
#define errorCodeToken_invalid 10109 // token 无效
#define codeToken_notPara      10112 // 缺少token参数

@implementation BBNetworkTool


+ (void)get:(NSString *)UrlStr parameters:(id)parameters success:(successBlock)success failure:(errorBlock)failure{
        AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
        mgr.requestSerializer = [AFJSONRequestSerializer serializer];
        mgr.requestSerializer.timeoutInterval = 30;
        mgr.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    
        __weak __block typeof(self) weakSelf = self;
    
        [mgr GET:UrlStr parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
    
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if (success) {
                
                if ([responseObject[@"code"] isEqual:@(errorCodeToken_expired)] || [responseObject[@"code"] isEqual:@(codeToken_error)] || [responseObject[@"code"] isEqual:@(errorCodeToken_invalid)]  || [responseObject[@"code"] isEqual:@(codeToken_notPara)]) {
                    
                    [weakSelf tokenErrorToLogin:responseObject[@"msg"]];
                    
                }else{
                    
                    success(responseObject);
                }
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if (failure) {
                
                failure(error);
            }
        }];

}
+ (void)post:(NSString *)UrlStr parameters:(id)parameters success:(successBlock)success failure:(errorBlock)failure{
        // 1. 创建请求操作管理者对象
        AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
        mgr.requestSerializer.timeoutInterval = 30;
        //mgr.requestSerializer = [AFJSONRequestSerializer serializer];
        // 2. 设置接收的类型
        mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    
        __weak __block typeof(self) weakSelf = self;
    
        // 开始请求数据并解析
        [mgr POST:UrlStr parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
    
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if (success) {
                
                if ([responseObject[@"code"] isEqual:@(errorUser_notExist)] || [responseObject[@"code"] isEqual:@(errorCodeToken_expired)] || [responseObject[@"code"] isEqual:@(codeToken_error)] || [responseObject[@"code"] isEqual:@(errorCodeToken_invalid)]  || [responseObject[@"code"] isEqual:@(codeToken_notPara)]) {
                    
                    [weakSelf tokenErrorToLogin:responseObject[@"msg"]];
                    [MSBAccount loginOut];
                    
                }else{
                    success(responseObject);
                }
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if (failure) {
                failure(error);
            }
        }];
}

+ (void)tokenErrorToLogin:(NSString *)msg {

    BaseViewController *presentedVC = (BaseViewController *)[self getCurrentVC];
    
    if ([presentedVC isKindOfClass:[HomeViewController class]]) {
        
        HomeViewController *vc = (HomeViewController *)presentedVC;
        [vc tokenErrorGetDataFromLocal];
        return;
    }
    
    if ([presentedVC isKindOfClass:[LoginViewController class]]) {
        
        return;
    }

    [presentedVC hudTip:msg];

    LoginViewController *loginVC   = [[LoginViewController alloc] init];
    [presentedVC.navigationController pushViewController:loginVC animated:YES];
}

//获取当前屏幕显示的viewcontroller
+ (UIViewController *)getCurrentVC
{
    UIViewController *result = nil;
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    //app默认windowLevel是UIWindowLevelNormal，如果不是，找到UIWindowLevelNormal的
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    id  nextResponder = nil;
    UIViewController *appRootVC=window.rootViewController;
    //    如果是present上来的appRootVC.presentedViewController 不为nil
    if (appRootVC.presentedViewController) {
        nextResponder = appRootVC.presentedViewController;
    }else{
        UIView *frontView = [[window subviews] objectAtIndex:0];
        nextResponder = [frontView nextResponder];  //  这方法下面有详解    </span>
    }
    
    if ([nextResponder isKindOfClass:[UITabBarController class]]){
        UITabBarController * tabbar = (UITabBarController *)nextResponder;
        UINavigationController * nav = (UINavigationController *)tabbar.viewControllers[tabbar.selectedIndex];
        //        UINavigationController * nav = tabbar.selectedViewController ; 上下两种写法都行
        result = nav.childViewControllers.lastObject;
        
    }else if ([nextResponder isKindOfClass:[UINavigationController class]]){
        UIViewController * nav = (UIViewController *)nextResponder;
        result = nav.childViewControllers.lastObject;
    }else{
        result = nextResponder;
    }
    
    return result;
}

//+ (void)get:(NSString *)UrlStr parameters:(id)parameters success:(void(^)(id response))success failure:(void(^)(NSError *error))failure{
//    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
//    mgr.requestSerializer = [AFJSONRequestSerializer serializer];
//    mgr.requestSerializer.timeoutInterval = 30;
//    mgr.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
//    [mgr GET:UrlStr parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
//        
//    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        if (responseObject) {
//            success(responseObject);
//        }
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        if (failure) {
//            failure(error);
//        }
//    }];
//}
//
//+ (void)post:(NSString *)UrlStr parameters:(id)parameters success:(void(^)(id response))success failure:(void(^)(NSError *error))failure{
//    // 1. 创建请求操作管理者对象
//    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
//    mgr.requestSerializer.timeoutInterval = 30;
//    // 2. 设置接收的类型
//    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
//    
//    // 开始请求数据并解析
//    [mgr POST:UrlStr parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
//        
//    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        if (responseObject) {
//            success(responseObject);
//        }
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        if (failure) {
//            failure(error);
//        }
//    }];
//}

@end
