//
//  ZanShangVc.m
//  ArtistsProject
//
//  Created by HELLO WORLD on 2017/4/22.
//  Copyright © 2017年 HELLO WORLD. All rights reserved.
//

#import "ZanShangVc.h"
#import "SIAlertView.h"
#import "RechargeVC.h"
#import "PayViewController.h"

@interface ZanShangVc ()<UITextFieldDelegate>
@property(nonatomic,strong)UIImageView* iconView;
@property(nonatomic,strong)UILabel* nameLabel;
@property(nonatomic,strong)UILabel* tagLabel;
@property(nonatomic,strong)UITextField* moneyField;
@end

@implementation ZanShangVc
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

}
-(void)createView{
    [super createView];
    _iconView = [[UIImageView alloc] init];
    _iconView.layer.cornerRadius = T_WIDTH(40);
    _iconView.layer.masksToBounds = YES;
    [_iconView sd_setImageWithUrlStr:[NSString stringWithFormat:@"%@!120a",self.iconStr] tempTmage:@"temp_Default_headProtrait"];
    [self.view addSubview:_iconView];
    [_iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.mas_offset(40);
        make.size.mas_equalTo(CGSizeMake(T_WIDTH(80), T_WIDTH(80)));
    }];
    
    _nameLabel = [[UILabel alloc]init];
    _nameLabel.text = self.userName;
    _nameLabel.textColor = kColor3;
    _nameLabel.textAlignment = NSTextAlignmentCenter;
    _nameLabel.font = ART_FONT(ARTFONT_OZ);
    [self.view addSubview:_nameLabel];
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(_iconView.mas_bottom).offset(10);
        make.size.mas_equalTo(CGSizeMake(100, 20));
    }];
    
    _tagLabel = [[UILabel alloc]init];
    _tagLabel.text = self.tagStr;
    _tagLabel.textAlignment = NSTextAlignmentCenter;
    _tagLabel.textColor = kColor3;
    _tagLabel.font = ART_FONT(ARTFONT_OZ);
    [self.view addSubview:_tagLabel];
    [_tagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(_nameLabel.mas_bottom).offset(10);
        make.size.mas_equalTo(CGSizeMake(100, 20));
    }];
    
    NSArray* titleArr = @[@"2元",@"8元",@"16元",@"32元",@"64元",@"128元"];
    CGFloat btnWidth = (SCREEN_WIDTH-15*2-5*2)/3;
    for (int i=0; i<6; i++) {
        UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = 100+i;
        btn.layer.cornerRadius = 5;
        btn.layer.borderWidth = 2;
        btn.layer.borderColor = [RGB(227, 78, 79) CGColor];
        [btn setTitleColor:RGB(227, 78, 79) forState:UIControlStateNormal];
        [btn setTitle:titleArr[i] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view).offset((i%3)*(btnWidth+5)+15);
            make.top.equalTo(_tagLabel.mas_bottom).offset((i/3)*(T_WIDTH(40)+10)+T_WIDTH(60));
            make.size.mas_equalTo(CGSizeMake(btnWidth, T_WIDTH(40)));
        }];
    }
    
    _moneyField = [[UITextField alloc]init];
    _moneyField.delegate = self;
    _moneyField.textAlignment = NSTextAlignmentCenter;
    _moneyField.font =  ART_FONT(ARTFONT_OFI);
    _moneyField.backgroundColor = BACK_CELL_COLOR;
    _moneyField.placeholder = @"请输入金额";
    _moneyField.keyboardType = UIKeyboardTypeNumberPad;
    [self.view addSubview:_moneyField];
    [_moneyField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(_tagLabel.mas_bottom).offset((5/3)*(T_WIDTH(40)+10)+T_WIDTH(60)+T_WIDTH(60));
        make.size.mas_equalTo(CGSizeMake(T_WIDTH(120), T_WIDTH(30)));
    }];
    
    UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"确定" forState:UIControlStateNormal];
    [btn setTitleColor:RGB(50, 150, 250) forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(sureClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(_moneyField.mas_bottom).offset(20);
        make.size.mas_equalTo(CGSizeMake(T_WIDTH(60), T_WIDTH(35)));
    }];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
-(void)sureClick{
    if ((_moneyField.text.length>0)&&![_moneyField.text isEqualToString:@"请输入金额"]) {
        PayViewController *vc=[[PayViewController alloc]init];
        vc.whichControl = self.whichControl;
        vc.type = @"5";
        vc.payId = self.topicId;
        vc.money = _moneyField.text;
        vc.navTitle=@"赞赏";
        [self.navigationController pushViewController:vc animated:YES];
        
    }else{
        [self showErrorHUDWithTitle:@"金额不能为空" SubTitle:nil Complete:nil];
    }
}
-(void)btnClick:(UIButton*)send{
    NSArray* titleArr = @[@"2",@"8",@"16",@"32",@"64",@"128"];
    NSInteger index = send.tag - 100;
    NSString* moneyStr = titleArr[index];
    _moneyField.text = moneyStr;
}
@end
