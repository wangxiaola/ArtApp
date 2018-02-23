//
//  ExpertAppointmentModel.h
//  ShesheDa
//
//  Created by chen on 16/7/11.
//  Copyright © 2016年 上海翔汇网络有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface xczxxzModel : NSObject

@property(nonatomic,copy) NSString *avatar;
@property(nonatomic,copy) NSString *comment_id;
@property(nonatomic,copy) NSString *content;
@property(nonatomic,copy) NSString *ctime;
@property(nonatomic,copy) NSString *uid;
@property(nonatomic,copy) NSString *uname;

@end

@interface xczxModel : NSObject

@property(strong,nonatomic) xczxxzModel *zx;


@end

@interface xczbModel : NSObject

@property(nonatomic,copy) NSString *id;
@property(nonatomic,copy) NSString *message;
@property(nonatomic,copy) NSString *photos;

@end

@interface ExpertAppointmentZhubandanweiDataModel : NSObject

@property(nonatomic,copy) NSString *audio;
@property(nonatomic,copy) NSString *avatar;
@property(nonatomic,copy) NSString *auth;
@property(nonatomic,copy) NSString *tag;
@property(nonatomic,copy) NSString *totalmember;
@property(nonatomic,copy) NSString *totalevent;
@property(nonatomic,copy) NSString *uid;
@property(nonatomic,copy) NSString *username;
@property(nonatomic,copy) NSString *comment_id;
@property(strong,nonatomic) xczxxzModel *zx;
@property(strong,nonatomic) xczxxzModel *hf;
@end

@interface ExpertAppointmentZhubandanweiModel : NSObject
@property(nonatomic,copy) NSMutableArray *data;
@property(nonatomic,copy) NSString *total;
@end

@interface ExpertAppointmentAudioModel : NSObject
@property(nonatomic,copy) NSString *url;
@property(nonatomic,copy) NSString *duration;
@end

@interface ExpertAppointmentUserModel : NSObject
@property(nonatomic,copy) NSString *isliked;
@property(nonatomic,copy) NSString *avatar;
@property(nonatomic,copy) NSString *tag;
@property(nonatomic,copy) NSString *uid;
@property(nonatomic,copy) NSString *username;

@end

@interface ExpertAppointmentZhuanjiaModel : NSObject
@property(nonatomic,copy) NSMutableArray *audio;
@property(nonatomic,copy) NSString *auth;
@property(nonatomic,copy) NSString *avatar;
@property(nonatomic,copy) NSString *tag;
@property(nonatomic,copy) NSString *uid;
@property(nonatomic,copy) NSString *username;

@end

@interface ExpertAppointmentModel : NSObject

@property(nonatomic,copy) NSString *eid;
@property(nonatomic,copy) NSString *name;
@property(nonatomic,copy) NSString *stime;
@property(nonatomic,copy) NSString *etime;
@property(nonatomic,copy) NSString *area;
@property(nonatomic,copy) NSString *city;
@property(nonatomic,copy) NSString *location;
@property(nonatomic,copy) NSString *place;
@property(nonatomic,copy) NSString *image;
@property(nonatomic,copy) NSString *manNumber;
@property(nonatomic,copy) NSString *remainder;
@property(nonatomic,copy) NSString *price;
@property(nonatomic,copy) NSString *tips;
@property(nonatomic,copy) NSString *cid;
@property(nonatomic,copy) NSString *audit;
@property(nonatomic,copy) NSString *content;
@property(nonatomic,copy) NSString *uid;
@property(nonatomic,copy) NSMutableArray *zhuanjia;
@property(nonatomic,strong) ExpertAppointmentZhubandanweiModel *zbdw;
@property(nonatomic,strong) ExpertAppointmentZhubandanweiModel *xbdw;
@property(nonatomic,copy) NSString *splj;
@property(nonatomic,strong) ExpertAppointmentZhubandanweiModel *gldt;
@property(nonatomic,strong) ExpertAppointmentZhubandanweiModel *cyzx;
@property(nonatomic,strong) NSMutableArray *xczb;
@property(nonatomic,copy) NSString *signall;
@property(nonatomic,copy) NSString *tatus;
@property(nonatomic,copy) NSMutableArray *signuser;
@property(nonatomic,copy) NSString *eurl;
@property(nonatomic,copy) NSString *lat;
@property(nonatomic,copy) NSString *lng;
@property(nonatomic,copy) NSString *status;
@property(nonatomic,copy) NSString *isliked;
@property(nonatomic,copy) NSString *topictitle;
@property(nonatomic,copy) NSString *contenturl;

@end
