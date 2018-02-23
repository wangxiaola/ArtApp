//
//  HRequest.m
//  Car
//
//  Created by HeLiulin on 15/9/12.
//  Copyright (c) 2015年 上海翔汇网络科技有限公司. All rights reserved.
//

#import "HHttpRequest.h"
#import "NSString+Extension.h"
#import "ConstantFile.h"
#define kAccessToken @"CYE334F697B64817B9352BA669B3E2110A1D790DE6G2888E82E2C542317129B2C4123C5941A2461289769AA95B7D7ZZZ"
#import "ResultModel.h"

@interface HHttpRequest ()
@property (nonatomic, copy) didDataErrorBlock dataErrorBlock;
@property (nonatomic, copy) didRequestSuccessBlock successBlock;
@property (nonatomic, copy) didRequestFailedBlock failedBlock;
@end

@implementation HHttpRequest

- (instancetype)init {
    if (self = [super init]) {
    }
    return self;
}

- (void)httpGetRequestWithActionName:(NSString*)actionName
                         andPramater:(NSDictionary*)pramaters
                andDidDataErrorBlock:(didDataErrorBlock)dataErrorBlock
           andDidRequestSuccessBlock:(didRequestSuccessBlock)successBlock
            andDidRequestFailedBlock:(didRequestFailedBlock)failedBlock
{

    //1.管理器
    AFHTTPSessionManager* manager = [AFHTTPSessionManager manager];
    //2 设定类型
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", nil];
    manager.requestSerializer.timeoutInterval = self.timeoutInterval > 0.0f ? self.timeoutInterval : 20.0f; //超时时间

    //特殊参数
    NSMutableDictionary* dicPramaters = [[NSMutableDictionary alloc] initWithDictionary:pramaters];
    [dicPramaters setObject:actionName forKey:@"ac"];
    [dicPramaters setObject:@"12215" forKey:@"binduid"];// 添加的绑定id
    [dicPramaters setObject:kPublicKey forKey:@"publickey"];
    //4 请求
    [manager GET:AppUrlRoot parameters:dicPramaters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //              ResultModel *result=[ResultModel objectWithKeyValues:responseObject];
        
        //              //验证签名是否合法
        //              if ([self isSafeRequestWithModult:moduleName Action:actionName Signature:result.signature]==NO)
        //              {
        //                  NSLog(@"请求签名错误,Module:%@--Action:%@",moduleName,actionName);
        //                  return;
        //              }
        //数据是否获取成功
        //              if ([result.result isEqualToString:@"0"]==YES)
        //              {
        //                  if (dataErrorBlock){
        //                      dataErrorBlock(operation,responseObject);
        //                  }
        //                  return;
        //              }
        if (successBlock) {
            successBlock(task, responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failedBlock) {
            failedBlock(task, error);
        }
    }];
    
}

- (void)httpPostRequestWithActionName:(NSString*)actionName
                          andPramater:(NSDictionary*)pramaters
                 andDidDataErrorBlock:(didDataErrorBlock)dataErrorBlock
            andDidRequestSuccessBlock:(didRequestSuccessBlock)successBlock
             andDidRequestFailedBlock:(didRequestFailedBlock)failedBlock
{
    //1.管理器
    AFHTTPSessionManager* manager = [AFHTTPSessionManager manager];
    //2 设定类型
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", nil];
    manager.requestSerializer.timeoutInterval = self.timeoutInterval > 0.0f ? self.timeoutInterval : 20.0f; //超时时间
    //特殊参数
    NSMutableDictionary* dicPramaters = [[NSMutableDictionary alloc] initWithDictionary:pramaters];
    [dicPramaters setObject:actionName forKey:@"ac"];
    [dicPramaters setObject:[Global sharedInstance].userID?[Global sharedInstance].userID:@"0" forKey:@"uid"];
    [dicPramaters setObject:@"12215" forKey:@"binduid"];// 添加的绑定id
    [dicPramaters setObject:kPublicKey forKey:@"publickey"];

    [dicPramaters setObject:[self signatureWithModule:actionName] forKey:@"privatekey"];
    kPrintLog(dicPramaters)
    //4 请求
    [manager POST:AppUrlRoot parameters:dicPramaters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //              //验证签名是否合法
        //              if ([self isSafeRequestWithModult:moduleName Action:actionName Signature:result.signature]==NO)
        //              {
        //                  NSLog(@"请求签名错误,Module:%@--Action:%@",moduleName,actionName);
        //                  return;
        //              }
        //数据是否获取成功
        ResultModel* result = [ResultModel mj_objectWithKeyValues:responseObject];

        if ([result.result isEqualToString:@"0"] == YES) {
            if (dataErrorBlock) {
                dataErrorBlock(task, responseObject);
            }
            return;
        }
        if (successBlock) {
            successBlock(task, responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failedBlock) {
            failedBlock(task, error);
        }
    }];
    
}

- (BOOL)isSafeRequestWithModult:(NSString*)strModule Action:(NSString*)strAction Signature:(NSString*)strSignature
{
    NSString* signature = [NSString stringWithFormat:@"module=%@&action=%@&token=%@", strModule, strAction, kAccessToken];
    return [strSignature isEqualToString:signature.md5];
}

- (NSString*)signatureWithModule:(NSString*)strModule Action:(NSString*)strAction
{
    return [NSString stringWithFormat:@"module=%@&action=%@&token=%@", strModule, strAction, kAccessToken].md5;
}

- (NSString*)signatureWithModule:(NSString*)strModule
{
    NSLog(@"%@",[Global sharedInstance].token);
    return [NSString stringWithFormat:@"%@%@%@", [Global sharedInstance].userID, strModule, [Global sharedInstance].token].md5;
}

@end
