//
//  YTXHuiPingOrderModel.h
//  ArtistsProject
//
//  Created by 黄兵 on 2017/7/10.
//  Copyright © 2017年 HELLO WORLD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YTXGoodsModel.h"
@interface YTXHuiPingOrderModel : NSObject

@property (nonatomic, copy) NSString *author;
@property (nonatomic, copy) NSString *authorid;// author
@property (nonatomic, copy) NSString *cid;// author
@property (nonatomic, copy) NSString *dateline;// author
@property (nonatomic, copy) NSString *id;// author
@property (nonatomic, copy) NSString *idtype;// author
@property (nonatomic, copy) NSString *ip;// author
@property (nonatomic, copy) NSString *magicflicker;// author
@property (nonatomic, copy) NSString *message;// author
@property (nonatomic, copy) NSString *reply;// author
@property (nonatomic, copy) NSString *replyid;
@property (nonatomic, copy) NSString *score;
@property (nonatomic, copy) NSString *tscid;
@property (nonatomic, copy) NSString *uid;
@property (nonatomic, strong) YTXUser *user;

@end
