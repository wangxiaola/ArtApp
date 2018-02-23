//
//  HDSettingSwitchCell.m
//  evtmaster
//
//  Created by T on 16/8/22.
//  Copyright © 2016年 benbun. All rights reserved.
//

#import "HDSettingArrowCell.h"
#import "GeneralConfigure.h"

@interface HDSettingArrowCell ()
@property(nonatomic,strong) UILabel *nameLab;
@property(nonatomic,strong) UILabel * rightLabel;
@property(nonatomic,strong) UIImageView *iconImageView;
@property(nonatomic,strong) UIView *lineView;
@end

@implementation HDSettingArrowCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        //self.lineView.dk_backgroundColorPicker = CellLineColor;
        self.dk_backgroundColorPicker = DKColorPickerWithRGB(0xffffff, 0x222222, 0xfafafa);
        //self.selectionStyle = UITableViewCellSelectionStyleNone;
        UIView * seleView = [UIView new];
        seleView.dk_backgroundColorPicker = DKColorSwiftWithRGB(0xececec, 0x1a1a1a);
        self.selectedBackgroundView = seleView;
    }
    return self;
}

-(void)setArrowTitle:(NSString *)title
{
    self.rightLabel.text = title;
}

- (void)setTitle:(NSString *)title{
    self.nameLab.text = title;
    
    self.iconImageView.dk_imagePicker = [DKImage pickerWithNormalImage:[UIImage imageNamed:@"info_arrow"] nightImage:[UIImage imageNamed:@"info_arrow_dark"]];
    //self.lineView.dk_backgroundColorPicker = DKColorPickerWithRGB(0xe7e7e7, 0x454545);
}

- (void)setModel:(MSBInfoStoreItem *)item{
    self.nameLab.text = item.post_title;
    self.iconImageView.dk_imagePicker = [DKImage pickerWithNormalImage:[UIImage imageNamed:@"info_arrow"] nightImage:[UIImage imageNamed:@"info_arrow_dark"]];
}

- (void)setHistoryModel:(MSBHistoryModel *)item{
    self.nameLab.text = item.title;
    self.iconImageView.dk_imagePicker = [DKImage pickerWithNormalImage:[UIImage imageNamed:@"info_arrow"] nightImage:[UIImage imageNamed:@"info_arrow_dark"]];
}

+ (CGFloat)rowHeight{
    
    return 44.f;
}

-(UILabel *)rightLabel
{
    if (!_rightLabel) {
        _rightLabel = [UILabel new];
        [_rightLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        _rightLabel.dk_textColorPicker = DKColorPickerWithRGB(0x030303, 0x989898);
        [_rightLabel setFont:[UIFont systemFontOfSize:16]];
        [_rightLabel setBackgroundColor:[UIColor clearColor]];
        [self.contentView addSubview:_rightLabel];
        [self.contentView addConstraints:@[
                                           [NSLayoutConstraint constraintWithItem:_rightLabel attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.nameLab attribute:NSLayoutAttributeTrailing multiplier:1 constant:20],
                                           [NSLayoutConstraint constraintWithItem:_rightLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0.f],
                                           [NSLayoutConstraint constraintWithItem:_rightLabel attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.iconImageView attribute:NSLayoutAttributeLeading multiplier:1 constant:-10.f]
                                           ]];
    }
    return _rightLabel;

}

- (UILabel *)nameLab{
    if (!_nameLab) {
        _nameLab = [UILabel new];
        [_nameLab setTranslatesAutoresizingMaskIntoConstraints:NO];
//        [_nameLab setTextColor:RGBCOLOR(3, 3, 3)];
        _nameLab.dk_textColorPicker = DKColorPickerWithRGB(0x030303, 0x989898);
        [_nameLab setFont:[UIFont systemFontOfSize:16]];
        [_nameLab setBackgroundColor:[UIColor clearColor]];
        [self.contentView addSubview:_nameLab];
        [self.contentView addConstraints:@[
                                           [NSLayoutConstraint constraintWithItem:_nameLab attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeading multiplier:1 constant:8.f],
                                           [NSLayoutConstraint constraintWithItem:_nameLab attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0.f],
                                           [NSLayoutConstraint constraintWithItem:_nameLab attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.rightLabel attribute:NSLayoutAttributeLeading multiplier:1 constant:-10.f]
                                           ]];
    }
    return _nameLab;
}

- (UIImageView *)iconImageView{
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] init];
        [_iconImageView setTranslatesAutoresizingMaskIntoConstraints:NO];
        [_iconImageView setContentMode:UIViewContentModeCenter];
        [self.contentView addSubview:_iconImageView];
        [self.contentView addConstraints:@[
                                           [NSLayoutConstraint constraintWithItem:_iconImageView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0.f],
                                           [NSLayoutConstraint constraintWithItem:_iconImageView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTrailing multiplier:1 constant:-8.f],
                                           [NSLayoutConstraint constraintWithItem:_iconImageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeWidth multiplier:1 constant:8.f],
                                           [NSLayoutConstraint constraintWithItem:_iconImageView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1 constant:12.f]
                                           ]];
    }
    return _iconImageView;
}

- (UIView *)lineView{
    if (!_lineView) {
        _lineView = [UIView new];
        [_lineView setTranslatesAutoresizingMaskIntoConstraints:NO];
//        [_lineView setBackgroundColor:RGBALCOLOR(210, 210, 210, 0.75)];
        [self.contentView addSubview:_lineView];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_lineView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_lineView)]];
        [self.contentView addConstraints:@[
                                           [NSLayoutConstraint constraintWithItem:_lineView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeBottom multiplier:1 constant:0.f],
                                           [NSLayoutConstraint constraintWithItem:_lineView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1 constant:0.5f]
                                           ]];
    }
    return _lineView;
}

- (void)setCellTintColor:(UIColor *)cellTintColor {
    _cellTintColor = cellTintColor;
    self.contentView.backgroundColor = _cellTintColor;
}


@end
