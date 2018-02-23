//
//  NSString+Check.h
//  Car
//
//  Created by XICHUNZHAO on 15/9/10.
//  Copyright (c) 2015年 上海翔汇网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString(Check)

//简单判断手机号格式
-(BOOL)checkPhoneNumSimple;
-(BOOL)checkPhoneNumComplex;
-(BOOL)checkIsEmpty;//检查是否为空
-(BOOL)checkValidateEmail;//检查邮箱格式是否正确
-(BOOL)checkIDCardNumberComplex;//检查身份证号码
@end
