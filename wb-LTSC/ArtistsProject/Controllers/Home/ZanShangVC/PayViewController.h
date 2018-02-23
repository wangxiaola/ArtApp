//
//  PayViewController.h
//  ArtistsProject
//
//  Created by HELLO WORLD on 2017/4/22.
//  Copyright © 2017年 HELLO WORLD. All rights reserved.
//

#import "RootViewController.h"

@class HomeListDetailVc;
@interface PayViewController : RootViewController
@property(nonatomic,copy)NSString* whichControl;

@property(nonatomic,copy)NSString* money;//支付金额

@property(nonatomic,copy)NSString* payId;
//支付类型对应的id，type=2时传报名的活动id，type=3时传发布的鉴定动态id,type=1时传0，type=4时传商品下单接口返回的订单id，
@property(strong,nonatomic)NSString *type;//支付类型 1-充值 2-报名 3-发布鉴定 4-购买商品 5-打赏
@end
