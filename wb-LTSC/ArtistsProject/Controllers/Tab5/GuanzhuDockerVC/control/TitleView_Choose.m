//
//  TitleView_Choose.m
//  ShesheDa
//
//  Created by chen on 16/8/2.
//  Copyright © 2016年 上海翔汇网络有限公司. All rights reserved.


#import "TitleView_Choose.h"

@implementation TitleView_Choose{
    NSMutableArray *arrayTitleBtn;
    HLine *lineChoose;
}

-(id)init{
    if (self=[super init]) {
        [self customInit];
    }
    return self;
}

- (void) customInit
{
    self.backgroundColor=kWhiteColor;
    
    arrayTitleBtn=[[NSMutableArray alloc]init];
    HLine* lineBottom=[[HLine alloc]init];
    lineBottom.lineWidth=2;
    lineBottom.lineStyle=UILineStyleHorizon;
    [self addSubview:lineBottom];
    [lineBottom mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.bottom.equalTo(self);
        make.height.mas_equalTo(2);
    }];
}

-(void)setArrayTitle:(NSArray *)arrayTitle{
    _arrayTitle=arrayTitle;
    for (int i=0; i<arrayTitle.count; i++) {
        NSString *title=arrayTitle[i];
        UIButton *btnTitle=[[UIButton alloc]init];
        [btnTitle setTitle:title forState:UIControlStateNormal];
        [btnTitle setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btnTitle.titleLabel.font=kFont(15);
        btnTitle.tag=i;
//        btnTitle.backgroundColor=[UIColor whiteColor];
        [btnTitle addTarget:self action:@selector(btnTitle_Click:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btnTitle];
        [btnTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self);
            make.width.mas_equalTo(self.bounds.size.width/_arrayTitle.count);
            make.left.equalTo(self).offset(i*self.bounds.size.width/_arrayTitle.count);
        }];
        [arrayTitleBtn addObject:btnTitle];
        if (i==0) {
            lineChoose=[[HLine alloc]init];
            lineChoose.lineWidth=5;
            lineChoose.lineColor=[UIColor blackColor];
            lineChoose.lineStyle=UILineStyleHorizon;
            [self addSubview:lineChoose];
            [lineChoose mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self);
                make.bottom.equalTo(self);
                make.height.mas_equalTo(5);
                make.width.mas_equalTo(self.bounds.size.width/_arrayTitle.count);
            }];
        }
    }
}
-(void)btnTitle_Click:(UIButton *)btnTitle{
    [lineChoose mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(btnTitle.tag*self.bounds.size.width/_arrayTitle.count);
    }];
    
    if (self.selectBtnCilck) {
        self.selectBtnCilck(btnTitle.tag);
    }
}

-(void)setIClick:(NSInteger)iClick{
    [lineChoose mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(iClick*self.bounds.size.width/_arrayTitle.count);
    }];
}

@end
