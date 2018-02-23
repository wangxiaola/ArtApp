//
//  ExpertAppointmentCell.m
//  ShesheDa
//
//  Created by chen on 16/7/11.
//  Copyright © 2016年 上海翔汇网络有限公司. All rights reserved.
//

#import "ExpertAppointmentCell.h"

@implementation ExpertAppointmentCell{
    UIImageView *imgTitle;
    HLabel *lblTitle;
    HLabel *lblSubmit,*lblBaoNumber,*lblFeeNumber;
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
    
    lblSubmit=[[HLabel alloc]init];
    lblSubmit.textColor=ColorHex(@"777777");
    lblSubmit.font=kFont(13);
    lblSubmit.numberOfLines=2;
    [self addSubview:lblSubmit];
    [lblSubmit mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lblTitle.mas_bottom).offset(5);
        make.left.equalTo(imgTitle.mas_right).offset(15);
        make.right.equalTo(self).offset(-30);
    }];
    
    lblBaoNumber=[[HLabel alloc]init];
    lblBaoNumber.textColor=ColorHex(@"777777");
    lblBaoNumber.font=kFont(12);
    [self addSubview:lblBaoNumber];
    [lblBaoNumber mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lblSubmit.mas_bottom).offset(5);
        make.left.equalTo(imgTitle.mas_right).offset(15);
    }];
    
    lblFeeNumber=[[HLabel alloc]init];
    lblFeeNumber.textColor=ColorHex(@"777777");
    lblFeeNumber.font=kFont(12);
    [self addSubview:lblFeeNumber];
    [lblFeeNumber mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lblSubmit.mas_bottom).offset(5);
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

}

-(void)setModel:(ExpertAppointmentModel *)model{
    _model=model;
    [imgTitle sd_setImageWithURL:[NSURL URLWithString:model.image] placeholderImage:[UIImage imageNamed:@"temp_Default_headProtrait"]];
    lblTitle.text=model.name;
    lblSubmit.text=model.content;
    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"报名 :%@人",model.signall]];
    [AttributedStr addAttribute:NSForegroundColorAttributeName
                          value:ColorHex(@"c09256")
                          range:NSMakeRange(4, model.signall.length)];
    lblBaoNumber.attributedText = AttributedStr;
    
    NSMutableAttributedString *AttributedStr1 = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"费用 :%@元",model.price]];
    [AttributedStr1 addAttribute:NSForegroundColorAttributeName
                          value:ColorHex(@"c09256")
                          range:NSMakeRange(4, model.price.length)];
    lblFeeNumber.attributedText = AttributedStr1;
}
@end
