//
//  LLRequestServer.h
//  evtmaster
//
//  Created by T on 16/7/22.
//  Copyright © 2016年 benbun. All rights reserved.
//

#import "LLRequestBaseServer.h"
#import "LLRequestBaseServer+Home.h"
#import "LLRequestBaseServer+User.h"
#import "LLRequestBaseServer+People.h"
#import "LLRequestBaseServer+Agency.h"

@interface LLRequestServer : LLRequestBaseServer
- (void)requestAdSuccess:(LLRequestSuccessBlock)success failure:(LLRequestFailedBlock)failure error:(LLRequestErrorBlock)error;
@end
