//
//  PayConfirmVC.m
//  Fruit
//
//  Created by HeLiulin on 15/8/21.
//  Copyright (c) 2015年 XICHUNZHAO. All rights reserved.
//

#import "PayConfirmVC.h"
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
//#import "OrderDetailVC.h"
//#import "OrderDataModel.h"
//#import "CFDetailVC.h"

@interface PayConfirmVC ()
{
//    OrderDataModel *orderModel;
}

@property (nonatomic, strong) UIView* viewSuccess;
@property (nonatomic, strong) UIView* viewFailed;

@end

@implementation PayConfirmVC
@synthesize viewSuccess,viewFailed;

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSArray *array = [[UIApplication sharedApplication] windows];
    
    UIWindow* win=[array objectAtIndex:0];
    
    [win setHidden:YES];
//    NSMutableArray *vcs=[[NSMutableArray alloc] initWithArray:self.navigationController.viewControllers];
//    if([vcs[vcs.count-2] isKindOfClass:[OrderComfireVC class]]){
//        [vcs removeObjectAtIndex:vcs.count-2];
//        
//        self.navigationController.viewControllers=vcs;
//    }
    
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if ([self.payType isEqualToString:@"1"]){//支付宝支付
        [self loadAlipayInfo];//调用支付宝接口
        
        //test
//        DriveReviewsVC *vc=[[DriveReviewsVC alloc] init];
//        vc.orderNo=self.orderNo;
//        [self.navigationController pushViewController:vc animated:YES];
        
    }
    if ([self.payType isEqualToString:@"2"]){
        [self loadWxpayInfo]; //调用微信支付接口
    }

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title=@"支付确认";
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self createView];
//    NSMutableArray *lstVC=[[NSMutableArray alloc] initWithArray:self.navigationController.viewControllers];
//    [lstVC removeObjectAtIndex:lstVC.count-2];
//    self.navigationController.viewControllers=lstVC;
    [self loadOrderData];
    //监听微信支付
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(wxPayNotification:) name:@"WX_PAY_NOTIFICATION" object:nil];
}
/**
 *  画面初始化
 */
