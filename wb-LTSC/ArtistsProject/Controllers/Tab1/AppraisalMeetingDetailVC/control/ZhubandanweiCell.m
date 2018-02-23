//
//  ZhubandanweiCell.m
//  ShesheDa
//
//  Created by chen on 16/7/16.
//  Copyright © 2016年 上海翔汇网络有限公司. All rights reserved.
//

#import "ZhubandanweiCell.h"

@implementation ZhubandanweiCell{
    UIImageView *imgTitle;
    HLabel *lblTitle;
    HLabel *lblSubmit;
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
        make.bottom.equalTo(imgTitle.mas_centerY).offset(-3);
        make.left.equalTo(imgTitle.mas_right).offset(15);
        make.right.equalTo(self).offset(-50);
    }];
    
    lblSubmit=[[HLabel alloc]init];
    lblSubmit.textColor=kSubTitleColor;
    lblSubmit.font=kFont(13);
    [self addSubview:lblSubmit];
    [lblSubmit mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imgTitle.mas_centerY).offset(3);
        make.left.equalTo(imgTitle.mas_right).offset(15);
        make.right.equalTo(self).offset(-15);
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
}

-(void)setModel:(ExpertAppointmentZhubandanweiDataModel *)model{
    [imgTitle sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@!2b1",model.avatar]] placeholderImage:[UIImage imageNamed:@"icon_Default_Product"]];
    lblTitle.text=model.username;
    lblSubmit.text=[NSString stringWithFormat:@"成功举办%@场活动,共%@人参加",model.totalevent,model.totalmember];
}

@end
