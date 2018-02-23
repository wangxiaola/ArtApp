//
//  ExpertAppointmentDetailH5VC.m
//  ShesheDa
//
//  Created by admin on 16/8/22.
//  Copyright © 2016年 上海翔汇网络有限公司. All rights reserved.
//

#import "ExpertAppointmentDetailH5VC.h"
#import "ExpertAppointmentModel.h"
#import "BaoMingVC.h"
#import "CangyouZixunVC.h"

@interface ExpertAppointmentDetailH5VC (){
    ExpertAppointmentModel *modelDetail;
}

@end

@implementation ExpertAppointmentDetailH5VC

@synthesize cid,url,state;
- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadData];
    self.navigationItem.title=@"专家预约";
    if ([state isEqualToString:@"2"]) {
        self.navigationItem.title=@"鉴定会详情";
    }
    
    UIBarButtonItem *rightBar=[[UIBarButtonItem alloc]initWithTitle:@"分享" style:UIBarButtonItemStyleDone target:self action:@selector(rightBar_Click)];
    self.navigationItem.rightBarButtonItem=rightBar;
    
//    [self.scrollView mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(self.view).offset(-40);
//    }];
//    
//    HView *viewBottom=[[HView alloc]init];
//    viewBottom.borderWidth=HViewBorderWidthMake(1,0,0,0);
//    viewBottom.borderColor=kLineColor;
//    viewBottom.backgroundColor=ColorHex(@"f6f6f6");
//    [self.view addSubview:viewBottom];
//    [viewBottom mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.bottom.equalTo(self.view);
//        make.height.mas_equalTo(40);
//    }];
//    
//    //我要报名按钮
//    HButton *btnBaoming=[[HButton alloc]init];
//    [btnBaoming setTitle:@"我要报名" forState:UIControlStateNormal];
//    [btnBaoming setImage:[UIImage imageNamed:@"icon_aprisa_baoming"] forState:UIControlStateNormal];
//    [btnBaoming addTarget:self action:@selector(btnBaoming_Click) forControlEvents:UIControlEventTouchUpInside];
//    [btnBaoming setTitleColor:kTitleColor forState:UIControlStateNormal];
//    btnBaoming.titleLabel.font=kFont(15);
//    [viewBottom addSubview:btnBaoming];
//    [btnBaoming mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(viewBottom);
//        make.width.mas_equalTo(kScreenW/2);
//        make.top.bottom.equalTo(viewBottom);
//    }];
//    
//    HButton *btnZixun=[[HButton alloc]init];
//    [btnZixun setTitle:@"我要咨询" forState:UIControlStateNormal];
//    [btnZixun setImage:[UIImage imageNamed:@"icon_aprisa_zixun"] forState:UIControlStateNormal];
//    [btnZixun addTarget:self action:@selector(btnZixun_Click) forControlEvents:UIControlEventTouchUpInside];
//    [btnZixun setTitleColor:kTitleColor forState:UIControlStateNormal];
//    btnZixun.titleLabel.font=kFont(15);
//    [viewBottom addSubview:btnZixun];
//    [btnZixun mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(viewBottom).offset(kScreenW/2);
//        make.width.mas_equalTo(kScreenW/2);
//        make.top.bottom.equalTo(viewBottom);
//    }];
    
}

//加载用户信息
- (void) loadData{
    //1.设置请求参数
    [self showLoadingHUDWithTitle:@"正在获取专家详情" SubTitle:nil];
    NSDictionary *dict = @{@"cuid":[Global sharedInstance].userID?:@"",
                           @"eid":cid};
    //    //2.开始请求
    HHttpRequest *request = [[HHttpRequest alloc] init];
    [request httpGetRequestWithActionName:@"eventcontent" andPramater:dict andDidDataErrorBlock:^(NSURLSessionTask *operation, id responseObject) {
        [self.hudLoading hideAnimated:YES];
        ResultModel *result=[ResultModel mj_objectWithKeyValues:responseObject];
        [self showErrorHUDWithTitle:result.msg SubTitle:nil Complete:nil];
    } andDidRequestSuccessBlock:^(NSURLSessionTask *operation, id responseObject) {
        [self.hudLoading hideAnimated:YES];
        modelDetail=[ExpertAppointmentModel mj_objectWithKeyValues:responseObject];
    } andDidRequestFailedBlock:^(NSURLSessionTask *operation, NSError *error) {
        [self.hudLoading hideAnimated:YES];
    }];
}

//分享按钮点击事件
- (void)rightBar_Click{
    OSMessage* msg = [[OSMessage alloc] init];
    msg.title = @"盛典鉴宝";
    msg.desc = modelDetail.name;
    msg.link = modelDetail.eurl;
    
    UIImage *dataImage=[UIImage imageNamed:@"icon_Default_Product"];
    NSData* shareImage = UIImagePNGRepresentation(dataImage);
    NSData* shareThumbImage =UIImagePNGRepresentation([dataImage imageCompressForWidth:60]);
    
    msg.image = shareImage;
    msg.thumbnail = shareThumbImage;
    HShareVC *vc=[[HShareVC alloc] init];
    vc.sharedes=modelDetail.name;
    vc.state=@"1";
    [self presentSemiView:vc];
}

//我要报名点击事件
-(void)btnBaoming_Click{
    if (![self isNavLogin]) {
        return ;
    }
    
    BaoMingVC *vc=[[BaoMingVC alloc]init];
    vc.uID=cid;
    vc.money=modelDetail.price;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)btnZixun_Click{
    CangyouZixunVC *vc=[[CangyouZixunVC alloc]init];
    vc.cID=cid;
    [self.navigationController pushViewController:vc animated:YES];
}

//控件放在这个方法里面才有滑动效果
- (void)createView:(UIView *)contentView{

    UIWebView *webView =[[UIWebView alloc] init];
    
    [self.view addSubview:webView];
    [webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(0);
    }];
    NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    [webView loadRequest:request];
}

@end
