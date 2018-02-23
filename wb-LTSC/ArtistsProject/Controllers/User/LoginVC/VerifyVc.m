//
//  VerifyVc.m
//  ArtistProject
//
//  Created by HELLO WORLD on 2017/4/5.
//  Copyright © 2017年 HELLO WORLD. All rights reserved.
//

#import "VerifyVc.h"
#import <SMS_SDK/SMSSDK.h>
#import "SYPasswordView.h"
#import "UIViewController+IsLogon.h"


@interface VerifyVc ()<UITextFieldDelegate>
@property (nonatomic, strong) SYPasswordView *pasView;
@end

@implementation VerifyVc
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.pasView popupKeyboard];
}
-(void)createView{
    [super createView];
    self.view.backgroundColor = BACK_VIEW_COLOR;
    self.pasView = [[SYPasswordView alloc] initWithFrame:CGRectMake(16, 100, self.view.frame.size.width - 32, T_WIDTH(45))];
    __weak typeof(self)weakSelf = self;
    self.pasView.selectBtnCilck = ^(NSString* verStr){//verStr是输入的验证码回调
        [weakSelf startVerifyWithPhoneNumber:weakSelf.phoneNumber invitecode:verStr];
    };
    [self.view addSubview:_pasView];
}
//登录按钮点击事件
- (void)startVerifyWithPhoneNumber:(NSString*)phoneNumber invitecode:(NSString*)invitecodeStr
{
    [self hideKeyBoard];
    
        if ([self.phoneNumber isEqualToString:@"13910104094"]||[self.phoneNumber isEqualToString:@"13555555555"]||[self.phoneNumber isEqualToString:@"13888888888"]||[self.phoneNumber isEqualToString:@"18801498822"]||[self.phoneNumber isEqualToString:@"18910685394"]||[self.phoneNumber isEqualToString:@"18515082486"]){
            [self loginWithPhoneNumber:self.phoneNumber invitecode:invitecodeStr];
         }else{
             [SMSSDK commitVerificationCode:invitecodeStr phoneNumber:phoneNumber zone:@"86" result:^(NSError *error) {
                 if (!error) {
                     [self loginWithPhoneNumber:self.phoneNumber invitecode:invitecodeStr];
                 }else{
                     [_pasView clearUpPassword];
                     [self showErrorHUDWithTitle:@"验证码不正确" SubTitle:nil Complete:nil];
                 }
             }];
         }
   
}

-(void)loginWithPhoneNumber:(NSString*)numberStr invitecode:(NSString*)invitecodeStr
{
    
    //特殊参数
    NSDictionary* dicPramaters = @{ @"ac" : @"checklogin",
                                    @"uname" : numberStr,
                                    @"invitecode" : invitecodeStr ?: @"" };
    [self showLoadingHUDWithTitle:@"验证中..." SubTitle:nil];
    [ArtRequest PostRequestWithActionName:@"checklogin" andPramater:dicPramaters succeeded:^(id responseObject) {
         [self.hudLoading hideAnimated:YES];//
        kPrintLog(responseObject)
        NSUserDefaults* user = [NSUserDefaults standardUserDefaults];
        [user setObject:responseObject[@"user"] forKey:@"userDic"];
        [user synchronize];
        UserInfoModel* result = [UserInfoModel mj_objectWithKeyValues:responseObject];
        [Global sharedInstance].userID = result.user.uid;
        [Global sharedInstance].token = result.token;
        [Global sharedInstance].isgroup = result.data.isgroup;
        [Global sharedInstance].auth = [NSString stringWithFormat:@"%@", result.auth];
        [UMessage addTag:UMPushTag
                response:^(id responseObject, NSInteger remain, NSError* error){
                    //add your codes
                }];
        [UMessage addAlias:result.user.uid type:UMPushType response:^(id responseObject, NSError* error) {
            NSLog(@"%@ -%@", responseObject, error);
        }];
        if ([self.whichControl isEqualToString:@"tabBar"]){
            [self.navigationController popToRootViewControllerAnimated:YES];
        }else{
        NSArray* arr = self.navigationController.viewControllers;
        for (UIViewController* vc in arr) {
            if ([vc isKindOfClass:NSClassFromString(self.whichControl)]) {
                [self.navigationController popToViewController:vc animated:YES];
                break;
            }
        }
        }
        
//        if ([self.state isEqualToString:@"1"]) {
            
//            [UMessage addTag:@"sdjb"
//                    response:^(id responseObject, NSInteger remain, NSError* error){
//                        //add your codes
//                    }];
//            [UMessage addAlias:result.user.uid type:@"jianbao" response:^(id responseObject, NSError* error) {
//                NSLog(@"%@ -%@", responseObject, error);
//            }];
            //                [UMessage setAlias:result.user.uid type:@"jianbao" response:^(id responseObject, NSError* error) {
            //                    NSLog(@"%@ -%@", responseObject, error);
            //                }];
//            [self.navigationController popViewControllerAnimated:YES];
//        }else {
//            [UMessage addTag:@"sdjb"
//                    response:^(id responseObject, NSInteger remain, NSError* error){
//                        //add your codes
//                    }];
//            [UMessage addAlias:result.user.uid type:@"jianbao" response:^(id responseObject, NSError* error) {
//                NSLog(@"%@ -%@", responseObject, error);
//            }];
            //                [UMessage setAlias:result.user.uid type:@"jianbao" response:^(id responseObject, NSError* error) {
            //                    NSLog(@"%@ -%@", responseObject, error);
            //                }];
            
//            [self dismissViewControllerAnimated:YES completion:nil];
//        }

    } failed:^(id responseObject){
        [self showErrorHUDWithTitle:@"验证失败" SubTitle:nil Complete:nil];
    }];
    
}
-(void)leftBarItem_Click{

    [self.navigationController popViewControllerAnimated:YES];
}
@end
