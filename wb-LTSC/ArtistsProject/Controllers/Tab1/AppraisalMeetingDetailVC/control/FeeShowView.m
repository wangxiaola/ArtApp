//
//  FeeShowView.m
//  ShesheDa
//
//  Created by chen on 16/7/31.
//  Copyright © 2016年 上海翔汇网络有限公司. All rights reserved.
//

#import "FeeShowView.h"

@implementation FeeShowView{
    HLabel *lblFee;
}

- (id)init{
    
    if ([super init]) {
        [self createView];
        self.backgroundColor=[UIColor colorWithHexString:@"000000" alpha:0.3];
    }
    return self;
}

//
-(void)createView{
    self.backgroundColor=ColorHexA(@"f6f6f6", 0.3);
    HView *viewBG=[[HView alloc]init];
    viewBG.backgroundColor=kWhiteColor;
    [self addSubview:viewBG];
    [viewBG mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self).offset(kScreenH/4);
        make.width.mas_equalTo(kScreenW/3*2);
        make.height.mas_equalTo(kScreenH/2);
    }];
    
    HLabel *lblFeeTip=[[HLabel alloc]init];
    lblFeeTip.textColor=[UIColor blackColor];
    lblFeeTip.text=@"说明";
    lblFeeTip.font=kFont(20);
    lblFeeTip.numberOfLines=0;
    [viewBG addSubview:lblFeeTip];
    [lblFeeTip mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(viewBG);
        make.left.equalTo(viewBG).offset(25);
        make.top.equalTo(viewBG).offset(35);
    }];
    
    lblFee=[[HLabel alloc]init];
    lblFee.textColor=kTitleColor;
    lblFee.font=kFont(14);
    lblFee.numberOfLines=0;
    [viewBG addSubview:lblFee];
    [lblFee mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(viewBG);
        make.left.equalTo(viewBG).offset(25);
        make.top.equalTo(lblFeeTip.mas_bottom).offset(40);
    }];
    
    self.userInteractionEnabled=YES;
    UITapGestureRecognizer *tapSelf=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapSelf_Click)];
    [self addGestureRecognizer:tapSelf];
}

-(void)tapSelf_Click{
    self.hidden=YES;
}

-(void)setFee:(NSString *)fee{
    _fee=fee;
    lblFee.text=fee;
}
@end
