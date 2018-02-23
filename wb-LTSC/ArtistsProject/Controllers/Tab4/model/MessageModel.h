//
//  MessageModel.h
//  ShesheDa
//
//  Created by chen on 16/7/9.
//  Copyright © 2016年 上海翔汇网络有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MessageFromuserModel : NSObject

@property(nonatomic,copy) NSString *audio;
@property(nonatomic,copy) NSString *auth;
@property(nonatomic,copy) NSString *avatar;
@property(nonatomic,copy) NSString *tag;
@property(nonatomic,copy) NSString *uid;
@property(nonatomic,copy) NSString *username;

@end

@interface MessageModel : NSObject

@property(nonatomic,strong) MessageFromuserModel *fromuser;
@property(nonatomic,copy) NSString *message;
@property(nonatomic,copy) NSString *msgfromid;
@property(nonatomic,copy) NSString *subject;
@property(nonatomic,copy) NSString *time;
@property(nonatomic,copy) NSString *touid;
@property(nonatomic,strong) MessageFromuserModel *touser;
@property(nonatomic,copy) NSString *uid;
@property(nonatomic,copy) NSString *user_verified_category_id;
@property(nonatomic,copy) NSString *verified;
@property(nonatomic,copy) NSString *audio;
@property(nonatomic,copy) NSString *auth;
@property(nonatomic,copy) NSString *rel;
@property(nonatomic,copy) NSString *avatar;
@property(nonatomic,copy) NSString *tag;
@property(nonatomic,copy) NSString *username;
@end
