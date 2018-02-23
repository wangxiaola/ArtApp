//
//  ArtRequest.m
//  ArtistProject
//
//  Created by HELLO WORLD on 2017/3/27.
//  Copyright © 2017年 HELLO WORLD. All rights reserved.
//

#import "ArtRequest.h"


@implementation ArtRequest

+(void)GetRequestWithActionName:(NSString*)actionName
                     andPramater:(NSDictionary*)pramaters
                       succeeded:(void (^)(id responseObject))successBlock
                          failed:(void (^)(id responseObject))failedBlock{
    //1.管理器
    AFHTTPSessionManager* manager = [AFHTTPSessionManager manager];
    //2 设定类型
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", nil];
    manager.requestSerializer.timeoutInterval = 20.0f; //超时时间

    //特殊参数
    NSMutableDictionary* dicPramaters = [[NSMutableDictionary alloc] initWithDictionary:pramaters];
    [dicPramaters setObject:actionName forKey:@"ac"];
    [dicPramaters setObject:kPublicKey forKey:@"publickey"];
    [dicPramaters setObject:@"12215" forKey:@"binduid"];// 添加的绑定id

    
    [manager GET:AppUrlRoot parameters:dicPramaters progress:^(NSProgress * _Nonnull downloadProgress) {
        
        }success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

             if (successBlock) {
                 successBlock(responseObject);
             }
         }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull   error) {
             if (failedBlock) {
                 failedBlock(error);
             }
         }];
}

+(void)PostRequestWithActionName:(NSString*)actionName
                    andPramater:(NSDictionary*)pramaters
                    succeeded:(void (^)(id responseObject))successBlock
                    failed:(void (^)(id responseObject))failedBlock{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //2 设定类型
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
//    manager.responseSerializer = [AFHTTPResponseSerializer serializer]; //很重要，去掉就容易遇到错误，暂时还未了解更加详细的原因
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", nil];
    manager.requestSerializer.timeoutInterval = 20.0f; //超时时间

    //特殊参数
    NSMutableDictionary* dicPramaters = [[NSMutableDictionary alloc] initWithDictionary:pramaters];
    [dicPramaters setObject:actionName forKey:@"ac"];
    [dicPramaters setObject:[Global sharedInstance].userID?[Global sharedInstance].userID:@"0" forKey:@"uid"];
    [dicPramaters setObject:@"12215" forKey:@"binduid"];// 添加的绑定id
    [dicPramaters setObject:kPublicKey forKey:@"publickey"];
    [dicPramaters setObject:[ArtRequest signatureWithModule:actionName] forKey:@"privatekey"];
    kPrintLog(dicPramaters);
    [manager POST:AppUrlRoot parameters:dicPramaters progress:^(NSProgress * _Nonnull uploadProgress) {
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (successBlock) {
            successBlock(responseObject);
        }
        
    }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failedBlock) {
            failedBlock(error);
        }
    }];
}
//网络监听
+(void)AFNetworkStatus{
    
    //1.创建网络监测者
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    
    /*枚举里面四个状态  分别对应 未知 无网络 数据 WiFi
     typedef NS_ENUM(NSInteger, AFNetworkReachabilityStatus) {
     AFNetworkReachabilityStatusUnknown          = -1,      未知
     AFNetworkReachabilityStatusNotReachable     = 0,       无网络
     AFNetworkReachabilityStatusReachableViaWWAN = 1,       蜂窝数据网络
     AFNetworkReachabilityStatusReachableViaWiFi = 2,       WiFi
     };
     */
    
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        //这里是监测到网络改变的block  可以写成switch方便
        //在里面可以随便写事件
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
                ARTLog(@"未知网络状态");
                break;
            case AFNetworkReachabilityStatusNotReachable:
                ARTLog(@"无网络");
                break;
                
            case AFNetworkReachabilityStatusReachableViaWWAN:
                ARTLog(@"蜂窝数据网");
                break;
                
            case AFNetworkReachabilityStatusReachableViaWiFi:
                ARTLog(@"WiFi网络");
                
                break;
                
            default:
                break;
        }
        
    }] ;
}
//+(BOOL)isSafeRequestWithModult:(NSString*)strModule Action:(NSString*)strAction Signature:(NSString*)strSignature
//{
//    NSString* signature = [NSString stringWithFormat:@"module=%@&action=%@&token=%@", strModule, strAction, kAccessToken];
//    return [strSignature isEqualToString:signature.md5];
//}
//
//+(NSString*)signatureWithModule:(NSString*)strModule Action:(NSString*)strAction
//{
//    return [NSString stringWithFormat:@"module=%@&action=%@&token=%@", strModule, strAction, kAccessToken].md5;
//}

+(NSString*)signatureWithModule:(NSString*)strModule
{
    //NSLog(@"%@",[Global sharedInstance].token);
    return [NSString stringWithFormat:@"%@%@%@", [Global sharedInstance].userID, strModule, [Global sharedInstance].token].md5;
}

@end
