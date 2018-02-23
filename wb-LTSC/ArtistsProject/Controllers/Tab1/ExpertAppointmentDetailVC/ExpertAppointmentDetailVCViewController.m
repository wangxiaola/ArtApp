//
//  ExpertAppointmentDetailVCViewController.m
//  ShesheDa
//
//  Created by chen on 16/7/12.
//  Copyright © 2016年 上海翔汇网络有限公司. All rights reserved.
//

#import "ExpertAppointmentDetailVCViewController.h"
#import "UserIndex_OrderStateView.h"
#import "ExpertAppointmentModel.h"
#import "STextFieldWithTitle.h"
#import "CangyouBaomingJiluVC.h"
#import "FeeShowView.h"
#import "CangyouZixunVC.h"
#import "CangyouZixunCell.h"
#import "BaoMingVC.h"

@interface ExpertAppointmentDetailVCViewController ()<UITableViewDelegate,UITableViewDataSource,UIWebViewDelegate>{
    HLabel *lblTitle;
    STextFieldWithTitle *txtCode,*txtFeeCode,*txtbaomingChengyuan,*txtMembertitle,*txtcangyouzixub;
    HView *viewImage,*viewMember;
    UserIndex_OrderStateView *viewOwerData;
    HLabel *lblTitleTip;
    UIScrollView *scrollMember;
    FeeShowView *viewFee;
    UITableView *tabCangyouZixun;
    ExpertAppointmentModel *modelDetail;
    UIWebView *viewHuodongJieShao;
}

@end

@implementation ExpertAppointmentDetailVCViewController
@synthesize cid;
- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadData];
    self.navigationItem.title=@"专家预约";
    UIBarButtonItem *rightBar=[[UIBarButtonItem alloc]initWithTitle:@"分享" style:UIBarButtonItemStyleDone target:self action:@selector(rightBar_Click)];
    self.navigationItem.rightBarButtonItem=rightBar;
    
    [self.scrollView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(-40);
    }];
    
    HView *viewBottom=[[HView alloc]init];
    viewBottom.borderWidth=HViewBorderWidthMake(1,0,0,0);
    viewBottom.borderColor=kLineColor;
    viewBottom.backgroundColor=ColorHex(@"f6f6f6");
    [self.view addSubview:viewBottom];
    [viewBottom mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.mas_equalTo(40);
    }];
    
    //我要报名按钮
    HButton *btnBaoming=[[HButton alloc]init];
    [btnBaoming setTitle:@"我要报名" forState:UIControlStateNormal];
    [btnBaoming setImage:[UIImage imageNamed:@"icon_aprisa_baoming"] forState:UIControlStateNormal];
    [btnBaoming addTarget:self action:@selector(btnBaoming_Click) forControlEvents:UIControlEventTouchUpInside];
    [btnBaoming setTitleColor:kTitleColor forState:UIControlStateNormal];
    btnBaoming.titleLabel.font=kFont(15);
    [viewBottom addSubview:btnBaoming];
    [btnBaoming mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(viewBottom);
        make.width.mas_equalTo(kScreenW/2);
        make.top.bottom.equalTo(viewBottom);
    }];
    
    HButton *btnZixun=[[HButton alloc]init];
    [btnZixun setTitle:@"我要咨询" forState:UIControlStateNormal];
    [btnZixun setImage:[UIImage imageNamed:@"icon_aprisa_zixun"] forState:UIControlStateNormal];
    [btnZixun addTarget:self action:@selector(btnZixun_Click) forControlEvents:UIControlEventTouchUpInside];
    [btnZixun setTitleColor:kTitleColor forState:UIControlStateNormal];
    btnZixun.titleLabel.font=kFont(15);
    [viewBottom addSubview:btnZixun];
    [btnZixun mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(viewBottom).offset(kScreenW/2);
        make.width.mas_equalTo(kScreenW/2);
        make.top.bottom.equalTo(viewBottom);
    }];

}

