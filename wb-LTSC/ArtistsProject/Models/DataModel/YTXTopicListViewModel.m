//
//  YTXTopicListViewModel.m
//  ShesheDa
//
//  Created by 徐建波 on 2016/11/17.
//  Copyright © 2016年 北京艺天下文化科技有限公司. All rights reserved.
//

#import "YTXTopicListViewModel.h"
#import "YTXUser.h"

@implementation YTXTopicListViewModel

+ (instancetype)modelWithTopicModel:(YTXTopicModel *)topicModel {
    YTXTopicListViewModel * model = [[YTXTopicListViewModel alloc]init];
    model.poster = [NSString stringWithFormat:@"%@发起的话题",topicModel.user.username];
    model.imageURL = [NSURL URLWithString:topicModel.user.avatar];
    model.name = topicModel.name;
    model.shareCount = [NSString stringWithFormat:@"%@个分享",topicModel.fenxiang];
    model.participationCount = [NSString stringWithFormat:@"%@人参与",topicModel.canyu];
    model.browseCount = [NSString stringWithFormat:@"%@次浏览",topicModel.liulan];
    model.postTime = topicModel.ctime;
    return model;
}

@end
