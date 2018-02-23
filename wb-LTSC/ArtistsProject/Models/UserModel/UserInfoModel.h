//
//  LoginResultModel.h
//  ShesheDa
//
//  Created by XICHUNZHAO on 15/12/23.
//  Copyright © 2015年 上海翔汇网络有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <NSObject+YYModel.h>

@interface UserInfoUserModel : NSObject
@property(nonatomic,copy) NSString *audio;
@property(nonatomic,copy) NSString *auth;
@property(nonatomic,copy) NSString *avatar;
@property(nonatomic,copy) NSString *uid;
@property(nonatomic,copy) NSString *tag;
@property(nonatomic,copy) NSString *username;
@property(nonatomic,copy) NSString *phonenum;
// 是否会员
@property (nonatomic, copy) NSString *verified;
@end



@interface UserInfoDataModel : NSObject
@property(nonatomic,copy) NSString *audio;
@property(nonatomic,copy) NSString *auth;
@property(nonatomic,copy) NSString *avatar;
@property(nonatomic,copy) NSString *birth;
@property(nonatomic,copy) NSString *city;
@property(nonatomic,copy) NSString *intro;
@property(nonatomic,copy) NSString *invitecode;
@property(nonatomic,copy) NSString *location;
@property(nonatomic,copy) NSString *nickname;
@property(nonatomic,copy) NSString *photo;
@property(nonatomic,copy) NSString *province;
@property(nonatomic,copy) NSString *sex;
@property(nonatomic,copy) NSString *tag;
@property(nonatomic,copy) NSString *uid;
@property(nonatomic,copy) NSString *verified;
@property(nonatomic,copy) NSString *video;
@property(nonatomic,copy) NSMutableArray *rectag;
// 是否编辑管理用户组
@property (nonatomic, copy) NSString *isgroup;
@end

@interface UserInfoModel : NSObject<NSCoding,YYModel>

@property(nonatomic,copy) NSString *userID;
@property(nonatomic,copy) NSString *phone;
@property(nonatomic,copy) NSString *password;
@property(nonatomic,copy) NSString *nickname;

@property(nonatomic,copy) NSString *headPortrait;
@property(nonatomic,copy) NSString *sex;
@property(nonatomic,copy) NSString *age;
@property(nonatomic)  BOOL isLiked;
@property(nonatomic,copy) NSString *ename;
@property(nonatomic,copy) NSString *realname;


@property(nonatomic,copy) NSString *birthday;
@property(nonatomic,copy) NSString *email;
@property(nonatomic,copy) NSString *provinceID;
@property(nonatomic,copy) NSString *cityID;
@property(nonatomic,copy) NSString *areaID;
@property(nonatomic,copy) NSString *status;
@property(nonatomic,copy) NSString *inviteCode;
@property(nonatomic,copy) NSString *inviteFrom;
@property(nonatomic,copy) NSString *addTime;
@property(nonatomic,copy) NSString *signature;
@property(nonatomic,copy) NSString *point;
@property(nonatomic,copy) NSString *vflag;
@property(nonatomic,copy) NSString *level;
@property(nonatomic,copy) NSString *province;// 省
@property(nonatomic,copy) NSString *city;//市
@property(nonatomic,copy) NSString *area;// 区
@property(nonatomic,copy) NSString *crowdfundingStr;
@property(nonatomic,copy) NSString *friendsCount;
@property(nonatomic,copy) NSString *fansCount;
@property(nonatomic,copy) NSString *follwCount;
@property(nonatomic,copy) NSString *notesCount;
@property(nonatomic,copy) NSString *couponCount;
@property(nonatomic,copy) NSString *pointSum;
@property(nonatomic,copy) NSString *unpaidOrderCount;
@property(nonatomic,copy) NSString *paidOrderCount;
@property(nonatomic,copy) NSString *receiveOrderCount;
@property(nonatomic,copy) NSString *orderCount;
@property(nonatomic,copy) NSString *crowdfundingOrderCount;
@property(nonatomic,copy) NSString *crowdfundingOrderNo;
@property(nonatomic,copy) NSString *unreadCount;
@property(nonatomic,copy) NSString *productCollectionCount;
@property(nonatomic,copy) NSString *notesCollectionCount;
@property(nonatomic,copy) NSString *msg_token;
@property(nonatomic,strong) NSString *isFollow;
@property(nonatomic,strong) NSString *isFriends;
@property(nonatomic,copy) NSString *url;
@property(nonatomic,strong) NSString *acceptCrowdfundingMsg;
@property (nonatomic,strong) NSString *loginID;//登录的方式
@property(nonatomic,copy) NSString *viewPhone;
@property(nonatomic,copy) NSString *viewEmail;
@property (nonatomic,copy) NSString *idcard;//身份证号码
@property (nonatomic,copy) NSString *avatar;
@property (nonatomic,copy) NSString *auth;
@property (nonatomic,copy) NSString *intro;//简介
@property (nonatomic,copy) NSString *verified; // 会员身份判断
@property (nonatomic,copy) NSString *birth;
@property (nonatomic,copy) NSString *location;
@property (nonatomic,copy) NSString *tag;
@property (nonatomic,copy) NSString *photo;
@property (nonatomic,copy) NSString *audio;
@property (nonatomic,copy) NSString *video;
@property (nonatomic,strong) UserInfoDataModel *data;
@property (nonatomic,copy) NSString *msg;
@property (nonatomic,copy) NSString *token;
@property (nonatomic,copy) NSString *uid;
@property (nonatomic,strong) UserInfoUserModel *user;

// 编辑管理用户组
@property (nonatomic, strong) NSString *isgroup;  //0不是，1是
// 作品图片
@property (nonatomic, copy) NSString *artwork; //艺术作品
// 微信二维码
@property (nonatomic, copy) NSString *wxphoto; // 微信二维码
// 创作类别
@property (nonatomic, copy) NSString *czlb;
// 毕业院校
@property (nonatomic, copy) NSString *byyx;
// 学历
@property (nonatomic, copy) NSString *xl;
// 师承
@property (nonatomic, copy) NSString *sc;
// 任职机构
@property (nonatomic, copy) NSString *rzjg;
// 原因
@property (nonatomic, copy) NSString *reason;
@end
