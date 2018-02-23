//
//  HLabelWithTitle.m
//  HUIKitLib
//
//  Created by by Heliulin on 15/6/1.
//  Copyright (c) 2015年 上海翔汇网络技术有限公司. All rights reserved.
//
#import "HControls.h"
#import "Masonry.h"
#import "HLabelWithTitle.h"

@interface HLabelWithTitle ()

@property(nonatomic,strong) HLabel *labelTitle;
@property(nonatomic,strong) HLabel *labelContent;

@end

@implementation HLabelWithTitle
@synthesize labelTitle;
@synthesize labelContent;

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
        make.left.equalTo(self).offset(10);
        make.top.and.bottom.equalTo(self);
        make.width.mas_equalTo(self.titleWidth);
    }];
    [labelTitle setFont:self.titleFont];
    [labelTitle setTextColor:self.titleColor];
    [labelTitle setTextAlignment:self.titleAlignment];

    labelContent=[HLabel new];
    [self addSubview:labelContent];
    [labelContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(labelTitle.mas_right);
        make.top.and.bottom.equalTo(self);
        make.right.equalTo(self).offset(-10);
    }];
    [labelContent setTextColor:self.contentColor];
    [labelContent setFont:self.contentFont];
    [labelContent setTextAlignment:NSTextAlignmentLeft];
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

- (void) setContent:(NSString *)content
{
    self.labelContent.text=content;
}

- (void) setContentColor:(UIColor *)contentColor
{
    _contentColor=contentColor;
    self.labelContent.textColor=contentColor;
}

- (void) setContentFont:(UIFont *)contentFont
{
    _contentFont=contentFont;
    [self.labelContent setFont:contentFont];
}
- (void) setContentAlignment:(NSTextAlignment)contentAlignment
{
    _contentAlignment=contentAlignment;
    [labelContent setTextAlignment:contentAlignment];
}

- (void) setLineNumOfContent:(NSInteger)lineNumOfContent
{
    _lineNumOfContent=lineNumOfContent;
    labelContent.numberOfLines=lineNumOfContent;
}
@end
