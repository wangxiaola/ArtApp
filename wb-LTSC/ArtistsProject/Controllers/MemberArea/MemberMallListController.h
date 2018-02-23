//
//  MemberMallListController.h
//  ArtistsProject
//
//  Created by 黄兵 on 2017/7/28.
//  Copyright © 2017年 HELLO WORLD. All rights reserved.
//

#import "BaseController.h"
#import "GoodsCategoryModel.h"
@interface MemberMallListController : BaseController

@property (nonatomic, strong) NSArray<GoodsCategoryModel *>  *collArray;
@end
