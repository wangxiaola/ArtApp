//
//  YTXEvaluteOrderViewController.h
//  ArtistsProject
//
//  Created by 黄兵 on 2017/7/10.
//  Copyright © 2017年 HELLO WORLD. All rights reserved.
//

#import "HScrollViewController.h"

@interface YTXEvaluteOrderViewController : HScrollViewController

@property (nonatomic, copy) NSString * orderID;//订单id
// orderType
@property (nonatomic, copy) NSString *orderType;// 1为卖家，2为买家
// 评论id
@property (nonatomic, copy) NSString *replyid;
@end
