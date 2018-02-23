//
//  MSBJumpLoginVC.m
//  meishubao
//
//  Created by T on 16/12/20.
//  Copyright © 2016年 benbun. All rights reserved.
//

#import "MSBJumpLoginVC.h"
#import "GeneralConfigure.h"
#import "UIView+MBProgressHUD.h"
@implementation MSBJumpLoginVC

+ (BOOL)showLoginAlert:(UIViewController *)vc {
    if (![MSBAccount userLogin] && ![MSBAccount isTourists]) {
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:nil message:@"登录选择" preferredStyle:UIAlertControllerStyleActionSheet];
        alert.view.tintColor = RGBCOLOR(181, 27, 32);
        UIAlertAction * cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction * loginAction = [UIAlertAction actionWithTitle:@"去登录" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            LoginViewController *loginVC = [LoginViewController new];
            [vc.navigationController pushViewController:loginVC animated:YES];
        }];
        UIAlertAction * touristsAction = [UIAlertAction actionWithTitle:@"游客访问" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //以设备唯一标识为uid生成一个用户作为游客
            [MSBJumpLoginVC touristsLogin:vc];
        }];
        [alert addAction:cancleAction];
        [alert addAction:loginAction];
        [alert addAction:touristsAction];
        [vc presentViewController:alert animated:YES completion:nil];

        return YES;
    }
    return NO;
}

+ (BOOL)jumpLoginVC:(UIViewController *)vc{
    if (![MSBAccount userLogin]) {
        LoginViewController *loginVC = [LoginViewController new];
        [vc.navigationController pushViewController:loginVC animated:YES];
        return YES;
    }
    return NO;
}

+ (void)touristsLogin:(UIViewController *)vc {
    NSString * uuid = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
//    int a = arc4random() % 100000;//生成六位随机数
//    NSString *str = [NSString stringWithFormat:@"%06d", a];
    [vc.view showLoadMessageAtCenter:nil];
    [[LLRequestBaseServer shareInstance] requestThirdOauthLoginWithtUid:uuid type:5 avatar:nil nickname:@"游客" success:^(LLResponse *response, id data) {
        if (data && [data isKindOfClass:[NSDictionary class]]) {
            NSString * token = data[@"token"];
            MSBUser * user = [MSBUser mj_objectWithKeyValues:data[@"user"]];
            user.isTourists = YES;
            [MSBAccount saveToken:token];
            [MSBAccount saveAccount:user];
            [vc.view showSuccess:@"游客登录成功"];
        }
    } failure:^(LLResponse *response) {
        [vc.view showError:@"登录失败"];
    } error:^(NSError *error) {
        [vc.view showError:@"登录失败"];
    }];
}

@end
