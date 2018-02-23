//
//  MSBAccount.m
//  meishubao
//
//  Created by T on 16/11/29.
//  Copyright © 2016年 benbun. All rights reserved.
//

#import "MSBAccount.h"
#import "GeneralConfigure.h"

@implementation MSBAccount
/** 保存token */
+ (void)saveToken:(NSString *)token{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:token forKey:APP_ACCESS_TOKEN];
    [userDefaults synchronize];
}
/** 获取token */
+ (NSString *)getToken{
    return [NSString notNilString:[[NSUserDefaults standardUserDefaults] objectForKey:APP_ACCESS_TOKEN]];
}
/** 保存用户信息 */
+ (void)saveAccount:(MSBUser *)user{
    [NSKeyedArchiver archiveRootObject:user toFile:APP_USER_PATH];
}
/** 获取用户信息 */
+ (MSBUser *)getUser{
    return [NSKeyedUnarchiver unarchiveObjectWithFile:APP_USER_PATH];
}
/** 用户登录 */
+ (BOOL)userLogin{
    MSBUser *user = [NSKeyedUnarchiver unarchiveObjectWithFile:APP_USER_PATH];
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:APP_ACCESS_TOKEN];
    if ((user && !user.isTourists)&&token) {
        return YES;
    }else{
        return NO;
    }

}

+ (BOOL)isTourists {
    MSBUser *user = [NSKeyedUnarchiver unarchiveObjectWithFile:APP_USER_PATH];
    if (user && user.isTourists) {
        return YES;
    }else {
        return NO;
    }
}

/** 用户退出 */
+ (void)loginOut{
    NSFileManager* fileManager=[NSFileManager defaultManager];
    [fileManager removeItemAtPath:APP_USER_PATH error:nil];
     [[NSUserDefaults standardUserDefaults] removeObjectForKey:APP_ACCESS_TOKEN];
     [[NSUserDefaults standardUserDefaults] removeObjectForKey:JPUSH_REGISTRATIONID];
}
@end
