//
//  YTXGoodsViewModel.h
//  ShesheDa
//
//  Created by Hongwei Chen on 2016/11/9.
//  Copyright © 2016年 北京艺天下文化科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YTXGoodsModel.h"

@interface YTXGoodsViewModel : NSObject

@property (nonatomic, copy) NSURL * goodsImageURL;

@property (nonatomic, copy) NSString * gid;

+ (instancetype)modelWithGoodsModel:(YTXGoodsModel *)goodsModel;

@end
