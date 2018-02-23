//
//  WithdrawalsVC.m
//  ShesheDa
//
//  Created by chen on 16/7/16.
//  Copyright © 2016年 上海翔汇网络有限公司. All rights reserved.
//
#define NUMBERS @"0123456789.\n"
#import "WithdrawalsVC.h"
#import "AuthenticationModel.h"
#import "SIAlertView.h"

@interface WithdrawalsVC ()<UITextFieldDelegate>{
    HLabel *lblBank;
    HTextField *txtMoney;
}

@end

@implementation WithdrawalsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title=@"余额提现";
    [self loadData];
}

-(void)loadData{
    //1.设置请求参数
    [self showLoadingHUDWithTitle:@"正在获取信息" SubTitle:nil];
    NSDictionary *dict = @{@"uid":[Global sharedInstance].userID};
    //    //2.开始请求
    HHttpRequest *request = [[HHttpRequest alloc] init];
    [request httpGetRequestWithActionName:@"getUserAuth" andPramater:dict andDidDataErrorBlock:^(NSURLSessionTask *operation, id responseObject) {
        [self.hudLoading hide:YES];
        ResultModel *result=[ResultModel objectWithKeyValues:responseObject];
        [self showErrorHUDWithTitle:result.msg SubTitle:nil Complete:nil];
    } andDidRequestSuccessBlock:^(NSURLSessionTask *operation, id responseObject) {
        AuthenticationModel* model=[AuthenticationModel objectWithKeyValues:responseObject];
        [self updataView:(AuthenticationModel *)model];
        [self.hudLoading hide:YES];
    } andDidRequestFailedBlock:^(NSURLSessionTask *operation, NSError *error) {
        [self.hudLoading hide:YES];
    }];

}

-(void)updataView:(AuthenticationModel *)model{
    if (model.card.length>4) {
        lblBank.text=[NSString stringWithFormat:@"%@(%@)",model.bank,[model.card substringFromIndex:model.card.length-3]];
    }else{
        lblBank.text=[NSString stringWithFormat:@"%@(%@)",model.bank,model.card];
    }
    

}

