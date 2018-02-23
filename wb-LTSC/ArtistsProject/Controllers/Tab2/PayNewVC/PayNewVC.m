//
//  PayNewVC.m
//  ShesheDa
//
//  Created by chen on 16/8/1.
//  Copyright © 2016年 上海翔汇网络有限公司. All rights reserved.
//

#import "PayNewVC.h"
#import "UserIndexVCItemView.h"
#import "UserIndexVCItemView.h"
#import "AlipayInfoModel.h"
#import <AlipaySDK/AlipaySDK.h>
#import "DataSigner.h"
#import "WXApi.h"
#import "WxpayInfoModel.h"
#import "AlipayOrder.h"
#import "DESEncryption.h"
#import "DataVerifier.h"
#import "MyHomePageDockerVC.h"
#import "SIAlertView.h"
#import "YTXOrderViewController.h"
#import "UserInfoModel.h"
@interface PayNewVC ()<UIActionSheetDelegate>{
    HLabel *lblZhifuMoney,*lblYueMoney,*lblNeedPay;
    UserIndexVCItemView * viewComment,*viewRelease,*viewYuer;
    NSString *strNeedPay;
    NSString *strZhanghuYue;
    NSString *payType;
    UserInfoModel *model;
}

@end

@implementation PayNewVC
@synthesize money,state,dicSave;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title=@"支付";
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.navigationController.navigationBar setTranslucent:NO];
    [self loadUserData];
}
//加载用户信息
- (void)loadUserData{
    
    //1.设置请求参数
    NSDictionary *dict = @{@"uid":[Global sharedInstance].userID?:@"0"};
    //    //2.开始请求
    HHttpRequest *request = [[HHttpRequest alloc] init];
    [request httpGetRequestWithActionName:@"userinfo" andPramater:dict andDidDataErrorBlock:^(NSURLSessionTask *operation, id responseObject) {
        ResultModel *result=[ResultModel modelWithDictionary:responseObject];
        [self showErrorHUDWithTitle:result.msg SubTitle:nil Complete:nil];
    }andDidRequestSuccessBlock:^(NSURLSessionTask *operation, id responseObject) {
        kPrintLog(responseObject)
        model=[UserInfoModel modelWithDictionary:responseObject];
        [Global sharedInstance].auth=[NSString stringWithFormat:@"%@",model.auth];
        [Global sharedInstance].userInfo=model;
    }andDidRequestFailedBlock:^(NSURLSessionTask *operation, NSError *error) {
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSArray *array = [[UIApplication sharedApplication] windows];
    UIWindow* win=[array objectAtIndex:0];
    [win setHidden:YES];
    [self loadData];
    //监听微信支付
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(wxPayNotification:) name:@"WX_PAY_NOTIFICATION" object:nil];
}

//加载用户信息
- (void) loadData{
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
        strZhanghuYue=[NSString stringWithFormat:@"%@",[responseObject objectForKey:@"coin"] ];
        lblYueMoney.text=[NSString stringWithFormat:@"· 账户余额: %.2f",[strZhanghuYue floatValue]/100];
        if (money.floatValue>strZhanghuYue.floatValue) {
            //余额不足
            viewYuer.hidden=YES;
            [viewYuer mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(1);
            }];
            lblNeedPay.text=[NSString stringWithFormat:@"· 还需支付: %.2f",(money.floatValue-strZhanghuYue.floatValue)/100];
            strNeedPay=[NSString stringWithFormat:@"%.2f",(money.floatValue-strZhanghuYue.floatValue)/100];
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
             lblNeedPay.text=[NSString stringWithFormat:@"· 还需支付: %.2f元", [money floatValue]/100];
            strNeedPay=[NSString stringWithFormat:@"%.2f",[money floatValue]/100];
        }
        [self.hudLoading hideAnimated:YES];
    } andDidRequestFailedBlock:^(NSURLSessionTask *operation, NSError *error) {
        [self.hudLoading hideAnimated:YES];
    }];
}

