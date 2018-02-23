//
//  GuanzhuVC.h
//  ShesheDa
//
//  Created by chen on 16/7/31.
//  Copyright © 2016年 上海翔汇网络有限公司. All rights reserved.
//

#import "HPageViewController.h"

@class MessageModel;
@interface GuanzhuVC : HPageViewController

@property (copy, nonatomic) NSArray *atuser;

@property (copy, nonatomic) void(^willDisappearBlock)(NSArray *atuserids);

@end
