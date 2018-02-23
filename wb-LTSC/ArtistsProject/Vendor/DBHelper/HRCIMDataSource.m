//
//  HRCIMDataSource.m
//  Car
//
//  Created by HeLiulin on 15/10/7.
//  Copyright © 2015年 上海翔汇网络科技有限公司. All rights reserved.
//

#import "HRCIMDataSource.h"
//#import "FriendInfoModel.h"
#import "tb_FriendsDAL.h"
#import "tb_GroupsDAL.h"

@implementation HRCIMDataSource
+ (HRCIMDataSource*)shareInstance
{
    static HRCIMDataSource* instance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        instance = [[[self class] alloc] init];
        
    });
    return instance;
}

@end
