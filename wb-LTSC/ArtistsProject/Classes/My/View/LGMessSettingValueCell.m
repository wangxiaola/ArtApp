//
//  LGMessSettingValueCell.m
//  evtmaster
//
//  Created by T on 16/7/20.
//  Copyright © 2016年 benbun. All rights reserved.
//

#import "LGMessSettingValueCell.h"
#import "GeneralConfigure.h"

@interface LGMessSettingValueCell ()
@property (strong, nonatomic) UILabel *valueLab;
@property (strong, nonatomic) UILabel *titleLab;
@property(nonatomic,strong) UIView *lineView;
@end

@implementation LGMessSettingValueCell

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

#pragma mark - Override
- (void)prepareForReuse {
    [super prepareForReuse];
    
    if (_titleLab) {
        
        _titleLab.text = nil;
    }
    
    if (_valueLab) {
        
        _valueLab.text = nil;
    }
}

#pragma mark - Methods
- (void)setTitle:(NSString *)title {
    
    self.titleLab.text = title;
}

- (void)setValue:(NSString *)value {
    
    self.valueLab.text = value;
}

- (void)setTitle:(NSString *)title value:(NSString *)value {
    
    self.titleLab.text = title;
    self.valueLab.text = value;
}

#pragma mark - Class Methods
+ (CGFloat)rowHeight {
    
    return 44.f;
}



#pragma mark - setter/getter
#pragma mark - Load
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
                                           [NSLayoutConstraint constraintWithItem:_titleLab attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.valueLab attribute:NSLayoutAttributeLeading multiplier:1 constant:-5]]];
    }
    
    return _titleLab;
}

- (UILabel *)valueLab {
    
    if (_valueLab == nil) {
        
        _valueLab = [[UILabel alloc] init];
        [_valueLab setTranslatesAutoresizingMaskIntoConstraints:NO];
        [_valueLab setFont:[UIFont systemFontOfSize:16.f]];
//        [_valueLab setTextColor:RGBCOLOR(3.f, 3.f, 3.f)];
        _valueLab.dk_textColorPicker = DKColorPickerWithRGB(0x030303, 0x989898);
        [_valueLab setTextAlignment:NSTextAlignmentRight];
        [self.contentView addSubview:_valueLab];
        
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_valueLab]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_valueLab)]];
        [self.contentView addConstraints:@[
                                           [NSLayoutConstraint constraintWithItem:_valueLab attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTrailing multiplier:1 constant:-8.f]]];
    }
    
    return _valueLab;
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


- (void)setCellTintColor:(UIColor *)cellTintColor {
    _cellTintColor = cellTintColor;
    self.contentView.backgroundColor = _cellTintColor;
}
@end
