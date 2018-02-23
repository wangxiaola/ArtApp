//
//  ShouCangCell.m
//  ShesheDa
//
//  Created by chen on 16/8/1.
//  Copyright © 2016年 上海翔汇网络有限公司. All rights reserved.
//

#import "ShouCangCell.h"

@implementation ShouCangCell{
    UIImageView *imgTitle;
    HLabel *lblTitle;
    HLabel *lblTime;
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
    lblTitle.font=kFont(13);
    [self addSubview:lblTitle];
    [lblTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(imgTitle);
        make.left.equalTo(imgTitle.mas_right).offset(15);
        make.right.equalTo(self).offset(-80);
    }];
    
    lblTime=[[HLabel alloc]init];
    lblTime.textColor=kTitleColor;
    lblTime.font=kFont(13);
    [self addSubview:lblTime];
    [lblTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(imgTitle);
        make.right.equalTo(self).offset(-15);
    }];
}

-(void)setModel:(CangyouQuanDetailModel *)model{
    _model=model;
    NSArray *arrayPhoto=[model.photos componentsSeparatedByString:@","];
    if (arrayPhoto.count>0) {
        [imgTitle sd_setImageWithUrlStr:[NSString stringWithFormat:@"%@!450a",arrayPhoto[0]] tempTmage:@"temp_Default_headProtrait"];
    }
    lblTitle.text=model.message;
    lblTime.text=[self changeTime:model.dateline];
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
