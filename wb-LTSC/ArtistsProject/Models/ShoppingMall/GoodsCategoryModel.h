//
//  GoodsCategory.h
//  ArtistsProject
//
//  Created by 大锅 on 2017/6/10.
//  Copyright © 2017年 HELLO WORLD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GoodsCategoryModel : NSObject

@property (nonatomic, copy)NSString *goods_id;
@property (nonatomic, copy) NSString *cname;
@property (nonatomic, copy)NSString *title;
@property (nonatomic, copy)NSString *pid;
@property (nonatomic, copy)NSString *sort;
@property (nonatomic, copy)NSString *imgurl;
@property (nonatomic, strong)NSArray <GoodsCategoryModel *> *child;

@end
