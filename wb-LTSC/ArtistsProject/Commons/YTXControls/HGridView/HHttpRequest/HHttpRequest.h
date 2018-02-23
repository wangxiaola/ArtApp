//
//  HHttpRequest.h
//  Car
//
//  Created by HeLiulin on 15/9/12.
//  Copyright (c) 2015年 上海翔汇网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "AFNetworking.h"
#import <AFNetworking/AFNetworking.h>


typedef void(^didDataErrorBlock) (NSURLSessionTask *operation, id responseObject);
typedef void(^didRequestSuccessBlock) (NSURLSessionTask *operation, id responseObject);
typedef void(^didRequestFailedBlock) (NSURLSessionTask *operation, NSError *error);


@interface HHttpRequest : NSObject
///请求超时时间
@property(nonatomic,readwrite) CGFloat timeoutInterval;
@property(nonatomic,readwrite) BOOL acTop;

- (void) httpGetRequestWithActionName:(NSString*)actionName
                     andPramater:(NSDictionary*)pramaters
            andDidDataErrorBlock:(didDataErrorBlock)dataErrorBlock
       andDidRequestSuccessBlock:(didRequestSuccessBlock)successBlock
        andDidRequestFailedBlock:(didRequestFailedBlock)failedBlock;

- (void) httpPostRequestWithActionName:(NSString*)actionName
                          andPramater:(NSDictionary*)pramaters
                 andDidDataErrorBlock:(didDataErrorBlock)dataErrorBlock
            andDidRequestSuccessBlock:(didRequestSuccessBlock)successBlock
             andDidRequestFailedBlock:(didRequestFailedBlock)failedBlock;
@end
