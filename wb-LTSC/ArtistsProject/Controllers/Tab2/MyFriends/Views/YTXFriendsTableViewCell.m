//
//  YTXFriendsTableViewCell.m
//  ShesheDa
//
//  Created by Hongwei Chen on 2016/11/7.
//  Copyright © 2016年 北京艺天下文化科技有限公司. All rights reserved.
//

#import "YTXFriendsTableViewCell.h"

NSString * const kYTXFriendsTableViewCell = @"YTXFriendsTableViewCell";

@interface YTXFriendsTableViewCell ()



@end

@implementation YTXFriendsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
//关注按钮点击事件
- (IBAction)focusBtnAction:(UIButton *)sender {
    if (_focusBtnAction) {
        _focusBtnAction();
    }
}

- (void)setModel:(YTXFriendsViewModel *)model {
    _model = model.modelCopy;
    [_iconImageView setImageWithURL:[NSURL URLWithString:_model.icon] placeholder:[UIImage imageNamed:@"temp_Default_headProtrait"]];
    _titleLabel.text = _model.name;
    if (_model.isHiddenSkill) {
        _skillLabel.hidden = YES;
        _titleCenterY.constant = 0;
    } else {
        _titleCenterY.constant = -11;
        _skillLabel.hidden = NO;
        _skillLabel.text = _model.skill ? _model.skill : @"";
    }
    if (_model.shouldShowFocus) {
        _focusBtn.hidden = NO;
    } else {
        _focusBtn.hidden = YES;
    }
    _timeLabel.text = _model.time ? _model.time : @"";
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
