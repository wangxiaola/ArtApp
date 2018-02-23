//
//  MessageCell.m
//  ShesheDa
//
//  Created by chen on 16/7/9.
//  Copyright © 2016年 上海翔汇网络有限公司. All rights reserved.
//

#import "MessageCell.h"

@implementation MessageCell{
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
    
    viewRed=[[HView alloc]init];
    viewRed.layer.masksToBounds=YES;
    viewRed.layer.cornerRadius=5;
    viewRed.backgroundColor=kRedColor;
    [self addSubview:viewRed];
    [viewRed mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imgTitle).offset(-4);
        make.width.height.mas_equalTo(10);
        make.right.equalTo(imgTitle).offset(4);
    }];
    viewRed.hidden=YES;
}

-(void)setModel:(MessageModel *)model{
    _model=model;
    if (model.fromuser) {
        if ([model.fromuser.uid isEqualToString:[Global sharedInstance].userID]) {
            [imgTitle sd_setImageWithURL:[NSURL URLWithString:model.touser.avatar] placeholderImage:[UIImage imageNamed:@"icon_Default_Product"]];
            lblTitle.text=model.touser.username;
            lblTime.text=[self changeTime:model.time];
            lblSubmit.text=model.message;
        }else{
            [imgTitle sd_setImageWithURL:[NSURL URLWithString:model.fromuser.avatar] placeholderImage:[UIImage imageNamed:@"icon_Default_Product"]];
            lblTitle.text=model.fromuser.username;
            lblTime.text=[self changeTime:model.time];
            lblSubmit.text=model.message;
        }
    }else{
        imgTitle.image=[UIImage imageNamed:@"icon_message_system"];
        lblTitle.text=@"系统消息";
        lblTime.text=[self changeTime:model.time];
        lblSubmit.text=model.message;
        viewRed.hidden=NO;
    }

}

-(NSString *)changeTime:(NSString *)time{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY/MM/dd"];
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:time.intValue];
    return [formatter stringFromDate:confromTimesp];
}

@end
