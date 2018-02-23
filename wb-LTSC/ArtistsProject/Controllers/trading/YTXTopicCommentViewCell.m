//
//  YTXTopicCommentViewCell.m
//  ShesheDa
//
//  Created by Hongwei Chen on 2016/12/2.
//  Copyright © 2016年 北京艺天下文化科技有限公司. All rights reserved.
//

#import "YTXTopicCommentViewCell.h"
#import "CangyouQuanDetailModel.h"

#define MARGIN      10
#define ICON_SIZE   CGSizeMake(40,40)

@interface YTXTopicCommentViewCell ()

@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *usernameLabel;
@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UIButton *replyButton;
@property (nonatomic, strong) UIButton *accountButton;

@end

@implementation YTXTopicCommentViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier  {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self iconImageView];
        [self usernameLabel];
        [self dateLabel];
        [self contentLabel];
        [self replyButton];
        
        UIView *linkView = [[UIView alloc] init];
        linkView.backgroundColor = [UIColor colorWithRed:222./255. green:222./255. blue:222./255. alpha:1.];
        [self.contentView addSubview:linkView];
        
        [linkView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.right.and.top.mas_equalTo(0);
            make.height.mas_equalTo(0.5);
        }];
        
        _accountButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_accountButton addTarget:self action:@selector(accountAction) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_accountButton];
        
        [_accountButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.top.and.bottom.mas_equalTo(0);
            make.right.mas_equalTo(_replyButton.mas_left).offset(-MARGIN * 2);
        }];
    }
    return self;
}


- (void)accountAction
{
    if (self.userIconTaped) {
        self.userIconTaped(_commentsModel);
    }
}

- (void)setCommentsModel:(CangyouQuanCommentsModel *)commentsModel
{
    UserInfoUserModel *user = nil;
    if (commentsModel.user) {
        user = commentsModel.user;
    } else {
        user = commentsModel.author;
    }
    
    _commentsModel = commentsModel;
    
    if ([[Global sharedInstance].userID isEqualToString:user.uid]) {
        [self.replyButton setTitle:@"删除" forState:UIControlStateNormal];
    } else {
        [self.replyButton setTitle:@"回复" forState:UIControlStateNormal];
    }
    
    [self.iconImageView setImageURL:[NSURL URLWithString:user.avatar]];
    self.usernameLabel.text = user.username;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yy-MM-dd HH:mm:ss"];
    [formatter setLocale:[NSLocale currentLocale]];
    self.dateLabel.text = [formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:[commentsModel.dateline integerValue]]];
    self.contentLabel.text = commentsModel.message;
}


+ (CGFloat)cellHeightWithCommentsModel:(CangyouQuanCommentsModel *)model
{
    CGFloat height = MARGIN + ICON_SIZE.height + MARGIN;
    
    height += [model.message sizeForFont:kFont(15) size:CGSizeMake(kScreenW - MARGIN * 3 - 40, FLT_MAX) mode:0].height;
    return height + MARGIN;
}


- (void)replyAction
{
    if ([_replyButton.titleLabel.text isEqualToString:@"删除"]) {
        if (self.deleteActionBlock) {
            self.deleteActionBlock(_commentsModel);
        }
    } else {
        if (self.userReplyTaped) {
            self.userReplyTaped(_commentsModel);
        }
    }
}


#pragma mark - getter

- (UIImageView *)iconImageView
{
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] init];
        _iconImageView.layer.cornerRadius = ICON_SIZE.width/2;
        _iconImageView.clipsToBounds = YES;
        [self.contentView addSubview:_iconImageView];
        
        [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(MARGIN);
            make.top.mas_equalTo(MARGIN);
            make.size.mas_equalTo(ICON_SIZE);
        }];
    }
    return _iconImageView;
}

- (UILabel *)usernameLabel
{
    if (!_usernameLabel) {
        _usernameLabel = [[UILabel alloc] init];
        _usernameLabel.font = kFont(15);
        [self.contentView addSubview:_usernameLabel];
        
        [_usernameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.iconImageView.mas_right).offset(MARGIN);
            make.top.mas_equalTo(self.iconImageView).offset(4);
        }];
    }
    return _usernameLabel;
}

- (UILabel *)dateLabel
{
    if (!_dateLabel) {
        _dateLabel = [[UILabel alloc] init];
        _dateLabel.font = kFont(11);
        _dateLabel.textColor = [UIColor darkGrayColor];
        [self.contentView addSubview:_dateLabel];
        
        [_dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.usernameLabel);
            make.top.mas_equalTo(self.usernameLabel.mas_bottom).offset(4);
        }];
    }
    return _dateLabel;
}

- (UILabel *)contentLabel
{
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.font = kFont(15);
        _contentLabel.numberOfLines = 0;
        _contentLabel.textColor = [UIColor darkGrayColor];
        [self.contentView addSubview:_contentLabel];
        
        [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(MARGIN);
            make.top.mas_equalTo(self.iconImageView.mas_bottom).offset(MARGIN);
            make.right.mas_equalTo(self.replyButton.mas_left);
        }];
    }
    return _contentLabel;
}

- (UIButton *)replyButton
{
    if (!_replyButton) {
        _replyButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_replyButton setTitle:@"回复" forState:UIControlStateNormal];
        [_replyButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        _replyButton.titleLabel.font = kFont(15);
        [_replyButton addTarget:self action:@selector(replyAction) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_replyButton];
        
        [_replyButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-MARGIN);
            make.centerY.mas_equalTo(0);
            make.size.mas_equalTo(CGSizeMake(40, 30));
        }];
    }
    return _replyButton;
}

@end
