//
//  YTXOrderViewModel.h
//  ShesheDa
//
//  Created by Hongwei Chen on 2016/11/14.
//  Copyright © 2016年 北京艺天下文化科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YTXOrderModel.h"

@interface YTXOrderViewModel : NSObject

@property (nonatomic, copy) NSString *type; // 卖家和买家
@property (nonatomic, strong) NSURL * imageURL;
@property (nonatomic, copy) NSString * createTime;//下单时间
@property (nonatomic, copy) NSString * payTime;//支付时间
@property (nonatomic, copy) NSString * rectime;//收货时间
@property (nonatomic, copy) NSString * sendtime;//发货时间
@property (nonatomic, copy) NSString * orderID;
@property (nonatomic, copy) NSString * goodsName;
@property (nonatomic, copy) NSString * shopName;//对方名称
@property (nonatomic, copy) NSString * firstBtnName;
@property (nonatomic, copy) NSString * SecondBtnName;
@property (nonatomic, strong) UIColor * firBtnColor;
@property (nonatomic, strong) UIColor * secondBtnColor;
@property (nonatomic, copy) NSString * price;
@property (nonatomic, copy) NSString * pinglun;//买家评论
@property (nonatomic, copy) NSString * huiping;//卖家回评
@property (nonatomic, copy) NSString * zhuiping;//买家追评
@property (nonatomic, copy) NSString * phone;//对方手机
@property (nonatomic, copy) NSString * address;//对方地址
@property (nonatomic, copy) NSString * score;//评分
@property (nonatomic, copy) NSString * replyuid;// 回评id
@property (nonatomic, copy) NSString * yunfei;
@property (nonatomic, copy) NSString *reason;// 取消订单
@property (nonatomic, copy) NSString *expname;// 快递公司
@property (nonatomic, copy) NSString *expnum;// 快递单号
@property (nonatomic, copy) NSString *status;// 状态
// 图片
@property (nonatomic, copy) NSString *photo;
@property (nonatomic, strong) YTXGoodsModel * goods;

+ (instancetype)modelWithOrderModel:(YTXOrderModel *)orderModel;

@end
