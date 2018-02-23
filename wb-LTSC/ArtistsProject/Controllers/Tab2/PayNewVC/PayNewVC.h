//
//  PayNewVC.h
//  ShesheDa
//
//  Created by chen on 16/8/1.
//  Copyright © 2016年 上海翔汇网络有限公司. All rights reserved.
//

#import "HScrollViewController.h"

@interface PayNewVC : HScrollViewController

@property(strong,nonatomic)NSString *money;

@property(strong,nonatomic)NSString *uID;//购买商品是传入orderid

@property(strong,nonatomic)NSDictionary *dicSave;

//为1时为 鉴定费  为4 时为商品支付  其他为鉴定会报名费
@property(strong,nonatomic)NSString *state;

//
@property (nonatomic, copy) NSString *tjdd;// 提交订单
@end
