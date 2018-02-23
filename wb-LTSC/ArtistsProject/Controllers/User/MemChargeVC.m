//
//  PayNewVC.m
//  ShesheDa
//
//  Created by chen on 16/8/1.
//  Copyright © 2016年 上海翔汇网络有限公司. All rights reserved.
//

#import "MemChargeVC.h"
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

#define kBeilv   100

@interface MemChargeVC ()<UIActionSheetDelegate,UITextFieldDelegate>{
    HLabel *lblZhifuMoney,*lblYueMoney,*lblNeedPay;
    UserIndexVCItemView * viewComment,*viewRelease,*viewYuer;
    NSString *strNeedPay;
    NSString *strZhanghuYue;
    NSString *payType;
    UITextField *jine;
    UIScrollView *scroll;
}

@end

@implementation MemChargeVC
@synthesize money,state,dicSave;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"充值";
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.navigationController.navigationBar setTranslucent:NO];
    [self createSubView:self.scrollView];
//    [self loadData];
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

////加载用户信息
//- (void) loadData{
//    //1.设置请求参数
//    [self showLoadingHUDWithTitle:@"正在获取余额信息" SubTitle:nil];
//    //2.开始请求
//    NSDictionary *dicMoney=@{@"uid":[Global sharedInstance].userID};
//    HHttpRequest *request = [[HHttpRequest alloc] init];
//    [request httpPostRequestWithActionName:@"coininfo" andPramater:dicMoney andDidDataErrorBlock:^(NSURLSessionTask *operation, id responseObject) {
//        [self.hudLoading hideAnimated:YES];
//        ResultModel *result=[ResultModel mj_objectWithKeyValues:responseObject];
//        [self showErrorHUDWithTitle:result.msg SubTitle:nil Complete:nil];
//    } andDidRequestSuccessBlock:^(NSURLSessionTask *operation, id responseObject) {
//        strZhanghuYue=[NSString stringWithFormat:@"%.2f",[[responseObject objectForKey:@"coin"] floatValue]/100];
//        lblYueMoney.text=[NSString stringWithFormat:@"· 账户余额: %@",strZhanghuYue];
//        if (money.floatValue>strZhanghuYue.floatValue) {
//            //余额不足
//            viewYuer.hidden=YES;
//            [viewYuer mas_updateConstraints:^(MASConstraintMaker *make) {
//                make.height.mas_equalTo(1);
//            }];
//            lblNeedPay.text=[NSString stringWithFormat:@"· 还需支付: %.2f",money.floatValue-strZhanghuYue.floatValue];
//            strNeedPay=[NSString stringWithFormat:@"%.2f",money.floatValue-strZhanghuYue.floatValue];
//        }else{
//            //余额充足
//            
//            //            viewRelease.hidden=YES;
//            //            [viewRelease mas_updateConstraints:^(MASConstraintMaker *make) {
//            //                make.height.mas_equalTo(1);
//            //            }];
//            //
//            //            viewComment.hidden=YES;
//            //            [viewComment mas_updateConstraints:^(MASConstraintMaker *make) {
//            //                make.height.mas_equalTo(1);
//            //            }];
//            lblNeedPay.text=[NSString stringWithFormat:@"· 还需支付: %@元",money];
//            strNeedPay=money;
//        }
//        
//        [self.hudLoading hideAnimated:YES];
//    } andDidRequestFailedBlock:^(NSURLSessionTask *operation, NSError *error) {
//        [self.hudLoading hideAnimated:YES];
//    }];
//}

- (void)createSubView:(UIView*)contentView
{
    UIImageView *imgBG=[[UIImageView alloc]init];
    imgBG.image=[UIImage imageNamed:@"icon_payWallet_beijing.png"];
    [contentView addSubview:imgBG];
    imgBG.userInteractionEnabled = YES;
    [imgBG mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(contentView);
        make.height.mas_equalTo(kScreenW/3*2);
    }];
//    HView *viewImageBG=[[HView alloc]init];
//    viewImageBG.backgroundColor=ColorHexA(@"000000", 0.2);
//    [imgBG addSubview:viewImageBG];
//    [viewImageBG mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.equalTo(imgBG);
//        make.top.equalTo(imgBG).offset(kScreenW/6);
//        make.height.mas_equalTo(120);
//    }];
    
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor whiteColor];
    [imgBG addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(imgBG);
        make.centerY.equalTo(imgBG);
        make.height.mas_equalTo(50);
    }];
//     金额
    UILabel *title = [[UILabel alloc] init];
    title.text = @"金额 (元)";
    [view addSubview:title];
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view).offset(15);
        make.centerY.equalTo(view);
        make.width.mas_equalTo(70);
        make.height.mas_equalTo(50);
    }];
    jine = [[UITextField alloc] init];
    jine.text = @"5000";
    jine.delegate = self;
    [view addSubview:jine];
    [jine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(title).offset(80);
        make.centerY.equalTo(view);
        make.height.mas_equalTo(50);
        make.width.mas_equalTo(kScreenW - 50);
    }];
    UIButton *clear = [UIButton buttonWithType:(UIButtonTypeSystem)];
    [clear setImage:ImageNamed(@"login_clean_btn") forState:(UIControlStateNormal)];
    [clear addTarget:self action:@selector(clearBtn) forControlEvents:(UIControlEventTouchUpInside)];
    [view addSubview:clear];
    [clear mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(view).offset(-15);
        make.centerY.equalTo(view);
        make.height.width.mas_equalTo(20);
    }];
    