//控件放在这个方法里面才有滑动效果
- (void)createView:(UIView *)contentView{
    __weak __typeof(self) weakSelf=self;

    HView *viewWBG=[[HView alloc]init];
    viewWBG.backgroundColor=kWhiteColor;
    [contentView addSubview:viewWBG];
    [viewWBG mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView).offset(20);
        make.top.equalTo(contentView).offset(15);
        make.right.equalTo(contentView).offset(-20);
        make.height.mas_equalTo(200);
    }];
    
    HLabel *lblTitleBank=[[HLabel alloc]init];
    lblTitleBank.text=@"到账银行卡";
    lblTitleBank.textColor=[UIColor blackColor];
    lblTitleBank.font=kFont(18);
    [viewWBG addSubview:lblTitleBank];
    [lblTitleBank mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(viewWBG).offset(15);
        make.top.equalTo(viewWBG).offset(10);
    }];
    
    lblBank=[[HLabel alloc]init];
    lblBank.textColor=ColorHex(@"66B3FF");
    lblBank.font=kFont(18);
    [viewWBG addSubview:lblBank];
    [lblBank mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lblTitleBank.mas_right).offset(25);
        make.top.equalTo(viewWBG).offset(10);
    }];
    
    HLabel *lblTitleBank1=[[HLabel alloc]init];
    lblTitleBank1.text=@"提现金额";
    lblTitleBank1.textColor=[UIColor blackColor];
    lblTitleBank1.font=kFont(16);
    [viewWBG addSubview:lblTitleBank1];
    [lblTitleBank1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(viewWBG).offset(15);
        make.top.equalTo(lblTitleBank.mas_bottom).offset(25);
    }];
    
    HLabel *lblTitleBank2=[[HLabel alloc]init];
    lblTitleBank2.text=@"￥";
    lblTitleBank2.textColor=[UIColor blackColor];
    lblTitleBank2.font=kFont(30);
    [viewWBG addSubview:lblTitleBank2];
    [lblTitleBank2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(viewWBG).offset(15);
        make.top.equalTo(lblTitleBank1.mas_bottom).offset(10);
    }];
    
    txtMoney=[[HTextField alloc]init];
    txtMoney.textColor=[UIColor blackColor];
    txtMoney.delegate=self;
    txtMoney.font=kFont(50);
    [viewWBG addSubview:txtMoney];
    [txtMoney mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lblTitleBank2.mas_right).offset(10);
        make.top.equalTo(lblTitleBank2);
        make.width.mas_equalTo(kScreenW-90);
        make.height.mas_equalTo(50);
    }];
    txtMoney.keyboardType=UIKeyboardTypeDecimalPad;
    txtMoney.clearButtonMode=UITextFieldViewModeWhileEditing;
    [txtMoney becomeFirstResponder];
    
    HLine *line=[[HLine alloc]init];
    line.lineColor=kLineColor;
    line.lineWidth=1;
    line.lineStyle=UILineStyleHorizon;
    [viewWBG addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lblTitleBank2);
        make.right.equalTo(viewWBG).offset(-25);
        make.top.equalTo(txtMoney.mas_bottom).offset(15);
        make.height.mas_equalTo(1);
    }];
    
    HLabel *lblTitleBank3=[[HLabel alloc]init];
    lblTitleBank3.text=[NSString stringWithFormat:@"可用余额:￥%@,",self.strYue];
    lblTitleBank3.textColor=kSubTitleColor;
    lblTitleBank3.font=kFont(15);
    [viewWBG addSubview:lblTitleBank3];
    [lblTitleBank3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lblTitleBank2);
        make.top.equalTo(line.mas_bottom).offset(15);
    }];
    
    HButton *BtnBank=[[HButton alloc]init];
    [BtnBank setTitle:@"全部取现" forState:UIControlStateNormal];
    [BtnBank addTarget:self action:@selector(BtnBank_Click) forControlEvents:UIControlEventTouchUpInside];
    [BtnBank setTitleColor:ColorHex(@"66B3FF") forState:UIControlStateNormal];
    BtnBank.titleLabel.font=kFont(15);
    [viewWBG addSubview:BtnBank];
    [BtnBank mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(lblTitleBank3);
        make.left.equalTo(lblTitleBank3.mas_right).offset(10);
    }];
    
    HLabel *lblTitleBank4=[[HLabel alloc]init];
    lblTitleBank4.text=@"当前24点前到账";
    lblTitleBank4.textColor=kTitleColor;
    lblTitleBank4.font=kFont(15);
    [viewWBG addSubview:lblTitleBank4];
    [lblTitleBank4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(contentView);
        make.top.equalTo(viewWBG.mas_bottom).offset(5);
    }];
    
    HButton *btnChongzhi=[[HButton alloc]init];
    [btnChongzhi setTitle:@"提现" forState:UIControlStateNormal];
    btnChongzhi.titleLabel.font=kFont(16);
    [btnChongzhi addTarget:self action:@selector(btnChongzhi_Click) forControlEvents:UIControlEventTouchUpInside];
    [btnChongzhi setBackgroundImage:[UIImage imageWithColor:ColorHex(@"00A600")] forState:UIControlStateNormal];
    btnChongzhi.layer.masksToBounds=YES;
    btnChongzhi.layer.cornerRadius=5;
    [contentView addSubview:btnChongzhi];
    [btnChongzhi mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(contentView);
        make.left.equalTo(contentView).offset(15);
        make.top.equalTo(lblTitleBank4.mas_bottom).offset(30);
        make.height.mas_equalTo(45);
    }];
}

-(void)btnChongzhi_Click{
    if ([self showCheckErrorHUDWithTitle:@"请输入提现金额" SubTitle:nil checkTxtField:txtMoney]) {
        return ;
    }
    [self hideKeyBoard];
    //1.设置请求参数
    [self showLoadingHUDWithTitle:@"正在提现" SubTitle:nil];
    NSDictionary *dict = @{
                           @"amount":[NSString stringWithFormat:@"%f",txtMoney.text.floatValue]};
    //    //2.开始请求
    HHttpRequest *request = [[HHttpRequest alloc] init];
    [request httpPostRequestWithActionName:@"extractcoin" andPramater:dict andDidDataErrorBlock:^(NSURLSessionTask *operation, id responseObject) {
        [self.hudLoading hideAnimated:YES];
        ResultModel *result=[ResultModel mj_objectWithKeyValues:responseObject];
        [self showErrorHUDWithTitle:result.msg SubTitle:nil Complete:nil];
    } andDidRequestSuccessBlock:^(NSURLSessionTask *operation, id responseObject) {
        SIAlertView *alert=[[SIAlertView alloc] initWithTitle:@"提示" andMessage:@"提现成功"];

        [alert addButtonWithTitle:@"确定" type:SIAlertViewButtonTypeDefault handler:^(SIAlertView *alertView) {
            [self.navigationController popViewControllerAnimated:YES];
        }];
        [alert show];
        [self.hudLoading hideAnimated:YES];
    } andDidRequestFailedBlock:^(NSURLSessionTask *operation, NSError *error) {
        [self.hudLoading hideAnimated:YES];
    }];

}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSCharacterSet *cs;
    cs = [[NSCharacterSet characterSetWithCharactersInString:NUMBERS] invertedSet];
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    BOOL basicTest = [string isEqualToString:filtered];
    if(!basicTest)
    {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"请输入数字"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        return NO;
    }
    //其他的类型不需要检测，直接写入
    return YES;
}

-(void)BtnBank_Click{
    txtMoney.text=[NSString stringWithFormat:@"%@",self.strYue];
}

@end
