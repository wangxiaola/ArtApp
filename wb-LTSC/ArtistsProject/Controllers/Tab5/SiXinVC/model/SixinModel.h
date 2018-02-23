//
//  SixinModel.h
//  ShesheDa
//
//  Created by chen on 16/8/1.
//  Copyright © 2016年 上海翔汇网络有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SixinDetailModel : NSObject

@property(nonatomic,copy) NSString *audio;
@property(nonatomic,copy) NSString *auth;
@property(nonatomic,copy) NSString *avatar;
@property(nonatomic,copy) NSString *tag;
@property(nonatomic,copy) NSString *uid;
@property(nonatomic,copy) NSString *username;

@end


@interface SixinModel : NSObject

@property(nonatomic,copy) NSString *dateline;
@property(nonatomic,copy) NSString *message;
@property(nonatomic,copy) NSString *msgfromid;
@property(nonatomic,copy) NSString *pmid;
@property(nonatomic,copy) NSString *subject;
@property(strong,nonatomic) SixinDetailModel *user;
@property(nonatomic,copy) NSString *msg;
@property(nonatomic,copy) NSString *toid;

@end