//控件放在这个方法里面才有滑动效果
- (void)createView:(UIView *)contentView{
    
    __block typeof (self) weakSelf = self;
 
    viewFee=[[FeeShowView alloc]init];
    [self.view addSubview:viewFee];
    [viewFee mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    viewFee.hidden=YES;
    
    HView *viewBG1=[[HView alloc]init];
    viewBG1.backgroundColor=kWhiteColor;
    [contentView addSubview:viewBG1];
    [viewBG1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(contentView);
    }];
    
    lblTitle=[[HLabel alloc]init];
    lblTitle.textColor=[UIColor blackColor];
    lblTitle.font=kFont(20);
    [viewBG1 addSubview:lblTitle];
    [lblTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(viewBG1).offset(15);
        make.top.equalTo(viewBG1).offset(20);
        make.right.equalTo(viewBG1).offset(-100);
    }];
    
    HLine *line=[[HLine alloc]init];
    line.lineColor=kLineColor;
    line.lineStyle=UILineStyleVertical;
    line.lineWidth=1;
    [viewBG1 addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(viewBG1);
        make.top.equalTo(viewBG1).offset(15);
        make.right.equalTo(viewBG1).offset(-90);
        make.width.mas_equalTo(1);
    }];
    
    lblTitleTip=[[HLabel alloc]init];
    lblTitleTip.textColor=kTitleColor;
    lblTitleTip.font=kFont(14);
    lblTitleTip.numberOfLines=0;
    [viewBG1 addSubview:lblTitleTip];
    [lblTitleTip mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(viewBG1).offset(15);
        make.top.equalTo(lblTitle.mas_bottom).offset(10);
        make.right.equalTo(line).offset(-15);
    }];
    
    //个人资料
    viewOwerData=[[UserIndex_OrderStateView alloc]init];
    viewOwerData.title=@"想去";
    viewOwerData.image=@"icon_appraisal_zan";
    viewOwerData.titleColor=kTitleColor;
    [viewBG1 addSubview:viewOwerData];
    [viewOwerData mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.equalTo(viewBG1);
        make.width.mas_equalTo(90);
    }];
    viewOwerData.didTapBlock=^(){
        [weakSelf clickWangGo];
    };
    
    [viewBG1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(lblTitleTip).offset(20);
    }];

    //我的邀请码
    txtFeeCode=[[STextFieldWithTitle alloc]init];
    txtFeeCode.title=@"专家介绍";
    txtFeeCode.isBottom=NO;
    txtFeeCode.headLineWidth=0;
    txtFeeCode.isHideArrow=YES;
    txtFeeCode.submitAligent=NSTextAlignmentLeft;
    txtFeeCode.didTapBlock=^(){
        
    };
    [contentView addSubview:txtFeeCode];
    [txtFeeCode mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(contentView);
        make.top.equalTo(viewBG1.mas_bottom).offset(10);
        make.height.mas_equalTo(45);
    }];
    
    //专家介绍
