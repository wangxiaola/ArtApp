//
//  YTXOrderViewModel.m
//  ShesheDa
//
//  Created by Hongwei Chen on 2016/11/14.
//  Copyright © 2016年 北京艺天下文化科技有限公司. All rights reserved.
//

#import "YTXOrderViewModel.h"
#import "NSString+YTXAdd.h"

@implementation YTXOrderViewModel

+ (instancetype)modelWithOrderModel:(YTXOrderModel *)orderModel {
    YTXOrderViewModel * model = [[YTXOrderViewModel alloc]init];
    model.type = orderModel.type;
    model.imageURL = [NSURL URLWithString:[orderModel.goods.photos componentsSeparatedByString:@","].firstObject];
    model.createTime = [orderModel.addtime stringWithFormat:@"yyyy-MM-dd HH:mm:ss"];
    model.goodsName = orderModel.goods_name;
    model.orderID = orderModel.orderid;
    model.price = orderModel.allcoin;
    model.pinglun = orderModel.pinglun.message;
    model.huiping = orderModel.huiping.message;
    model.zhuiping = orderModel.zhuiping.message;
    model.phone = orderModel.phone;
    model.address = orderModel.addr;
    model.score = orderModel.huiping.score;
    model.yunfei = orderModel.yunfei;
    model.goods = orderModel.goods;
    model.replyuid = orderModel.huiping.cid;
    model.photo = orderModel.photo;
    model.rectime = orderModel.rectime;
    model.sendtime = orderModel.sendtime;
    model.payTime = orderModel.paytime;
    model.reason = orderModel.cancelinfo;// 取消订单
    model.expname = orderModel.expname;
    model.expnum = orderModel.expnum;
    model.status = orderModel.status;
    if ([orderModel.type isEqualToString:@"2"]) {//买入
        if ([orderModel.status isEqualToString:@"0"]) {//未支付
            model.firstBtnName = @"去支付";
            model.firBtnColor = ColorHex(@"9BCE5F");
            model.SecondBtnName = @"取消订单";
            model.secondBtnColor = ColorHex(@"999999");
        } else if ([orderModel.status isEqualToString:@"-1"]){
            model.firstBtnName = @"已取消";
            model.firBtnColor = ColorHex(@"999999");
//            model.SecondBtnName = @"已取消";
//            model.secondBtnColor = ColorHex(@"999999");
        }
        else if ([orderModel.status isEqualToString:@"1"] ){
            model.firstBtnName = @"待发货";
            model.firBtnColor = ColorHex(@"9BCE5F");
            model.SecondBtnName = @"取消订单";
            model.secondBtnColor = ColorHex(@"999999");
        }else if ([orderModel.status isEqualToString:@"2"]){
            model.firstBtnName = @"确认收货";
            model.firBtnColor = ColorHex(@"9BCE5F");
            //            model.SecondBtnName = @"已取消";
            //            model.secondBtnColor = ColorHex(@"999999");
        }else if ([orderModel.status isEqualToString:@"3"]){
            model.firstBtnName = @"追评";
            model.firBtnColor = ColorHex(@"9BCE5F");
//            model.SecondBtnName = @"申请售后";
//            model.secondBtnColor = ColorHex(@"999999");
        }else if([orderModel.status isEqualToString:@"5"]){
            model.firstBtnName = @"追评";
            model.firBtnColor = ColorHex(@"9BCE5F");
//            model.SecondBtnName = @"申请售后";
//            model.secondBtnColor = ColorHex(@"999999");
        }else if ([orderModel.status isEqualToString:@"6"]||[orderModel.status isEqualToString:@"4"]){
            model.firstBtnName = @"完成";
            model.firBtnColor = ColorHex(@"999999");
//            model.SecondBtnName = @"申请售后";
//            model.secondBtnColor = ColorHex(@"999999");
        }
        model.shopName = [NSString stringWithFormat:@"卖家:%@",orderModel.consignee];
    } else {//卖出
        if ([orderModel.status isEqualToString:@"0"]) {//未支付
            model.firstBtnName = @"待支付";
            model.firBtnColor = ColorHex(@"999999");
        }else if ([orderModel.status isEqualToString:@"-1"]){
            model.firstBtnName = @"已取消";
            model.firBtnColor = ColorHex(@"999999");
            // model.SecondBtnName = @"已取消";
            // model.secondBtnColor = ColorHex(@"999999");
        }else if ([orderModel.status isEqualToString:@"1"]) {//未发货
            model.firstBtnName = @"发货";
            model.firBtnColor = ColorHex(@"9BCE5F");
            model.SecondBtnName = @"取消订单";
            model.secondBtnColor = ColorHex(@"999999");
        } else if ([orderModel.status isEqualToString:@"2"]){// 未收货
            model.firstBtnName = @"待买家确认";
            model.firBtnColor = ColorHex(@"999999");
//            model.SecondBtnName = @"处理售后";
//            model.secondBtnColor = ColorHex(@"999999");
        }else if ([orderModel.status isEqualToString:@"3"]){// 未收货
            model.firstBtnName = @"回评";
            model.firBtnColor = ColorHex(@"9BCE5F");
//            model.SecondBtnName = @"处理售后";
//            model.secondBtnColor = ColorHex(@"999999");
        }else if ([orderModel.status isEqualToString:@"5"]){// 未收货
            model.firstBtnName = @"回评";
            model.firBtnColor = ColorHex(@"9BCE5F");
            // model.SecondBtnName = @"处理售后";
            // model.secondBtnColor = ColorHex(@"999999");
        } else if ([orderModel.status isEqualToString:@"6"]||[orderModel.status isEqualToString:@"4"]){ // 售后富强
            model.firstBtnName = @"完成";
            model.firBtnColor = ColorHex(@"999999");
//            model.SecondBtnName = @"处理售后";
//            model.secondBtnColor = ColorHex(@"9BCE5F");
        }
        model.shopName = [NSString stringWithFormat:@"买家:%@",orderModel.consignee];
    }
    return model;
}

@end
