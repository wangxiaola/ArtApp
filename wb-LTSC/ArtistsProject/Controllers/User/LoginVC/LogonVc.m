//
//  LogonVc.m
//  ArtistProject
//
//  Created by HELLO WORLD on 2017/4/5.
//  Copyright © 2017年 HELLO WORLD. All rights reserved.
//

#import "LogonVc.h"
#import <SMS_SDK/SMSSDK.h>
#import "VerifyVc.h"
#import "H5VC.h"
#import "OpenShareHeader.h"
#import "UserController.h"
#import "WXApi.h"

@interface LogonVc ()<UITextFieldDelegate>
{
    
    NSDictionary* DataDic2;
    NSString *phoneStrstr123;
    NSDictionary *weixindic;
}


@property (strong, nonatomic) IBOutlet UITextField *phoneNumber;
@property (strong, nonatomic) IBOutlet UIButton *imgBtn;
@property (strong, nonatomic) IBOutlet UIButton *argeedBtn;
@property (strong, nonatomic) IBOutlet UIButton *protocolBtn;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *imgBtnLeft;

@end

@implementation LogonVc

-(void)createView{
    [super createView];
    _imgBtnLeft.constant = T_WIDTH(90);
    weixindic=[[NSDictionary alloc]init];
    [_imgBtn setImage:[UIImage imageNamed:@"icon_Default_unSelected"] forState:UIControlStateNormal];
    [_imgBtn setImage:[UIImage imageNamed:@"icon_Default_selected"] forState:UIControlStateSelected];
    _imgBtn.selected = YES;
    _argeedBtn.selected = YES;
    _phoneNumber.keyboardType = UIKeyboardTypeNumberPad;
    self.view.backgroundColor = BACK_VIEW_COLOR;
    HHttpRequest *request1 = [[HHttpRequest alloc] init];
    [request1 httpGetRequestWithActionName:@"coincheck" andPramater:nil andDidDataErrorBlock:^(NSURLSessionTask *operation, id responseObject) {
        
    }andDidRequestSuccessBlock:^(NSURLSessionTask *operation, id responseObject){
        NSString* tempStr = [NSString stringWithFormat:@"%@",responseObject[@"res"]];
        if ([tempStr isEqualToString:@"0"]) {
            _Weixin.hidden=YES;
        }else{
//            _Weixin.hidden=NO;
        }
        
        [self.hudLoading hideAnimated:YES];
    } andDidRequestFailedBlock:^(NSURLSessionTask *operation, NSError *error) {
        [self.hudLoading hideAnimated:YES];
    }];
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if ([WXApi isWXAppInstalled]) {
        _Weixin.hidden = NO;
    }else{
        _Weixin.hidden = YES;
    }
}
//发送验证码
- (IBAction)verifyClick:(UIButton *)sender {
    [self hideKeyBoard];
    if ([self showCheckErrorHUDWithTitle:@"请输入手机号" SubTitle:nil checkTxtField:self.phoneNumber]) {
        return;
    }
    
    if (!_imgBtn.selected) {
        [self showErrorHUDWithTitle:@"请同意用户协议" SubTitle:nil Complete:nil];
        return;
    }
    
    if (_phoneNumber.text.length == 11) {
        [self SendVerifyCode];
    }else {
        [self showErrorHUDWithTitle:@"手机号码格式不正确" SubTitle:nil Complete:nil];
    }
    
}
//发送验证码
- (void)SendVerifyCode
{

    self.hudLoading.color = [UIColor colorWithHexString:@"#666666"];
    self.hudLoading.labelColor = kWhiteColor;
    self.hudLoading.activityIndicatorColor = kWhiteColor;
    [self showLoadingHUDWithTitle:@"正在发送" SubTitle:nil];
    if ([phoneStrstr123  isEqualToString:@"1"]){
            
            NSDictionary* dict = @{
                                   @"phone":_phoneNumber.text,
                                   @"account":[DataDic2 objectForKey:@"unionid"],
                                   @"type": @"wechat",
                                   @"info": [[Global sharedInstance] dictionaryToJson:weixindic]
                                   };
            [ArtRequest PostRequestWithActionName:@"savephone" andPramater:dict succeeded:^(id responseObject){
                kPrintLog(responseObject)
                UserInfoModel* result = [UserInfoModel modelWithDictionary:responseObject];
                [Global sharedInstance].userID = result.user.uid;
                [Global sharedInstance].token = result.token;
                [Global sharedInstance].userInfo = result;
            } failed:^(id responseObject) {
                
            }];
        }
         [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodSMS phoneNumber:_phoneNumber.text
                                       zone:@"86"
                                     result:^(NSError* error) {
                                         [self.hudLoading hide:YES];
                                         if (!error){
                                             VerifyVc* verify = [[VerifyVc alloc]init];
                                             verify.phoneNumber = _phoneNumber.text;
                                             verify.navTitle = @"验证码";
                                             verify.whichControl = self.whichControl;
                                             [self.hudLoading hideAnimated:YES];
                                             [self.navigationController pushViewController:verify animated:YES];

                                         }else {
                                             [self showErrorHUDWithTitle:@"发送失败" SubTitle:nil Complete:nil];
                                         }
                                         
        }];
    
}
- (IBAction)loginBtnClick:(UIButton *)sender {
    if (sender.tag==100) {
        _imgBtn.selected=!_imgBtn.selected;
        _argeedBtn.selected = _imgBtn.selected;
        
    }else if(sender.tag==101){
        _argeedBtn.selected=!_argeedBtn.selected;
        _imgBtn.selected = _argeedBtn.selected;
    }else{
        //NSLog(@"用户协议");
        H5VC* h5 = [[H5VC alloc] init];
        h5.navTitle = @"用户协议";
        h5.url = @"http://jianbao.guwanw.com/agreement.html";
        h5.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:h5 animated:YES];
    }
    
}
- (BOOL)showCheckErrorHUDWithTitle:(NSString*)title SubTitle:(NSString*)subTitle checkTxtField:(UITextField*)txt
{
    NSString* strTxtCheck = txt.text;
    strTxtCheck = strTxtCheck ? strTxtCheck : @"";
    if ([strTxtCheck checkIsEmpty]) {
        [self showErrorHUDWithTitle:title SubTitle:subTitle Complete:^{
            [txt becomeFirstResponder];
        }];
        return YES;
    }
    else {
        return NO;
    }
}
-(void)leftBarItem_Click{
    if ([self.whichControl isEqualToString:@"tabBar"]){
        [self.navigationController popToRootViewControllerAnimated:NO];
        [self JumpToControlIndex:0 TransitionType:UISSAnimationFromBottom whichContol:nil];
    }else{
        NSArray* arr = self.navigationController.viewControllers;
        for (UIViewController* vc in arr) {
            if ([vc isKindOfClass:NSClassFromString(self.whichControl)]) {
                [self.navigationController popToViewController:vc animated:YES];
                break;
            }
        }
    }
}
//微信登录
- (IBAction)weixinLogin:(UIButton *)sender {
    [self hideKeyBoard];
    
    [OpenShare WeixinAuth:@"snsapi_userinfo" Success:^(NSDictionary *message) {
        NSLog(@"微信登录成功:\n%@",message);
        [self wxLogin:message];
        if ([self.state isEqualToString:@"1"]) {
            [self.navigationController popViewControllerAnimated:YES];
        }else {
            
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        
    } Fail:^(NSDictionary *message, NSError *error) {
        NSLog(@"微信登录失败:\n%@\n%@",message,error);
    }];

    
    //    OSMessage *msg=[[OSMessage alloc]init];
    
    //    if ([OpenShare isWeixinInstalled] == NO) {
    //        [self showErrorHUDWithTitle:@"您当前的手机上没有安装微信客户端，无法进行登录" SubTitle:nil Complete:nil];
    //        return;
    //    }
    //    [OpenShare WeixinAuth:@"snsapi_userinfo" Success:^(NSDictionary* message) {
    //        [self wxLogin:message];
    //    }Fail:^(NSDictionary* message, NSError* error) {
    //                         SIAlertView* alert = [[SIAlertView alloc] initWithTitle:@"消息" andMessage:@"登录失败"];
    //                         [alert addButtonWithTitle:@"确定" type:SIAlertViewButtonTypeCancel handler:nil];
    //                         [alert show];
    //                     }];
}
/**
 *  微信登录
 *
 *  @param code 微信客户端返回的登录码
 */
- (void)wxLogin:(NSDictionary*)code
{
//    appid bbd5c62da1ae8466
//   secret 3ca02b8f99da67e216022356f6df9700
    NSData* Data1 = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code",wechatAppID,wechatAppSecret,[code objectForKey:@"code"]]]];
    NSDictionary* DataDic1 = [NSJSONSerialization JSONObjectWithData:Data1 options:NSJSONReadingMutableContainers error:nil]; //转换数据格式
    
    NSData* Data2 = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/userinfo?access_token=%@&openid=%@&lang=zh_CN", [DataDic1 objectForKey:@"access_token"], [DataDic1 objectForKey:@"openid"]]]];
    DataDic2 = [NSJSONSerialization JSONObjectWithData:Data2 options:NSJSONReadingMutableContainers error:nil]; //转换数据格式
    NSLog(@"RESPONSE　DATA: %@", DataDic2); //
    
    //    1.管理器
    AFHTTPSessionManager* manager = [AFHTTPSessionManager manager];
    //2 设定类型
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", nil];
    manager.requestSerializer.timeoutInterval = 20.0f; //超时时间
    NSString* url = AppUrlRoot;
    //特殊参数
    weixindic = @{ @"username" : [DataDic2 objectForKey:@"nickname"],
                   @"id" : [DataDic2 objectForKey:@"unionid"],
                   @"avatar" : [DataDic2 objectForKey:@"headimgurl"],
                   @"sex" : [DataDic2 objectForKey:@"sex"] };
    
    NSDictionary* dicPramaters = @{ @"ac" : @"platform",
                                    @"account" : [DataDic2 objectForKey:@"unionid"],
                                    @"type" : @"wechat",
                                    @"info" : [[Global sharedInstance] dictionaryToJson:weixindic] };
    
    [manager POST:url parameters:dicPramaters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

        NSString* phoneStr = [NSString stringWithFormat:@"%@",responseObject[@"firstauth"]];
        if ([phoneStr  isEqualToString:@"1"])
        {
             phoneStrstr123=@"1";
    
        }else{
            if ([self.whichControl isEqualToString:@"tabBar"]){
                [self.navigationController popToRootViewControllerAnimated:YES];
            }else{
                NSArray* arr = self.navigationController.viewControllers;
                for (UIViewController* vc in arr) {
                    if ([vc isKindOfClass:NSClassFromString(self.whichControl)]) {
                        UserInfoModel* result = [UserInfoModel modelWithDictionary:responseObject];
                        [Global sharedInstance].userID = result.user.uid;
                        [Global sharedInstance].token = result.token;
                        [Global sharedInstance].userInfo = result;
                        [Global sharedInstance].isgroup = result.data.isgroup;
                        [UMessage addTag:UMPushTag
                                 response:^(id  _Nonnull responseObject, NSInteger remain, NSError * _Nonnull error) {
                                     
                                 }];
                        [UMessage addAlias:result.user.uid type:UMPushType response:^(id responseObject, NSError* error) {
                            NSLog(@"%@ -%@", responseObject, error);
                        }];
                        [self.navigationController popToViewController:vc animated:YES];
                        break;
                    }

                    }
                }
    
//            NSArray* arr = self.navigationController.viewControllers;
//            for (UIViewController* vc in arr) {
//                if ([vc isKindOfClass:NSClassFromString(@"UserController")]||[vc isKindOfClass:NSClassFromString(@"MemberAreaController")]||[vc isKindOfClass:NSClassFromString(@"HomeListDetailVC")]||[vc isKindOfClass:NSClassFromString(@"YTXMyFriendsViewController")]||[vc isKindOfClass:NSClassFromString(@"AppraisalMeetingDetailVC")]||[vc isKindOfClass:NSClassFromString(@"BaoMingVC")]||[vc isKindOfClass:NSClassFromString(@"CangyouZixunVC")]||[vc isKindOfClass:NSClassFromString(@"CommentListVc")]||[vc isKindOfClass:NSClassFromString(@"ExpertAppointmentDetailH5VC")]||[vc isKindOfClass:NSClassFromString(@"ExpertAppointmentDetailVCViewController")]||[vc isKindOfClass:NSClassFromString(@"HomeController")]||[vc isKindOfClass:NSClassFromString(@"MyHomePageDockerVC")]||[vc isKindOfClass:NSClassFromString(@"SiXinVC")]||[vc isKindOfClass:NSClassFromString(@"YTXTopicCommentViewController")]||[vc isKindOfClass:NSClassFromString(@"MemberMallController")]||[vc isKindOfClass:NSClassFromString(@"MemberMallListController")]){
//                            UserInfoModel* result = [UserInfoModel modelWithDictionary:responseObject];
//                            [Global sharedInstance].userID = result.user.uid;
//                            [Global sharedInstance].token = result.token;
//                            [Global sharedInstance].userInfo = result;
//                            [Global sharedInstance].isgroup = result.data.isgroup;
//                    [UMessage addTag:UMPushTag
//                            response:^(id responseObject, NSInteger remain, NSError* error){
//                                //add your codes
//                            }];
//                    [UMessage addAlias:result.user.uid type:UMPushType response:^(id responseObject, NSError* error) {
//                        NSLog(@"%@ -%@", responseObject, error);
//                    }];
//                    [self.navigationController popToViewController:vc animated:YES];
//                    break;
//                }
//            }
            
        }
    }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}
@end
