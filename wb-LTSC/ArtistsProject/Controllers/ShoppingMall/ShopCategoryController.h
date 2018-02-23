//
//  ShopCategoryController.h
//  ArtistsProject
//
//  Created by 黄兵 on 2017/7/17.
//  Copyright © 2017年 HELLO WORLD. All rights reserved.
//

#import "HViewController.h"

@interface ShopCategoryController : HViewController

@property (nonatomic, copy) void(^saveBtnCilck)(NSString *backValue, NSString *backId);
@end
