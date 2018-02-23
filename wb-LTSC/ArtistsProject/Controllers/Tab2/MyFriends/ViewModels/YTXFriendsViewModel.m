//
//  YTXFriendsViewModel.m
//  ShesheDa
//
//  Created by Hongwei Chen on 2016/11/7.
//  Copyright © 2016年 北京艺天下文化科技有限公司. All rights reserved.
//

#import "YTXFriendsViewModel.h"

@implementation YTXFriendsViewModel

+(instancetype)modelWithFriendsModel:(YTXUser *)friendsModel {
    YTXFriendsViewModel * model = [[YTXFriendsViewModel alloc]init];
    model.name = friendsModel.username;
    model.icon = friendsModel.avatar;
    model.skill = friendsModel.tag;
    model.uid = friendsModel.uid;
    return model;
}

@end
