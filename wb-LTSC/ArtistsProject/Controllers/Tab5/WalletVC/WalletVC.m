//
//  WalletVC.m
//  ShesheDa
//
//  Created by chen on 16/7/16.
//  Copyright © 2016年 上海翔汇网络有限公司. All rights reserved.
//

#import "WalletVC.h"
#import "RechargeVC.h"
#import "BalancePaymentsVC.h"
#import "WithdrawalsVC.h"
#import "AuthenticationVC.h"
#import "H5VC.h"

@interface WalletVC (){
    HLabel *lblMoney;
    NSString *strTip;
    NSString *strCoin;
}

@end

@implementation WalletVC

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.navigationController.navigationBar setTranslucent:NO];
    if([[Global sharedInstance] userID]){
        [self loadData];
    }
}

//加载用户信息
- (void) loadData{
    //1.设置请求参数
    [self showLoadingHUDWithTitle:@"正在获取余额信息" SubTitle:nil];
    //2.开始请求
    NSDictionary *dicMoney=@{@"uid":[Global sharedInstance].userID};
    HHttpRequest *request = [[HHttpRequest alloc] init];
    [request httpPostRequestWithActionName:@"coininfo" andPramater:dicMoney andDidDataErrorBlock:^(NSURLSessionTask *operation, id responseObject) {
        [self.hudLoading hideAnimated:YES];
        ResultModel *result = [ResultModel mj_objectWithKeyValues:responseObject];
        [self showErrorHUDWithTitle:result.msg SubTitle:nil Complete:nil];
    } andDidRequestSuccessBlock:^(NSURLSessionTask *operation, id responseObject) {
        lblMoney.text=[NSString stringWithFormat:@"%.2f",[[responseObject objectForKey:@"coin"]floatValue]/100];
        strTip=[responseObject objectForKey:@"text"];
        strCoin=[NSString stringWithFormat:@"%.2f",[[responseObject objectForKey:@"coin"]floatValue]/100];
        [self.hudLoading hideAnimated:YES];
    } andDidRequestFailedBlock:^(NSURLSessionTask *operation, NSError *error) {
        [self.hudLoading hideAnimated:YES];
    }];
}

-(void)viewDidLoad{
    [super viewDidLoad];
    self.navigationItem.title=@"钱包";
    UIBarButtonItem *rightBar=[[UIBarButtonItem alloc]initWithTitle:@"收支明细" style:UIBarButtonItemStyleDone target:self action:@selector(rightBar_Click)];
    self.navigationItem.rightBarButtonItem=rightBar;
}

- (void) createView:(UIView*)contentView{
    UIImageView *imgBG=[UIImageView new];
    imgBG.image=[UIImage imageNamed:@"icon_wallet_BG1"];
    [contentView addSubview:imgBG];
    [imgBG mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(contentView);
        make.top.equalTo(contentView).offset(50);
    }];
    
    HLabel *lblTitle=[[HLabel alloc]init];
    lblTitle.text=@"余额";
    lblTitle.textColor=[UIColor blackColor];
    lblTitle.font=kFont(17);
    [contentView addSubview:lblTitle];
    [lblTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(contentView);
        make.top.equalTo(imgBG.mas_bottom).offset(20);
    }];
    
    lblMoney=[[HLabel alloc]init];
    lblMoney.textColor=[UIColor blackColor];
    lblMoney.font=kFont(25);
    [contentView addSubview:lblMoney];
    [lblMoney mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(contentView);
        make.top.equalTo(lblTitle.mas_bottom).offset(10);
    }];
    
    HButton *btnChongzhi=[[HButton alloc]init];
    [btnChongzhi setTitle:@"充值" forState:UIControlStateNormal];
    btnChongzhi.titleLabel.font=kFont(16);
    [btnChongzhi addTarget:self action:@selector(btnChongzhi_Click) forControlEvents:UIControlEventTouchUpInside];
    [btnChongzhi setBackgroundImage:[UIImage imageWithColor:ColorHex(@"00A600")] forState:UIControlStateNormal];
    btnChongzhi.layer.masksToBounds=YES;
    btnChongzhi.layer.cornerRadius=5;
    [contentView addSubview:btnChongzhi];
    [btnChongzhi mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(contentView);
        make.left.equalTo(contentView).offset(15);
        make.top.equalTo(lblMoney.mas_bottom).offset(30);
        make.height.mas_equalTo(45);
    }];
    
    HButton *btntixian=[[HButton alloc]init];
    [btntixian setTitle:@"提现" forState:UIControlStateNormal];
    btntixian.titleLabel.font=kFont(16);
    [btntixian setBackgroundImage:[UIImage imageWithColor:kWhiteColor] forState:UIControlStateNormal];
    btntixian.layer.masksToBounds=YES;
    [btntixian addTarget:self action:@selector(btntixian_Click) forControlEvents:UIControlEventTouchUpInside];
    [btntixian setTitleColor:kTitleColor forState:UIControlStateNormal];
    btntixian.layer.cornerRadius=5;
    [contentView addSubview:btntixian];
    [btntixian mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(contentView);
        make.left.equalTo(contentView).offset(15);
        make.top.equalTo(btnChongzhi.mas_bottom).offset(20);
        make.height.mas_equalTo(45);
    }];

    
    HButton *btnProblem=[[HButton alloc]init];
    [btnProblem setTitle:@"常见问题" forState:UIControlStateNormal];
    [btnProblem setTitleColor:kTitleColor forState:UIControlStateNormal];
    btnProblem.titleLabel.font=kFont(12);
    [btnProblem addTarget:self action:@selector(btnProblem_Click) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:btnProblem];
    [btnProblem mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(contentView);
        make.top.equalTo(contentView).offset(kScreenH-150);
    }];
}

//分享按钮点击事件
-(void)rightBar_Click{
    BalancePaymentsVC *vc=[[BalancePaymentsVC alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

//充值
-(void)btnChongzhi_Click{
    RechargeVC *vc=[[RechargeVC alloc]init];
    vc.tip=strTip;
//    vc.moneyStr = @"0.01";
    [self.navigationController pushViewController:vc animated:YES];
} 

//提现功能
-(void)btntixian_Click{
    if ([Global sharedInstance].userInfo.auth.intValue==1||
        [Global sharedInstance].userInfo.auth.intValue==2||
        [Global sharedInstance].userInfo.auth.intValue==3||
        [Global sharedInstance].userInfo.auth.intValue==4||
        [Global sharedInstance].userInfo.auth.intValue==5||
        [Global sharedInstance].userInfo.auth.intValue==6) {
        if(strCoin.floatValue<100){
            [self showErrorHUDWithTitle:@"最低提现金额为100元" SubTitle:nil Complete:nil];
            return ;
        }
        
        WithdrawalsVC *vc=[[WithdrawalsVC alloc]init];
        vc.strYue=strCoin;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        AuthenticationVC *auvc=[[AuthenticationVC alloc]init];
        [self.navigationController pushViewController:auvc animated:YES];
    }
}


//常见问题
-(void)btnProblem_Click{
    H5VC *h5=[[H5VC alloc]init];
    h5.navTitle=@"常见问题";
    h5.url=@"http://jianbao.guwanw.com/wallet.html";
    [self.navigationController pushViewController:h5 animated:YES];
}

@end