//    lblZhuanjiaJieshaoDetail=[[HLabel alloc]init];
//    lblZhuanjiaJieshaoDetail.backgroundColor=kWhiteColor;
//    lblZhuanjiaJieshaoDetail.textEdgeInsets=UIEdgeInsetsMake(10, 10, 10, 10);
//    [contentView addSubview:lblZhuanjiaJieshaoDetail];
//    [lblZhuanjiaJieshaoDetail mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.equalTo(contentView);
//        make.top.equalTo(txtFeeCode.mas_bottom);
//    }];
    
    viewHuodongJieShao=[[UIWebView alloc]init];
    viewHuodongJieShao.delegate=self;
    viewHuodongJieShao.userInteractionEnabled=NO;
    [contentView addSubview:viewHuodongJieShao];
    [viewHuodongJieShao mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(contentView);
        make.left.equalTo(contentView);
        make.top.equalTo(txtFeeCode.mas_bottom);
        make.height.mas_equalTo(1);
    }];

    //报名成员
    txtMembertitle=[[STextFieldWithTitle alloc]init];
    txtMembertitle.title=@"报名成员";
    txtMembertitle.submitAligent=NSTextAlignmentLeft;
    txtMembertitle.submitColor=ColorHex(@"0000FF");
    txtMembertitle.titleColor=kTitleColor;
    txtMembertitle.isHideArrow=YES;
    txtMembertitle.didTapBlock=^(){
        
    };
    [contentView addSubview:txtMembertitle];
    [txtMembertitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(contentView);
        make.top.equalTo(viewHuodongJieShao.mas_bottom).offset(10);
        make.height.mas_equalTo(40);
    }];
    
    scrollMember=[[UIScrollView alloc] init];
    [contentView addSubview:scrollMember];
    [scrollMember mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(txtMembertitle.mas_bottom).offset(10);
        make.left.right.equalTo(contentView);
        make.height.mas_equalTo(100);
    }];
    scrollMember.alwaysBounceHorizontal=YES;
    scrollMember.scrollEnabled=YES;
    scrollMember.showsHorizontalScrollIndicator=NO;
    
    //向右的箭头
    UIImageView *imgRight=[[UIImageView alloc]init];
    imgRight.image=[UIImage imageNamed:@"icon_HComboBox_right"];
    [scrollMember addSubview:imgRight];
    [imgRight mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(scrollMember);
        make.right.equalTo(scrollMember).offset(-5);
        make.width.height.mas_equalTo(15);
    }];
    
    
    viewMember=[[HView alloc]init];
    [scrollMember addSubview:viewMember];
    [viewMember mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(scrollMember);
        make.height.mas_equalTo(scrollMember);
    }];
    scrollMember.userInteractionEnabled=YES;
    UITapGestureRecognizer *tapBaomingchengyuan=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapMember_Click)];
    [scrollMember addGestureRecognizer:tapBaomingchengyuan];
    
    //我的邀请码
    txtCode=[[STextFieldWithTitle alloc]init];
    txtCode.title=@"费用";
    txtCode.titleColor=kTitleColor;
    txtCode.isBottom=NO;
    txtCode.submitAligent=NSTextAlignmentLeft;
    txtCode.didTapBlock=^(){
        [weakSelf clickFee];
    };
    [contentView addSubview:txtCode];
    [txtCode mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(contentView);
        make.top.equalTo(scrollMember.mas_bottom);
        make.height.mas_equalTo(45);
    }];

    txtcangyouzixub=[[STextFieldWithTitle alloc]init];
    txtcangyouzixub.title=@"藏友咨询";
    txtcangyouzixub.isBottom=NO;
    txtcangyouzixub.submitColor=ColorHex(@"0000FF");
    txtcangyouzixub.titleColor=kTitleColor;
    txtcangyouzixub.submitAligent=NSTextAlignmentLeft;
    
    __weak typeof(cid)weakId = cid;
    txtcangyouzixub.didTapBlock=^(){
        CangyouZixunVC *vc=[[CangyouZixunVC alloc]init];
        vc.cID=weakId;
        [weakSelf.navigationController pushViewController:vc animated:YES];
    };
    [contentView addSubview:txtcangyouzixub];
    [txtcangyouzixub mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(contentView);
        make.top.equalTo(txtCode.mas_bottom).offset(10);
        make.height.mas_equalTo(40);
    }];
    
    tabCangyouZixun=[[UITableView alloc]init];
    tabCangyouZixun.delegate=self;
    tabCangyouZixun.dataSource=self;
    tabCangyouZixun.tableFooterView=[UIView new];
    [contentView addSubview:tabCangyouZixun];
    [tabCangyouZixun mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(contentView);
        make.top.equalTo(txtcangyouzixub.mas_bottom);
        make.height.mas_equalTo(1);
    }];

}
-(void)clickFee{
    
    viewFee.hidden=NO;
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
        [self upDataView:modelDetail];
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

-(void)upDataView:(ExpertAppointmentModel *)model{
    lblTitle.text=model.name;
    viewFee.fee=model.tips;
    txtCode.submit=model.price;
//    NSAttributedString * attrStr = [[NSAttributedString alloc] initWithData:[model.content dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
//    lblZhuanjiaJieshaoDetail.attributedText=attrStr;
    NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:model.contenturl]];
    [viewHuodongJieShao loadRequest:request];
    txtMembertitle.submit=model.signall;
    [self upMember:model.signuser];
    tabCangyouZixun.hidden=YES;
    [tabCangyouZixun mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(1);
    }];
    if (model.cyzx.data.count>0) {
        tabCangyouZixun.hidden=NO;
        
        CGFloat fCellCangyouHeight=0;
        for (ExpertAppointmentZhubandanweiDataModel *modelCangyou in model.cyzx.data) {
            CGSize sizeCell1=[modelCangyou.hf.content sizeWithFontSize:13 andMaxWidth:kScreenW-105 andMaxHeight:1000];
            CGSize sizeCell2=[modelCangyou.zx.content sizeWithFontSize:13 andMaxWidth:kScreenW-105 andMaxHeight:1000];
            fCellCangyouHeight=fCellCangyouHeight+sizeCell1.height+sizeCell2.height+80;
        }
        
        [tabCangyouZixun mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(fCellCangyouHeight);
        }];
        [tabCangyouZixun reloadData];
    }
    txtcangyouzixub.submit=model.cyzx.total;
    
    viewOwerData.image=@"icon_appraisal_zan";
    //已点击想去
    if ([model.isliked isEqualToString:@"1"]) {
        viewOwerData.image=@"icon_appraisal_Azan";
    }
    
}

