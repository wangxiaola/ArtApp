//
//  YTXSearchDynamicModel.h
//  ShesheDa
//
//  Created by lixianjun on 2016/12/25.
//  Copyright © 2016年 北京艺天下文化科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YTXUser.h"
#import "YTXPhotoscbkModel.h"

@interface YTXSearchDynamicModel : NSObject<YYModel>

@property (nonatomic, copy) NSString * albumid;
@property (nonatomic, copy) NSString * clicknum;
@property (nonatomic, copy) NSString * likeuser;
@property (nonatomic, copy) NSString * id;
@property (nonatomic, copy) NSString * topictitle;
@property (nonatomic, copy) NSString * people;
@property (nonatomic, copy) NSString * dateline;
@property (nonatomic, copy) NSString * endtime;
@property (nonatomic, copy) NSString * address;
@property (nonatomic, copy) NSArray * comments;
@property (nonatomic, copy) NSString * award;
@property (nonatomic, copy) NSString * authtime;
@property (nonatomic, copy) NSString * sellprice;
@property (nonatomic, copy) NSString * postuid;
@property (nonatomic, strong) YTXUser * user;
@property (nonatomic, copy) NSString * attach_list;
@property (nonatomic, copy) NSString * catatype;
@property (nonatomic, copy) NSString * isfollow;
@property (nonatomic, copy) NSString * source;
@property (nonatomic, copy) NSString * pingyu;
@property (nonatomic, copy) NSString * gtypename;
@property (nonatomic, copy) NSString * sellstatus;
@property (nonatomic, copy) NSString * height;
@property (nonatomic, copy) NSString * caizhi;
@property (nonatomic, copy) NSString * status;
@property (nonatomic, copy) NSString * city;
@property (nonatomic, copy) NSString * price;
@property (nonatomic, copy) NSString * yunfei;
@property (nonatomic, copy) NSString * planner;
@property (nonatomic, copy) NSString * isdel;
@property (nonatomic, copy) NSString * video;
@property (nonatomic, copy) NSString * audio;
@property (nonatomic, copy) NSString * kucun;
@property (nonatomic, copy) NSString * starttime;
@property (nonatomic, copy) NSString * alt;
@property (nonatomic, copy) NSString * topictype;
@property (nonatomic, copy) NSString * likenum;
@property (nonatomic, copy) NSString * commentnum;
@property (nonatomic, copy) NSString * age;
@property (nonatomic, copy) NSString * gtype;
@property (nonatomic, copy) NSString * photos;
@property (nonatomic, copy) NSString * isLiked;
@property (nonatomic, copy) NSString * ispay;
@property (nonatomic, copy) NSString * shopgoodscata;
@property (nonatomic, copy) NSString * addtop;
@property (nonatomic, copy) NSString * arttype;
@property (nonatomic,  copy) NSString * replyuid;
@property (nonatomic, copy) NSString * reltopic;
@property (nonatomic, copy) NSString * message;
@property (nonatomic, copy) NSString * width;
@property (nonatomic, copy) NSString * goodlong;
@property (nonatomic, strong) NSMutableArray  * photoscbk;

- (NSString *)catetypeName;
- (NSString *)statusName;
- (NSString *)topictypeName;

@end
