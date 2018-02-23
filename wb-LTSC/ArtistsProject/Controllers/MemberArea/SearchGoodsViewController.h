//
//  SearchGoodsViewController.h
//  ArtistsProject
//
//  Created by 大锅 on 2017/6/12.
//  Copyright © 2017年 HELLO WORLD. All rights reserved.
//

#import "BaseController.h"
#import "GoodsCategoryModel.h"

@interface SearchGoodsViewController : BaseController

@property (nonatomic, strong)NSArray<GoodsCategoryModel *> *goodsCategorys;
@property (nonatomic, copy)NSString *gtype;
// 搜索分类
@property (nonatomic, copy) NSString *searchText;
// 会员
@property (nonatomic, copy) NSString *huiyuan;

@end
