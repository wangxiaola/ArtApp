//
//  SetupVC.m
//  ShesheDa
//
//  Created by XICHUNZHAO on 15/12/22.
//  Copyright © 2015年 上海翔汇网络有限公司. All rights reserved.
//

#import "SetupVC.h"
#import "orderDetailView.h"
#import "LogonVc.h"
#import "TuiSongSettingVC.h"
#import "FeedBackVC.h"
//#import "UMessage.h"
#import "H5VC.h"
#import "AppDelegate.h"
#import "CategoryInfoModel.h"


@interface SetupVC (){
    orderDetailView *lblClearBuffer,*lblCustomerService,*lblAboutUs,*lblScore,*lblShield,*lblWeixin;
}
@property(nonatomic,strong)CategoryInfoModel *telModel,*aboutModel,*linkAppStoreModel;
@end

@implementation SetupVC


- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationItem.title=@"设置中心";
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.navigationController.navigationBar setTranslucent:NO];
    
}
- (void) createView:(UIView *)contentView
{
    __weak __typeof(self)weakSelf=self;
    //修改密码
    orderDetailView * lblChangePSW=[[orderDetailView alloc]init];
    lblChangePSW.title=@"推送设置";
    lblChangePSW.topLine=NO;
//    lblChangePSW.imgRightName=@"icon_arrow_right";
    [contentView addSubview:lblChangePSW];
    [lblChangePSW mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(contentView);
        make.top.equalTo(contentView).offset(10);
        make.height.mas_equalTo(40);
    }];
    lblChangePSW.borderColor=kLineColor;
    lblChangePSW.borderWidth=HViewBorderWidthMake(0, 0, 1, 0);
    [lblChangePSW setDidTapBlock:^{
        if (![self isLogin]) {
            return ;
        }
        
        TuiSongSettingVC *vc=[[TuiSongSettingVC alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }];

    
    //关于奢奢哒
    lblAboutUs=[[orderDetailView alloc]init];
    lblAboutUs.title=@"关于我们";
    lblAboutUs.topLine=NO;
    lblAboutUs.imgRightName=@"icon_arrow_right";
    [contentView addSubview:lblAboutUs];
    [lblAboutUs mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(contentView);
        make.top.equalTo(lblChangePSW.mas_bottom).offset(0);
        make.height.mas_equalTo(40);
    }];
    lblAboutUs.borderColor=kLineColor;
    lblAboutUs.borderWidth=HViewBorderWidthMake(0, 0, 1, 0);
    [lblAboutUs setDidTapBlock:^{
        H5VC *about=[H5VC new];
        about.navTitle=@"关于我们";
        about.url=@"http://jianbao.guwanw.com/about.html";//weakSelf.aboutModel.linkUrl;
        [weakSelf.navigationController pushViewController:about animated:YES];
    }];
    
    //意见反馈
    orderDetailView * lblFeedback=[[orderDetailView alloc]init];
    lblFeedback.title=@"意见反馈";
    lblFeedback.topLine=NO;
    lblFeedback.imgRightName=@"icon_arrow_right";
    [contentView addSubview:lblFeedback];
    [lblFeedback mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(contentView);
        make.top.equalTo(lblAboutUs.mas_bottom);
        make.height.mas_equalTo(40);
    }];
    lblFeedback.borderColor=kLineColor;
    lblFeedback.borderWidth=HViewBorderWidthMake(0, 0, 1, 0);
    [lblFeedback setDidTapBlock:^{
        if (![self isLogin]) {
            return ;
        }
        
        FeedBackVC *vc=[[FeedBackVC alloc]init];
        [weakSelf.navigationController pushViewController:vc animated:YES];
    }];

    //清除图片缓存
    lblClearBuffer=[[orderDetailView alloc]init];
    lblClearBuffer.title=@"清除缓存";
    lblClearBuffer.topLine=NO;
    lblClearBuffer.imgRightName=@"icon_arrow_right";
    [contentView addSubview:lblClearBuffer];
    [lblClearBuffer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(contentView);
        make.top.equalTo(lblFeedback.mas_bottom);
        make.height.mas_equalTo(40);
    }];
    lblClearBuffer.borderColor=kLineColor;
    lblClearBuffer.borderWidth=HViewBorderWidthMake(0, 0, 1, 0);
    float tmpSize = [[SDImageCache sharedImageCache]getSize];
    NSString *strCache=[NSString stringWithFormat:@"%4.2fM",tmpSize/1024/1024];
    lblClearBuffer.content=strCache;
    UITapGestureRecognizer *tapCache=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapCache_Click)];
    [lblClearBuffer addGestureRecognizer:tapCache];
    
    //评分
    lblScore=[[orderDetailView alloc]init];
    lblScore.title=@"评价";
    lblScore.topLine=NO;
    lblScore.imgRightName=@"icon_arrow_right";
    [contentView addSubview:lblScore];
    [lblScore mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(contentView);
        make.top.equalTo(lblClearBuffer.mas_bottom);
        make.height.mas_equalTo(40);
    }];
    lblScore.borderColor=kLineColor;
    lblScore.borderWidth=HViewBorderWidthMake(0, 0, 1, 0);

    
    //退出当前账号
    HButton *btnSignOut=[[HButton alloc]init];
    btnSignOut.backgroundColor=[UIColor blackColor];
    [btnSignOut setTitle:@"退出当前账号" forState:UIControlStateNormal];
    [btnSignOut addTarget:self action:@selector(btnSignOut_Click) forControlEvents:UIControlEventTouchUpInside];
    [btnSignOut setTitleColor:kWhiteColor forState:UIControlStateNormal];
    btnSignOut.titleLabel.font=[[Global sharedInstance]fontWithSize:15];
    btnSignOut.borderColor=kLineColor;
    btnSignOut.borderWidth=HViewBorderWidthMake(1, 0, 1, 0);
    if ([[Global sharedInstance] userID]) {
        [contentView addSubview:btnSignOut];
        [btnSignOut mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(contentView).offset(20);
            make.centerX.equalTo(contentView);
            make.top.equalTo(lblScore.mas_bottom).offset(50);
            make.height.mas_equalTo(40);
        }];
    }
}

#pragma mark - 方法
#pragma mark - 事件

- (void) tapCache_Click
{
    SIAlertView *alert=[[SIAlertView alloc] initWithTitle:@"询问" andMessage:@"是否确定清除图片缓存?"];
    [alert addButtonWithTitle:@"取消" type:SIAlertViewButtonTypeCancel handler:nil];
    [alert addButtonWithTitle:@"清除" type:SIAlertViewButtonTypeDefault handler:^(SIAlertView *alertView) {
        [[SDImageCache sharedImageCache] clearDiskOnCompletion:^{

        }];
        float tmpSize = [[SDImageCache sharedImageCache]getSize];
        NSString *strCache=[NSString stringWithFormat:@"%4.2fM",tmpSize/1024/1024];
        lblClearBuffer.content=strCache;
    }];
    [alert show];
}

//退出当前账号
-(void)btnSignOut_Click{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userDic"];
//    [UMessage removeAllTags:nil];
//    [UMessage removeAlias:[Global sharedInstance].userID type:kUMessageAliasTypeWeiXin response:nil];
    
    [[Global sharedInstance] Logout];
    self.navigationController.tabBarItem.badgeValue=nil;
    [self.navigationController popViewControllerAnimated:YES];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [AppDelegate shareDelegate].tabBarVC.selectedIndex = 0;
        [self.navigationController popToRootViewControllerAnimated:NO];
        [self JumpToControlIndex:0 TransitionType:UISSAnimationFromBottom whichContol:nil];
    });
}

@end
