//
//  YTXTopicCommentViewCell.h
//  ShesheDa
//
//  Created by Hongwei Chen on 2016/12/2.
//  Copyright © 2016年 北京艺天下文化科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CangyouQuanCommentsModel;
@interface YTXTopicCommentViewCell : UITableViewCell

@property (nonatomic, strong) void (^userIconTaped)(CangyouQuanCommentsModel *model);
@property (nonatomic, strong) void (^userReplyTaped)(CangyouQuanCommentsModel *model);
@property (nonatomic, strong) void (^deleteActionBlock)(CangyouQuanCommentsModel *model);

@property (nonatomic, strong) CangyouQuanCommentsModel *commentsModel;

+ (CGFloat)cellHeightWithCommentsModel:(CangyouQuanCommentsModel *)model;

@end
