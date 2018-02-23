//
//  MSBFollowCell.m
//  meishubao
//
//  Created by T on 16/11/25.
//  Copyright © 2016年 benbun. All rights reserved.
//

#import "MSBFollowCell.h"
#import "GeneralConfigure.h"
#import "MSBFollowBtn.h"
@interface MSBFollowCell ()
@property(nonatomic,strong) UIImageView *photoImageView;
@property(nonatomic,strong) UILabel *titleLab;
@property(nonatomic,strong) UILabel *descLab;
@property(nonatomic,strong) MSBFollowBtn *followBtn;
@property(nonatomic,strong) UIView *lineView;
@end

@implementation MSBFollowCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.lineView.dk_backgroundColorPicker = CellLineColor;
        self.dk_backgroundColorPicker = DKColorPickerWithRGB(0xffffff, 0x222222, 0xfafafa);
    }
    return self;
}

- (void)dealloc{
    if (self.followBlock) {
        self.followBlock = nil;
    }
}

- (void)setModel:(MSBFollowItem *)item{
    
    if (item.type == 1) {
        [self.photoImageView sd_setImageWithURL:[NSURL URLWithString:item.payload.avatar] placeholderImage:[UIImage imageNamed:@"people_collection_cell"]];
        self.titleLab.text = item.payload.name;
        self.descLab.text = item.payload.intro;
        if (item.payload.attention_status == 0) {

            self.followBtn.selected = NO;
        }else{
            
            self.followBtn.selected = YES;
        }
    }else{
        [self.photoImageView sd_setImageWithURL:[NSURL URLWithString:item.payload.org_image] placeholderImage:[UIImage imageNamed:@"people_collection_cell"]];
        self.titleLab.text = item.payload.org_name;
        self.descLab.text = item.payload.org_intro;
        if (item.payload.attention_status == 0) {
            
            self.followBtn.selected = NO;
        }else{
            
            self.followBtn.selected = YES;
        }
    }
}

- (void)followBtnClick:(MSBFollowBtn *)btn{
    if (self.followBlock) {
        self.followBlock(btn);
    }
}

- (UIImageView *)photoImageView{
    if (_photoImageView==nil) {
        _photoImageView = [[UIImageView alloc] init];
        [_photoImageView setTranslatesAutoresizingMaskIntoConstraints:NO];
        [_photoImageView setContentMode:UIViewContentModeScaleAspectFill];
        [_photoImageView setClipsToBounds:YES];
        [_photoImageView.layer setCornerRadius:21.f];
        [_photoImageView.layer setBorderColor:RGBCOLOR(182,16,36).CGColor];
        [_photoImageView.layer setBorderWidth:0.5f];
        [_photoImageView setClipsToBounds:YES];
        [self.contentView addSubview:_photoImageView];
        [self.contentView addConstraints:@[
                                          [NSLayoutConstraint constraintWithItem:_photoImageView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeading multiplier:1 constant:15.f],
                                          [NSLayoutConstraint constraintWithItem:_photoImageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeWidth multiplier:1 constant:43.f],
                                          [NSLayoutConstraint constraintWithItem:_photoImageView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1 constant:43.f],
                                           [NSLayoutConstraint constraintWithItem:_photoImageView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0.f],
                                          ]];
    }
    return _photoImageView;
}

- (UILabel *)titleLab{
    if (!_titleLab) {
        _titleLab = [[UILabel alloc] init];
        [_titleLab setTranslatesAutoresizingMaskIntoConstraints:NO];
        [_titleLab setFont:[UIFont boldSystemFontOfSize:14]];
        [_titleLab setNumberOfLines:1];
//        [_titleLab setTextColor:RGBALCOLOR(0 , 0, 0,1)];
        _titleLab.dk_textColorPicker = DKColorPickerWithRGB(0x030303, 0x989898);

        [self.contentView addSubview:_titleLab];
        [self.contentView addConstraints:@[
                                          [NSLayoutConstraint constraintWithItem:_titleLab attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.photoImageView attribute:NSLayoutAttributeTrailing multiplier:1 constant:17.f],
                                          [NSLayoutConstraint constraintWithItem:_titleLab attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.photoImageView attribute:NSLayoutAttributeTop multiplier:1 constant:5.f],
                                          [NSLayoutConstraint constraintWithItem:_titleLab attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.followBtn attribute:NSLayoutAttributeLeading multiplier:1 constant:-10.f]
                                          ]];
    }
    return _titleLab;
}

- (UILabel *)descLab{
    if (!_descLab) {
        _descLab = [[UILabel alloc] init];
        [_descLab setTranslatesAutoresizingMaskIntoConstraints:NO];
        [_descLab setFont:[UIFont systemFontOfSize:11]];
        [_descLab setNumberOfLines:1];
        _descLab.dk_textColorPicker = DKColorPickerWithRGB(0x030303, 0x989898);
        [self.contentView addSubview:_descLab];
        [self.contentView addConstraints:@[
                                           [NSLayoutConstraint constraintWithItem:_descLab attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.photoImageView attribute:NSLayoutAttributeTrailing multiplier:1 constant:17.f],
                                           [NSLayoutConstraint constraintWithItem:_descLab attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.photoImageView attribute:NSLayoutAttributeBottom multiplier:1 constant:-6.f],
                                           [NSLayoutConstraint constraintWithItem:_descLab attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.followBtn attribute:NSLayoutAttributeLeading multiplier:1 constant:-10.f]
                                           ]];
    }
    return _descLab;
}

- (MSBFollowBtn *)followBtn{
    if (!_followBtn) {
        _followBtn = [MSBFollowBtn buttonWithType:UIButtonTypeCustom];
        [_followBtn setTranslatesAutoresizingMaskIntoConstraints:NO];
        [_followBtn.titleLabel setFont:[UIFont systemFontOfSize:14.f]];
        [_followBtn setTitle:@"关注" forState:UIControlStateNormal];
        [_followBtn setTitle:@"已关注" forState:UIControlStateSelected];
        [_followBtn dk_setTitleColorPicker:DKColorPickerWithRGB(0x030303, 0x989898) forState:UIControlStateNormal];
        [_followBtn.imageView setContentMode:UIViewContentModeCenter];
        if (isNightMode) {
            
            [_followBtn setImage:[UIImage imageNamed:@"info_icon_follow_dark"] forState:UIControlStateNormal];
        }else {
        
            [_followBtn setImage:[UIImage imageNamed:@"info_icon_follow"] forState:UIControlStateNormal];
        }
        [_followBtn setImage:[UIImage imageNamed:@"info_icon_follow_red"] forState:UIControlStateSelected];
        [_followBtn addTarget:self
                       action:@selector(followBtnClick:)
             forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_followBtn];
        [self.contentView addConstraints:@[
                                           [NSLayoutConstraint constraintWithItem:_followBtn attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.photoImageView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0.f],
                                           [NSLayoutConstraint constraintWithItem:_followBtn attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTrailing multiplier:1 constant:-15.f],
                                            [NSLayoutConstraint constraintWithItem:_followBtn attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeWidth multiplier:1 constant:60.f],
                                           [NSLayoutConstraint constraintWithItem:_followBtn attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1 constant:50.f]
                                           ]];
    }
    return _followBtn;
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
