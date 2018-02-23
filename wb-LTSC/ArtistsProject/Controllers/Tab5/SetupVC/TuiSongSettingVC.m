//
//  TuiSongSettingVC.m
//  ShesheDa
//
//  Created by chen on 16/8/1.
//  Copyright © 2016年 上海翔汇网络有限公司. All rights reserved.
//

#import "TuiSongSettingVC.h"
#import "orderDetailView.h"

@interface TuiSongSettingVC (){
    NSMutableArray *arrayControl;
}
@end

@implementation TuiSongSettingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title=@"消息提醒";
    [self loadData];
}

- (void) createView:(UIView*)contentView{
    arrayControl=[[NSMutableArray alloc]init];
    
    NSArray *arrayTitle=@[@"被@",@"被关注",@"被评论",@"被喜欢",@"每日热点推送",@"私信",@"私信通知",@"新动态提醒",@"鉴定结果"];
    
    for (int i=0; i<arrayTitle.count; i++) {
        NSString *title=arrayTitle[i];
        //关于奢奢哒
       orderDetailView * lblAboutUs1=[[orderDetailView alloc]init];
        lblAboutUs1.title=title;
        [contentView addSubview:lblAboutUs1];
        [lblAboutUs1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(contentView);
            make.top.equalTo(contentView).offset(20+i*40);
            make.height.mas_equalTo(40);
        }];
        lblAboutUs1.borderColor=kLineColor;
        
        if (i==arrayTitle.count-1) {
           lblAboutUs1.borderWidth=HViewBorderWidthMake(1, 0, 1, 0);
        }else{
            lblAboutUs1.borderWidth=HViewBorderWidthMake(1, 0, 0, 0);
        }
        
        UISwitch *switchOm=[[UISwitch alloc]init];
        switchOm.on=YES;
        switchOm.tag=i;
        [contentView addSubview:switchOm];
        [switchOm mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(contentView.mas_top).offset(40+i*40);
            make.right.equalTo(contentView).offset(-15);
        }];
          [switchOm addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
        [arrayControl addObject:switchOm];
    }
}

-(void)loadData{
    //1.设置请求参数
    [self showLoadingHUDWithTitle:@"正在获取数据" SubTitle:nil];
    //2.开始请求
    NSDictionary *dicMoney=@{@"uid":[Global sharedInstance].userID};
    HHttpRequest *request = [[HHttpRequest alloc] init];
    [request httpGetRequestWithActionName:@"msgsetinfo"
                               andPramater:dicMoney
                      andDidDataErrorBlock:^(NSURLSessionTask *operation, id responseObject) {
        [self.hudLoading hide:YES];
                          ResultModel *result=[ResultModel objectWithKeyValues:responseObject];
                          [self showErrorHUDWithTitle:result.msg SubTitle:nil Complete:nil];
    } andDidRequestSuccessBlock:^(NSURLSessionTask *operation, id responseObject) {
        NSArray *arrayQuanxian=@[@"beat",@"beattent",@"becomment",@"belike",@"dayhot",@"private",@"privateset",@"newdynamic",@"jdres"];
        for (int i=0; i<arrayQuanxian.count; i++) {
            NSString *strQuanxin=arrayQuanxian[i];
            NSString *strQuanxianResult=[NSString stringWithFormat:@"%@",[responseObject objectForKey:strQuanxin]];
            UISwitch *switchChoose=arrayControl[i];
            if ([strQuanxianResult isEqualToString:@"0"]) {
                switchChoose.on=NO;
            }else{
               switchChoose.on=YES;
            }
        }
        [self.hudLoading hide:YES];
    } andDidRequestFailedBlock:^(NSURLSessionTask *operation, NSError *error) {
        [self.hudLoading hide:YES];
    }];
}

-(void)switchAction:(id)sender
{
    UISwitch *switchButton = (UISwitch*)sender;
    NSArray *arrayQuanxian=@[@"beat",@"beattent",@"becomment",@"belike",@"dayhot",@"private",@"privateset",@"newdynamic",@"jdres"];
    NSString *strQuanxian=arrayQuanxian[switchButton.tag];
    NSString *strQuanxianDetail=@"0";
    if (switchButton.on) {
        strQuanxianDetail=@"1";
    }
    NSDictionary *dicSave=@{@"type":strQuanxian,
                            @"num":strQuanxianDetail,
                            @"uid":[Global sharedInstance].userID};
    //1.设置请求参数
    [self showLoadingHUDWithTitle:@"正在保存设置" SubTitle:nil];
    HHttpRequest *request = [[HHttpRequest alloc] init];
    [request httpPostRequestWithActionName:@"msgset"
                              andPramater:dicSave
                     andDidDataErrorBlock:^(NSURLSessionTask *operation, id responseObject) {
                         [self.hudLoading hide:YES];
                         ResultModel *result=[ResultModel objectWithKeyValues:responseObject];
                         [self showErrorHUDWithTitle:result.msg SubTitle:nil Complete:nil];
                     } andDidRequestSuccessBlock:^(NSURLSessionTask *operation, id responseObject) {
                         [self.hudLoading hide:YES];
                     } andDidRequestFailedBlock:^(NSURLSessionTask *operation, NSError *error) {
                         [self.hudLoading hide:YES];
                     }];

}

@end
