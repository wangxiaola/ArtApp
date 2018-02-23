//
//  LLRequestBaseServer.m
//  evtmaster
//
//  Created by T on 16/6/15.
//  Copyright © 2016年 benbun. All rights reserved.
//

#import "LLRequestBaseServer.h"
#import "BBNetworkTool.h"
#import "NSString+ToString.h"
#import "MJExtension.h"
#import "GeneralConfigure.h"

typedef NS_ENUM(NSInteger, RequestType) {
    
    RequestTypePost,
    RequestTypeGet,
};
#pragma mark - LLRequestUpload
@implementation LLRequestUpload

- (instancetype)initWithName:(NSString *)name image:(UIImage *)image{
    if (self = [super init]) {
        self.name = name;
        self.image = image;
    }
    return self;
}

+ (instancetype)initWithName:(NSString *)name image:(UIImage *)image  {
    return [[LLRequestUpload alloc] initWithName:name image:image];
}
@end

#pragma mark - LLResponse
@implementation LLResponse

@end

@implementation LLRequestBaseServer
static LLRequestBaseServer *_sharedInstance = nil;
- (void)dealloc {
    _sharedInstance = nil;
}

- (void)requestWithMethods:(RequestType)methods url:(NSString *)url parameters:(NSDictionary *)parameters success:(LLRequestSuccessBlock)success failure:(LLRequestFailedBlock)failure error:(LLRequestErrorBlock)error {
    
    NDLog(@"\n接口请求地址:%@\n请求参数:%@", url, parameters);
    
    void(^successResponse)(id response) = ^(id response){
        
        NDLog(@"\n接口请求地址:%@\n请求结果:%@", url, response);
        
        __block LLResponse *responseObj = [LLResponse mj_objectWithKeyValues:response];
        
        if (responseObj) {
            responseObj.response = response;
            if (success && responseObj.code == 0) {
                // 状态码=0
                success(responseObj, responseObj ? responseObj.data : nil);
            } else if (failure && responseObj.code != 0) {
                // 状态码!=0
                failure(responseObj);
            }
        } else {
            
            if (error) {
                
                error(nil);
            }
        }
    };
    
    void(^failureResponse)(NSError *errorDetail) = ^(NSError *errorDetail) {
        
        if (error) {
            
            error(errorDetail);
        }
    };
    
    switch (methods) {
            
        case RequestTypeGet:
            if (![parameters isKindOfClass:[NSMutableDictionary class]]) {
                
                parameters = [NSMutableDictionary dictionaryWithDictionary:parameters];
            }
            [BBNetworkTool get:[NSString notNilString:url] parameters:parameters success:successResponse failure:failureResponse];
            break;
        default:
            [BBNetworkTool post:[NSString notNilString:url] parameters:parameters success:successResponse failure:failureResponse];
            break;
    }
}

- (void)getWithUrl:(NSString *)url parameters:(NSDictionary *)parameters success:(LLRequestSuccessBlock)success failure:(LLRequestFailedBlock)failure error:(LLRequestErrorBlock)error {
    
    [self requestWithMethods:RequestTypeGet url:url parameters:parameters success:success failure:failure error:error];
}

- (void)postWithUrl:(NSString *)url parameters:(NSDictionary *)parameters success:(LLRequestSuccessBlock)success failure:(LLRequestFailedBlock)failure error:(LLRequestErrorBlock)error {
    
    [self requestWithMethods:RequestTypePost url:url parameters:parameters success:success failure:failure error:error];
}


+ (instancetype)shareInstance {
    
    if (_sharedInstance == nil) {
        
        _sharedInstance = [[self alloc] init];
    }
    
    return _sharedInstance;
}

- (NSString *)getToken {
    return [NSString notNilString:[MSBAccount getToken]];
}
@end
