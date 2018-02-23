//
//  PayViewController.m
//  ArtistsProject
//
//  Created by HELLO WORLD on 2017/4/22.
//  Copyright © 2017年 HELLO WORLD. All rights reserved.
//

#import "PayViewController.h"
#import "UserIndexVCItemView.h"
#import "AlipayInfoModel.h"
#import <AlipaySDK/AlipaySDK.h>
#import "PayNewVC.h"
#import "WXApi.h"
#import "WxpayInfoModel.h"
#import "HomeListDetailVc.h"
@interface PayViewController ()
{
    HLabel *lblZhifuMoney,*lblYueMoney,*lblNeedPay;
    UserIndexVCItemView * viewComment,*viewRelease,*viewYuer;
    NSString *strNeedPay;//还需支付金额
    NSString *strZhanghuYue;//账户余额
    NSString *payType;//支付方式
    
}
@property(nonatomic,strong)UILabel* payLabel;
@property(nonatomic,strong)UILabel* yueLabel;
@property(nonatomic,strong)UILabel* moneyLabel;//还需支付
@end

@implementation PayViewController

@synthesize money,payId,type;

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSArray *array = [[UIApplication sharedApplication] windows];
    
    UIWindow* win=[array objectAtIndex:0];
    
    [win setHidden:YES];
}
-(void)createView{
    [super createView];
    UIImageView *imgBG=[[UIImageView alloc]init];
    imgBG.image=[UIImage imageNamed:@"icon_payWallet_beijing.png"];
    [self.view addSubview:imgBG];
    [imgBG mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.view);
        make.height.mas_equalTo(kScreenW/3*2);
    }];
    
    HView *viewImageBG=[[HView alloc]init];
    viewImageBG.backgroundColor=ColorHexA(@"000000", 0.2);
    [imgBG addSubview:viewImageBG];
    [viewImageBG mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(imgBG);
        make.top.equalTo(imgBG).offset(kScreenW/6);
        make.height.mas_equalTo(120);
    }];
    
    lblZhifuMoney=[[HLabel alloc]init];
    lblZhifuMoney.textColor=kYellowColor;
    lblZhifuMoney.text=[NSString stringWithFormat:@"· 支付金额 : %0.2f元",[money floatValue]];
    lblZhifuMoney.font=kFont(17);
    lblZhifuMoney.textEdgeInsets=UIEdgeInsetsMake(0, 20, 0, 0);
    [viewImageBG addSubview:lblZhifuMoney];
    [lblZhifuMoney mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(viewImageBG);
        make.height.mas_equalTo(40);
        make.top.equalTo(viewImageBG);
    }];
    
    lblYueMoney=[[HLabel alloc]init];
    lblYueMoney.textColor=kYellowColor;
    lblYueMoney.font=kFont(17);
    lblYueMoney.textEdgeInsets=UIEdgeInsetsMake(0, 20, 0, 0);
    [viewImageBG addSubview:lblYueMoney];
    [lblYueMoney mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(viewImageBG);
        make.height.mas_equalTo(40);
        make.top.equalTo(lblZhifuMoney.mas_bottom);
    }];
    
    
    lblNeedPay=[[HLabel alloc]init];
    lblNeedPay.textColor=kYellowColor;
    lblNeedPay.font=kFont(17);
    lblNeedPay.textEdgeInsets=UIEdgeInsetsMake(0, 20, 0, 0);
    [viewImageBG addSubview:lblNeedPay];
    [lblNeedPay mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(viewImageBG);
        make.height.mas_equalTo(40);
        make.top.equalTo(lblYueMoney.mas_bottom);
    }];
    
    __weak typeof(self)weakSelf = self;
    //余额支付
    viewYuer = [UserIndexVCItemView new];
    [self.view addSubview:viewYuer];
    viewYuer.bottomLineWidth = 17;
    [viewYuer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imgBG.mas_bottom);
        make.left.and.right.equalTo(self.view);
        make.height.mas_equalTo(45);
    }];
    viewYuer.imgIcon = @"icon_wallet_BG";
    viewYuer.title = @"余额支付";
    viewYuer.imgArrow = @"icon_UserIndexVC_rightArrow";
    viewYuer.borderColor = kLineColor;
    viewYuer.borderWidth=HViewBorderWidthMake(1, 0, 0, 0);
    [viewYuer setDidTapBlock:^{
        [weakSelf btnTijiao_Click];
    }];
    
    
    viewComment = [UserIndexVCItemView new];
    [self.view addSubview:viewComment];
    viewComment.bottomLineWidth = 17;
    [viewComment mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(viewYuer.mas_bottom);
        make.left.and.right.equalTo(self.view);
        make.height.mas_equalTo(45);
    }];
    viewComment.imgIcon = @"icon_wallet_zhifubao";
    viewComment.title = @"支付宝";
    viewComment.imgArrow = @"icon_UserIndexVC_rightArrow";
    [viewComment setDidTapBlock:^{
        payType=@"1";
        [weakSelf payWithZhifubao];
    }];
    
    
    viewRelease = [UserIndexVCItemView new];
    [self.view addSubview:viewRelease];
    viewRelease.bottomLineWidth = 10;
    [viewRelease mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(viewComment.mas_bottom);
        make.left.and.right.equalTo(self.view);
        make.height.mas_equalTo(45);
    }];
    viewRelease.imgIcon = @"icon_wallet_wechat";
    viewRelease.title = @"微信支付";
    viewRelease.imgArrow = @"icon_UserIndexVC_rightArrow";
    [viewRelease setDidTapBlock:^{
        payType=@"2";
        [weakSelf payWithWechat];
    }];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"WX_PAY_NOTIFICATION" object:nil];
    //监听微信支付
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(wxPayNotification:) name:@"WX_PAY_NOTIFICATION" object:nil];
}
//请求用户余额信息
- (void)loadData{
    //1.设置请求参数
    [self showLoadingHUDWithTitle:@"正在获取余额信息" SubTitle:nil];
    //2.开始请求
    NSDictionary *dicMoney=@{@"uid":[Global sharedInstance].userID};
    HHttpRequest *request = [[HHttpRequest alloc] init];
    [request httpPostRequestWithActionName:@"coininfo" andPramater:dicMoney andDidDataErrorBlock:^(NSURLSessionTask *operation, id responseObject) {
        [self.hudLoading hideAnimated:YES];
        ResultModel *result=[ResultModel mj_objectWithKeyValues:responseObject];
        [self showErrorHUDWithTitle:result.msg SubTitle:nil Complete:nil];
    } andDidRequestSuccessBlock:^(NSURLSessionTask *operation, id responseObject) {
        strZhanghuYue=[NSString stringWithFormat:@"%.2f",[[responseObject objectForKey:@"coin"] floatValue]/100];
        lblYueMoney.text=[NSString stringWithFormat:@"· 账户余额: %@元",strZhanghuYue];
        if (money.floatValue>strZhanghuYue.floatValue) {
            //余额不足
            viewYuer.hidden=YES;
            [viewYuer mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(1);
            }];
            lblNeedPay.text=[NSString stringWithFormat:@"· 还需支付: %.2f元",money.floatValue-strZhanghuYue.floatValue];
            strNeedPay=[NSString stringWithFormat:@"%.2f",money.floatValue-strZhanghuYue.floatValue];
        }else{
            //余额充足
            
            viewRelease.hidden=YES;
            [viewRelease mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(1);
            }];
            
            viewComment.hidden=YES;
            [viewComment mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(1);
            }];
            lblNeedPay.text=[NSString stringWithFormat:@"· 还需支付: %@元",money];
            strNeedPay=money;
            
        }
        
        [self.hudLoading hideAnimated:YES];
    } andDidRequestFailedBlock:^(NSURLSessionTask *operation, NSError *error) {
        [self.hudLoading hideAnimated:YES];
    }];
}

