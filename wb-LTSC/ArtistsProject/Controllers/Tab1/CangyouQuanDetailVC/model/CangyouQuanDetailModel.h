//
//  CangyouQuanDetailModel.h
//  ShesheDa
//
//  Created by MengTuoChina on 16/7/23.
//  Copyright © 2016年 上海翔汇网络有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserInfoModel.h"

@interface shareModel : NSObject

@property(nonatomic,copy) NSString *name;
@property(nonatomic,copy) NSString *weburl;
@property(nonatomic,copy) NSString *cover;

@end

@interface photoscbkModel : NSObject

@property(nonatomic,copy) NSString *cbk;
@property(nonatomic,copy) NSString *photo;

@end

@interface CangyouQuanCommentsModel : NSObject

@property(nonatomic,copy) NSString *cid;
@property(nonatomic,copy) NSString *dateline;
@property(nonatomic,copy) NSString *message;
@property(nonatomic,strong) UserInfoUserModel *author;
@property(nonatomic,copy) NSString *authorid;
@property(nonatomic,copy) NSString *id;
@property(nonatomic,copy) NSString *replyid;
@property(nonatomic,copy) NSString *uid;
@property(nonatomic,copy) NSString *reply;
@property(nonatomic,strong) UserInfoUserModel *user;

@end

@interface CangyouQuanDetailModel : NSObject

@property(nonatomic,copy) NSString *addtop;
@property(nonatomic,copy) NSString *age;
@property(nonatomic,copy) NSString *alt;
@property(nonatomic,copy) NSString *attach_list;
@property(nonatomic,strong) NSString *audio;
@property(nonatomic,copy) NSString *authtime;
@property(nonatomic,copy) NSString *catatype;
@property(nonatomic,copy) NSString *clicknum;
@property(nonatomic,copy) NSString *commentnum;
@property(nonatomic,copy) NSString *dateline;
@property(nonatomic,copy) NSString *id;
@property(nonatomic,copy) NSString *isLiked;
@property(nonatomic,copy) NSString *isdel;
@property(nonatomic,copy) NSString *ispay;
@property(nonatomic,copy) NSString *likenum;
@property(nonatomic,copy) NSString *message;
@property(nonatomic,copy) NSString *photos;
@property(nonatomic,copy) NSMutableArray *comments;
@property(nonatomic,copy) NSString *pingyu;
@property(nonatomic,copy) NSString *postuid;
@property(nonatomic,copy) NSString *price;
@property(nonatomic,copy) NSString *replyuid;
@property(nonatomic,copy)NSString* zsnum;
@property(nonatomic,copy) NSMutableArray *likeuser;
@property(nonatomic,strong) id source;
@property(nonatomic,copy) NSString *status;
@property(nonatomic,copy) NSString *topictitle;
//topictype: 动态类型，1-在线鉴定 2-动态 3-在线讲堂 4-商品 5-拍卖 6-作品  7-相册  8-展览  9-文字  10-日程  11-视频  12 记录    13艺术年表 14荣誉奖项 15收藏拍卖16公益捐赠 17媒体关注 18出版著作 19工作经历 20教育经历
@property(nonatomic,copy) NSString *topictype;
@property(nonatomic,copy) NSString *video;
@property(nonatomic,copy) NSMutableArray *zanlist;
@property(nonatomic,strong) UserInfoUserModel *user;
@property(nonatomic,strong) UserInfoUserModel *replyuser;
@property(nonatomic,copy) NSString *isfollow;
@property(nonatomic,copy) NSMutableArray *photoscbk;
//商品详情
@property (nonatomic, copy) NSString *sellprice;
@property (nonatomic, copy) NSString *kucun;
@property (nonatomic, strong) NSString *huiyuan;
@property (nonatomic, copy) NSString *yunfei;
@property (nonatomic, copy) NSString *width;
@property (nonatomic, copy) NSString *height;
@property (nonatomic, copy) NSString *longstr;
@property (nonatomic, copy) NSString *caizhi;
@property (nonatomic, copy) NSString *arttype;
@property (nonatomic, copy) NSString *gtype;
@property (nonatomic, copy) NSString *gtypename;
@property (nonatomic, copy) NSString *starttime;
@property (nonatomic, copy) NSString *endtime;
@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, strong) id people;
@property(nonatomic,strong)NSString* relation_ids;//关联记录id
@property(nonatomic,strong) NSString* work_ids;//关联作品id
@property (nonatomic, copy) NSString *award;
@property (nonatomic, copy) NSString *planner;

@property (nonatomic, assign) BOOL isSelect;// 是否选择

- (NSString *)firstTitle;
- (NSString *)lastTitle;
- (NSString *)sourceUserName;
- (NSString *)peopleUserName;

- (NSString *)catetypeName;
- (NSString *)statusName;

- (NSString *)topictypeName;

- (NSString *)sellPriceText;

- (NSString *)priceText;

- (NSString *)ageText;

- (NSString *)resultSource;

- (NSString *)sourceText;

- (NSString *)zuopinGuigeText;

@end
