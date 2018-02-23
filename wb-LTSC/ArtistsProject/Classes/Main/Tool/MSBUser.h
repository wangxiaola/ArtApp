//
//  MSBUser.h
//  meishubao
//
//  Created by T on 16/11/29.
//  Copyright © 2016年 benbun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface MSBUser : NSObject
@property (nonatomic, copy) NSString *identity;
@property (nonatomic, copy) NSString *uid;
@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, copy) NSString *signature;
@property (nonatomic, copy) NSString *mobile;
@property (nonatomic, copy) NSString *email;
@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, copy) NSString *birthday;
@property (nonatomic, strong) UIImage *avarImage;
@property (nonatomic, assign) NSInteger sex; //1男 2女
@property (nonatomic, copy) NSString *device;
@property (nonatomic, copy) NSString* anonymity;//1跟帖 0不跟帖

@property (nonatomic,assign) BOOL isTourists;//是否是游客登录
@end
