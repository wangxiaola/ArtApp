//
//  LLRequestServer.m
//  evtmaster
//
//  Created by T on 16/7/22.
//  Copyright © 2016年 benbun. All rights reserved.
//

#import "LLRequestServer.h"

@implementation LLRequestServer
- (void)requestAdSuccess:(LLRequestSuccessBlock)success failure:(LLRequestFailedBlock)failure error:(LLRequestErrorBlock)error {
    NSDictionary *parameters = @{@"lat":@(0),
                                 @"lng":@(0)};
    [self postWithUrl:@"http://app-api.niu.com/advertisement/getadvertisement" parameters:parameters success:success failure:failure error:error];
}

@end