- (void)createView:(UIView*)contentView{
    UIImageView *imgBG=[[UIImageView alloc]init];
    imgBG.image=[UIImage imageNamed:@"icon_payWallet_beijing.png"];
    [contentView addSubview:imgBG];
    [imgBG mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(contentView);
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
    lblZhifuMoney.textColor=kWhiteColor;
    lblZhifuMoney.text=[NSString stringWithFormat:@"· 支付金额 : %.2f",[money floatValue]/100];
    lblZhifuMoney.font=kFont(17);
    lblZhifuMoney.textEdgeInsets=UIEdgeInsetsMake(0, 20, 0, 0);
    [viewImageBG addSubview:lblZhifuMoney];
    [lblZhifuMoney mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(viewImageBG);
        make.height.mas_equalTo(40);
        make.top.equalTo(viewImageBG);
    }];
    
    lblYueMoney=[[HLabel alloc]init];
    lblYueMoney.textColor=kWhiteColor;
    lblYueMoney.font=kFont(17);
    lblYueMoney.textEdgeInsets=UIEdgeInsetsMake(0, 20, 0, 0);
    [viewImageBG addSubview:lblYueMoney];
    [lblYueMoney mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(viewImageBG);
        make.height.mas_equalTo(40);
        make.top.equalTo(lblZhifuMoney.mas_bottom);
    }];

    
    lblNeedPay=[[HLabel alloc]init];
    lblNeedPay.textColor=kWhiteColor;
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
    [contentView addSubview:viewYuer];
    viewYuer.bottomLineWidth = 17;
    [viewYuer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imgBG.mas_bottom);
        make.left.and.right.equalTo(contentView);
        make.height.mas_equalTo(45);
    }];
    viewYuer.imgIcon = @"icon_wallet_BG";
    viewYuer.title = @"余额支付";
    viewYuer.imgArrow = @"icon_UserIndexVC_rightArrow";
    viewYuer.borderColor = kLineColor;
    viewYuer.borderWidth=HViewBorderWidthMake(1, 0, 0, 0);
    [viewYuer setDidTapBlock:^{
        NSLog(@"余额支付");
        [weakSelf btnTijiao_Click];
    }];
    viewComment = [UserIndexVCItemView new];
    [contentView addSubview:viewComment];
    viewComment.bottomLineWidth = 17;
    [viewComment mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(viewYuer.mas_bottom);
        make.left.and.right.equalTo(contentView);
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
        payType=@"2";
        [weakSelf payWithWechat];
    }];
}

//支付宝支付
-(void)payWithZhifubao{
    [self hideKeyBoard];
    NSString *strPayState=@"";
    NSString *strTip=@"";
    if ([state isEqualToString:@"1"]) {
        strPayState=@"3";
        strTip=@"鉴定费";
    }
    else if ([state isEqualToString:@"4"]){
        strPayState = @"4";
        strTip = @"购买商品费用";
    }
    else{
        strPayState=@"2";
        strTip=@"鉴定会报名费";
    }
//    strNeedPay = @"0.01";
    //1.设置请求参数
    [self showLoadingHUDWithTitle:@"正在获取支付宝信息" SubTitle:nil];
    NSDictionary *dict = @{@"subject":strTip,
                           @"total_fee":[NSString stringWithFormat:@"%f",strNeedPay.floatValue*100],
                           @"body":strTip,
                           @"type":strPayState,
                           @"pid":self.uID};
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
        if (![[UIApplication sharedApplication] canOpenURL: [NSURL URLWithString:@"alipay://"]]) {
//            支付宝网页支付设置，显示UIWindow窗口
            NSArray *array = [[UIApplication sharedApplication] windows];
            UIWindow* win=[array objectAtIndex:0];
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH)];
            view.backgroundColor = [UIColor whiteColor];
            [win addSubview:view];
            [win setHidden:NO];
            orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                           model.params, signedString, @"RSA"];
            [[AlipaySDK defaultService] payOrder:orderString
                                      fromScheme:appScheme
                                        callback:^(NSDictionary* resultDic) {
                                            [win setHidden:YES];
                                            
                                            if ([[resultDic objectForKey:@"resultStatus"] isEqualToString:@"9000"]
                                                && [[resultDic objectForKey:@"result"] rangeOfString:@"success=\"true\""].length > 0) {
                                                [win setHidden:YES];

                                                [self paySuccess];
                                            }else{
                                                [win setHidden:YES];

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
}

//支付成功
-(void)paySuccess{
    //无权限
    SIAlertView *alert=[[SIAlertView alloc] initWithTitle:@"提示" andMessage:@"支付成功"];
    [alert addButtonWithTitle:@"确定" type:SIAlertViewButtonTypeCancel handler:^(SIAlertView *alertView) {
          [self ZhifuSuccess];
    }];
    [alert show];
}

//支付失败
- (void)payFaile{
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

-(void)payWithWechat{
    [self hideKeyBoard];
    
    NSString *strPayState=@"";
    NSString *strTip=@"";
    if ([state isEqualToString:@"1"]) {
        strPayState=@"3";
        strTip=@"鉴定费";
    }else if ([state isEqualToString:@"4"]){
        strPayState = @"4";
        strTip = @"购买商品费用";
    }
    else{
        strPayState=@"2";
        strTip=@"鉴定会报名费";
    }

    
    //1.设置请求参数
    [self showLoadingHUDWithTitle:@"正在获取微信信息" SubTitle:nil];
    NSDictionary *dict = @{@"subject":strTip,
                           @"total_fee":[NSString stringWithFormat:@"%f",strNeedPay.floatValue*100],
                           @"body":strTip,
                           @"type":strPayState,
                           @"pid":self.uID};
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
        }        [self.hudLoading hideAnimated:YES];
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

//用余额支付
-(void)btnTijiao_Click{
    //1.设置请求参数
    [self showLoadingHUDWithTitle:@"正在支付" SubTitle:nil];
    NSString *strPayState=@"";
    if ([state isEqualToString:@"1"]) {
        strPayState=@"3";
    }else if ([state isEqualToString:@"4"]){
        strPayState = @"4";
    }
    else{
        strPayState=@"2";
    }
    
    NSDictionary *dict = @{@"amount":[NSString stringWithFormat:@"%.2f",strNeedPay.floatValue*100],
                           @"type":strPayState,
                           @"uid":[Global sharedInstance].userID,
                           @"pid":self.uID};
    kPrintLog(dict);
    //    //2.开始请求
    HHttpRequest *request = [[HHttpRequest alloc] init];
    [request httpPostRequestWithActionName:@"changecoin" andPramater:dict andDidDataErrorBlock:^(NSURLSessionTask *operation, id responseObject) {
        kPrintLog(responseObject);
        [self.hudLoading hideAnimated:YES];
        ResultModel *result=[ResultModel mj_objectWithKeyValues:responseObject];
        [self showErrorHUDWithTitle:result.msg SubTitle:nil Complete:nil];
    } andDidRequestSuccessBlock:^(NSURLSessionTask *operation, id responseObject) {
        kPrintLog(responseObject);
        if ([[ArtUIHelper sharedInstance] alertSuccessWith:@"支付" obj:responseObject]){
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if ([_tjdd isEqualToString:@"tijiaodingdan"]) {// 提交订单页面进入
                    YTXOrderViewController *vc=[[YTXOrderViewController alloc]init];
                    vc.isgroup = model.isgroup;
                    vc.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:vc animated:YES];
                    return ;
                }else{
                    [self.navigationController popViewControllerAnimated:YES];
                }
            });
//            [self ZhifuSuccess];
        }else{
            NSString* msg = responseObject[@"msg"];
            if((msg.length>0)&&[msg rangeOfString:@"其它手机登录"].location!=NSNotFound){
                [self logonAgain];
            }
        }

        
        [self.hudLoading hideAnimated:YES];
    } andDidRequestFailedBlock:^(NSURLSessionTask *operation, NSError *error) {
        kPrintLog(error);
        [self.hudLoading hideAnimated:YES];
    }];
    
}

