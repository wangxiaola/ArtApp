//
//  STextFieldWithTitle.h
//  ArtistProject
//
//  Created by HELLO WORLD on 2017/4/19.
//  Copyright © 2017年 HELLO WORLD. All rights reserved.

#import "STextFieldWithTitle.h"

@interface STextFieldWithTitle (){
    UILabel *lblTitle;
    UILabel *lblsubmit;
    UIImageView *imgArrow;
}

@end

@implementation STextFieldWithTitle

-(id)init{
    if (self=[super init]) {
        [self customInit];
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        [self customInit];
    }
    return self;
}

- (void) customInit
{
    self.backgroundColor=[UIColor whiteColor];
    
    lblTitle=[[UILabel alloc]init];
    lblTitle.textColor=kColor3;
    lblTitle.font=[[Global sharedInstance]fontWithSize:15];
    [self addSubview:lblTitle];
    [lblTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self).offset(15);
    }];
    
    lblsubmit=[[HLabel alloc]init];
    lblsubmit.textColor=kColor3;
    lblsubmit.textAlignment=NSTextAlignmentRight;
    lblsubmit.font=[[Global sharedInstance]fontWithSize:15];
    [self addSubview:lblsubmit];
    [lblsubmit mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.equalTo(self).offset(-25);
    }];
    
    //箭头
    imgArrow=[[UIImageView alloc]init];
    [self addSubview:imgArrow];
    [imgArrow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.equalTo(self).offset(-5);
        make.width.height.mas_equalTo(15);
    }];
    
    self.userInteractionEnabled=YES;
    UITapGestureRecognizer *tapClick=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap_Click)];
    [self addGestureRecognizer:tapClick];
}

-(void)setHeadLineWidth:(CGFloat)headLineWidth{
    _headLineWidth=headLineWidth;
    HLine *line=[[HLine alloc]init];
    line.lineColor=kLineColor;
    line.lineStyle=UILineStyleHorizon;
    line.lineWidth=1;
    [self addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.equalTo(self);
        make.height.mas_equalTo(1);
        make.left.equalTo(self).offset(headLineWidth);
    }];
}

-(void)setTitle:(NSString *)title{
    _title=title;
    lblTitle.text=title;
}

-(void)setIsBottom:(BOOL)isBottom{
    _isBottom=isBottom;
    if (isBottom) {
        imgArrow.image=[UIImage imageNamed:@"icon_HComboBox_down"];
    }else{
        imgArrow.image=[UIImage imageNamed:@"icon_HComboBox_right"];
    }
}

-(void)tap_Click{
    
    if (self.didTapBlock) {
        self.didTapBlock();
    }
}

-(void)setSubmit:(NSString *)submit{
    _submit=submit;
    lblsubmit.text=submit;
}

-(void)setIsHideArrow:(BOOL)isHideArrow{
    _isHideArrow=isHideArrow;
    imgArrow.hidden=YES;
    self.userInteractionEnabled=NO;
}

-(void)setSubmitAligent:(NSTextAlignment)submitAligent{
    _submitAligent=submitAligent;
    lblsubmit.textAlignment=submitAligent;
    [lblsubmit mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lblTitle.mas_right).offset(15);
    }];
}

-(void)setSubmitColor:(UIColor *)submitColor{
    _submitColor=submitColor;
    lblsubmit.textColor=submitColor;
}

-(void)setIsMutable:(BOOL)isMutable{
    if (isMutable) {
        lblsubmit.numberOfLines=0;
    }
}

-(void)setIsMutableChage:(BOOL)isMutableChage{
    if (isMutableChage) {
        lblsubmit.numberOfLines=0;
        [lblsubmit mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(15);
            make.width.mas_equalTo(kScreenW-80);
            make.right.equalTo(self).offset(-25);
        }];
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(lblsubmit).offset(15);
        }];
    }
}

-(void)setIsMutableChageShow:(BOOL)isMutableChageShow{
    _isMutableChageShow=isMutableChageShow;
    if (isMutableChageShow) {
        [lblTitle mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(15);
            make.left.equalTo(self).offset(15);
            make.width.mas_equalTo(self.HeightMutableChageShow);
        }];
        
        lblsubmit.numberOfLines=0;
        [lblsubmit mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(15);
            make.left.equalTo(lblTitle.mas_right);
            make.right.equalTo(self).offset(-25);
        }];
        
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(lblsubmit).offset(15);
        }];
        
    }
}

-(void)setSubmitFont:(UIFont *)submitFont{
    lblsubmit.font=submitFont;
}

-(void)setTitleColor:(UIColor *)titleColor{
    lblTitle.textColor=titleColor;
}

@end
