//
//  YTXFriendsTableViewCell.h
//  ShesheDa
//
//  Created by Hongwei Chen on 2016/11/7.
//  Copyright © 2016年 北京艺天下文化科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YTXFriendsViewModel.h"

extern NSString * const kYTXFriendsTableViewCell;

@interface YTXFriendsTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *skillLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *focusBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleCenterY;
@property (nonatomic, copy) void(^focusBtnAction)();

@property (nonatomic, strong) YTXFriendsViewModel * model;
// constModel
@property (nonatomic, strong) YTXFriendsViewModel *constModel;

@end