//支付成功
-(void)ZhifuSuccess{
    MyHomePageDockerVC *vc=[[MyHomePageDockerVC alloc]init];
    vc.navTitle=@"我";
    vc.artId=[Global sharedInstance].userID;
    [self.navigationController pushViewController:vc animated:YES];
}

//返回按钮点击事件
- (void) leftBarItem_Click
{
    if (!dicSave) {
        [self.navigationController popViewControllerAnimated:YES];
        return ;
    }
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:nil
                                  delegate:self
                                  cancelButtonTitle:@"取消"
                                  destructiveButtonTitle:@"删除"
                                  otherButtonTitles:@"保存草稿",nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [actionSheet showInView:self.view];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {//删除
        [self delecateData];
    }else if (buttonIndex == 1) {//保存草稿
        [self savaData];
    }
}

//删除数据
-(void)delecateData{
    //1.设置请求参数
    [self showLoadingHUDWithTitle:@"正在删除" SubTitle:nil];
    NSDictionary *dict = @{@"topicid":self.uID};
    //    //2.开始请求
    HHttpRequest *request = [[HHttpRequest alloc] init];
    [request httpPostRequestWithActionName:@"deltopic" andPramater:dict andDidDataErrorBlock:^(NSURLSessionTask *operation, id responseObject) {
        [self.hudLoading hideAnimated:YES];
        ResultModel *result=[ResultModel mj_objectWithKeyValues:responseObject];
        [self showErrorHUDWithTitle:result.msg SubTitle:nil Complete:nil];
    } andDidRequestSuccessBlock:^(NSURLSessionTask *operation, id responseObject) {
        [self.hudLoading hideAnimated:YES];
        [self.navigationController popToRootViewControllerAnimated:YES];
    } andDidRequestFailedBlock:^(NSURLSessionTask *operation, NSError *error) {
        [self.hudLoading hideAnimated:YES];
    }];
}

//保存数据
-(void)savaData{
    //1.设置请求参数
    NSMutableDictionary *dicAddTime=[dicSave mutableCopy];
    [dicAddTime setObject:[self getData] forKey:@"time"];
    NSDictionary *dicNow=[dicAddTime mutableCopy];
    [[Global sharedInstance]addCaoGao:dicNow];
    [self showOkHUDWithTitle:@"保存成功" SubTitle:nil Complete:^{
        [self.navigationController popToRootViewControllerAnimated:YES];
    }];
}

-(NSString *)getData{
    NSDate *  senddate=[NSDate date];
    
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    
    [dateformatter setDateFormat:@"YYYY-MM-dd HH:MM:SS"];
    
    return [dateformatter stringFromDate:senddate];
}


@end
