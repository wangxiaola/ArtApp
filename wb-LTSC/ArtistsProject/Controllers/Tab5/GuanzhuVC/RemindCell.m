//
//  GuanzhuCell.m
//  ShesheDa
//
//  Created by chen on 16/7/31.
//  Copyright © 2016年 上海翔汇网络有限公司. All rights reserved.
//

#import "RemindCell.h"

@interface RemindCell ()
{
    UIImageView *imgTitle;
    HLabel *lblTitle;
    HLabel *lblSubmit;
    UIImageView *imgRight;
}
@end
@implementation RemindCell

//@synthesize img
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createView];
        
        
    }
    return self;
}
-(void)createView{
    self.backgroundColor=kWhiteColor;
    
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
        make.bottom.equalTo(imgTitle.mas_centerY).offset(-5);
        make.left.equalTo(imgTitle.mas_right).offset(15);
    }];
    
    lblSubmit=[[HLabel alloc]init];
    lblSubmit.textColor=kSubTitleColor;
    lblSubmit.font=kFont(13);
    [self addSubview:lblSubmit];
    [lblSubmit mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imgTitle.mas_centerY).offset(5);
        make.left.equalTo(imgTitle.mas_right).offset(15);
    }];
    
    //向右的箭头
    imgRight=[[UIImageView alloc]init];
    imgRight.image=[UIImage imageNamed:@"checkbox_selected"];
    [self addSubview:imgRight];
    [imgRight mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.equalTo(self).offset(-15);
    }];
}

-(void)setModel:(MessageModel *)model{
    _model=model;
    [imgTitle sd_setImageWithURL:[NSURL URLWithString:model.avatar] placeholderImage:[UIImage imageNamed:@"icon_Default_Product"]];
    lblTitle.text=model.username;
    lblSubmit.text=model.tag;
}



@end