//用余额支付
-(void)btnTijiao_Click{
    //1.设置请求参数
    [self showLoadingHUDWithTitle:@"正在支付" SubTitle:nil];
//    strNeedPay = @"0.01";
    NSDictionary *dict = @{@"amount":[NSString stringWithFormat:@"%.2f",strNeedPay.floatValue*100],
                           @"type":type,
                           @"uid":[Global sharedInstance].userID,
                           @"pid":self.payId};
    //    //2.开始请求
    HHttpRequest *request = [[HHttpRequest alloc] init];
    [request httpPostRequestWithActionName:@"changecoin" andPramater:dict andDidDataErrorBlock:^(NSURLSessionTask *operation, id responseObject) {
        [self.hudLoading hideAnimated:YES];
        ResultModel *result=[ResultModel mj_objectWithKeyValues:responseObject];
        [self showErrorHUDWithTitle:result.msg SubTitle:nil Complete:nil];
    } andDidRequestSuccessBlock:^(NSURLSessionTask *operation, id responseObject) {
       
        if ([[ArtUIHelper sharedInstance] alertSuccessWith:@"支付" obj:responseObject]){
           
            NSArray* arr = self.navigationController.viewControllers;
            for (UIViewController* vc in arr) {
                if ([vc isKindOfClass:NSClassFromString(self.whichControl)]){
                    HomeListDetailVc* detail = (HomeListDetailVc*)vc;
                    [detail refreshData];
                    [self.navigationController popToViewController:vc animated:YES];
                    break;
                }
            }

        }else{
            NSString* msg = responseObject[@"msg"];
            if((msg.length>0)&&[msg rangeOfString:@"其它手机登录"].location!=NSNotFound){
                [self logonAgain];
            }
        }

        
        //[self ZhifuSuccess];
        [self.hudLoading hideAnimated:YES];
    } andDidRequestFailedBlock:^(NSURLSessionTask *operation, NSError *error) {
        [self.hudLoading hideAnimated:YES];
    }];
    
}


