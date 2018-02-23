//
//  SellVC.h
//  ArtistsProject
//
//  Created by 黄兵 on 2017/7/19.
//  Copyright © 2017年 HELLO WORLD. All rights reserved.
//

#import "ScrollViewController.h"
#import "GoodsCategoryModel.h"


@interface SellVC : ScrollViewController

@property (nonatomic, strong)NSArray<GoodsCategoryModel *> *goodsCategorys;
@property (nonatomic, copy)NSString *gtype;
// 搜索分类
@property (nonatomic, copy) NSString *searchText;
// 会员
@property (nonatomic, copy) NSString *huiyuan;
@end
