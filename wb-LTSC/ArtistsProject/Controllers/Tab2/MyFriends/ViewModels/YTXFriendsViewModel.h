//
//  YTXFriendsViewModel.h
//  ShesheDa
//
//  Created by Hongwei Chen on 2016/11/7.
//  Copyright © 2016年 北京艺天下文化科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YTXUser.h"

@interface YTXFriendsViewModel : NSObject

@property (nonatomic, copy) NSString * icon;//头像
@property (nonatomic, copy) NSString * name;//昵称
@property (nonatomic, copy) NSString * skill;//技能
@property (nonatomic, copy) NSString * time;//时间
@property (nonatomic, copy) NSString * uid;//用户ID

@property (nonatomic, assign) BOOL shouldShowFocus;//是否显示关注按钮
@property (nonatomic, assign) BOOL isHiddenSkill;//是否隐藏技能

+(instancetype)modelWithFriendsModel:(YTXUser *)friendsModel;

@end
