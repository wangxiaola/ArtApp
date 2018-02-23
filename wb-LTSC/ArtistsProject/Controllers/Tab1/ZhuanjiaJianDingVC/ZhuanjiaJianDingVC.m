//
//  ZhuanjiaJianDingVC.m
//  ShesheDa
//
//  Created by chen on 16/8/1.
//  Copyright © 2016年 上海翔汇网络有限公司. All rights reserved.
//

#import "ZhuanjiaJianDingVC.h"
#import "STextFieldWithTitle.h"
#import "TextVC.h"

@interface ZhuanjiaJianDingVC (){
    STextFieldWithTitle *txtBirthday,*txtPlace,*txtSign1;
    HTextView *txtView;
}

@end

@implementation ZhuanjiaJianDingVC

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.navigationController.navigationBar setTranslucent:NO];
    self.navigationItem.title=@"鉴定结果";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void) createView:(UIView*)contentView{
    //绑定手机号
    __block typeof (self) weakSelf = self;
    txtBirthday=[[STextFieldWithTitle alloc]init];
    __weak __typeof(STextFieldWithTitle *) weakTxtBirthday=txtBirthday;
    txtBirthday.title=@"结果";
    txtBirthday.isBottom=NO;
    txtBirthday.headLineWidth=0;
    txtBirthday.didTapBlock = ^(){
        HSingleCategoryChoiceVC *vc=[[HSingleCategoryChoiceVC alloc] init];
        NSMutableArray *itemSex= [[NSMutableArray alloc] initWithCapacity:0];
        [itemSex addObject:HKeyValuePair(@"1", @"真")];
        [itemSex addObject:HKeyValuePair(@"2", @"伪")];
        [itemSex addObject:HKeyValuePair(@"3", @"无法鉴定")];
        vc.items=itemSex;
        
        vc.numberOfColumns=1;
        vc.navTitle=@"请选择类别";
        vc.disabledClear=YES;
        [vc setFinishSelectedBlock:^(NSArray<HKeyValuePair*> *selectItems) {
            weakTxtBirthday.submit=selectItems[0].displayText;
            weakTxtBirthday.strTag=selectItems[0].value;
        }];
        [weakSelf presentSemiViewController:vc];
    };
    [contentView addSubview:txtBirthday];
    [txtBirthday mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(contentView);
        make.top.equalTo(contentView).offset(20);
        make.height.mas_equalTo(45);
    }];
    
       //地区
    txtPlace=[[STextFieldWithTitle alloc]init];
    __weak __typeof(STextFieldWithTitle *) weakTxtPlace=txtPlace;
    txtPlace.title=@"年代";
    txtPlace.isBottom=NO;
    txtPlace.headLineWidth=0;
    txtPlace.didTapBlock=^(){
        TextVC *viewText = [[TextVC alloc] init];
        viewText.navTitle =@"年代";
        viewText.placeholder = @"请输入年代";
        viewText.maxLength = 50;
        viewText.checkTips = @"年代不能为空";
        viewText.isMultiLine = NO;
        viewText.isBack=YES;
        [viewText setSaveBtnCilck:^(NSString * name) {
            weakTxtPlace.submit=name;
        }];
        [weakSelf.navigationController pushViewController:viewText animated:YES];
    };
    [contentView addSubview:txtPlace];
    [txtPlace mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(contentView);
        make.top.equalTo(txtBirthday.mas_bottom);
        make.height.mas_equalTo(45);
    }];
    
    //个性签名
    txtSign1=[[STextFieldWithTitle alloc]init];
    __weak __typeof(STextFieldWithTitle *) weakTxtSign1=txtSign1;
    txtSign1.title=@"估价";
    txtSign1.isBottom=NO;
    txtSign1.headLineWidth=0;
    txtSign1.didTapBlock=^(){
        TextVC *viewText = [[TextVC alloc] init];
        viewText.navTitle =@"估价";
        viewText.placeholder = @"请输入您的估价";
        viewText.maxLength = 200;
        viewText.checkTips = @"估价不能为空";
        viewText.isMultiLine = NO;
        viewText.isBack=YES;
        [viewText setSaveBtnCilck:^(NSString * name) {
            weakTxtSign1.submit=name;
        }];
        [weakSelf.navigationController pushViewController:viewText animated:YES];
    };
    [contentView addSubview:txtSign1];
    [txtSign1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(contentView);
        make.top.equalTo(txtPlace.mas_bottom);
        make.height.mas_equalTo(45);
    }];
    txtSign1.borderColor=kLineColor;
    txtSign1.borderWidth=HViewBorderWidthMake(0, 0, 1, 0);
    
    //备注
    txtView=[[HTextView alloc]init];
    txtView.placeholder=@"请输入评语";
    txtView.font=kFont(15);
    txtView.textColor=kTitleColor;
    txtView.backgroundColor=kWhiteColor;
    [contentView addSubview:txtView];
    [txtView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(contentView);
        make.top.equalTo(txtSign1.mas_bottom);
        make.height.mas_equalTo(150);
    }];
    txtView.borderColor=kLineColor;
    txtView.borderWidth=HViewBorderWidthMake(0, 0, 1, 0);
    
    //提交按钮
    HButton *btnTijiao=[[HButton alloc]init];
    [btnTijiao setTitle:@"提交" forState:UIControlStateNormal];
    [btnTijiao setTitleColor:kTitleColor forState:UIControlStateNormal];
    btnTijiao.titleLabel.font=kFont(14);
    btnTijiao.backgroundColor=kWhiteColor;
    btnTijiao.layer.borderColor=kLineColor.CGColor;
    btnTijiao.layer.borderWidth=1;
    btnTijiao.layer.masksToBounds=YES;
    btnTijiao.layer.cornerRadius=5;
    [btnTijiao addTarget:self action:@selector(btnTijiao_Click) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:btnTijiao];
    [btnTijiao mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(contentView);
        make.top.equalTo(txtView.mas_bottom).offset(50);
        make.width.mas_equalTo(70);
        make.height.mas_equalTo(30);
    }];
}

