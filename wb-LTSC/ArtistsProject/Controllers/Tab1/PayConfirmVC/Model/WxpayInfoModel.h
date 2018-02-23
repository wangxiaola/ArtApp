//
//  WxpayModel.h
//  Fruit
//
//  Created by HeLiulin on 15/9/28.
//  Copyright © 2015年 上海翔汇网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WxpayInfoModel : NSObject
//服务器响应时间戳
@property (nonatomic,copy) NSString *timestamp;
//平台签名，请配合token验证签名
@property (nonatomic,copy) NSString *signature;
//错误码
@property (nonatomic,copy) NSString *errCode;
//错误信息
@property (nonatomic,copy) NSString *errMsg;


//
@property (nonatomic,copy) NSString *AppID;
//账号PID
@property (nonatomic,copy) NSString *partner;

@property (nonatomic,copy) NSString *prepay_id;
@property (nonatomic,copy) NSString *nonce_str;
@property (nonatomic,copy) NSString *sign;
@property (nonatomic,copy) NSString *TimeStamp;

//错误信息
@property (nonatomic,copy) NSString *appid;


//
@property (nonatomic,copy) NSString *noncestr;
//账号PID
@property (nonatomic,copy) NSString *package;

@property (nonatomic,copy) NSString *partnerid;
@property (nonatomic,copy) NSString *prepayid;

@end
