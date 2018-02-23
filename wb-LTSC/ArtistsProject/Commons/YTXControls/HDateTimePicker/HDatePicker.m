//
//  HDatePicker.m
//  logistics
//
//  Created by HeLiulin on 15/12/26.
//  Copyright © 2015年 XICHUNZHAO. All rights reserved.
//

#import "HDatePicker.h"

@implementation HDatePicker{
    UIDatePicker *datePicker;
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    [self.view setFrame:CGRectMake(0, 0, kScreenW, 200)];
    self.navItem.title=@"时间选择";
    
    
    datePicker = [UIDatePicker new];
    datePicker.timeZone = [NSTimeZone systemTimeZone];
    [self.view addSubview:datePicker];
    [datePicker mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navBar.mas_bottom);
        make.left.and.right.and.bottom.equalTo(self.view);
    }];
    datePicker.backgroundColor=[UIColor whiteColor];
//    NSLocale *datelocale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
//    datePicker.locale = datelocale;
//    datePicker.timeZone = [NSTimeZone timeZoneWithName:@"GMT"];
    datePicker.datePickerMode = UIDatePickerModeDate;
//    datePicker.minimumDate=[NSDate date];
    
    UIBarButtonItem *btn3=[[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(ok)];
    [btn3 setTitleTextAttributes:self.dicBarItemAttr forState:UIControlStateNormal];
    self.navItem.rightBarButtonItems=@[btn3];
}

/**
 *  确定
 */
- (void) ok
{
    if (self.finishSelectedBlock){
        self.finishSelectedBlock(@[HKeyValuePair([datePicker.date formatWithString:@"yyyy-MM-dd"], [datePicker.date formatWithString:@"yyyy年MM月dd日"])]);
        [self dismiss];
    }
}

@end
