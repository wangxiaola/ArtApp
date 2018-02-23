//
//  ShoppingArtClassController.h
//  ArtistsProject
//
//  Created by 黄兵 on 2017/8/5.
//  Copyright © 2017年 HELLO WORLD. All rights reserved.
//

#import "BaseController.h"
#import "GoodsCategoryModel.h"
@interface ShoppingArtClassController : BaseController
@property (nonatomic, strong)NSMutableArray<GoodsCategoryModel *> *tableViewDataM;
@property (nonatomic, copy) NSString *navTitle;
@end
