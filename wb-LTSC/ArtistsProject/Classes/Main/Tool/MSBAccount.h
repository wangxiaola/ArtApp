//
//  MSBAccount.h
//  meishubao
//
//  Created by T on 16/11/29.
//  Copyright © 2016年 benbun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MSBUser.h"

@interface MSBAccount : NSObject
/** 保存token */
+ (void)saveToken:(NSString *)token;
/** 获取token */
+ (NSString *)getToken;
/** 保存用户信息 */
+ (void)saveAccount:(MSBUser *)user;
/** 获取用户信息 */
+ (MSBUser *)getUser;
/** 用户登录 */
+ (BOOL)userLogin;
/** 用户退出 */
+ (void)loginOut;
/** 是否游客登录 */
+ (BOOL)isTourists;
@end
