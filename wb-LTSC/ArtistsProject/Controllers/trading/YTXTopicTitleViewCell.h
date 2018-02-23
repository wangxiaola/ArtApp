//
//  YTXTopicTitleViewCell.h
//  ShesheDa
//
//  Created by Hongwei Chen on 2016/12/17.
//  Copyright © 2016年 北京艺天下文化科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CangyouQuanDetailModel;

@interface YTXTopicTitleViewCell : UITableViewCell

@property (strong, nonatomic) CangyouQuanDetailModel *model;

+ (CGFloat)heightWithModel:(CangyouQuanDetailModel *)model;

@end
