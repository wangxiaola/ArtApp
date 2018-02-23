//
//  YTXOrderModel.h
//  ShesheDa
//
//  Created by Hongwei Chen on 2016/11/14.
//  Copyright © 2016年 北京艺天下文化科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YTXGoodsModel.h"
#import "YTXHuiPingOrderModel.h"

@interface YTXOrderModel : NSObject<YYModel>

@property (nonatomic, copy) NSString * orderid;
@property (nonatomic, copy) NSString * goods_id;
@property (nonatomic, copy) NSString * goods_name;
@property (nonatomic, copy) NSString * count;
@property (nonatomic, copy) NSString * allcoin;
@property (nonatomic, copy) NSString * uid;
@property (nonatomic, copy) NSString * yunfei;
@property (nonatomic, copy) NSString * consignee;
@property (nonatomic, copy) NSString * phone;
@property (nonatomic, copy) NSString * addr;
@property (nonatomic, copy) NSString * addtime;
@property (nonatomic, copy) NSString * status;
@property (nonatomic, copy) NSString * type;
@property (nonatomic, copy) NSString * maiuid;
@property (nonatomic, copy) NSString * expressid;
@property (nonatomic, copy) NSString * photo;
@property (nonatomic, copy) NSString * paytime;
@property (nonatomic, copy) NSString * sendtime;
@property (nonatomic, copy) NSString * rectime;
@property (nonatomic, copy) NSString * expname;
@property (nonatomic, copy) NSString * expnum;
@property (nonatomic, copy) NSString * canceluid;
@property (nonatomic, copy) NSString * cancelinfo;
@property (nonatomic, copy) NSString * score;
@property (nonatomic, copy) NSString *replyuid;

//@property (nonatomic, copy) NSString * pinglun;
//@property (nonatomic, copy) NSString * huiping;
@property (nonatomic, strong) YTXHuiPingOrderModel * zhuiping;
@property (nonatomic, strong) YTXHuiPingOrderModel * pinglun;
@property (nonatomic, strong) YTXUser * user;
@property (nonatomic, strong) YTXUser * seller;
@property (nonatomic, strong) YTXGoodsModel * goods;
@property (nonatomic, strong) YTXHuiPingOrderModel *huiping;
@end
