//
//  MSBCommonQuestionBox.m
//  meishubao
//
//  Created by T on 16/12/19.
//  Copyright © 2016年 benbun. All rights reserved.
//

#import "MSBCommonQuestionBox.h"
#import "GeneralConfigure.h"

@interface MSBCommonQuestionBox ()
@property (strong, nonatomic) UILabel *titleLab;
@property (strong, nonatomic) UILabel *contentLab;
@end

@implementation MSBCommonQuestionBox

- (instancetype)init {
    if (self = [super init]) {
        [self setBackgroundColor:[UIColor clearColor]];
        [self setClipsToBounds:YES];
    }
    
    return self;
}

- (void)dealloc {
    
    if (_titleLab) {
        
        _titleLab.text = nil;
    }
    if (_contentLab) {
        
        _contentLab.attributedText = nil;
    }
}

- (void)setTitle:(NSString *)title
         content:(NSString *)content{
    self.titleLab.attributedText = [self createTitleAttribute:title];
    self.contentLab.attributedText = [self createAttribute:content];
}

#pragma mark - 懒加载

- (NSAttributedString *)createTitleAttribute:(NSString *)title{
    
    if ([NSString isNull:title]) {
        return nil;
    } else {
        
        NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:title];
        [attributeString addAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:16]} range:NSMakeRange(0, attributeString.length)];
        NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
        style.lineSpacing = 5.f;
        style.lineBreakMode = NSLineBreakByTruncatingTail;
        [attributeString addAttributes:@{NSParagraphStyleAttributeName:style} range:NSMakeRange(0, attributeString.length)];
        
        return attributeString;
    }
}


- (NSAttributedString *)createAttribute:(NSString *)content{
    
    if ([NSString isNull:content]) {
        return nil;
    } else {
        
        NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:content];
        [attributeString addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} range:NSMakeRange(0, attributeString.length)];
        NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
        style.lineSpacing = 5.f;
        style.lineBreakMode = NSLineBreakByTruncatingTail;
        [attributeString addAttributes:@{NSParagraphStyleAttributeName:style} range:NSMakeRange(0, attributeString.length)];
        
        return attributeString;
    }
}

- (UILabel *)titleLab {
    
    if (_titleLab == nil) {
        
        _titleLab = [[UILabel alloc] init];
        [_titleLab setTranslatesAutoresizingMaskIntoConstraints:NO];
        [_titleLab setFont:[UIFont boldSystemFontOfSize:16]];
         _titleLab.dk_textColorPicker = DKColorPickerWithRGB(0x030303, 0x989898);
        _titleLab.numberOfLines = 0;
        [self addSubview:_titleLab];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_titleLab]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_titleLab)]];
        [self addConstraints:@[
                                 [NSLayoutConstraint constraintWithItem:_titleLab attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:0.f]
                               ]];
    }
    
    return _titleLab;
}

- (UILabel *)contentLab {
    
    if (_contentLab == nil) {
        
        _contentLab = [[UILabel alloc] init];
        [_contentLab setTranslatesAutoresizingMaskIntoConstraints:NO];
        [_contentLab setFont:[UIFont systemFontOfSize:14]];
        _contentLab.dk_textColorPicker = DKColorPickerWithRGB(0x030303, 0x989898);
        _contentLab.numberOfLines = 0;
        [self addSubview:_contentLab];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_contentLab]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_contentLab)]];
        [self addConstraints:@[
                               [NSLayoutConstraint constraintWithItem:_contentLab attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.titleLab attribute:NSLayoutAttributeBottom multiplier:1 constant:15.f]
                               ]];
    }
    
    return _contentLab;
}

@end
