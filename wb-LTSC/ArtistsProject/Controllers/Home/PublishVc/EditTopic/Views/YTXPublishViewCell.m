//
//  YTXPublishViewCell.m
//  ShesheDa
//
//  Created by Hongwei Chen on 2016/12/24.
//  Copyright © 2016年 北京艺天下文化科技有限公司. All rights reserved.
//

#import "YTXPublishViewCell.h"

@interface YTXPublishViewCell ()

@property (strong, nonatomic) UILabel *titleLabel;
@end

@implementation YTXPublishViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

        [self titleLabel];
//        [self miaoshu];
        [self subtitleLabel];
        [self huiyuan];
    }
    return self;
}

- (NSString *)title
{
    return self.titleLabel.text;
}

- (void)setTitle:(NSString *)title
{
    self.titleLabel.text = title;
    if ([title isEqualToString:@"网页链接"]) {
        [self.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(80);
        }];
    }
}


- (NSString *)subtitle
{
    return self.subtitleLabel.text;
}

- (void)setSubtitle:(NSString *)subtitle
{
    self.subtitleLabel.text = subtitle;
}


#pragma mark - Getter

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = kFont(15);
        [self.contentView addSubview:_titleLabel];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(12);
            make.centerY.mas_equalTo(0);
            make.width.mas_equalTo(80);
        }];
    }
    return _titleLabel;
}

- (UILabel *)subtitleLabel
{
    if (!_subtitleLabel) {
        _subtitleLabel = [[UILabel alloc] init];
        _subtitleLabel.font = kFont(15);
        _subtitleLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:_subtitleLabel];
        [_subtitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(0);
            make.centerY.mas_equalTo(0);
            make.left.equalTo(_titleLabel.mas_right).offset(8);
        }];
    }
    return _subtitleLabel;
}
- (UILabel *)miaoshu
{
    if (!_miaoshu) {
        _miaoshu = [[UILabel alloc] init];
        _miaoshu.font = kFont(15);
        _miaoshu.hidden = YES;
        _miaoshu.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:_miaoshu];
        [_miaoshu mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(0);
            make.centerY.mas_equalTo(0);
            make.left.equalTo(_titleLabel.mas_right).offset(8);
        }];
    }
    return _miaoshu;
}
- (UISwitch *)huiyuan
{
    if (!_huiyuan) {
        _huiyuan = [[UISwitch alloc] init];
        _huiyuan.on = YES;
        [self.contentView addSubview:_huiyuan];
        _huiyuan.hidden = YES;
        [_huiyuan mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-15);
            make.centerY.mas_equalTo(0);
        }];
    }
    return _huiyuan;
}
@end
