//
//  MSBSettingPhotoArrowCell.m
//  meishubao
//
//  Created by T on 16/11/24.
//  Copyright © 2016年 benbun. All rights reserved.
//

#import "MSBSettingPhotoArrowCell.h"
#import "GeneralConfigure.h"

@interface MSBSettingPhotoArrowCell ()
@property (strong, nonatomic) UILabel *titleLab;
@property(nonatomic,strong) UIImageView *iconImageView;
@property(nonatomic,strong) UIImageView *photoImageView;

@property(nonatomic,strong) UIView *lineView;
@end

@implementation MSBSettingPhotoArrowCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        //self.lineView.dk_backgroundColorPicker = CellLineColor;
        self.dk_backgroundColorPicker = DKColorPickerWithRGB(0xffffff, 0x222222, 0xfafafa);
        UIView * seleView = [UIView new];
        seleView.dk_backgroundColorPicker = DKColorSwiftWithRGB(0xececec, 0x1a1a1a);
        self.selectedBackgroundView = seleView;
    }
    return self;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    
    if (_titleLab) {
        
        _titleLab.text = nil;
    }
    
    if (_photoImageView) {
        
        _photoImageView.image = nil;
    }
}


- (UILabel *)titleLab {
    
    if (_titleLab == nil) {
        
        _titleLab = [[UILabel alloc] init];
        [_titleLab setTranslatesAutoresizingMaskIntoConstraints:NO];
        _titleLab.font = [UIFont systemFontOfSize:16.f];
//        _titleLab.textColor = RGBCOLOR(3.f, 3.f, 3.f);
        _titleLab.dk_textColorPicker = DKColorPickerWithRGB(0x030303, 0x989898);
        [self.contentView addSubview:_titleLab];
        
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_titleLab]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_titleLab)]];
        [self.contentView addConstraints:@[
                                           [NSLayoutConstraint constraintWithItem:_titleLab attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeading multiplier:1 constant:8],
                                           [NSLayoutConstraint constraintWithItem:_titleLab attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.photoImageView attribute:NSLayoutAttributeLeading multiplier:1 constant:-5]]];
    }
    
    return _titleLab;
}


- (UIImageView *)photoImageView{
    if (_photoImageView==nil) {
        _photoImageView = [[UIImageView alloc] init];
        [_photoImageView setTranslatesAutoresizingMaskIntoConstraints:NO];
        [_photoImageView setContentMode:UIViewContentModeScaleAspectFill];
        [_photoImageView.layer setCornerRadius:20.f];
        [_photoImageView setClipsToBounds:YES];

        [self.contentView addSubview:_photoImageView];
        [self.contentView addConstraints:@[
                                           [NSLayoutConstraint constraintWithItem:_photoImageView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0.f],
                                           [NSLayoutConstraint constraintWithItem:_photoImageView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.iconImageView attribute:NSLayoutAttributeLeading multiplier:1 constant:-5.f],
                                           [NSLayoutConstraint constraintWithItem:_photoImageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeWidth multiplier:1 constant:40],
                                           [NSLayoutConstraint constraintWithItem:_photoImageView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1 constant:40]
                                           ]];

    }
    return _photoImageView;
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
        [self.contentView addSubview:_lineView];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_lineView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_lineView)]];
        [self.contentView addConstraints:@[
                                           [NSLayoutConstraint constraintWithItem:_lineView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeBottom multiplier:1 constant:0.f],
                                           [NSLayoutConstraint constraintWithItem:_lineView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1 constant:0.5f]
                                           ]];
    }
    return _lineView;
}
- (void)setTitle:(NSString *)title{
    self.titleLab.text = title;
    self.iconImageView.dk_imagePicker =  [DKImage pickerWithNormalImage:[UIImage imageNamed:@"info_arrow"] nightImage:[UIImage imageNamed:@"info_arrow_dark"]];
}

- (void)setValue:(UIImage *)value{
    self.photoImageView.image = value;
    
}
+ (CGFloat)rowHeight{
    return 44.f;
}

- (void)setCellTintColor:(UIColor *)cellTintColor {
    _cellTintColor = cellTintColor;
    self.contentView.backgroundColor = _cellTintColor;
}
@end
