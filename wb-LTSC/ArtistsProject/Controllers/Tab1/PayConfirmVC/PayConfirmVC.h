//
//  PayConfirmVC.h
//  Fruit
//
//  Created by HeLiulin on 15/8/21.
//  Copyright (c) 2015年 XICHUNZHAO. All rights reserved.
//

#import "HViewController.h"

@interface PayConfirmVC : HViewController
@property(nonatomic,copy) NSString *orderNo;
@property(nonatomic,copy) NSString *totalAmount;
@property(nonatomic,copy) NSString *payType;

@property (nonatomic, copy) void(^selectPaySuccess)();
@property (nonatomic, copy) void(^selectPayFailure)();

@end
