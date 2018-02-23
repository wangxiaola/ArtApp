//
//  FeedBackVC.m
//  ShesheDa
//
//  Created by chen on 16/8/2.
//  Copyright © 2016年 上海翔汇网络有限公司. All rights reserved.
//

#import "FeedBackVC.h"

@interface FeedBackVC (){
    HTextView *txtView;
}

@end

@implementation FeedBackVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title=@"意见反馈";
    UIBarButtonItem *rightBar=[[UIBarButtonItem alloc]initWithTitle:@"提交" style:UIBarButtonItemStyleDone target:self action:@selector(rightBar_Click)];
    self.navigationItem.rightBarButtonItem=rightBar;
}

- (void) createView:(UIView*)contentView{
    txtView=[[HTextView alloc]init];
    txtView.placeholder=@"请输入意见反馈";
    txtView.textColor=kTitleColor;
    txtView.font=kFont(15);
    txtView.backgroundColor=kWhiteColor;
    txtView.borderWidth=HViewBorderWidthMake(1,0,1,0);
    txtView.borderColor=kLineColor;
    [contentView addSubview:txtView];
    [txtView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(contentView);
        make.top.equalTo(contentView).offset(30);
        make.height.mas_equalTo(150);
    }];
}

//提交按钮点击事件
-(void)rightBar_Click{
    [self hideKeyBoard];
    if (![self isLogin]) {
        return ;
    }
    
    if ([self showCheckErrorHUDWithTitle:@"意见反馈不能为空" SubTitle:nil checkTxtField:(HTextField *)txtView]) {
        return ;
    }
    
    NSDictionary *dicAll=@{@"uid":[Global sharedInstance].userID?:@"0",
                           @"message":txtView.text,
                           @"fromapp":@"ios"} ;
    
    [self showLoadingHUDWithTitle:@"正在提交意见..." SubTitle:nil];
    HHttpRequest* request = [HHttpRequest new];
    [request httpPostRequestWithActionName:@"feedback"
                               andPramater:dicAll
                      andDidDataErrorBlock:^(NSURLSessionTask* operation, id responseObject) {
                          [self.hudLoading hide:YES];
                          ResultModel *result=[ResultModel objectWithKeyValues:responseObject];
                          [self showErrorHUDWithTitle:result.msg SubTitle:nil Complete:nil];
                      }
                 andDidRequestSuccessBlock:^(NSURLSessionTask* operation, id responseObject) {
                     [self.hudLoading hide:YES];
                     [self showOkHUDWithTitle:@"提交成功" SubTitle:nil Complete:^{
                         [self.navigationController popViewControllerAnimated:YES];
                     }];
                 }
                  andDidRequestFailedBlock:^(NSURLSessionTask* operation, NSError* error) {
                      [self.hudLoading hide:YES];
                  }];
    
}

@end
