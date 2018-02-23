//
//  YTXTopicTitleViewCell.m
//  ShesheDa
//
//  Created by Hongwei Chen on 2016/12/17.
//  Copyright © 2016年 北京艺天下文化科技有限公司. All rights reserved.
//

#import "YTXTopicTitleViewCell.h"
#import "CangyouQuanDetailModel.h"

@interface YTXTopicTitleViewCell ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subtitleLabel;
@property (nonatomic, strong) UIView *linkView;
@property (nonatomic, strong) UILabel *authorLabel;

@end

@implementation YTXTopicTitleViewCell


- (void)setModel:(CangyouQuanDetailModel *)model
{
    if (!model) {
        return;
    }
    _model = model;
    
    
    self.titleLabel.text = model.firstTitle;
    if (model.lastTitle.length > 0) {
        self.subtitleLabel.text = model.lastTitle;
    }
    NSString *author = @"";
    if ([model.topictype isEqualToString:@"17"]) {
        if ([model.source isKindOfClass:[NSString class]]) {
            author = model.source;
        } else if ([model.source isKindOfClass:[NSDictionary class]]) {
            author = model.source[@"username"];;
        }
    } else {
        if ([model.people isKindOfClass:[NSString class]]) {
            author = model.people;
        } else if ([model.people isKindOfClass:[NSDictionary class]]) {
            author = model.people[@"username"];;
        }
    }
    self.authorLabel.text = [NSString stringWithFormat:@"作者：%@",author];
}

+ (CGFloat)heightWithModel:(CangyouQuanDetailModel *)model
{
    CGFloat height = 25;
    CGSize titleSize = [model.firstTitle sizeForFont:[UIFont systemFontOfSize:26] size:CGSizeMake(kScreenW - 20 * 2, CGFLOAT_MAX) mode:0];
    height += titleSize.height;
    if (model.lastTitle) {
        height += 5;
        CGSize subtitleSize = [model.lastTitle sizeForFont:[UIFont systemFontOfSize:26] size:CGSizeMake(kScreenW - 20 * 2, CGFLOAT_MAX) mode:0];
        height += subtitleSize.height;
    }
    height += 20;
    height += 20;
    height += 20;
    height += 25;
    return height;
}


#pragma mark - getter

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:26];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.numberOfLines = 0;
        [self.contentView addSubview:_titleLabel];
        
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(20);
            make.right.mas_equalTo(-20);
            make.top.mas_equalTo(25);
        }];
    }
    return _titleLabel;
}

- (UILabel *)subtitleLabel
{
    if (!_subtitleLabel) {
        _subtitleLabel = [[UILabel alloc] init];
        _subtitleLabel.numberOfLines = 0;
        _subtitleLabel.font = [UIFont systemFontOfSize:26];
        _subtitleLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_subtitleLabel];
        
        [_subtitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(20);
            make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(5);
            make.right.mas_equalTo(-20);
        }];
    }
    return _subtitleLabel;
}

- (UIView *)linkView
{
    if (!_linkView) {
        _linkView = [[UIView alloc] init];
        _linkView.backgroundColor = [UIColor lightGrayColor];
        [self.contentView addSubview:_linkView];
        
        [_linkView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(100);
            make.height.mas_equalTo(0.5);
            make.centerX.mas_equalTo(0);
            make.top.mas_equalTo(self.subtitleLabel.mas_bottom).offset(20);
        }];
    }
    return _linkView;
}

- (UILabel *)authorLabel
{
    if (!_authorLabel) {
        _authorLabel = [[UILabel alloc] init];
        _authorLabel.font = [UIFont systemFontOfSize:17];
        [self.contentView addSubview:_authorLabel];
        
        [_authorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(0);
            make.top.mas_equalTo(self.linkView.mas_bottom).offset(20);
        }];
    }
    return _authorLabel;
}

@end
