//
//  ResultModel.h
//  Car
//
//  Created by HeLiulin on 15/8/9.
//  Copyright (c) 上海翔汇网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ResultModel : NSObject
//服务器响应时间戳
@property (nonatomic,copy) NSString *timestamp;
//平台签名，请配合token验证签名
@property (nonatomic,copy) NSString *signature;
//错误码
@property (nonatomic,copy) NSString *errCode;
//错误信息
@property (nonatomic,copy) NSString *errMsg;

@property (nonatomic,strong) NSDictionary *data;
@property (nonatomic,copy) NSString *result;
@property (nonatomic,copy) NSString *msg;
@end
