//
//  YTXOrderConfirmViewModel.h
//  ShesheDa
//
//  Created by Hongwei Chen on 2016/11/12.
//  Copyright © 2016年 北京艺天下文化科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@class YTXGoodsModel;
@class YTXAddressModel;

@interface YTXOrderConfirmViewModel : NSObject

@property (nonatomic, copy) NSString * name;//名称
@property (nonatomic, copy) NSString * phone;//电话
@property (nonatomic, copy) NSString * address;//地址
@property (nonatomic, strong) NSURL  * imageURL;//商品图片
@property (nonatomic, copy) NSString * goodsName;//商品名称
@property (nonatomic, copy) NSString * price;//商品价格
@property (nonatomic, copy) NSString * buyCount;//购买数量
@property (nonatomic, copy) NSString * freight;//运费
@property (nonatomic, copy) NSString * totalPrice;//总价格
@property (nonatomic, copy) NSString * stock;//库存

+ (instancetype)modelWithGoodsModel:(YTXGoodsModel *)goodsModel
                       addressModel:(YTXAddressModel *)addressModel;
@end