- (void) createView
{
    HLabel* lblTitle = [HLabel new];
    [self.view addSubview:lblTitle];
    [lblTitle mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.equalTo(self.view).offset(30);
        make.left.and.right.equalTo(self.view);
    }];
    lblTitle.text = @"应付金额(元)";
    [lblTitle setTextColor:kSubTitleColor];
    [lblTitle setTextAlignment:NSTextAlignmentCenter];

    HLabel* lblAmount = [HLabel new];
    [self.view addSubview:lblAmount];
    [lblAmount mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.equalTo(lblTitle.mas_bottom).offset(10);
        make.centerX.equalTo(self.view);
    }];
    [lblAmount setFont:[UIFont systemFontOfSize:30]];
    [lblAmount setTextColor:kPriceColor];
    lblAmount.text = self.totalAmount;

    //名称下面的横线
    HLine* line1 = [HLine new];
    [self.view addSubview:line1];
    [line1 mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.equalTo(lblAmount.mas_bottom).offset(30);
        make.left.and.right.equalTo(self.view);
        make.height.mas_equalTo(1);
    }];
    line1.lineColor = kLineColor;
    line1.lineStyle = UILineStyleVertical;
    line1.lineWidth = 1;

    HLine* line2 = [HLine new];
    [self.view addSubview:line2];
    [line2 mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.equalTo(line1.mas_bottom);
        make.centerX.equalTo(self.view);
        make.height.mas_equalTo(100);
        make.width.mas_equalTo(1);
    }];
    line2.lineColor = kLineColor;
    line2.lineStyle = UILineStyleHorizon;
    line2.lineWidth = 1;

    viewSuccess = [UIView new];
    [self.view addSubview:viewSuccess];
    [viewSuccess mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.equalTo(line1.mas_bottom);
        make.left.equalTo(self.view);
        make.right.equalTo(line2.mas_left);
        make.bottom.equalTo(line2);
    }];
    HLabel* lblSuccess = [HLabel new];
    [viewSuccess addSubview:lblSuccess];
    [lblSuccess mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.and.right.equalTo(viewSuccess);
        make.bottom.equalTo(viewSuccess.mas_centerY);
    }];
    lblSuccess.text = @"已完成支付";
    [lblSuccess setTextColor:kTitleColor];
    [lblSuccess setTextAlignment:NSTextAlignmentCenter];
    [lblSuccess setFont:[UIFont systemFontOfSize:18]];

    HButton* btnReview = [HButton new];
    [viewSuccess addSubview:btnReview];
    [btnReview mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.and.right.equalTo(viewSuccess);
        make.top.equalTo(viewSuccess.mas_centerY);
    }];
    [btnReview setTitle:@"查看订单详情" forState:UIControlStateNormal];
    [btnReview setTitleColor:kBlueColor forState:UIControlStateNormal];
    [btnReview.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [btnReview.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [btnReview addTarget:self action:@selector(btnReview_Click) forControlEvents:UIControlEventTouchUpInside];

    viewFailed = [UIView new];
    [self.view addSubview:viewFailed];
    [viewFailed mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.equalTo(line1.mas_bottom);
        make.left.equalTo(line2.mas_right);
        make.right.equalTo(self.view);
        make.bottom.equalTo(line2);
    }];
    [viewFailed setBackgroundColor:Color(174, 221, 247, 0.5)];

    HLabel* lblFailed = [HLabel new];
    [viewFailed addSubview:lblFailed];
    [lblFailed mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.and.right.equalTo(viewFailed);
        make.bottom.equalTo(viewFailed.mas_centerY);
    }];
    lblFailed.text = @"支付遇到问题";
    [lblFailed setTextColor:kTitleColor];
    [lblFailed setTextAlignment:NSTextAlignmentCenter];
    [lblFailed setFont:[UIFont systemFontOfSize:18]];

    HButton* btnChoosePayment = [HButton new];
    [viewFailed addSubview:btnChoosePayment];
    [btnChoosePayment mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.and.right.equalTo(viewFailed);
        make.top.equalTo(viewFailed.mas_centerY);
    }];
    [btnChoosePayment setTitle:@"修改支付方式" forState:UIControlStateNormal];
    [btnChoosePayment setTitleColor:kBlueColor forState:UIControlStateNormal];
    [btnChoosePayment.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [btnChoosePayment.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [btnChoosePayment addTarget:self action:@selector(btnChoosePayment_Click) forControlEvents:UIControlEventTouchUpInside];

    HLine* line3 = [HLine new];
    [self.view addSubview:line3];
    [line3 mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.equalTo(line2.mas_bottom);
        make.left.and.right.equalTo(self.view);
        make.height.mas_equalTo(1);
    }];
    line3.lineColor = kLineColor;
    line3.lineStyle = UILineStyleVertical;
    line3.lineWidth = 1;
}

///获取数据
- (void) loadOrderData
{
//    NSDictionary* dic = @{ @"orderNo" : self.orderNo,
//                           @"userID":[Global sharedInstance].userID?:@"0"};
//    [self showLoadingHUDWithTitle:@"正在获取数据..." SubTitle:nil];
//    HHttpRequest* request = [HHttpRequest new];
//    [request httpRequestWithModuleName:@"TOrder"
//                         andActionName:@"getTOrderByOrderNo"
//                           andPramater:dic
//                  andDidDataErrorBlock:^(AFHTTPRequestOperation* operation, id responseObject) {
//                      [self.hudLoading hide:YES];
//                      ResultModel* result = [ResultModel objectWithKeyValues:responseObject];
//                      [self showErrorHUDWithTitle:result.errMsg SubTitle:nil Complete:nil];
//                  }
//             andDidRequestSuccessBlock:^(AFHTTPRequestOperation* operation, id responseObject) {
//                 [self.hudLoading hide:YES];
////                orderModel=[OrderDataModel objectWithKeyValues:responseObject[@"data"]];
//                 
//             }
//              andDidRequestFailedBlock:^(AFHTTPRequestOperation* operation, NSError* error) {
//                  [self.hudLoading hide:YES];
//              }];
    
}

#pragma mark - 支付宝支付
/**
 *  获取支付宝支付接口信息
 */
