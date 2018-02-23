//  RechargeVC.m
//  ShesheDa
//
//  Created by chen on 16/7/16.
//  Copyright © 2016年 上海翔汇网络有限公司. All rights reserved.
//
#define NUMBERS @"0123456789\n"
#import "RechargeVC.h"
#import "UserIndexVCItemView.h"
#import "AlipayInfoModel.h"
#import <AlipaySDK/AlipaySDK.h>
#import "DataSigner.h"
#import "WXApi.h"
#import "WxpayInfoModel.h"
#import "AlipayOrder.h"
//#import "OrderComfireVC.h"
//#import "CartVC.h"
//#import "PayTypeChoiceVC.h"
#import "DESEncryption.h"
#import "DataVerifier.h"
#import "SIAlertView.h"

@interface RechargeVC ()<UITextFieldDelegate>{
    HTextFieldWithTitle *txtMoney;
    NSString *payType;
}

@end

@implementation RechargeVC
@synthesize tip;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title=@"充值";
    //监听微信支付
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(wxPayNotification:) name:@"WX_PAY_NOTIFICATION" object:nil];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSArray *array = [[UIApplication sharedApplication] windows];
    UIWindow* win=[array objectAtIndex:0];
    [win setHidden:YES];
}
/*
*  微信支付成功处理
*/
- (void)wxPayNotification:(NSNotification*)text
{
    NSLog(@"－－－－－接收到通知------");
    NSLog(@"%@", text.userInfo[@"payResult"]);
    if ([text.userInfo[@"payResult"] isEqualToString:@"success"]) {
        [self paySuccess];
    }else{
        [self payFaile];
    }
     [[NSNotificationCenter defaultCenter] removeObserver:self name:@"WX_PAY_NOTIFICATION" object:nil];
}

- (void) createView:(UIView*)contentView{
    txtMoney=[[HTextFieldWithTitle alloc]init];
    if (self.moneyStr.length>0) {
        txtMoney.textContent.text = _moneyStr;
        self.navigationItem.title=@"赞赏";
    }
    txtMoney.title=@"金额(元)   ";
    txtMoney.textContent.delegate=self;
    txtMoney.textContent.keyboardType=UIKeyboardTypeDecimalPad;
    txtMoney.textContent.clearButtonMode=UITextFieldViewModeWhileEditing;
    txtMoney.backgroundColor=kWhiteColor;
    txtMoney.titleColor=[UIColor blackColor];
    txtMoney.titleFont=kFont(16);
    [contentView addSubview:txtMoney];
    [txtMoney mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(contentView);
        make.top.equalTo(contentView).offset(20);
        make.height.mas_equalTo(40);
    }];
    [txtMoney.textContent resignFirstResponder];
    
    HLabel *lblTip=[[HLabel alloc]init];
    lblTip.text=tip;
    lblTip.textColor=[UIColor redColor];
    lblTip.font=kFont(10);
    [contentView addSubview:lblTip];
    [lblTip mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView).offset(25);
        make.top.equalTo(txtMoney.mas_bottom).offset(3);
    }];
    
    //我的点评
    UserIndexVCItemView * viewComment = [UserIndexVCItemView new];
    [contentView addSubview:viewComment];
    viewComment.bottomLineWidth = 17;
    [viewComment mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lblTip.mas_bottom).offset(30);
        make.left.and.right.equalTo(contentView);
        make.height.mas_equalTo(45);
    }];
    viewComment.imgIcon = @"icon_wallet_zhifubao";
    viewComment.title = @"支付宝";
    viewComment.imgArrow = @"icon_UserIndexVC_rightArrow";
    viewComment.borderColor = kLineColor;
    viewComment.borderWidth=HViewBorderWidthMake(1, 0, 0, 0);
    [viewComment setDidTapBlock:^{
        NSLog(@"我的点评");
        payType=@"1";
        [self payWithZhifubao];
    }];
    
//    //我的发布
    UserIndexVCItemView *viewRelease = [UserIndexVCItemView new];
    [contentView addSubview:viewRelease];
    viewRelease.bottomLineWidth = 10;
    [viewRelease mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(viewComment.mas_bottom);
        make.left.and.right.equalTo(contentView);
        make.height.mas_equalTo(45);
    }];
    viewRelease.imgIcon = @"icon_wallet_wechat";
    viewRelease.title = @"微信支付";
    viewRelease.imgArrow = @"icon_UserIndexVC_rightArrow";
    [viewRelease setDidTapBlock:^{
        NSLog(@"微信支付");
        payType=@"2";
        [self payWithWechat];
    }];
}

