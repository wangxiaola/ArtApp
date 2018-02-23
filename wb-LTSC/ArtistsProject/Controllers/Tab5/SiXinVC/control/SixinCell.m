//
//  SixinCell.m
//  ShesheDa
//
//  Created by chen on 16/8/1.
//  Copyright © 2016年 上海翔汇网络有限公司. All rights reserved.
//

#import "SixinCell.h"

@implementation SixinCell

{
    UIImageView *imgTitle,*imgTitle2;
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
    imgTitle.layer.cornerRadius=30;
    [self addSubview:imgTitle];
    [imgTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(10);
        make.left.equalTo(self).offset(15);
        make.width.height.mas_equalTo(60);
    }];
    
    lblTitle=[[HLabel alloc]init];
    lblTitle.textColor=kTitleColor;
    lblTitle.font=kFont(15);
    lblTitle.numberOfLines=0;
    [self addSubview:lblTitle];
    [lblTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imgTitle);
        make.left.equalTo(imgTitle.mas_right).offset(15);
        make.right.equalTo(self).offset(-80);
    }];
    
    lblSubmit=[[HLabel alloc]init];
    lblSubmit.textColor=kSubTitleColor;
    lblSubmit.font=kFont(13);
    lblSubmit.numberOfLines=0;
    [self addSubview:lblSubmit];
    [lblSubmit mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lblTitle.mas_bottom).offset(20);
        make.left.equalTo(imgTitle.mas_right).offset(15);
        make.right.equalTo(self).offset(-80);
    }];
    
    imgTitle2=[[UIImageView alloc]init];
    imgTitle2.layer.masksToBounds=YES;
    imgTitle2.layer.cornerRadius=30;
    [self addSubview:imgTitle2];
    [imgTitle2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(10);
        make.right.equalTo(self).offset(-15);
        make.width.height.mas_equalTo(60);
    }];
}

-(NSString *)changeTime:(NSString *)time{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY/MM/dd HH:MM:SS"];
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:time.intValue];
    return [formatter stringFromDate:confromTimesp];
}


-(void)setModel:(SixinModel *)model{
    _model=model;
    if (!model.msgfromid) {
        [imgTitle mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(1);
        }];
        imgTitle.hidden=YES;
        lblTitle.text=model.msg;
        lblSubmit.text=[self changeTime:model.dateline];
        return ;
    }
    
    lblTitle.text=model.message;
    lblSubmit.text=[self changeTime:model.dateline];
    if ([model.user.uid isEqualToString:[Global sharedInstance].userID]) {
        [imgTitle2 sd_setImageWithURL:[NSURL URLWithString:model.user.avatar] placeholderImage:[UIImage imageNamed:@"icon_Default_Product"]];
        lblTitle.textAlignment=NSTextAlignmentRight;
        lblSubmit.textAlignment=NSTextAlignmentRight;
    }else{
       [imgTitle sd_setImageWithURL:[NSURL URLWithString:model.user.avatar] placeholderImage:[UIImage imageNamed:@"icon_Default_Product"]];
        lblTitle.textAlignment=NSTextAlignmentLeft;
        lblSubmit.textAlignment=NSTextAlignmentLeft;
    }
}

@end