- (void) loadAlipayInfo
{
//    [self showLoadingHUDWithTitle:@"正在获取支付接口信息，请稍候..." SubTitle:nil];
//    HHttpRequest* request = [HHttpRequest new];
//    [request httpRequestWithModuleName:@"TPayApi"
//        andActionName:@"getPayInfo"
//        andPramater:@{@"type":@"1"}
//        andDidDataErrorBlock:^(AFHTTPRequestOperation* operation, id responseObject) {
//            [self.hudLoading hide:YES];
//            AlipayInfoModel* result = [AlipayInfoModel objectWithKeyValues:responseObject];
//            [self showErrorHUDWithTitle:result.errMsg SubTitle:nil Complete:nil];
//            return;
//        }
//        andDidRequestSuccessBlock:^(AFHTTPRequestOperation* operation, id responseObject) {
//            [self.hudLoading hide:YES];
//            AlipayInfoModel* result = [AlipayInfoModel objectWithKeyValues:responseObject];
//            [self alipay:result];
//        }
//        andDidRequestFailedBlock:^(AFHTTPRequestOperation* operation, NSError* error) {
//            [self.hudLoading hide:YES];
//        }];
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
    AlipayOrder* order = [[AlipayOrder alloc] init];
    order.partner = [DESEncryption decryptUseDES:model.partner key:kPayKey];
    order.seller = [DESEncryption decryptUseDES:model.seller key:kPayKey];
    //订单ID（由商家自行制定）
    order.tradeNO = self.orderNo;
    //商品标题
    order.productName = @"奢奢哒订单";
    //商品描述
    order.productDescription = @"奢奢哒订单";
    //商品价格
    order.amount = self.totalAmount;
    //回调URL2
//    order.notifyURL = model.notifyurl;

    order.service = @"mobile.securitypay.pay";
    order.paymentType = @"1";
    order.inputCharset = @"utf-8";
    order.itBPay = @"30m";
    order.showUrl = @"m.alipay.com";

    //应用注册scheme,在Info.plist定义URL types
    NSString* appScheme = @"WebxhShesheDa";

    //将商品信息拼接成字符串
    NSString* orderSpec = [order description];
    NSLog(@"orderSpec = %@", orderSpec);

    //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
    id<DataSigner> signer = CreateRSADataSigner(model.privateKey);
    NSString* signedString = [signer signString:orderSpec];
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
                                orderSpec, signedString, @"RSA"];

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
                                            [self payFailure];
                                        }
                                    }];
    }else{
        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                       orderSpec, signedString, @"RSA"];
        
        [[AlipaySDK defaultService] payOrder:orderString
                                  fromScheme:appScheme
                                    callback:^(NSDictionary* resultDic) {
                                        if ([[resultDic objectForKey:@"resultStatus"] isEqualToString:@"9000"]
                                                                                     && [[resultDic objectForKey:@"result"] rangeOfString:@"success=\"true\""].length > 0) {
                                            [self paySuccess];
                                        }else{
                                            [self payFailure];
                                        }
                                    }];
    }
}

//- (void) paySuccess
//{
//    [self showLoadingHUDWithTitle:@"正在更新订单状态，请稍候..." SubTitle:nil];
//    HHttpRequest *request=[HHttpRequest new];
//    [request httpRequestWithModuleName:@"TOrder" andActionName:@"complete" andPramater:@{@"orderNo":self.orderNo} andDidDataErrorBlock:^(AFHTTPRequestOperation *operation, id responseObject) {
//        ResultModel *result=[ResultModel objectWithKeyValues:responseObject];
//        [self showErrorHUDWithTitle:result.errMsg SubTitle:nil];
//        return;
//    } andDidRequestSuccessBlock:^(AFHTTPRequestOperation *operation, id responseObject) {
//        [self showOkHUDNotAutoHideWithTitle:@"支付成功" SubTitle:nil];
//        [self._HUD showAnimated:YES whileExecutingBlock:^{
//            sleep(1);
//        } completionBlock:^{
//            DriveReviewsVC *vc=[[DriveReviewsVC alloc] init];
//            vc.orderNo=self.orderNo;
//            [self.navigationController pushViewController:vc animated:YES];
//        }];
//    } andDidRequestFailedBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
//        [self showErrorHUDWithTitle:kNetworkErrorMsg SubTitle:nil];
//    }];
//
//}

#pragma mark - 微信支付
/**
 *  获取微信支付接口信息
 */
