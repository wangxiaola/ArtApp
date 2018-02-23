//
//  HRCIMDataSource.h
//  Car
//
//  Created by HeLiulin on 15/10/7.
//  Copyright © 2015年 上海翔汇⺴络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "tb_FriendsDAL.h"

@interface HRCIMDataSource : NSObject
//<RCIMUserInfoDataSource,RCIMGroupInfoDataSource>
+(HRCIMDataSource *)shareInstance;
//- (void) syncFriendListDataAfterCompletion:(void (^)())completion;
@end
