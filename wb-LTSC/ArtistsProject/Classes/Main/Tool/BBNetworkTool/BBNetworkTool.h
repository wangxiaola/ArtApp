//
//  BBNetworkTool.h
//  EventMaster
//
//  Created by sks on 16/5/5.
//  Copyright © 2016年 benbun. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^successBlock)(id response);
typedef void(^errorBlock)(NSError *error);

@interface BBNetworkTool : NSObject

+ (void)get:(NSString *)UrlStr parameters:(id)parameters success:(successBlock)success failure:(errorBlock)failure;
+ (void)post:(NSString *)UrlStr parameters:(id)parameters success:(successBlock)success failure:(errorBlock)failure;

//+ (void)get:(NSString *)UrlStr parameters:(id)parameters success:(void(^)(id response))success failure:(void(^)(NSError *error))failure;
//+ (void)post:(NSString *)UrlStr parameters:(id)parameters success:(void(^)(id response))success failure:(void(^)(NSError *error))failure;

@end
