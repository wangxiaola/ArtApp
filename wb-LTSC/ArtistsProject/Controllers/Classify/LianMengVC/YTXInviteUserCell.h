//
//  YTXInviteUserCell.h
//  ShesheDa
//
//  Created by 贾卯 on 2016/12/18.
//  Copyright © 2016年 北京艺天下文化科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YTXInviteUserModel.h"

extern NSString * const kYTXInviteUserTableViewCell;

@interface YTXInviteUserCell : UITableViewCell

@property (nonatomic, copy) void(^focusBtnAction)();

@property (weak, nonatomic) IBOutlet UIImageView *avtaorView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *inviteLabel;
@property (weak, nonatomic) IBOutlet UIButton *attentionBtn;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (nonatomic, strong) YTXInviteUserModel * model;

@end
