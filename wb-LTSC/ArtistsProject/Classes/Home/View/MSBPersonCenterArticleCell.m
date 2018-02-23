//
//  MSBPersonCenterArticleCell.m
//  meishubao
//
//  Created by T on 16/12/16.
//  Copyright © 2016年 benbun. All rights reserved.
//

#import "MSBPersonCenterArticleCell.h"
#import "GeneralConfigure.h"

@interface MSBPersonCenterArticleCell ()
@property (nonatomic, strong) UILabel *timeLab;

@property(nonatomic,strong) UILabel *messageLab;
@property(nonatomic,strong) UIImageView *iconImageView;
@property(nonatomic,strong) UIView *lineView;

@property(nonatomic,strong) UIButton *praiseBtn;
@property(nonatomic,strong) UIButton *commentBtn;
@property(nonatomic,strong) UIButton *shareBtn;
@end

@implementation MSBPersonCenterArticleCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.lineView.dk_backgroundColorPicker = CellLineColor;
        self.dk_backgroundColorPicker = DKColorPickerWithRGB(0xffffff, 0x222222, 0xfafafa);
        
        [self.praiseBtn addTarget:self action:@selector(praiseBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.shareBtn addTarget:self action:@selector(shareBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.commentBtn addTarget:self action:@selector(commentBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)dealloc{
    if (self.messageLab) {
        self.messageLab.attributedText = nil;
    }
    
    if (self.timeLab) {
        self.timeLab.text = nil;
    }
    
    if (self.praiseBtn) {
        [self.praiseBtn removeTarget:self action:@selector(praiseBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    if (self.shareBtn) {
        [self.shareBtn removeTarget:self action:@selector(shareBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    
    if (self.commentBtn) {
        [self.commentBtn removeTarget:self action:@selector(commentBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    if (self.shareBlock ) {
        self.shareBlock = nil;
    }
    
    if (self.commentBlock) {
        self.commentBlock = nil;
    }
    
    if (self.praiseBlock) {
        self.praiseBlock = nil;
    }
}

- (void)setModel:(MSBInfoStoreItem *)item{
    self.timeLab.text = item.comment_date;
    self.messageLab.text = item.post_title;
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:item.post_image] placeholderImage:[UIImage imageNamed:@"article_cell"]];
    [self.shareBtn setTitle:@"分享" forState:UIControlStateNormal];
    [self.commentBtn setTitle:[NSString stringWithFormat:@"%tu", item.comment_num] forState:UIControlStateNormal];
    self.praiseBtn.selected = item.is_praise;
    
    if (item.is_praise) {
       [self.praiseBtn setTitle:[NSString stringWithFormat:@"%tu", item.praise+1] forState:UIControlStateNormal];
    }else{
        [self.praiseBtn setTitle:[NSString stringWithFormat:@"%tu", item.praise==0?0:(item.praise-1)] forState:UIControlStateNormal];
    }
}

- (void)praiseBtnClick:(UIButton *)btn{
    if (self.praiseBlock) {
        self.praiseBlock(btn);
    }
}

- (void)shareBtnClick:(UIButton *)btn{
    if (self.shareBlock) {
        self.shareBlock(self.iconImageView.image);
    }
}

- (void)commentBtnClick:(UIButton *)btn{
    if (self.commentBlock) {
        self.commentBlock(btn);
    }
}

- (UILabel *)timeLab{
    if (!_timeLab) {
        _timeLab = [[UILabel alloc] init];
        [_timeLab setTranslatesAutoresizingMaskIntoConstraints:NO];
        [_timeLab setFont:[UIFont systemFontOfSize:12.f]];
        _timeLab.dk_textColorPicker = DKColorPickerWithRGB(0x1d1d26, 0x989898);
        [self.contentView addSubview:_timeLab];
        [self.contentView addConstraints:@[
                                           [NSLayoutConstraint constraintWithItem:_timeLab attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1 constant:15.f],
                                           [NSLayoutConstraint constraintWithItem:_timeLab attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeading multiplier:1 constant:15.f]
                                           ]];
    }
    return _timeLab;
}

- (UIImageView *)iconImageView{
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] init];
        [_iconImageView setTranslatesAutoresizingMaskIntoConstraints:NO];
        [_iconImageView setContentMode:UIViewContentModeScaleAspectFill];
        [_iconImageView.layer setCornerRadius:5.f];
        [_iconImageView setClipsToBounds:YES];
        [self.contentView addSubview:_iconImageView];
        [self.contentView addConstraints:@[
                                          [NSLayoutConstraint constraintWithItem:_iconImageView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTrailing multiplier:1 constant:-15.f],
                                          [NSLayoutConstraint constraintWithItem:_iconImageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeWidth multiplier:1 constant:80.f],
                                           [NSLayoutConstraint constraintWithItem:_iconImageView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1 constant:80.f],
                                           [NSLayoutConstraint constraintWithItem:_iconImageView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0.f],
                                          ]];
    }
    return _iconImageView;
    
}

- (UILabel *)messageLab{
    if (!_messageLab) {
        _messageLab = [[UILabel alloc] init];
        [_messageLab setTranslatesAutoresizingMaskIntoConstraints:NO];
        [_messageLab setFont:[UIFont boldSystemFontOfSize:15.f]];
        _messageLab.dk_textColorPicker = DKColorPickerWithRGB(0x000000, 0x989898);
        [_messageLab setNumberOfLines:1];
        [self.contentView addSubview:_messageLab];
        [self.contentView addConstraints:@[
                                         [NSLayoutConstraint constraintWithItem:_messageLab attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeading multiplier:1 constant:15.f],
                                         [NSLayoutConstraint constraintWithItem:_messageLab attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.iconImageView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0.f],
                                          [NSLayoutConstraint constraintWithItem:_messageLab attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.iconImageView attribute:NSLayoutAttributeLeading multiplier:1 constant:-10.f]
                                        ]];
    }
    return _messageLab;
}

- (UIButton *)praiseBtn{
    if (!_praiseBtn) {
        _praiseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_praiseBtn setTranslatesAutoresizingMaskIntoConstraints:NO];
        [_praiseBtn setTitle:@"0" forState:UIControlStateNormal];
        [_praiseBtn.titleLabel setFont:[UIFont systemFontOfSize:12.f]];
        [_praiseBtn dk_setTitleColorPicker:DKColorPickerWithRGB(0x1d1d26, 0x989898) forState:UIControlStateNormal];
        [_praiseBtn.imageView setContentMode:UIViewContentModeCenter];
        [_praiseBtn setImageEdgeInsets:UIEdgeInsetsMake(0.0, -10, 0.0, 0.0)];
        [_praiseBtn setImage:[UIImage imageNamed:@"info_icon_praise"] forState:UIControlStateNormal];
        [_praiseBtn setImage:[UIImage imageNamed:@"info_icon_praise_selected"] forState:UIControlStateSelected];
        [self.contentView addSubview:_praiseBtn];
        [self.contentView addConstraints:@[
                                           [NSLayoutConstraint constraintWithItem:_praiseBtn attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.iconImageView attribute:NSLayoutAttributeBottom multiplier:1 constant:10.f],
                                           [NSLayoutConstraint constraintWithItem:_praiseBtn attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.commentBtn attribute:NSLayoutAttributeTrailing multiplier:1 constant:10.f],
                                           [NSLayoutConstraint constraintWithItem:_praiseBtn attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeWidth multiplier:1 constant:50.f],
                                           [NSLayoutConstraint constraintWithItem:_praiseBtn attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1 constant:40.f]
                                           ]];
    }
    return _praiseBtn;
}

- (UIButton *)shareBtn{
    if (!_shareBtn) {
        _shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_shareBtn setTranslatesAutoresizingMaskIntoConstraints:NO];
        [_shareBtn setTitle:@"分享" forState:UIControlStateNormal];
        [_shareBtn.titleLabel setFont:[UIFont systemFontOfSize:12.f]];
        [_shareBtn dk_setTitleColorPicker:DKColorPickerWithRGB(0x1d1d26, 0x989898) forState:UIControlStateNormal];
        [_shareBtn.imageView setContentMode:UIViewContentModeCenter];
        [_shareBtn setImageEdgeInsets:UIEdgeInsetsMake(0.0, -10, 0.0, 0.0)];
        [_shareBtn setImage:[UIImage imageNamed:@"person_share_icon"] forState:UIControlStateNormal];
        [_shareBtn setImage:[UIImage imageNamed:@"person_share_icon"] forState:UIControlStateSelected];
        [self.contentView addSubview:_shareBtn];
        [self.contentView addConstraints:@[
                                           [NSLayoutConstraint constraintWithItem:_shareBtn attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.iconImageView attribute:NSLayoutAttributeBottom multiplier:1 constant:10.f],
                                           [NSLayoutConstraint constraintWithItem:_shareBtn attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeading multiplier:1 constant:10.f],
                                           [NSLayoutConstraint constraintWithItem:_shareBtn attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeWidth multiplier:1 constant:60.f],
                                           [NSLayoutConstraint constraintWithItem:_shareBtn attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1 constant:40.f]
                                           ]];
    }
    return _shareBtn;
}


- (UIButton *)commentBtn{
    if (!_commentBtn) {
        _commentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_commentBtn setTranslatesAutoresizingMaskIntoConstraints:NO];
        [_commentBtn setTitle:@"0" forState:UIControlStateNormal];
        [_commentBtn.titleLabel setFont:[UIFont systemFontOfSize:12.f]];
        [_commentBtn dk_setTitleColorPicker:DKColorPickerWithRGB(0x1d1d26, 0x989898) forState:UIControlStateNormal];
        [_commentBtn.imageView setContentMode:UIViewContentModeCenter];
        [_commentBtn setImageEdgeInsets:UIEdgeInsetsMake(0.0, -10, 0.0, 0.0)];
        [_commentBtn setImage:[UIImage imageNamed:@"person_comment_icon"] forState:UIControlStateNormal];
        [_commentBtn setImage:[UIImage imageNamed:@"person_comment_icon"] forState:UIControlStateSelected];
        [self.contentView addSubview:_commentBtn];
        [self.contentView addConstraints:@[
                                           [NSLayoutConstraint constraintWithItem:_commentBtn attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.iconImageView attribute:NSLayoutAttributeBottom multiplier:1 constant:10.f],
                                           [NSLayoutConstraint constraintWithItem:_commentBtn attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.shareBtn attribute:NSLayoutAttributeTrailing multiplier:1 constant:10.f],
                                           [NSLayoutConstraint constraintWithItem:_commentBtn attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeWidth multiplier:1 constant:60.f],
                                           [NSLayoutConstraint constraintWithItem:_commentBtn attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1 constant:40.f]
                                           ]];
    }
    return _commentBtn;
}


- (UIView *)lineView{
    if (!_lineView) {
        _lineView = [UIView new];
        [_lineView setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self.contentView addSubview:_lineView];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_lineView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_lineView)]];
        [self.contentView addConstraints:@[
                                           [NSLayoutConstraint constraintWithItem:_lineView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeBottom multiplier:1 constant:0.f],
                                           [NSLayoutConstraint constraintWithItem:_lineView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1 constant:0.5f]
                                           ]];
    }
    return _lineView;
}

@end
