//
//  orderDetailView.m
//  ShesheDa
//
//  Created by XICHUNZHAO on 15/12/22.
//  Copyright © 2015年 上海翔汇网络有限公司. All rights reserved.
//

#import "orderDetailView.h"
@interface orderDetailView () {
    HLine* lineTop;
    UIImageView* imgRightCell;
}
@property (nonatomic, strong) HLabel* labelTitle;
@property (nonatomic, strong) HLabel* labelContent;

@end

@implementation orderDetailView
@synthesize labelTitle;
@synthesize labelContent;

- (id)init
{
    self = [super init];
    if (self) {
        [self customInit];
    }
    return self;
}

- (void)customInit
{
    self.backgroundColor = [UIColor whiteColor];

    //顶部横线
    lineTop = [[HLine alloc] init];
    lineTop.lineColor = kLineColor;
    lineTop.lineStyle = UILineStyleHorizon;
    lineTop.lineWidth = 1;
    [self addSubview:lineTop];
    [lineTop mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.equalTo(self).offset(15);
        make.top.and.right.equalTo(self);
        make.height.mas_equalTo(1);
    }];

    labelTitle = [HLabel new];
    [self addSubview:labelTitle];
    [labelTitle mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.equalTo(self).offset(15);
        make.centerY.equalTo(self);
    }];
    [labelTitle setFont:[[Global sharedInstance] fontWithSize:14]];
    [labelTitle setTextColor:kColor7];

    labelContent = [HLabel new];
    [self addSubview:labelContent];
    [labelContent mas_makeConstraints:^(MASConstraintMaker* make) {
        make.right.equalTo(self).offset(-25);
        make.centerY.equalTo(self);
    }];
    [labelContent setTextColor:kColor7];
    [labelContent setFont:[[Global sharedInstance] fontWithSize:15]];
    [labelContent setTextAlignment:NSTextAlignmentRight];
    labelContent.numberOfLines=0;

    imgRightCell = [[UIImageView alloc] init];
    imgRightCell.hidden = YES;
    [self addSubview:imgRightCell];
    [imgRightCell mas_makeConstraints:^(MASConstraintMaker* make) {
        make.centerY.equalTo(self);
        make.right.equalTo(self).offset(-10);
    }];

    self.userInteractionEnabled = YES;
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap_Click)];
    [self addGestureRecognizer:tap];
}

- (void)tap_Click
{
    if (self.didTapBlock) {
        self.didTapBlock();
    }
}

- (void)setTitle:(NSString*)title
{
    _title = title;
    self.labelTitle.text = title;
}

- (void)setContent:(NSString*)content
{
    self.labelContent.text = content;
}

- (void)setContentColor:(UIColor*)contentColor
{
    _contentColor = contentColor;
    self.labelContent.textColor = contentColor;
}

- (void)setTopLine:(BOOL)topLine
{
    if (!topLine) {
        lineTop.hidden = YES;
    }
}

- (void)setImgRightName:(NSString*)imgRightName
{
    if (imgRightName) {
        imgRightCell.hidden = NO;
        imgRightCell.image = [UIImage imageNamed:imgRightName];
    }
}

- (void)setContentAligent:(NSTextAlignment)contentAligent
{
    [labelContent mas_remakeConstraints:^(MASConstraintMaker* make) {
        make.centerY.equalTo(self);
        make.left.equalTo(labelTitle.mas_right).offset(3);
    }];
}

- (void)setContentFont:(CGFloat)contentFont
{
    _contentFont = contentFont;
    labelContent.font = [[Global sharedInstance] fontWithSize:contentFont];
}

- (void)setLineLeft:(CGFloat)lineLeft
{
    _lineLeft = lineLeft;
    HLine* line = [[HLine alloc] init];
    line.lineWidth = 1;
    line.lineColor = kLineColor;
    line.lineStyle = UILineStyleHorizon;
    [self addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.equalTo(self).offset(lineLeft);
        make.top.and.right.equalTo(self);
        make.height.mas_equalTo(1);
    }];
}

@end