-(void)payWithWechat{
    if ([self showCheckErrorHUDWithTitle:@"请输入充值金额" SubTitle:nil checkTxtField:txtMoney.textContent]) {
        return ;
    }
    [self hideKeyBoard];
    //1.设置请求参数
    [self showLoadingHUDWithTitle:@"正在获取微信信息" SubTitle:nil];
    NSDictionary *dict = @{@"subject":@"余额充值",
                           @"total_fee":[NSString stringWithFormat:@"%f",txtMoney.textContent.text.floatValue*100],
                           @"body":@"余额充值",
                           @"type":@"1",
                           @"pid":@"0"};
    //    //2.开始请求
    HHttpRequest *request = [[HHttpRequest alloc] init];
    [request httpPostRequestWithActionName:@"wxsign" andPramater:dict andDidDataErrorBlock:^(NSURLSessionTask *operation, id responseObject) {
        kPrintLog(responseObject)
        [self.hudLoading hideAnimated:YES];
        ResultModel *result=[ResultModel mj_objectWithKeyValues:responseObject];
        [self showErrorHUDWithTitle:result.msg SubTitle:nil Complete:nil];
    } andDidRequestSuccessBlock:^(NSURLSessionTask *operation, id responseObject) {
        kPrintLog(responseObject)
        NSDictionary* dic = [NSDictionary dictionaryWithDictionary:responseObject];
        if ([dic containsObjectForKey:@"res"]) {
            NSString* resStr = [NSString stringWithFormat:@"%@",responseObject[@"res"]];
        if ([resStr isEqualToString:@"1"]){
            WxpayInfoModel* result = [WxpayInfoModel mj_objectWithKeyValues:responseObject];
            [self wxpayWithWxpayInfoModel:result];
        }else{
            NSString* msg = responseObject[@"msg"];
            if((msg.length>0)&&[msg rangeOfString:@"其它手机登录"].location!=NSNotFound){
                [self logonAgain];
            }
         }
        }else{
            WxpayInfoModel* result = [WxpayInfoModel mj_objectWithKeyValues:responseObject];
            [self wxpayWithWxpayInfoModel:result];
        }

        [self.hudLoading hideAnimated:YES];
    } andDidRequestFailedBlock:^(NSURLSessionTask *operation, NSError *error) {
        kPrintLog(error)
        [self.hudLoading hideAnimated:YES];
    }];
}

-(void)wxpayWithWxpayInfoModel:(WxpayInfoModel *)modelWechat{
    PayReq* req = [[PayReq alloc] init];
    req.partnerId = modelWechat.partnerid;
    req.prepayId = modelWechat.prepayid;
    req.package = @"Sign=WXPay";
    req.nonceStr = modelWechat.noncestr;
    req.timeStamp = [modelWechat.timestamp intValue];
    req.sign = modelWechat.sign;
    [WXApi sendReq:req];
}

//支付宝支付
-(void)payWithZhifubao{
    if ([self showCheckErrorHUDWithTitle:@"请输入充值金额" SubTitle:nil checkTxtField:txtMoney.textContent]) {
        return ;
    }
    [self hideKeyBoard];
    
    //1.设置请求参数
    [self showLoadingHUDWithTitle:@"正在获取支付宝信息" SubTitle:nil];
        NSDictionary *dict = @{@"subject":@"支付宝余额充值",
                               @"total_fee":[NSString stringWithFormat:@"%.2f",txtMoney.textContent.text.floatValue*100],
                               @"body":@"支付宝余额充值",
                               @"type":@"1",
                               @"pid":@"0"};
    //    //2.开始请求
    HHttpRequest *request = [[HHttpRequest alloc] init];
    [request httpPostRequestWithActionName:@"alisign" andPramater:dict andDidDataErrorBlock:^(NSURLSessionTask *operation, id responseObject) {
        [self.hudLoading hideAnimated:YES];
        ResultModel *result=[ResultModel mj_objectWithKeyValues:responseObject];
        [self showErrorHUDWithTitle:result.msg SubTitle:nil Complete:nil];
    } andDidRequestSuccessBlock:^(NSURLSessionTask *operation, id responseObject) {
        
        NSDictionary* dic = [NSDictionary dictionaryWithDictionary:responseObject];
        if ([dic containsObjectForKey:@"res"]) {
            NSString* resStr = [NSString stringWithFormat:@"%@",responseObject[@"res"]];
            if ([resStr isEqualToString:@"1"]){
                AlipayInfoModel* result = [AlipayInfoModel mj_objectWithKeyValues:responseObject];
                [self alipay:result];
            }else{
                NSString* msg = responseObject[@"msg"];
                if((msg.length>0)&&[msg rangeOfString:@"其它手机登录"].location!=NSNotFound){
                    [self logonAgain];
                }
            }
        }else{
            AlipayInfoModel* result = [AlipayInfoModel mj_objectWithKeyValues:responseObject];
            [self alipay:result];
        }
        [self.hudLoading hideAnimated:YES];
    } andDidRequestFailedBlock:^(NSURLSessionTask *operation, NSError *error) {
        [self.hudLoading hideAnimated:YES];
    }];
}


