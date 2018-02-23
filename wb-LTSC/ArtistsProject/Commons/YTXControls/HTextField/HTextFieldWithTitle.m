//
//  HTextFieldWithTitle
//  HUIKitLib
//
//  Created by by Heliulin on 15/6/1.
//  Copyright (c) 2015年 上海翔汇网络技术有限公司. All rights reserved.
//
#import "HControls.h"
#import "Masonry.h"
#import "HTextFieldWithTitle.h"

@interface HTextFieldWithTitle ()

@property(nonatomic,strong) HLabel *labelTitle;

@end

@implementation HTextFieldWithTitle
@synthesize labelTitle;
@synthesize textContent;

- (id) init
{
    self=[super init];
    if (self){
        [self customInit];
    }
    return self;
}

- (id) initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self){
        [self customInit];
    }
    return self;
}

- (void) customInit
{
    self.titleWidth=80;
    self.titleAlignment=NSTextAlignmentRight;
    self.titleColor=kSubTitleColor;
    self.titleFont=[UIFont systemFontOfSize:15];
    
    self.contentColor=kTitleColor;
    self.contentFont=[UIFont systemFontOfSize:15];
    
    labelTitle=[HLabel new];
    [self addSubview:labelTitle];
    [labelTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.top.and.bottom.equalTo(self);
        make.width.mas_equalTo(self.titleWidth);
    }];
    [labelTitle setFont:self.titleFont];
    [labelTitle setTextColor:self.titleColor];
    [labelTitle setTextAlignment:self.titleAlignment];

    textContent=[HTextField new];
    [self addSubview:textContent];
    [textContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(labelTitle.mas_right).offset(3);
        make.top.and.bottom.and.right.equalTo(self);
    }];
    [textContent setTextColor:self.contentColor];
    [textContent setFont:self.contentFont];
    [textContent setTextAlignment:NSTextAlignmentLeft];
}

- (void) setTitleWidth:(CGFloat)titleWidth
{
    _titleWidth=titleWidth;
    [self.labelTitle mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(titleWidth);
    }];
}

- (void) setTitleAlignment:(NSTextAlignment)titleAlignment
{
    _titleAlignment=titleAlignment;
    [self.labelTitle setTextAlignment:titleAlignment];
}

- (void) setTitle:(NSString *)title
{
    _title=title;
    self.labelTitle.text=title;
}

- (void) setTitleColor:(UIColor *)titleColor
{
    _titleColor=titleColor;
    self.labelTitle.textColor=titleColor;
}

- (void) setTitleFont:(UIFont *)titleFont
{
    _titleFont=titleFont;
    [self.labelTitle setFont:titleFont];
}

- (void) setText:(NSString *)text
{
    self.textContent.text=text;
}
- (NSString*) text
{
    return self.textContent.text;
}

- (void) setContentColor:(UIColor *)contentColor
{
    _contentColor=contentColor;
    self.textContent.textColor=contentColor;
}

- (void) setContentFont:(UIFont *)contentFont
{
    _contentFont=contentFont;
    [self.textContent setFont:contentFont];
}

- (void) setPlaceHolder:(NSString *)placeHolder
{
    _placeHolder=placeHolder;
    [self.textContent setPlaceholder:placeHolder];
}
@end
