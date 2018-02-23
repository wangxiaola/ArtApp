//
//  HotShowDatePicker.m
//  meishubao
//
//  Created by 胡亚刚 on 2017/4/19.
//  Copyright © 2017年 benbun. All rights reserved.
//

#import "HotShowDatePicker.h"
#import "GeneralConfigure.h"

static const CGFloat datePickerHeight = 240;
static const CGFloat contentViewHeight = 310;
@interface HotShowDatePicker ()
{
    BOOL _isShow;
}

@property (nonatomic,strong) UIView * contentView;
@property (nonatomic,strong) UIDatePicker * datePicker;

@end

@implementation HotShowDatePicker

-(instancetype)init
{
    if (self = [super init]) {
        CGFloat height = SCREEN_HEIGHT - APP_NAVIGATIONBAR_H - 44;
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, height);
        self.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.5];
        self.clipsToBounds = YES;
        self.alpha = 0;
        
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(close)];
        [self addGestureRecognizer:tap];
        [self uiconfig];
        return self;
    }
    return nil;
}

-(void)uiconfig
{
    [self datePicker];
    _isShow = NO;
}

-(void)showDatePicker:(NSDate *)seleDate position:(CGPoint)position
{
    if (_isShow) {
        [self close];
        return;
    }
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self];
    self.frame = CGRectMake(position.x, position.y, self.width, self.height);
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 1;
        CGRect frame = self.contentView.frame;
        frame.origin.y = 0;
        self.contentView.frame = frame;
    }];
    _isShow = YES;
}

-(void)close
{
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0;
        CGRect frame = self.contentView.frame;
        frame.origin.y = -contentViewHeight;
        self.contentView.frame = frame;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    _isShow = NO;
}

-(void)sureClick
{
    NSString * dateStr;
    NSDateFormatter * format = [[NSDateFormatter alloc] init];
    format.dateFormat = @"yyyy-MM-dd";
    dateStr = [format stringFromDate:self.datePicker.date];
    if (self.block) {
        self.block(dateStr);
        [self close];
    }
}

-(void)returnSelectedDateWithBlock:(returnSelectedDate)block
{
    self.block = block;
}

-(UIView *)contentView
{
    if (!_contentView) {
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, contentViewHeight)];
        _contentView.dk_backgroundColorPicker = DKColorSwiftWithRGB(0xf6f6f6, 0x1c1c1c);
        [self addSubview:_contentView];
        
        NSArray * titles = @[@"年",@"月",@"日"];
        for (int i = 0; i < titles.count; i++) {
            UILabel * label = [UILabel new];
            label.frame = CGRectMake(i * (self.width / 3), 0, self.width / 3, 40);
            label.text = titles[i];
            label.dk_textColorPicker = DKColorPickerWithKey(TEXT);
            label.font = [UIFont systemFontOfSize:12];
            label.textAlignment = NSTextAlignmentCenter;
            [_contentView addSubview:label];
        }
        CALayer * line = [CALayer new];
        line.frame = CGRectMake(15, 40, self.width - 30, 0.5);
        line.dk_backgroundColorPicker = CellLineColor;
        [_contentView.layer addSublayer:line];
        
        UIButton * cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelBtn.frame = CGRectMake(0, contentViewHeight - 30, 60, 30);
        [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [cancelBtn setTitleColor:[UIColor colorWithHex:0xb4232b] forState:UIControlStateNormal];
        cancelBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [cancelBtn addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
        [_contentView addSubview:cancelBtn];
        
        UIButton * sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        sureBtn.frame = CGRectMake(_contentView.width - 60, contentViewHeight - 30, 60, 30);
        [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
        [sureBtn setTitleColor:[UIColor colorWithHex:0xb4232b] forState:UIControlStateNormal];
        sureBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [sureBtn addTarget:self action:@selector(sureClick) forControlEvents:UIControlEventTouchUpInside];
        [_contentView addSubview:sureBtn];
    }
    return _contentView;
}

-(UIDatePicker *)datePicker
{
    if (!_datePicker) {
        _datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 40, self.width, datePickerHeight)];
        
        _datePicker.datePickerMode = UIDatePickerModeDate;
        [_datePicker setValue:[UIColor colorWithHex:0xb4232b] forKey:@"textColor"];
        [self.contentView addSubview:_datePicker];
    }
    return _datePicker;
}

@end
