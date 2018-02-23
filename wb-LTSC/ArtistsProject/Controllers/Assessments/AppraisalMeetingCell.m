//
//  AppraisalMeetingCell.m
//  ShesheDa
//
//  Created by chen on 16/7/12.
//  Copyright © 2016年 上海翔汇网络有限公司. All rights reserved.
//

#import "AppraisalMeetingCell.h"

@implementation AppraisalMeetingCell{
    UIImageView *imgTitle;
    HLabel *lblTitle,*lblState;
    HLabel *lblTime,*lblPlace,*lblBaoNumber,*lblFeeNumber;
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
    imgTitle=[[UIImageView alloc]init];
    imgTitle.layer.masksToBounds=YES;
    imgTitle.layer.cornerRadius=3;
    [self addSubview:imgTitle];
    [imgTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self).offset(15);
        make.width.height.mas_equalTo(70);
    }];
    
    lblTitle=[[HLabel alloc]init];
    lblTitle.textColor=kTitleColor;
    lblTitle.font=kFont(15);
    [self addSubview:lblTitle];
    [lblTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imgTitle);
        make.left.equalTo(imgTitle.mas_right).offset(15);
        make.right.equalTo(self).offset(-30);
    }];
    
    lblTime=[[HLabel alloc]init];
    lblTime.textColor=kTitleColor;
    lblTime.font=kFont(13);
    [self addSubview:lblTime];
    [lblTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lblTitle.mas_bottom).offset(5);
        make.left.equalTo(imgTitle.mas_right).offset(15);
        make.right.equalTo(self).offset(-30);
    }];
    
    lblPlace=[[HLabel alloc]init];
    lblPlace.textColor=kTitleColor;
    lblPlace.font=kFont(13);
    [self addSubview:lblPlace];
    [lblPlace mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lblTime.mas_bottom).offset(5);
        make.left.equalTo(imgTitle.mas_right).offset(15);
        make.right.equalTo(self).offset(-30);
    }];
    
    lblBaoNumber=[[HLabel alloc]init];
    lblBaoNumber.textColor=ColorHex(@"777777");
    lblBaoNumber.font=kFont(12);
    [self addSubview:lblBaoNumber];
    [lblBaoNumber mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lblPlace.mas_bottom).offset(5);
        make.left.equalTo(imgTitle.mas_right).offset(15);
    }];
    
    lblFeeNumber=[[HLabel alloc]init];
    lblFeeNumber.textColor=ColorHex(@"777777");
    lblFeeNumber.font=kFont(12);
    [self addSubview:lblFeeNumber];
    [lblFeeNumber mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lblPlace.mas_bottom).offset(5);
        make.right.equalTo(self).offset(-30);
    }];
    
    //向右的箭头
    UIImageView *imgRight=[[UIImageView alloc]init];
    imgRight.image=[UIImage imageNamed:@"icon_HComboBox_right"];
    [self addSubview:imgRight];
    [imgRight mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.equalTo(self).offset(-5);
        make.width.height.mas_equalTo(15);
    }];
    
    //状态
    lblState=[[HLabel alloc]init];
    lblState.backgroundColor=ColorHexA(@"FFFFFF", 0.9);
    lblState.textAlignment=NSTextAlignmentCenter;
    lblState.font=kFont(12);
    [imgTitle addSubview:lblState];
    [lblState mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(imgTitle);
        make.height.mas_equalTo(15);
    }];
}

-(void)setModel:(ExpertAppointmentModel *)model{
    _model=model;
    [imgTitle sd_setImageWithURL:[NSURL URLWithString:model.image] placeholderImage:[UIImage imageNamed:@"icon_Default_headProtrait"]];
    lblTitle.text=model.name;
    lblTime.text=[NSString stringWithFormat:@"时间 :%@-%@",[self changeTime:model.stime],[self changeTime:model.etime]];
    lblPlace.text=[NSString stringWithFormat:@"城市 :%@",model.location];
//    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"报名 :%@人",model.signall]];
//    [AttributedStr addAttribute:NSForegroundColorAttributeName
//                          value:ColorHex(@"c09256")
//                          range:NSMakeRange(4, model.signall.length)];
//    lblBaoNumber.attributedText = AttributedStr;
    
//    NSMutableAttributedString *AttributedStr1 = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"费用 :%@元",model.price]];
//    [AttributedStr1 addAttribute:NSForegroundColorAttributeName
//                           value:ColorHex(@"c09256")
//                           range:NSMakeRange(4, model.price.length)];
//    lblFeeNumber.attributedText = AttributedStr1;
    switch (model.status.intValue) {//1-活动未开始 2-活动进行中 3-活动已结束
        case 1:{
            lblState.text=@"报名中";
            lblState.textColor=kTitleColor;
        }break;
        case 2:{
            lblState.text=@"进行中";
            lblState.textColor=ColorHex(@"00A600");
        }break;
        case 3:{
            lblState.text=@"已结束";
            lblState.textColor=ColorHex(@"EA7500");
        }break;
        default:
            break;
    }
}

-(NSString *)changeTime:(NSString *)time{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY:MM:dd"];
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:time.intValue];
    return [formatter stringFromDate:confromTimesp];
}

@end