//    lblZhifuMoney=[[HLabel alloc]init];
//    lblZhifuMoney.textColor=kWhiteColor;
//    lblZhifuMoney.text=[NSString stringWithFormat:@"· 支付金额 : %@",money];
//    lblZhifuMoney.font=kFont(17);
//    lblZhifuMoney.textEdgeInsets=UIEdgeInsetsMake(0, 20, 0, 0);
//    
//    lblYueMoney=[[HLabel alloc]init];
//    lblYueMoney.textColor=kWhiteColor;
//    lblYueMoney.font=kFont(17);
//    lblYueMoney.textEdgeInsets=UIEdgeInsetsMake(0, 20, 0, 0);
//    
//    lblNeedPay=[[HLabel alloc]init];
//    lblNeedPay.textColor=kWhiteColor;
//    lblNeedPay.font=kFont(17);
//    lblNeedPay.textEdgeInsets=UIEdgeInsetsMake(0, 20, 0, 0);

    
    __weak typeof(self)weakSelf = self;
//    //我的支付
//    viewYuer = [UserIndexVCItemView new];
//    [contentView addSubview:viewYuer];
//    viewYuer.bottomLineWidth = 17;
//    [viewYuer mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(imgBG.mas_bottom);
//        make.left.and.right.equalTo(contentView);
//        make.height.mas_equalTo(45);
//    }];
//    viewYuer.imgIcon = @"icon_wallet_BG";
//    viewYuer.title = @"余额支付";
//    viewYuer.imgArrow = @"icon_UserIndexVC_rightArrow";
//    viewYuer.borderColor = kLineColor;
//    viewYuer.borderWidth=HViewBorderWidthMake(1, 0, 0, 0);
//    [viewYuer setDidTapBlock:^{
//        NSLog(@"我的点评");
//        [weakSelf btnTijiao_Click];
//    }];
    
    
    viewComment = [UserIndexVCItemView new];
    [contentView addSubview:viewComment];
    viewComment.bottomLineWidth = 17;
    [viewComment mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imgBG.mas_bottom);
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

- (void)clearBtn
{
    jine.text = @"";
}

//支付宝支付
-(void)payWithZhifubao{
    [self hideKeyBoard];
    if ([jine.text floatValue] == 0) {
        [self showErrorHUDWithTitle:@"请输入金额" SubTitle:nil Complete:nil];
        return;
    }
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
                           @"total_fee":[NSString stringWithFormat:@"%f",jine.text.floatValue*kBeilv],  // 将元转换为分
                           @"body":@"充值",
                           @"type":@"1",
                           @"pid":@"0"};
    kPrintLog(dict)
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
            kPrintLog(responseObject);
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

//支付成功
- (void)paySuccess{
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

- (void)payWithWechat{
    [self hideKeyBoard];
    if ([jine.text floatValue] == 0) {
        [self showErrorHUDWithTitle:@"请输入金额" SubTitle:nil Complete:nil];
        return;
    }
    NSString *strPayState=@"";
    NSString *strTip=@"";
    if ([state isEqualToString:@"1"]) {
        strPayState = @"3";
        strTip = @"鉴定费";
    }else if ([state isEqualToString:@"4"]){
        strPayState = @"4";
        strTip = @"购买商品费用";
    }else{
        strPayState=@"2";
        strTip=@"鉴定会报名费";
    }
    
    
    //1.设置请求参数
    [self showLoadingHUDWithTitle:@"正在获取微信信息" SubTitle:nil];
    NSDictionary *dict = @{@"subject":strTip,
                           @"total_fee":[NSString stringWithFormat:@"%f",jine.text.floatValue *kBeilv],
                           @"body":@"充值",
                           @"type":@"1",
                           @"pid":@"0"};
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

- (void)wxpayWithWxpayInfoModel:(WxpayInfoModel *)modelWechat{
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
    
    NSDictionary *dict = @{@"amount":[NSString stringWithFormat:@"%.2f",strNeedPay.floatValue],
                           @"type":strPayState,
                           @"pid":self.uID};
    //    //2.开始请求
    HHttpRequest *request = [[HHttpRequest alloc] init];
    [request httpPostRequestWithActionName:@"changecoin" andPramater:dict andDidDataErrorBlock:^(NSURLSessionTask *operation, id responseObject) {
        [self.hudLoading hideAnimated:YES];
        ResultModel *result=[ResultModel mj_objectWithKeyValues:responseObject];
        [self showErrorHUDWithTitle:result.msg SubTitle:nil Complete:nil];
    } andDidRequestSuccessBlock:^(NSURLSessionTask *operation, id responseObject) {
        if ([[ArtUIHelper sharedInstance] alertSuccessWith:@"支付" obj:responseObject]){
            [self ZhifuSuccess];
        }else{
            NSString* msg = responseObject[@"msg"];
            if((msg.length>0)&&[msg rangeOfString:@"其它手机登录"].location!=NSNotFound){
                [self logonAgain];
            }
        }
        [self.hudLoading hideAnimated:YES];
    } andDidRequestFailedBlock:^(NSURLSessionTask *operation, NSError *error) {
        [self.hudLoading hideAnimated:YES];
    }];
    
}

//支付成功
- (void)ZhifuSuccess{
    MyHomePageDockerVC *vc = [[MyHomePageDockerVC alloc]init];
    vc.navTitle = @"我";
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

- (NSString *)getData{
    NSDate *  senddate=[NSDate date];
    
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    
    [dateformatter setDateFormat:@"YYYY-MM-dd HH:MM:SS"];
    
    return [dateformatter stringFromDate:senddate];
}


@end
