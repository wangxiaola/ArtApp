//
//  YTXInviteUserCell.m
//  ShesheDa
//
//  Created by 贾卯 on 2016/12/18.
//  Copyright © 2016年 北京艺天下文化科技有限公司. All rights reserved.
//

#import "YTXInviteUserCell.h"

NSString * const kYTXInviteUserTableViewCell = @"YTXInviteUserTableViewCell";

@implementation YTXInviteUserCell

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

- (void)setModel:(YTXInviteUserModel *)model {
    _model = model.modelCopy;
    [_avtaorView setImageWithURL:[NSURL URLWithString:_model.avatar] placeholder:[UIImage imageNamed:@"temp_Default_headProtrait"]];
    _nameLabel.text = _model.uname;
    
    _timeLabel.text = _model.ctime ? _model.ctime : @"";
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