//支付宝支付
-(void)payWithZhifubao{
    [self hideKeyBoard];
    NSString *strTip=@"";
    if ([type isEqualToString:@"5"]) {
        strTip=@"赞赏小费";
    }
//    strNeedPay = @"0.01";
    //1.设置请求参数
    [self showLoadingHUDWithTitle:@"正在获取支付宝信息" SubTitle:nil];
    NSDictionary *dict = @{
                           @"uid" : [Global sharedInstance].userID,
                           @"subject":strTip,
                           @"total_fee":[NSString stringWithFormat:@"%f",strNeedPay.floatValue*100],
                           @"body":strTip,
                           @"type":type,
                           @"pid":self.payId};
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
 *   sellerID   商户ID
 *   partnerID  appkey
 *   privateKey 私钥
 */

- (void)alipay:(AlipayInfoModel*)model
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
        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                       model.params, signedString, @"RSA"];
        
        [[AlipaySDK defaultService] payOrder:orderString
                                  fromScheme:appScheme
                                    callback:^(NSDictionary* resultDic) {
                                        if (![[UIApplication sharedApplication] canOpenURL: [NSURL URLWithString:@"alipay:"]]) {
                                            //支付宝网页支付设置，显示UIWindow窗口
                                            
                                            NSArray *array = [[UIApplication sharedApplication] windows];
                                            
                                            UIWindow* win=[array objectAtIndex:0];
                                            [win setHidden:YES];
                                            
                                        }                                        if ([[resultDic objectForKey:@"resultStatus"] isEqualToString:@"9000"]
                                            && [[resultDic objectForKey:@"result"] rangeOfString:@"success=\"true\""].length > 0) {
                                            [self paySuccess];
                                        }else{
                                            [self payFaile];
                                        }
                                        
                                    }];
        
    }else{
        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                       model.params, signedString, @"RSA"];
        
        [[AlipaySDK defaultService] payOrder:orderString
                                  fromScheme:appScheme
                                    callback:^(NSDictionary* resultDic) {
                                                                                if ([[resultDic objectForKey:@"resultStatus"] isEqualToString:@"9000"]
                                                                                     && [[resultDic objectForKey:@"result"] rangeOfString:@"success=\"true\""].length > 0) {
                                            [self paySuccess];
                                        }else{
                                            [self payFaile];
                                        }
                                        
                                    }];
        
    }
}
//微信
-(void)payWithWechat{
    [self hideKeyBoard];
    NSString *strTip=@"";
    
    if ([type isEqualToString:@"5"]) {
        strTip=@"赞赏小费";
    }
//    strNeedPay = @"0.01";
    //1.设置请求参数
    [self showLoadingHUDWithTitle:@"正在获取微信信息" SubTitle:nil];
    NSDictionary *dict = @{@"subject":strTip,
                           @"total_fee":[NSString stringWithFormat:@"%f",strNeedPay.floatValue*100],
                           @"body":strTip,
                           @"type":type,
                           @"pid":self.payId};
    //    //2.开始请求
    HHttpRequest *request = [[HHttpRequest alloc] init];
    [request httpPostRequestWithActionName:@"wxsign" andPramater:dict andDidDataErrorBlock:^(NSURLSessionTask *operation, id responseObject) {
        [self.hudLoading hideAnimated:YES];
        ResultModel *result=[ResultModel mj_objectWithKeyValues:responseObject];
        [self showErrorHUDWithTitle:result.msg SubTitle:nil Complete:nil];
    } andDidRequestSuccessBlock:^(NSURLSessionTask *operation, id responseObject) {
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

//支付成功
-(void)paySuccess{
    //无权限
    SIAlertView *alert=[[SIAlertView alloc] initWithTitle:@"提示" andMessage:@"支付成功"];
    [alert addButtonWithTitle:@"确定" type:SIAlertViewButtonTypeCancel handler:^(SIAlertView *alertView){
        NSArray* arr = self.navigationController.viewControllers;
        for (UIViewController* vc in arr) {
            if ([vc isKindOfClass:NSClassFromString(self.whichControl)]){
                HomeListDetailVc* detail = (HomeListDetailVc*)vc;
                [detail refreshData];
                [self.navigationController popToViewController:vc animated:YES];
                break;
            }
        }
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
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"WX_PAY_NOTIFICATION" object:nil];
}
@end
