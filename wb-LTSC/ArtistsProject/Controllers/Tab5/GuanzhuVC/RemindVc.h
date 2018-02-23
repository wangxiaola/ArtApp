//
//  RemindVc.h
//  ArtistsProject
//
//  Created by HELLO WORLD on 2017/5/3.
//  Copyright © 2017年 HELLO WORLD. All rights reserved.
//

#import "HPageViewController.h"

@class MessageModel;
@interface RemindVc : HPageViewController
@property (copy, nonatomic) NSArray *atuser;

@property (copy, nonatomic) void(^willDisappearBlock)(NSArray *atuserids);
@end