-(void)upMember:(NSMutableArray *)arraySignure{
    if (arraySignure.count<1) {
        scrollMember.hidden=YES;
        [scrollMember mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(1);
        }];
        return ;
    }
    
    for (int i=0; i<arraySignure.count; i++) {
        NSMutableDictionary *modelUser=arraySignure[i];
        UIImageView *imgHead=[[UIImageView alloc]init];
        [imgHead sd_setImageWithURL:[NSURL URLWithString:[modelUser objectForKey:@"avatar"]] placeholderImage:[UIImage imageNamed:@"temp_Default_headProtrait"]];
        [viewMember addSubview:imgHead];
        [imgHead mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(viewMember).offset(10+i*90);
            make.width.height.mas_equalTo(80);
            make.top.equalTo(viewMember).offset(10);
        }];
    }
    
    [viewMember mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(viewMember.subviews.lastObject).offset(10);
    }];
}


//点击想去按钮
-(void)clickWangGo{
    if (![self isNavLogin]) {
        return ;
    }
    
    
    NSString *strAc=@"";
    if ([modelDetail.isliked isEqualToString:@"1"]) {
        //关闭想
        strAc=@"delactionevent";
    }else{
        strAc=@"actionevent";
    }
    //1.设置请求参数
    [self showLoadingHUDWithTitle:@"正在加载数据" SubTitle:nil];
    NSDictionary *dict = @{@"uid":[Global sharedInstance].userID,
                           @"eid":cid};
    //    //2.开始请求
    HHttpRequest *request = [[HHttpRequest alloc] init];
    [request httpPostRequestWithActionName:strAc
                               andPramater:dict
                      andDidDataErrorBlock:^(NSURLSessionTask *operation, id responseObject) {
                          [self.hudLoading hideAnimated:YES];
                          ResultModel *result=[ResultModel mj_objectWithKeyValues:responseObject];
                          [self showErrorHUDWithTitle:result.msg SubTitle:nil Complete:nil];
                      } andDidRequestSuccessBlock:^(NSURLSessionTask *operation, id responseObject) {
                          [self.hudLoading hide:YES];
                          [self loadData];
                      } andDidRequestFailedBlock:^(NSURLSessionTask *operation, NSError *error) {
                          [self.hudLoading hide:YES];
                      }];
}

//报名成员点击事件
-(void)tapMember_Click{
    CangyouBaomingJiluVC *vc=[[CangyouBaomingJiluVC alloc]init];
    vc.cID=cid;
    [self.navigationController pushViewController:vc animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([tabCangyouZixun isEqual:tableView]) {
        ExpertAppointmentZhubandanweiDataModel *model=modelDetail.cyzx.data[indexPath.row];
        CGSize sizeCell1=[model.hf.content sizeWithFontSize:13 andMaxWidth:kScreenW-105 andMaxHeight:1000];
        CGSize sizeCell2=[model.zx.content sizeWithFontSize:13 andMaxWidth:kScreenW-105 andMaxHeight:1000];
        return sizeCell1.height+sizeCell2.height+80;
    }
    return 80;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([tabCangyouZixun isEqual:tableView]) {
        return modelDetail.cyzx.data.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([tabCangyouZixun isEqual:tableView]) {
        NSString *identifier=@"tabCangyouZixun";
        CangyouZixunCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[CangyouZixunCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
        }
        cell.model=modelDetail.cyzx.data[indexPath.row];
        return cell;
    }
    return nil;
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

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    CGFloat height = webView.scrollView.contentSize.height;
    [viewHuodongJieShao mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(height);
    }];
}

@end
