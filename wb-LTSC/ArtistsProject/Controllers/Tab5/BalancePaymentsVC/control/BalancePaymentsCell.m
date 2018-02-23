//
//  BalancePaymentsCell.m
//  ShesheDa
//
//  Created by chen on 16/7/16.
//  Copyright © 2016年 上海翔汇网络有限公司. All rights reserved.
//

#import "BalancePaymentsCell.h"

@implementation BalancePaymentsCell{
    HLabel *lblTitle;
    HLabel *lblSubmit,*lblTime;
}
//@synthesize img
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createView];
        
        
    }
    return self;
}
-(void)createView{
    lblTitle=[[HLabel alloc]init];
    lblTitle.textColor=[UIColor blackColor];
    lblTitle.font=kFont(15);
    [self addSubview:lblTitle];
    [lblTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_centerY).offset(-3);
        make.left.equalTo(self).offset(15);
        make.right.equalTo(self).offset(-100);
    }];
    
    lblSubmit=[[HLabel alloc]init];
    lblSubmit.textColor=[UIColor blackColor];
    lblSubmit.font=kFont(20);
    [self addSubview:lblSubmit];
    [lblSubmit mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.equalTo(self).offset(-20);
    }];
    
    lblTime=[[HLabel alloc]init];
    lblTime.textColor=kSubTitleColor;
    lblTime.font=kFont(10);
    [self addSubview:lblTime];
    [lblTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_centerY).offset(3);
        make.left.equalTo(lblTitle);
    }];
}

- (void)setModel:(BalancePaymentsModel *)model{
    _model=model;
    lblTitle.text=model.action;
    lblTime.text=[self changeTime:model.ctime];
    lblSubmit.text=[NSString stringWithFormat:@"¥ %.2f",model.coinnum.floatValue/100];//model.detail.coin;
}

- (NSString *)changeTime:(NSString *)time{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:time.intValue];
    return [formatter stringFromDate:confromTimesp];
}


@end
