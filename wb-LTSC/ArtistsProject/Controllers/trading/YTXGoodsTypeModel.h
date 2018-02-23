//
//  YTXGoodsTypeModel.h
//  ShesheDa
//
//  Created by Hongwei Chen on 2016/11/9.
//  Copyright © 2016年 北京艺天下文化科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YTXGoodsTypeModel : NSObject<YYModel>

@property (nonatomic, copy) NSString * goods_id;

@property (nonatomic, copy) NSString * title;

@property (nonatomic, copy) NSString * pid;

@property (nonatomic, copy) NSString * sort;

@property (nonatomic, strong) NSArray * child;

@end
