//
//  MSBFollowModel.h
//  meishubao
//
//  Created by T on 16/12/19.
//  Copyright © 2016年 benbun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MSBFollowModel : NSObject
/* "attention_uid": "120", //用户id
 "name": "杨晓阳",//名称
 "avatar": "http://h.hiphotos.baidu.com/baike/c0%3Dbaike.jpg",//头像
 "intro": "中国国家画院院长",//简介*/

@property (nonatomic, copy) NSString *uid;
@property (nonatomic, copy)  NSString *name;
@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, copy)  NSString *intro;
@property (nonatomic, assign) BOOL selected;
@property (nonatomic, assign) NSInteger attention_status; // 0, 未关注 1, 关注
@property (nonatomic, copy) NSString *signature;
@property (nonatomic, assign) NSInteger attention_num;
@property (nonatomic, assign) NSInteger fans_num;

// 机构
@property (nonatomic, copy) NSString *org_id;
@property (nonatomic, copy) NSString *org_name;
@property (nonatomic, copy) NSString *org_image;
@property (nonatomic, copy) NSString *org_intro;
@end
