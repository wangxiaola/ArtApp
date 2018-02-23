//
//  CangyouBaomingJiluCell.m
//  ShesheDa
//
//  Created by chen on 16/7/31.
//  Copyright © 2016年 上海翔汇网络有限公司. All rights reserved.
//

#import "CangyouBaomingJiluCell.h"

@implementation CangyouBaomingJiluCell{
    UIImageView *imgTitle;
    HLabel *lblTitle;
    HLabel *lblSubmit,*lblTime;
    HView *viewRed;
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
        make.width.height.mas_equalTo(60);
    }];
    
    lblTitle=[[HLabel alloc]init];
    lblTitle.textColor=kTitleColor;
    lblTitle.font=kFont(15);
    [self addSubview:lblTitle];
    [lblTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imgTitle);
        make.left.equalTo(imgTitle.mas_right).offset(15);
        make.right.equalTo(self).offset(-80);
    }];
    
    lblSubmit=[[HLabel alloc]init];
    lblSubmit.textColor=kSubTitleColor;
    lblSubmit.font=kFont(13);
    [self addSubview:lblSubmit];
    [lblSubmit mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(imgTitle);
        make.left.equalTo(imgTitle.mas_right).offset(15);
        make.right.equalTo(self).offset(-15);
    }];
    
    lblTime=[[HLabel alloc]init];
    lblTime.textColor=kSubTitleColor;
    lblTime.font=kFont(10);
    [self addSubview:lblTime];
    [lblTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imgTitle);
        make.right.equalTo(self).offset(-15);
    }];
}

-(void)setModel:(CangyouBaomingJiluModel *)model{
    _model=model;
    [imgTitle sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@!2b1",model.avatar]] placeholderImage:[UIImage imageNamed:@"icon_Default_Product"]];
    lblTitle.text=model.name;
    lblTime.text=[self changeTime:model.time];
    lblSubmit.text=model.tag;
}

-(NSString *)changeTime:(NSString *)time{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY/MM/dd HH:MM"];
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:time.intValue];
    return [formatter stringFromDate:confromTimesp];
}


@end
