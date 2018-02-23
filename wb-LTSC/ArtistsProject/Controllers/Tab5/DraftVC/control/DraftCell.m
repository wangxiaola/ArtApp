//
//  DraftCell.m
//  ShesheDa
//
//  Created by chen on 16/7/17.
//  Copyright © 2016年 上海翔汇网络有限公司. All rights reserved.
//

#import "DraftCell.h"

@implementation DraftCell{
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

-(void)setDic:(NSDictionary *)dic{
    _dic=dic;
    NSString *strPhoto=[dic objectForKey:@"photos"];
    NSArray *arrayPhoto=[strPhoto componentsSeparatedByString:@","];
    [imgTitle sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@!120",arrayPhoto[0]]] placeholderImage:[UIImage imageNamed:@"icon_Default_Product"]];
    lblTitle.text=[dic objectForKey:@"topictitle"];
    lblTime.text=[dic objectForKey:@"time"];
}

@end
