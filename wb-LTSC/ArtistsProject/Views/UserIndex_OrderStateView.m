//
//  OrderStateView.m
//  ShesheDa
//
//  Created by XICHUNZHAO on 16/2/19.
//  Copyright © 2016年 上海翔汇网络有限公司. All rights reserved.
//

#import "UserIndex_OrderStateView.h"
#import "JSBadgeView.h"

@implementation UserIndex_OrderStateView{
    HLabel  *lblTitle;
    UIImageView *imgTitle;
    JSBadgeView *viewBadge;
}

-(id)init{
    if (self=[super init]) {
        [self customInit];
    }
    return self;
}

- (void) customInit
{
    //图片
    imgTitle=[[UIImageView alloc]init];
    [self addSubview:imgTitle];
    [imgTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.centerY.equalTo(self).offset(-10);
    }];
    
    //标题
    lblTitle=[[HLabel alloc]init];
    lblTitle.textColor=kWhiteColor;
    lblTitle.font=[[Global sharedInstance]fontWithSize:15];
    [self addSubview:lblTitle];
    [lblTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(imgTitle.mas_bottom).offset(10);
    }];
    
    //点击事件
    self.userInteractionEnabled=YES;
    UITapGestureRecognizer *tapSelf=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapself_Click)];
    [self addGestureRecognizer:tapSelf];
}

-(void)tapself_Click{
    if (self.didTapBlock) {
        self.didTapBlock();
    }
}

-(void)setNumber:(NSString *)number{
    _number=number;
    if ([number intValue]==0) {
        viewBadge.hidden=YES;
    }else{
        viewBadge.hidden=NO;
        viewBadge.badgeText=number;
    }
    
}

-(void)setImage:(NSString *)image{
    _image=image;
    imgTitle.image=[UIImage imageNamed:image];
}

-(void)setTitle:(NSString *)title{
    _title=title;
    lblTitle.text=title;
}

-(void)setTitleColor:(UIColor *)titleColor{
    _titleColor=titleColor;
    lblTitle.textColor=titleColor;
}


@end
