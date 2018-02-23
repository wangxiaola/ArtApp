//
//  AlipayInfoModel.h
//  Car
//
//  Created by HeLiulin on 15/8/19.
//  Copyright (c) 上海翔汇网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AlipayInfoDetailModel : NSObject

//服务器响应时间戳
@property (nonatomic,copy) NSString *partner;
//平台签名，请配合token验证签名
@property (nonatomic,copy) NSString *seller_id;
//错误码
@property (nonatomic,copy) NSString *out_trade_no;
//错误信息
@property (nonatomic,copy) NSString *subject;
@property (nonatomic,copy) NSString *body;
@property (nonatomic,copy) NSString *total_fee;
@property (nonatomic,copy) NSString *notify_url;
@property (nonatomic,copy) NSString *service;
@property (nonatomic,copy) NSString *payment_type;
@property (nonatomic,copy) NSString *_input_charset;
@property (nonatomic,copy) NSString *it_b_pay;
//支付宝私钥
@property (nonatomic,copy) NSString *privateKey;

@end

@interface AlipayInfoModel : NSObject
//服务器响应时间戳
@property (nonatomic,copy) NSString *timestamp;
//平台签名，请配合token验证签名
@property (nonatomic,copy) NSString *signature;
//错误码
@property (nonatomic,copy) NSString *errCode;
//错误信息
@property (nonatomic,copy) NSString *errMsg;


//支付宝私钥
@property (nonatomic,copy) NSString *privateKey;

//支付宝PID （商户ID）
@property (nonatomic,copy) NSString *partner;

//支付宝账号  （账号）
@property (nonatomic,copy) NSString *seller;

//回调地址
@property (nonatomic,strong) AlipayInfoDetailModel *data;

@property (nonatomic,copy) NSString *params;

//回调地址
@property (nonatomic,copy) NSString *sign;
@end