- (void) loadWxpayInfo
{
//    NSDictionary* dict = @{ @"type" : @"2",
//                            @"orderNo" : self.orderNo };
//
//    [self showLoadingHUDWithTitle:@"正在获取支付接口信息，请稍候..." SubTitle:nil];
//    HHttpRequest* request = [HHttpRequest new];
//    [request httpRequestWithModuleName:@"TPayApi"
//        andActionName:@"getPayInfo"
//        andPramater:dict
//        andDidDataErrorBlock:^(AFHTTPRequestOperation* operation, id responseObject) {
//            [self.hudLoading hide:YES];
//            ResultModel* result = [ResultModel objectWithKeyValues:responseObject];
//            [self showErrorHUDWithTitle:result.errMsg SubTitle:nil Complete:nil];
//            return;
//        }
//        andDidRequestSuccessBlock:^(AFHTTPRequestOperation* operation, id responseObject) {
//            [self.hudLoading hide:YES];
//            WxpayInfoModel* result = [WxpayInfoModel objectWithKeyValues:responseObject];
//            [self wxpayWithWxpayInfoModel:result];
//        }
//        andDidRequestFailedBlock:^(AFHTTPRequestOperation* operation, NSError* error) {
//            [self.hudLoading hide:YES];
//        }];
}

/**
 *  发起微信支付
 *
 *  @param model 微信支付信息
 */
- (void) wxpayWithWxpayInfoModel:(WxpayInfoModel*)model
{
    PayReq* req = [[PayReq alloc] init];
    req.partnerId = model.partner;
    req.prepayId = model.prepay_id;
    req.package = @"Sign=WXPay";
    req.nonceStr = model.nonce_str;
    req.timeStamp = [model.TimeStamp intValue];
    req.sign = model.sign;
    [WXApi sendReq:req];
}
/**
 *  微信支付成功处理
 */
- (void)wxPayNotification:(NSNotification*)text
{
    NSLog(@"－－－－－接收到通知------");
    NSLog(@"%@", text.userInfo[@"payResult"]);
    if ([text.userInfo[@"payResult"] isEqualToString:@"success"]) {
        [self paySuccess];
    }else{
        [self payFailure];
    }
     [[NSNotificationCenter defaultCenter] removeObserver:self name:@"WX_PAY_NOTIFICATION" object:nil];
}

//付款失败
-(void)payFailure{
    if (self.selectPayFailure) {
        self.selectPayFailure();
    }
}

- (void)paySuccess
{
    //订单状态设定成功
    [viewSuccess setBackgroundColor:Color(174, 221, 247, 0.5)];
    [viewFailed setBackgroundColor:[UIColor whiteColor]];
    viewFailed.userInteractionEnabled = NO;
    
    if (self.selectPaySuccess) {
        self.selectPaySuccess();
    }
//    NSMutableArray* vcs = [[NSMutableArray alloc] initWithArray:self.navigationController.viewControllers];
//    [vcs removeObjectAtIndex:vcs.count - 2];
//    self.navigationController.viewControllers = vcs;
}
#pragma mark - 事件
/**
 *  查看订单详情
 */
- (void) btnReview_Click
{
//    NSMutableArray* vcs = [[NSMutableArray alloc] initWithArray:self.navigationController.viewControllers];
//    [vcs removeObjectAtIndex:vcs.count - 2];
//    self.navigationController.viewControllers = vcs;
//    [self.navigationController popViewControllerAnimated:YES];
    
//    NSMutableArray *vcs=[[NSMutableArray alloc] initWithArray:self.navigationController.viewControllers];
//    if (orderModel&&[orderModel.crowdfunding isEqualToString:@"1"]){
//        if(![vcs[vcs.count-2] isKindOfClass:[CFDetailVC class]]){
//            CFDetailVC *vc=[[CFDetailVC alloc] init];
//            vc.orderNo=self.orderNo;
//            [vcs insertObject:vc atIndex:vcs.count-1];
//            self.navigationController.viewControllers=vcs;
//        }
//    }else{
//        if(![vcs[vcs.count-2] isKindOfClass:[OrderDetailVC class]]){
//            
//            OrderDetailVC *vc=[[OrderDetailVC alloc] init];
//            vc.orderNo=self.orderNo;
//            [vcs insertObject:vc atIndex:vcs.count-1];
//            self.navigationController.viewControllers=vcs;
//        }
//    }
//    [self.navigationController popViewControllerAnimated:YES];
}
/**
 *  选择支付方式
 */
- (void) btnChoosePayment_Click
{
//    PayTypeChoiceVC *vc=[[PayTypeChoiceVC alloc] init];
//    [vc setDidFinishSelectBlock:^(PayTypeInfoModel *payTypeModel) {
//        self.payType=payTypeModel.paymentTerms;
//    }];
//    [self.navigationController pushViewController:vc animated:YES];
}
@end
