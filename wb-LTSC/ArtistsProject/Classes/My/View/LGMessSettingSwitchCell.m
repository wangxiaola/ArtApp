//
//  LGMessSettingSwitchCell.m
//  evtmaster
//
//  Created by T on 16/7/20.
//  Copyright © 2016年 benbun. All rights reserved.
//

#import "LGMessSettingSwitchCell.h"
#import "GeneralConfigure.h"

@interface LGMessSettingSwitchCell ()
@property (strong, nonatomic) UISwitch *switchBtn;
@property (strong, nonatomic) UILabel *titleLab;
//@property(nonatomic,strong) UIImageView *iconView;

@property(nonatomic,strong) UIView *lineView;
@end

@implementation LGMessSettingSwitchCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        //self.lineView.dk_backgroundColorPicker = CellLineColor;
        self.dk_backgroundColorPicker = DKColorPickerWithRGB(0xffffff, 0x222222, 0xfafafa);
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}
#pragma mark - Override

- (void)prepareForReuse {
    
    [super prepareForReuse];
    
    if (_titleLab) {
        
        _titleLab.text = nil;
    }
    
    if (_switchBtn) {
        
        [_switchBtn setOn:NO];
    }
    
    if (self.changeBlock) {
        self.changeBlock = nil;
    }
    
}
#pragma mark - Load

- (UILabel *)titleLab {
    
    if (_titleLab == nil) {
        
        _titleLab = [[UILabel alloc] init];
        [_titleLab setTranslatesAutoresizingMaskIntoConstraints:NO];
        _titleLab.font = [UIFont systemFontOfSize:16.f];
        [_titleLab setBackgroundColor:[UIColor clearColor]];
//        _titleLab.textColor = RGBCOLOR(3, 3, 3);
         _titleLab.dk_textColorPicker = DKColorPickerWithRGB(0x030303, 0x989898);
        [self.contentView addSubview:_titleLab];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_titleLab]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_titleLab)]];
        [self.contentView addConstraints:@[
                                           [NSLayoutConstraint constraintWithItem:_titleLab attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeading multiplier:1 constant:8],
                                           [NSLayoutConstraint constraintWithItem:_titleLab attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.switchBtn attribute:NSLayoutAttributeLeading multiplier:1 constant:20],
                                           ]];
    }
    
    return _titleLab;
}

- (UISwitch *)switchBtn {
    
    if (_switchBtn == nil) {
        
        _switchBtn = [[UISwitch alloc] init];
        [_switchBtn setTranslatesAutoresizingMaskIntoConstraints:NO];
        [_switchBtn addTarget:self action:@selector(switchChange) forControlEvents:UIControlEventValueChanged];
//        [_switchBtn setOnTintColor:RGBCOLOR(224, 25, 44)];
        [_switchBtn setOn:NO];
        [self.contentView addSubview:_switchBtn];
        
        [self.contentView addConstraints:@[
                                           [NSLayoutConstraint constraintWithItem:_switchBtn attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0],
                                           [NSLayoutConstraint constraintWithItem:_switchBtn attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTrailing multiplier:1 constant:-8.f]]];
    }
    
    return _switchBtn;
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

//- (UIImageView *)iconView{
//    if (!_iconView) {
//        _iconView = [UIImageView new];
//        [_iconView setContentMode:UIViewContentModeCenter];
//        [_iconView setTranslatesAutoresizingMaskIntoConstraints:NO];
//        [self.contentView addSubview:_iconView];
//        [self.contentView addConstraints:@[
//                                           [NSLayoutConstraint constraintWithItem:_iconView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeading multiplier:1 constant:15.f],
//                                           [NSLayoutConstraint constraintWithItem:_iconView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0.f],
//                                           [NSLayoutConstraint constraintWithItem:_iconView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeWidth multiplier:1 constant:20.f],
//                                           [NSLayoutConstraint constraintWithItem:_iconView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1 constant:20.f]
//                                           ]];
//        
//    }
//    return _iconView;
//}

#pragma mark - Methods

- (void)setTitle:(NSString *)title {
    
    self.titleLab.text = title;
}

- (void)setTitle:(NSString *)title icon:(NSString *)icon{
    self.titleLab.text = title;
//    self.iconView.image = [UIImage imageNamed:icon];
}

- (void)setTitle:(NSString *)title isOn:(BOOL)isOn {
    
    self.titleLab.text = title;
    [self setOn:isOn];
}

- (void)setOn:(BOOL)on {
    
    _isOn = on;
    [self.switchBtn setOn:on animated:NO];
}

- (void)setEnbaled:(BOOL)enabled {
    self.userInteractionEnabled = enabled;
    self.contentView.alpha = enabled ? 1.f : 0.5f;
//    [self.switchBtn setOnTintColor:enabled ? RGBCOLOR(224, 25, 44) : RGBCOLOR(230, 230, 230)];
}

#pragma mark - Handler

- (void)switchChange {
    _isOn = self.switchBtn.isOn;
    if (self.changeBlock) {
        self.changeBlock(_isOn);
    }
}

#pragma mark - Class Methods

+ (CGFloat)rowHeight {
    return 44.f;
}

- (void)setCellTintColor:(UIColor *)cellTintColor {
    _cellTintColor = cellTintColor;
    self.contentView.backgroundColor = _cellTintColor;
}

@end