/**
 *  启动支付宝支付
 *
 *  @param sellerID   商户ID
 *  @param partnerID  appkey
 *  @param privateKey 私钥
 */
- (void) alipay:(AlipayInfoModel*)model
{
    //应用注册scheme,在Info.plist定义URL types
    NSString* appScheme = kAppScheme;
    NSString* signedString = [self urlEncodedString:model.sign];
    //将签名成功字符串格式化为订单字符串,请严格按照该格式
    NSString* orderString = nil;
    if (signedString != nil) {
        if (![[UIApplication sharedApplication] canOpenURL: [NSURL URLWithString:@"alipay:"]]) {
            //支付宝网页支付设置，显示UIWindow窗口
            
            NSArray *array = [[UIApplication sharedApplication] windows];
            
            UIWindow* win=[array objectAtIndex:0];
            
            [win setHidden:NO];
            
        }
        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",model.params, signedString, @"RSA"];
        [[AlipaySDK defaultService] payOrder:orderString
                                  fromScheme:appScheme
                                    callback:^(NSDictionary* resultDic) {
                                        kPrintLog(resultDic);
                                        if (![[UIApplication sharedApplication] canOpenURL: [NSURL URLWithString:@"alipay:"]]) {
                                            //支付宝网页支付设置，显示UIWindow窗口
                                            
                                            NSArray *array = [[UIApplication sharedApplication] windows];
                                            
                                            UIWindow* win=[array objectAtIndex:0];
                                            
                                            [win setHidden:YES];
                                            
                                        }                                         if ([[resultDic objectForKey:@"resultStatus"] isEqualToString:@"9000"]
                                            && [[resultDic objectForKey:@"result"] rangeOfString:@"success=\"true\""].length > 0) {
                                            [self paySuccess];
                                        }else{
                                            [self payFaile];
                                        }
                                    }];
    }else{
        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",model.params, signedString, @"RSA"];
        [[AlipaySDK defaultService] payOrder:orderString
                                  fromScheme:appScheme
                                    callback:^(NSDictionary* resultDic) {
                                        kPrintLog(resultDic);
                                                                                 if ([[resultDic objectForKey:@"resultStatus"] isEqualToString:@"9000"]
                                                                                      && [[resultDic objectForKey:@"result"] rangeOfString:@"success=\"true\""].length > 0) {
                                            [self paySuccess];
                                        }else{
                                            [self payFaile];
                                        }
                                    }];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSCharacterSet *cs;
    cs = [[NSCharacterSet characterSetWithCharactersInString:NUMBERS] invertedSet];
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    BOOL basicTest = [string isEqualToString:filtered];
    if(!basicTest)
    {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"请输入数字"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        return NO;
    }
    //其他的类型不需要检测，直接写入
    return YES;
}

//支付成功
-(void)paySuccess{
    //无权限
    SIAlertView *alert=[[SIAlertView alloc] initWithTitle:@"提示" andMessage:@"支付成功"];
    [alert addButtonWithTitle:@"确定" type:SIAlertViewButtonTypeCancel handler:^(SIAlertView *alertView) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
    [alert show];
}

//支付失败
-(void)payFaile{
    //无权限
    SIAlertView *alert=[[SIAlertView alloc] initWithTitle:@"提示" andMessage:@"支付失败"];
    [alert addButtonWithTitle:@"取消" type:SIAlertViewButtonTypeCancel handler:nil];
    [alert addButtonWithTitle:@"重新支付" type:SIAlertViewButtonTypeDefault handler:^(SIAlertView *alertView) {
        if (payType.length>0) {
            if ([payType isEqualToString:@"1"]) {
                [self payWithZhifubao];
            }else{
                [self payWithWechat];
            }
        }
        
    }];
    [alert show];
}

@end