-(void)btnTijiao_Click{
    if (txtBirthday.strTag.length<1) {
        [self showErrorHUDWithTitle:@"请选择鉴定结果" SubTitle:nil Complete:nil];
        return;
    }
    
    if (txtPlace.submit.length<1) {
        [self showErrorHUDWithTitle:@"请输入年代" SubTitle:nil Complete:nil];
        return ;
    }
    if (txtSign1.submit.length<1) {
        [self showErrorHUDWithTitle:@"请输入估价" SubTitle:nil Complete:nil];
        return ;
    }
    [self showLoadingHUDWithTitle:@"正在提交鉴定结果" SubTitle:nil];
    NSDictionary *dict = @{@"replyuid":[Global sharedInstance].userID,
                           @"topicid":self.uID,
                           @"status":txtBirthday.strTag,
                           @"age":txtPlace.submit,
                           @"price":txtSign1.submit,
                           @"pingyu":txtView.text?:@""};
    //    //2.开始请求
    HHttpRequest *request = [[HHttpRequest alloc] init];
    [request httpPostRequestWithActionName:@"authtopic" andPramater:dict andDidDataErrorBlock:^(NSURLSessionTask *operation, id responseObject) {
        [self.hudLoading hide:YES];
        ResultModel *result=[ResultModel objectWithKeyValues:responseObject];
        [self showErrorHUDWithTitle:result.msg SubTitle:nil Complete:nil];
    } andDidRequestSuccessBlock:^(NSURLSessionTask *operation, id responseObject) {
        [self.hudLoading hide:YES];
        [self.navigationController popViewControllerAnimated:YES];
    } andDidRequestFailedBlock:^(NSURLSessionTask *operation, NSError *error) {
        [self.hudLoading hide:YES];
    }];
}

@end
