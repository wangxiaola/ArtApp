//
//  AppraisalMeetingDetailVC.m
//  ShesheDa
//
//  Created by chen on 16/7/13.
//  Copyright © 2016年 上海翔汇网络有限公司. All rights reserved.
//

#import "AppraisalMeetingDetailVC.h"
#import "BaoMingVC.h"
#import "CangyouBaomingJiluVC.h"
#import "CangyouZhiboVC.h"
#import "CangyouZixunCell.h"
#import "CangyouZixunVC.h"
#import "ExpertAppointmentModel.h"
#import "FeeShowView.h"
#import "MapKitVC.h"
#import "MyHomePageDockerVC.h"
#import "PlayerViewController.h"
#import "PublishDongtaiVC.h"
#import "STextFieldWithTitle.h"
#import "UserIndex_OrderStateView.h"
#import "XiangguanXinwenCell.h"
#import "ZhuanjiaView.h"
#import "ZhubandanweiCell.h"
#import "xczbDetailCell.h"

@interface AppraisalMeetingDetailVC () <UITableViewDataSource, UITableViewDelegate, UIWebViewDelegate> {
    HLabel* lblTitle;
    STextFieldWithTitle *txtCode, *txtbaomingChengyuan, *txtPlace, *txtMembertitle, *txtZhubandanweiTitle, *txtXiebandanwei, *txtVideoTitle, *txtXiangguanxinwen, *txtCangyouzhibo, *txtcangyouzixub;
    HView* viewImage;
    HLabel* lblTitleTipState;
    HView *viewZhuanjiaBG, *viewMember, *viewVideo;
    UIScrollView *scrollZhuanjia, *scrollMember, *scrollVideo;
    UITableView *tabZhubandanwei, *tabXiebandanwei, *tabXiangguanxinwen, *tabCangyouZhibo, *tabCangyouZixun;
    ExpertAppointmentModel* modelDetail;
    UIWebView* webHuodong;
    NSMutableArray* arrayPlayer;
    UserIndex_OrderStateView* viewOwerData;
    FeeShowView* viewFee;
    STextFieldWithTitle* txtPlaceTitle;
    UIWebView* viewHuodongJieShao;
    NSMutableArray* arrayVideoImage;
}

@end

@implementation AppraisalMeetingDetailVC
@synthesize cid;

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.navigationController.navigationBar setTranslucent:NO];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    arrayVideoImage = [[NSMutableArray alloc] init];

    [self loadData];
    self.navigationItem.title = @"";
    UIBarButtonItem* rightBar = [[UIBarButtonItem alloc] initWithTitle:@"分享" style:UIBarButtonItemStyleDone target:self action:@selector(rightBar_Click)];
    self.navigationItem.rightBarButtonItem = rightBar;
    [self.scrollView mas_updateConstraints:^(MASConstraintMaker* make) {
        make.bottom.equalTo(self.view).offset(-40);
    }];

    HView* viewBottom = [[HView alloc] init];
    viewBottom.borderWidth = HViewBorderWidthMake(1, 0, 0, 0);
    viewBottom.borderColor = kLineColor;
    viewBottom.backgroundColor = ColorHex(@"f6f6f6");
    [self.view addSubview:viewBottom];
    [viewBottom mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.mas_equalTo(40);
    }];

    //我要报名按钮
    HButton* btnBaoming = [[HButton alloc] init];
    [btnBaoming setTitle:@"我要报名" forState:UIControlStateNormal];
    [btnBaoming setImage:[UIImage imageNamed:@"icon_aprisa_baoming"] forState:UIControlStateNormal];
    [btnBaoming addTarget:self action:@selector(btnBaoming_Click) forControlEvents:UIControlEventTouchUpInside];
    [btnBaoming setTitleColor:kTitleColor forState:UIControlStateNormal];
    btnBaoming.titleLabel.font = kFont(15);
    [viewBottom addSubview:btnBaoming];
    [btnBaoming mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.equalTo(viewBottom);
        make.width.mas_equalTo(kScreenW / 3);
        make.top.bottom.equalTo(viewBottom);
    }];

    HButton* btnZixun = [[HButton alloc] init];
    [btnZixun setTitle:@"我要咨询" forState:UIControlStateNormal];
    [btnZixun setImage:[UIImage imageNamed:@"icon_aprisa_zixun"] forState:UIControlStateNormal];
    [btnZixun addTarget:self action:@selector(btnZixun_Click) forControlEvents:UIControlEventTouchUpInside];
    [btnZixun setTitleColor:kTitleColor forState:UIControlStateNormal];
    btnZixun.titleLabel.font = kFont(15);
    [viewBottom addSubview:btnZixun];
    [btnZixun mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.equalTo(viewBottom).offset(kScreenW / 3);
        make.width.mas_equalTo(kScreenW / 3);
        make.top.bottom.equalTo(viewBottom);
    }];

    HButton* btnPublish = [[HButton alloc] init];
    [btnPublish setImage:[UIImage imageNamed:@"icon_cangyou_publish"] forState:UIControlStateNormal];
    [btnPublish addTarget:self action:@selector(btnPublish_Click) forControlEvents:UIControlEventTouchUpInside];
    [viewBottom addSubview:btnPublish];
    [btnPublish mas_makeConstraints:^(MASConstraintMaker* make) {
        make.right.equalTo(viewBottom);
        make.width.mas_equalTo(kScreenW / 4);
        make.top.bottom.equalTo(viewBottom);
    }];
}

- (void)btnPublish_Click
{
    PublishDongtaiVC* vc = [[PublishDongtaiVC alloc] init];
    vc.state = @"1";
    vc.messageTop = modelDetail.name;
    [self.navigationController pushViewController:vc animated:YES];
}

//控件放在这个方法里面才有滑动效果
- (void)createView:(UIView*)contentView
{
    arrayPlayer = [[NSMutableArray alloc] init];
    __block typeof(self) weakSelf = self;
    HView* viewBG1 = [[HView alloc] init];
    viewBG1.backgroundColor = kWhiteColor;
    [contentView addSubview:viewBG1];
    [viewBG1 mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.top.right.equalTo(contentView);
    }];

    viewFee = [[FeeShowView alloc] init];
    [self.view addSubview:viewFee];
    [viewFee mas_makeConstraints:^(MASConstraintMaker* make) {
        make.edges.equalTo(self.view);
    }];
    viewFee.hidden = YES;

    lblTitle = [[HLabel alloc] init];
    lblTitle.numberOfLines = 0;
    lblTitle.textColor = [UIColor blackColor];
    lblTitle.font = kFont(22);
    [viewBG1 addSubview:lblTitle];
    [lblTitle mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.equalTo(viewBG1).offset(15);
        make.top.equalTo(viewBG1).offset(30);
        make.right.equalTo(viewBG1).offset(-100);

    }];

    //    HLabel *lblTitleTip=[[HLabel alloc]init];
    //    lblTitleTip.textColor=[UIColor whiteColor];
    //    lblTitleTip.backgroundColor=[UIColor colorWithHexString:@"5599FF"];
    //    lblTitleTip.text=@"鉴定会";
    //    lblTitleTip.textAlignment=NSTextAlignmentCenter;
    //    lblTitleTip.font=kFont(10);
    //    [viewBG1 addSubview:lblTitleTip];
    //    [lblTitleTip mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.left.equalTo(viewBG1).offset(15);
    //        make.top.equalTo(lblTitle.mas_bottom).offset(10);
    //        make.height.mas_equalTo(20);
    //        make.width.mas_equalTo(60);
    //    }];

    //    lblTitleTipState=[[HLabel alloc]init];
    //    lblTitleTipState.textColor=[UIColor whiteColor];
    //    lblTitleTipState.backgroundColor=[UIColor colorWithHexString:@"5599FF"];
    //    lblTitleTipState.text=@"鉴定会";
    //    lblTitleTipState.textAlignment=NSTextAlignmentCenter;
    //    lblTitleTipState.font=kFont(10);
    //    [viewBG1 addSubview:lblTitleTipState];
    //    [lblTitleTipState mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.left.equalTo(lblTitleTip.mas_right).offset(5);
    //        make.top.equalTo(lblTitle.mas_bottom).offset(10);
    //        make.height.mas_equalTo(20);
    //        make.width.mas_equalTo(60);
    //    }];

    HLine* line = [[HLine alloc] init];
    line.lineColor = kLineColor;
    line.lineStyle = UILineStyleVertical;
    line.lineWidth = 1;
    [viewBG1 addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker* make) {
        make.centerY.equalTo(viewBG1);
        make.top.equalTo(viewBG1).offset(15);
        make.right.equalTo(viewBG1).offset(-90);
        make.width.mas_equalTo(1);
    }];

    //个人资料
    viewOwerData = [[UserIndex_OrderStateView alloc] init];
    viewOwerData.title = @"想去";
    viewOwerData.image = @"icon_appraisal_zan";
    viewOwerData.titleColor = kTitleColor;
    [viewBG1 addSubview:viewOwerData];
    [viewOwerData mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.right.bottom.equalTo(viewBG1);
        make.width.mas_equalTo(90);
    }];
    viewOwerData.didTapBlock = ^() {
        [weakSelf clickWangGo];
    };

    [viewBG1 mas_makeConstraints:^(MASConstraintMaker* make) {
        make.bottom.equalTo(lblTitle).offset(30);
    }];

    //我的邀请码
    txtCode = [[STextFieldWithTitle alloc] init];
    txtCode.title = @"费用";
    txtCode.titleColor = kTitleColor;
    txtCode.isBottom = NO;
    txtCode.submitAligent = NSTextAlignmentLeft;
    txtCode.didTapBlock = ^() {
        [weakSelf clickFee];
    };
    [contentView addSubview:txtCode];
    [txtCode mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.right.equalTo(contentView);
        make.top.equalTo(viewBG1.mas_bottom).offset(10);
        make.height.mas_equalTo(45);
    }];

    txtbaomingChengyuan = [[STextFieldWithTitle alloc] init];
    txtbaomingChengyuan.title = @"时间";
    txtbaomingChengyuan.titleColor = kTitleColor;
    txtbaomingChengyuan.isMutable = YES;
    txtbaomingChengyuan.isBottom = NO;
    txtbaomingChengyuan.submitAligent = NSTextAlignmentLeft;
    txtbaomingChengyuan.didTapBlock = ^() {

    };
    [contentView addSubview:txtbaomingChengyuan];
    [txtbaomingChengyuan mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.right.equalTo(contentView);
        make.top.equalTo(txtCode.mas_bottom);
        make.height.mas_equalTo(65);
    }];

    txtPlace = [[STextFieldWithTitle alloc] init];
    txtPlace.title = @"地点";
    txtPlace.titleColor = kTitleColor;
    txtPlace.isMutable = YES;
    txtPlace.isBottom = NO;
    txtPlace.submitAligent = NSTextAlignmentLeft;
    
    __weak typeof(modelDetail)weakModel = modelDetail;
    txtPlace.didTapBlock = ^() {

        if (weakModel.lat.floatValue > 0 && weakModel.lng.floatValue > 0) {
            MapKitVC* vc = [[MapKitVC alloc] init];
            vc.navTitle = @"详情查询";
            vc.titleDAtou = weakModel.name;
            vc.subtitle = @"";
            vc.coordinate = CLLocationCoordinate2DMake(weakModel.lat.floatValue, weakModel.lng.floatValue);
            [weakSelf.navigationController pushViewController:vc animated:YES];
            return;
        }
        [weakSelf showErrorHUDWithTitle:@"无经纬度信息" SubTitle:nil Complete:nil];
    };
    [contentView addSubview:txtPlace];
    [txtPlace mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.right.equalTo(contentView);
        make.top.equalTo(txtbaomingChengyuan.mas_bottom);
        make.height.mas_equalTo(65);
    }];

    txtPlaceTitle = [[STextFieldWithTitle alloc] init];
    txtPlaceTitle.title = @"本场艺术家";
    txtPlaceTitle.titleColor = kTitleColor;
    txtPlaceTitle.isHideArrow = YES;
    txtPlaceTitle.didTapBlock = ^() {

    };
    [contentView addSubview:txtPlaceTitle];
    [txtPlaceTitle mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.right.equalTo(contentView);
        make.top.equalTo(txtPlace.mas_bottom).offset(10);
        make.height.mas_equalTo(40);
    }];

    scrollZhuanjia = [[UIScrollView alloc] init];
    [contentView addSubview:scrollZhuanjia];
    [scrollZhuanjia mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.equalTo(txtPlaceTitle.mas_bottom);
        make.left.right.equalTo(contentView);
        make.height.mas_equalTo(200);
    }];
    scrollZhuanjia.backgroundColor = kWhiteColor;
    scrollZhuanjia.alwaysBounceHorizontal = YES;
    scrollZhuanjia.scrollEnabled = YES;
    scrollZhuanjia.showsHorizontalScrollIndicator = YES;

    viewZhuanjiaBG = [[HView alloc] init];
    viewZhuanjiaBG.backgroundColor = kWhiteColor;
    [scrollZhuanjia addSubview:viewZhuanjiaBG];
    [viewZhuanjiaBG mas_makeConstraints:^(MASConstraintMaker* make) {
        make.edges.equalTo(scrollZhuanjia);
        make.height.mas_equalTo(scrollZhuanjia);
    }];

    //报名成员
    txtMembertitle = [[STextFieldWithTitle alloc] init];
    txtMembertitle.title = @"报名成员";
    txtMembertitle.submitAligent = NSTextAlignmentLeft;
    txtMembertitle.submitColor = ColorHex(@"0000FF");
    txtMembertitle.titleColor = kTitleColor;
    txtMembertitle.isHideArrow = YES;
    txtMembertitle.didTapBlock = ^() {

    };
    [contentView addSubview:txtMembertitle];
    [txtMembertitle mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.right.equalTo(contentView);
        make.top.equalTo(scrollZhuanjia.mas_bottom).offset(10);
        make.height.mas_equalTo(40);
    }];

    scrollMember = [[UIScrollView alloc] init];
    [contentView addSubview:scrollMember];
    [scrollMember mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.equalTo(txtMembertitle.mas_bottom);
        make.left.right.equalTo(contentView);
        make.height.mas_equalTo(100);
    }];
    scrollMember.backgroundColor = kWhiteColor;
    scrollMember.alwaysBounceHorizontal = YES;
    scrollMember.scrollEnabled = YES;
    scrollMember.showsHorizontalScrollIndicator = NO;

    //向右的箭头
    UIImageView* imgRight = [[UIImageView alloc] init];
    imgRight.image = [UIImage imageNamed:@"icon_HComboBox_right"];
    [scrollMember addSubview:imgRight];
    [imgRight mas_makeConstraints:^(MASConstraintMaker* make) {
        make.centerY.equalTo(scrollMember);
        make.right.equalTo(scrollMember).offset(-5);
        make.width.height.mas_equalTo(15);
    }];

    viewMember = [[HView alloc] init];
    [scrollMember addSubview:viewMember];
    [viewMember mas_makeConstraints:^(MASConstraintMaker* make) {
        make.edges.equalTo(scrollMember);
        make.height.mas_equalTo(scrollMember);
    }];
    viewMember.backgroundColor = kWhiteColor;
    scrollMember.userInteractionEnabled = YES;
    UITapGestureRecognizer* tapBaomingchengyuan = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapMember_Click)];
    [scrollMember addGestureRecognizer:tapBaomingchengyuan];

    //主办单位
    txtZhubandanweiTitle = [[STextFieldWithTitle alloc] init];
    txtZhubandanweiTitle.title = @"主办单位";
    txtZhubandanweiTitle.submitColor = ColorHex(@"0000FF");
    txtZhubandanweiTitle.titleColor = kTitleColor;
    txtZhubandanweiTitle.isHideArrow = YES;
    txtZhubandanweiTitle.submitAligent = NSTextAlignmentLeft;
    txtZhubandanweiTitle.didTapBlock = ^() {

    };
    [contentView addSubview:txtZhubandanweiTitle];
    [txtZhubandanweiTitle mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.right.equalTo(contentView);
        make.top.equalTo(scrollMember.mas_bottom).offset(10);
        make.height.mas_equalTo(40);
    }];

    tabZhubandanwei = [[UITableView alloc] init];
    tabZhubandanwei.delegate = self;
    tabZhubandanwei.dataSource = self;

    tabZhubandanwei.tableFooterView = [UIView new];
    [contentView addSubview:tabZhubandanwei];
    [tabZhubandanwei mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.right.equalTo(contentView);
        make.top.equalTo(txtZhubandanweiTitle.mas_bottom);
        make.height.mas_equalTo(40);
    }];

    //主办单位
    txtXiebandanwei = [[STextFieldWithTitle alloc] init];
    txtXiebandanwei.title = @"协办单位";
    txtXiebandanwei.submitAligent = NSTextAlignmentLeft;
    txtXiebandanwei.submitColor = ColorHex(@"0000FF");
    txtXiebandanwei.titleColor = kTitleColor;
    txtXiebandanwei.isHideArrow = YES;
    txtXiebandanwei.didTapBlock = ^() {

    };
    [contentView addSubview:txtXiebandanwei];
    [txtXiebandanwei mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.right.equalTo(contentView);
        make.top.equalTo(tabZhubandanwei.mas_bottom);
        make.height.mas_equalTo(40);
    }];
    tabXiebandanwei = [[UITableView alloc] init];
    tabXiebandanwei.delegate = self;
    tabXiebandanwei.dataSource = self;
    tabXiebandanwei.separatorStyle = UITableViewCellSeparatorStyleNone;
    tabXiebandanwei.tableFooterView = [UIView new];
    [contentView addSubview:tabXiebandanwei];
    [tabXiebandanwei mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.right.equalTo(contentView);
        make.top.equalTo(txtXiebandanwei.mas_bottom);
        make.height.mas_equalTo(40);
    }];
    //活动介绍
    STextFieldWithTitle* txtHuodongJieshao = [[STextFieldWithTitle alloc] init];
    txtHuodongJieshao.title = @"活动介绍";
    txtHuodongJieshao.submitColor = ColorHex(@"0000FF");
    txtHuodongJieshao.titleColor = kTitleColor;
    txtHuodongJieshao.isHideArrow = YES;
    txtHuodongJieshao.didTapBlock = ^() {

    };
    [contentView addSubview:txtHuodongJieshao];
    [txtHuodongJieshao mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.right.equalTo(contentView);
        make.top.equalTo(tabXiebandanwei.mas_bottom).offset(10);
        make.height.mas_equalTo(40);
    }];

    //活动介绍
    //    lblHuodongJieshao=[[HLabel alloc]init];
    //    lblHuodongJieshao.textColor=kTitleColor;
    //    lblHuodongJieshao.font=kFont(15);
    //    lblHuodongJieshao.numberOfLines=0;
    //    [contentView addSubview:lblHuodongJieshao];
    //    [lblHuodongJieshao mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.right.equalTo(contentView).offset(-10);
    //        make.left.equalTo(contentView).offset(10);
    //        make.top.equalTo(txtHuodongJieshao.mas_bottom);
    //    }];
    viewHuodongJieShao = [[UIWebView alloc] init];
    viewHuodongJieShao.delegate = self;
    viewHuodongJieShao.userInteractionEnabled = NO;
    [contentView addSubview:viewHuodongJieShao];
    [viewHuodongJieShao mas_makeConstraints:^(MASConstraintMaker* make) {
        make.right.equalTo(contentView);
        make.left.equalTo(contentView);
        make.top.equalTo(txtHuodongJieshao.mas_bottom);
        make.height.mas_equalTo(1);
    }];

    txtVideoTitle = [[STextFieldWithTitle alloc] init];
    txtVideoTitle.title = @"相关视频";
    txtVideoTitle.submitColor = ColorHex(@"0000FF");
    txtVideoTitle.titleColor = kTitleColor;
    txtVideoTitle.submitAligent = NSTextAlignmentLeft;
    txtVideoTitle.isHideArrow = YES;
    txtVideoTitle.didTapBlock = ^() {

    };
    [contentView addSubview:txtVideoTitle];
    [txtVideoTitle mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.right.equalTo(contentView);
        make.top.equalTo(viewHuodongJieShao.mas_bottom).offset(10);
        make.height.mas_equalTo(40);
    }];

    scrollVideo = [[UIScrollView alloc] init];
    scrollVideo.backgroundColor = kWhiteColor;
    [contentView addSubview:scrollVideo];
    [scrollVideo mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.equalTo(txtVideoTitle.mas_bottom).offset(10);
        make.left.right.equalTo(contentView);
        make.height.mas_equalTo(100);
    }];
    scrollVideo.alwaysBounceHorizontal = YES;
    scrollVideo.scrollEnabled = YES;
    scrollVideo.showsHorizontalScrollIndicator = NO;

    viewVideo = [[HView alloc] init];
    viewVideo.backgroundColor = kWhiteColor;
    [scrollVideo addSubview:viewVideo];
    [viewVideo mas_makeConstraints:^(MASConstraintMaker* make) {
        make.edges.equalTo(scrollVideo);
        make.height.mas_equalTo(scrollVideo);
    }];
    viewVideo.userInteractionEnabled = YES;
    scrollVideo.userInteractionEnabled = YES;

    tabXiangguanxinwen = [[UITableView alloc] init];
    tabXiangguanxinwen.delegate = self;
    tabXiangguanxinwen.dataSource = self;

    tabXiangguanxinwen.tableFooterView = [UIView new];
    [contentView addSubview:tabXiangguanxinwen];
    [tabXiangguanxinwen mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.right.equalTo(contentView);
        make.top.equalTo(viewVideo.mas_bottom);
        make.height.mas_equalTo(1);
    }];

    txtCangyouzhibo = [[STextFieldWithTitle alloc] init];
    txtCangyouzhibo.title = @"藏友现场直播";
    txtCangyouzhibo.isBottom = NO;
    txtCangyouzhibo.submitColor = ColorHex(@"0000FF");
    txtCangyouzhibo.titleColor = kTitleColor;
    txtCangyouzhibo.submitAligent = NSTextAlignmentLeft;
    txtCangyouzhibo.didTapBlock = ^() {
        CangyouZhiboVC* vc = [[CangyouZhiboVC alloc] init];
        vc.topicName = modelDetail.name;
        [weakSelf.navigationController pushViewController:vc animated:YES];
    };
    [contentView addSubview:txtCangyouzhibo];
    [txtCangyouzhibo mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.right.equalTo(contentView);
        make.top.equalTo(tabXiangguanxinwen.mas_bottom).offset(10);
        make.height.mas_equalTo(40);
    }];

    tabCangyouZhibo = [[UITableView alloc] init];
    tabCangyouZhibo.delegate = self;
    tabCangyouZhibo.dataSource = self;
    tabCangyouZhibo.tableFooterView = [UIView new];
    [contentView addSubview:tabCangyouZhibo];
    [tabCangyouZhibo mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.right.equalTo(contentView);
        make.top.equalTo(txtCangyouzhibo.mas_bottom);
        make.height.mas_equalTo(200);
    }];

    txtcangyouzixub = [[STextFieldWithTitle alloc] init];
    txtcangyouzixub.title = @"藏友咨询";
    txtcangyouzixub.isBottom = NO;
    txtcangyouzixub.submitColor = ColorHex(@"0000FF");
    txtcangyouzixub.titleColor = kTitleColor;
    txtcangyouzixub.submitAligent = NSTextAlignmentLeft;
    txtcangyouzixub.didTapBlock = ^() {
        CangyouZixunVC* vc = [[CangyouZixunVC alloc] init];
        vc.cID = cid;
        [weakSelf.navigationController pushViewController:vc animated:YES];
    };
    [contentView addSubview:txtcangyouzixub];
    [txtcangyouzixub mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.right.equalTo(contentView);
        make.top.equalTo(tabCangyouZhibo.mas_bottom).offset(10);
        make.height.mas_equalTo(40);
    }];

    tabCangyouZixun = [[UITableView alloc] init];
    tabCangyouZixun.delegate = self;
    tabCangyouZixun.dataSource = self;
    tabCangyouZixun.tableFooterView = [UIView new];

    [tabCangyouZixun setSeparatorColor:ColorHex(@"f5f5f5")];

    [contentView addSubview:tabCangyouZixun];
    [tabCangyouZixun mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.right.equalTo(contentView);
        make.top.equalTo(txtcangyouzixub.mas_bottom);
        make.height.mas_equalTo(1);
    }];
}

- (void)btnZixun_Click
{
    CangyouZixunVC* vc = [[CangyouZixunVC alloc] init];
    vc.cID = cid;
    [self.navigationController pushViewController:vc animated:YES];
}

- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    if ([tabCangyouZixun isEqual:tableView]) {
        ExpertAppointmentZhubandanweiDataModel* model = modelDetail.cyzx.data[indexPath.row];
        CGSize sizeCell1 = [model.hf.content sizeWithFontSize:13 andMaxWidth:kScreenW - 105 andMaxHeight:1000];
        CGSize sizeCell2 = [model.zx.content sizeWithFontSize:13 andMaxWidth:kScreenW - 105 andMaxHeight:1000];
        return sizeCell1.height + sizeCell2.height + 90;
    }

    if ([tabCangyouZhibo isEqual:tableView]) {
        CGFloat cellHeight = 0;
        cellHeight = cellHeight + 20;
        xczbModel* modelXYZX = modelDetail.xczb[indexPath.row];
        CGSize cellSize = [modelXYZX.message sizeWithFontSize:15 andMaxWidth:kScreenW - 20 andMaxHeight:10000];
        cellHeight = cellHeight + cellSize.height;
        NSArray* arrayPhoto = [modelXYZX.photos componentsSeparatedByString:@","];
        if (arrayPhoto.count > 0) {
            cellHeight = cellHeight + 80;
        }
        return cellHeight;
    }
    return 80;
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([tabZhubandanwei isEqual:tableView]) {
        return modelDetail.zbdw.data.count;
    }

    if ([tabXiebandanwei isEqual:tableView]) {
        return modelDetail.xbdw.data.count;
    }

    if ([tabXiangguanxinwen isEqual:tableView]) {
        return modelDetail.gldt.data.count;
    }

    if ([tabCangyouZhibo isEqual:tableView]) {
        return modelDetail.xczb.count;
    }

    if ([tabCangyouZixun isEqual:tableView]) {
        return modelDetail.cyzx.data.count;
    }
    return 0;
}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    if ([tabZhubandanwei isEqual:tableView]) {
        ExpertAppointmentZhubandanweiDataModel* modelSelect = modelDetail.zbdw.data[indexPath.row];
        MyHomePageDockerVC* vc = [[MyHomePageDockerVC alloc] init];
        vc.navTitle = modelSelect.username;
        vc.artId = modelSelect.uid;
        [self.navigationController pushViewController:vc animated:YES];
    }

    if ([tabXiebandanwei isEqual:tableView]) {
        ExpertAppointmentZhubandanweiDataModel* modelSelect = modelDetail.zbdw.data[indexPath.row];
        MyHomePageDockerVC* vc = [[MyHomePageDockerVC alloc] init];
        vc.navTitle = modelSelect.username;
        vc.artId = modelSelect.uid;
        [self.navigationController pushViewController:vc animated:YES];
    }
    if ([tabCangyouZhibo isEqual:tableView]) {
    }
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    if ([tableView isEqual:tabZhubandanwei]) {
        NSString* identifier = @"tabZhubandanwei";
        ZhubandanweiCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[ZhubandanweiCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.model = modelDetail.zbdw.data[indexPath.row];
        return cell;
    }

    if ([tabXiebandanwei isEqual:tableView]) {
        NSString* identifier = @"tabXiebandanwei";
        ZhubandanweiCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[ZhubandanweiCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.model = modelDetail.xbdw.data[indexPath.row];
        return cell;
    }

    if ([tabXiangguanxinwen isEqual:tableView]) {
        NSString* identifier = @"tabXiangguanxinwen";
        XiangguanXinwenCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[XiangguanXinwenCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.model = modelDetail.gldt.data[indexPath.row];
        return cell;
    }

    if ([tabCangyouZixun isEqual:tableView]) {
        NSString* identifier = @"tabCangyouZixun";
        CangyouZixunCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[CangyouZixunCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.model = modelDetail.cyzx.data[indexPath.row];
        return cell;
    }

    if ([tabCangyouZhibo isEqual:tableView]) {
        NSString* identifier = @"tabCangyouZhibo";
        xczbDetailCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[xczbDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.model = modelDetail.xczb[indexPath.row];
        return cell;
    }
    return nil;
}

//加载用户信息
- (void)loadData
{
    //1.设置请求参数
    [self showLoadingHUDWithTitle:@"正在获取鉴定会详情" SubTitle:nil];
    NSDictionary* dict = @{ @"cuid" : [Global sharedInstance].userID ?: @"0",
        @"eid" : cid };
    //    //2.开始请求
    HHttpRequest* request = [[HHttpRequest alloc] init];
    [request httpGetRequestWithActionName:@"eventcontent" andPramater:dict andDidDataErrorBlock:^(NSURLSessionTask* operation, id responseObject) {
        [self.hudLoading hideAnimated:YES];
        ResultModel* result = [ResultModel mj_objectWithKeyValues:responseObject];
        [self showErrorHUDWithTitle:result.msg SubTitle:nil Complete:nil];
    }
        andDidRequestSuccessBlock:^(NSURLSessionTask* operation, id responseObject) {
            [self.hudLoading hideAnimated:YES];
            modelDetail = [ExpertAppointmentModel mj_objectWithKeyValues:responseObject];
            [self upDataView:modelDetail];
        }
        andDidRequestFailedBlock:^(NSURLSessionTask* operation, NSError* error) {
            [self.hudLoading hideAnimated:YES];
        }];
}

- (void)rightBar_Click
{
    OSMessage* msg = [[OSMessage alloc] init];
    msg.title = @"盛典鉴宝";
    msg.desc = modelDetail.name;
    msg.link = modelDetail.eurl;

    UIImage* dataImage = [UIImage imageNamed:@"icon_Default_Product"];
    NSData* shareImage = UIImagePNGRepresentation(dataImage);
    NSData* shareThumbImage = UIImagePNGRepresentation([dataImage imageCompressForWidth:60]);

    msg.image = shareImage;
    msg.thumbnail = shareThumbImage;

    HShareVC* vc = [[HShareVC alloc] init];
    vc.shareimage = [UIImage imageWithData:shareImage];
    vc.sharedes = modelDetail.name;
    vc.state = @"1";
    [self presentSemiView:vc];
}
- (void)jubao
{
    UIAlertView* dialog = [[UIAlertView alloc] initWithTitle:@"请输入举报内容" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
    [dialog setAlertViewStyle:UIAlertViewStylePlainTextInput];
    [[dialog textFieldAtIndex:0] setKeyboardType:UIKeyboardTypeEmailAddress];
    [dialog show];
}

- (void)alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != 0) {
        return;
    }
    UITextField* nameField = [alertView textFieldAtIndex:0];

    if (nameField.text.length < 1) {
        [self showErrorHUDWithTitle:@"举报内容不能为空" SubTitle:nil Complete:nil];
        return;
    }
    if (![self isNavLogin]) {
        return;
    }
    if(![[Global sharedInstance] userID]){
        [ArtUIHelper addHUDInView:self.view text:@"您尚未登录" hideAfterDelay:1.0];
        return;
    }
    //1.设置请求参数
    [self showLoadingHUDWithTitle:@"正在举报" SubTitle:nil];
    NSDictionary* dict = @{ @"uid" : [Global sharedInstance].userID?:@"0",
        @"tid" : modelDetail.eid,
        @"reason" : nameField.text ?: @"" };
    //2.开始请求
    HHttpRequest* request = [[HHttpRequest alloc] init];
    [request httpPostRequestWithActionName:@"denounce" andPramater:dict andDidDataErrorBlock:^(NSURLSessionTask* operation, id responseObject) {
        [self.hudLoading hideAnimated:YES];
        ResultModel* result = [ResultModel mj_objectWithKeyValues:responseObject];
        [self showErrorHUDWithTitle:result.msg SubTitle:nil Complete:nil];
    }
        andDidRequestSuccessBlock:^(NSURLSessionTask* operation, id responseObject) {
            [self.hudLoading hideAnimated:YES];
            [self showOkHUDWithTitle:@"举报成功" SubTitle:nil Complete:nil];
        }
        andDidRequestFailedBlock:^(NSURLSessionTask* operation, NSError* error) {
            [self.hudLoading hideAnimated:YES];
        }];
}

- (void)upDataView:(ExpertAppointmentModel*)model
{
    //鉴定会状态
    viewFee.fee = modelDetail.tips;
    //    lblTitleTipState.textColor=[UIColor whiteColor];
    //    lblTitleTipState.backgroundColor=[UIColor colorWithHexString:@"5599FF"];
    //    if ([model.status isEqualToString:@"1"]) {
    //        lblTitleTipState.text=@"报名中";
    //    }else if ([model.status isEqualToString:@"2"]){
    //        lblTitleTipState.text=@"进行中";
    //    }else if ([model.status isEqualToString:@"3"]){
    //        lblTitleTipState.text=@"已结束";
    //        lblTitleTipState.backgroundColor=[UIColor grayColor];
    //    }
    viewOwerData.image = @"icon_appraisal_zan";
    //已点击想去
    if ([model.isliked isEqualToString:@"1"]) {
        viewOwerData.image = @"icon_appraisal_Azan";
    }

    lblTitle.text = [self changModelTitle:model.name];
    txtCode.submit = [NSString stringWithFormat:@"%@元", model.price];
    txtbaomingChengyuan.submit = [NSString stringWithFormat:@"%@-%@", [self changeTime:model.stime], [self changeTime:model.etime]]; //model.signall;
    txtPlace.submit = model.location;
    [self upZhuanjia:model.zhuanjia];
    txtMembertitle.submit = model.signall;
    [self upMember:model.signuser];
    [tabZhubandanwei mas_updateConstraints:^(MASConstraintMaker* make) {
        make.height.mas_equalTo(model.zbdw.data.count * 80);
    }];
    [tabZhubandanwei reloadData];

    [tabXiebandanwei mas_updateConstraints:^(MASConstraintMaker* make) {
        make.height.mas_equalTo(model.xbdw.data.count * 80);
    }];
    [tabXiebandanwei reloadData];
    //    NSAttributedString * attrStr = [[NSAttributedString alloc] initWithData:[model.content dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];

    //    lblHuodongJieshao.attributedText=attrStr;
    NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:model.contenturl]];
    [viewHuodongJieShao loadRequest:request];
    NSString* strVideo = model.splj;
    if (strVideo.length > 2) {
        NSMutableArray* arrayVideo = [[strVideo componentsSeparatedByString:@","] mutableCopy];
        for (NSString* strPic in arrayVideo) {
            if (strPic.length < 2) {
                [arrayVideo removeObject:strPic];
            }
        }
        [arrayVideoImage removeAllObjects];
        [self getImage:arrayVideo withNumber:0];
        //        [self upDataVideo:arrayVideo];
    }
    else {
        txtVideoTitle.submit = @"0";
        [scrollVideo mas_updateConstraints:^(MASConstraintMaker* make) {
            make.height.mas_equalTo(1);
        }];
        txtVideoTitle.hidden = YES;
        [txtVideoTitle mas_updateConstraints:^(MASConstraintMaker* make) {
            make.height.mas_equalTo(1);
        }];
        scrollVideo.hidden = YES;
    }
    txtZhubandanweiTitle.submit = model.zbdw.total;
    txtXiebandanwei.submit = model.xbdw.total ?: @"0";
    txtCangyouzhibo.submit = [NSString stringWithFormat:@"%lu", model.xczb.count ?: 0];
    if (model.xczb.count < 1) {
        txtCangyouzhibo.hidden = YES;
        [txtCangyouzhibo mas_updateConstraints:^(MASConstraintMaker* make) {
            make.height.mas_equalTo(1);
        }];
    }
    else {
        txtCangyouzhibo.hidden = NO;
        [txtCangyouzhibo mas_updateConstraints:^(MASConstraintMaker* make) {
            make.height.mas_equalTo(40);
        }];
    }
    txtXiangguanxinwen.submit = model.gldt.total;

    if (model.zbdw.data.count < 1) {
        txtZhubandanweiTitle.hidden = YES;
        [txtZhubandanweiTitle mas_updateConstraints:^(MASConstraintMaker* make) {
            make.height.mas_equalTo(1);
        }];
    }

    if (model.xbdw.data.count < 1) {
        txtXiebandanwei.hidden = YES;
        [txtXiebandanwei mas_updateConstraints:^(MASConstraintMaker* make) {
            make.height.mas_equalTo(1);
        }];
    }

    tabXiangguanxinwen.hidden = YES;
    [tabXiangguanxinwen mas_updateConstraints:^(MASConstraintMaker* make) {
        make.height.mas_equalTo(1);
    }];

    tabCangyouZhibo.hidden = YES;
    [tabCangyouZhibo mas_updateConstraints:^(MASConstraintMaker* make) {
        make.height.mas_equalTo(1);
    }];
    if (model.xczb.count > 0) {
        tabCangyouZhibo.hidden = NO;
        CGFloat cellHeight = 0;
        for (xczbModel* modelXYZX in model.xczb) {
            cellHeight = cellHeight + 20;
            CGSize cellSize = [modelXYZX.message sizeWithFontSize:15 andMaxWidth:kScreenW - 20 andMaxHeight:10000];
            cellHeight = cellHeight + cellSize.height;
            NSArray* arrayPhoto = [modelXYZX.photos componentsSeparatedByString:@","];
            if (arrayPhoto.count > 0) {
                cellHeight = cellHeight + 80;
            }
        }

        [tabCangyouZhibo mas_updateConstraints:^(MASConstraintMaker* make) {
            make.height.mas_equalTo(cellHeight);
        }];

        [tabCangyouZhibo reloadData];
    }

    tabCangyouZixun.hidden = YES;
    [tabCangyouZixun mas_updateConstraints:^(MASConstraintMaker* make) {
        make.height.mas_equalTo(1);
    }];
    if (model.cyzx.data.count > 0) {
        tabCangyouZixun.hidden = NO;

        CGFloat fCellCangyouHeight = 0;
        for (ExpertAppointmentZhubandanweiDataModel* modelCangyou in modelDetail.cyzx.data) {
            CGSize sizeCell1 = [modelCangyou.hf.content sizeWithFontSize:13 andMaxWidth:kScreenW - 105 andMaxHeight:1000];
            CGSize sizeCell2 = [modelCangyou.zx.content sizeWithFontSize:13 andMaxWidth:kScreenW - 105 andMaxHeight:1000];
            fCellCangyouHeight = fCellCangyouHeight + sizeCell1.height + sizeCell2.height + 80;
        }

        [tabCangyouZixun mas_updateConstraints:^(MASConstraintMaker* make) {
            make.height.mas_equalTo(fCellCangyouHeight);
        }];
        [tabCangyouZixun reloadData];
    }
    txtcangyouzixub.submit = model.cyzx.total;
    if (model.cyzx.data.count < 1) {
        txtcangyouzixub.hidden = YES;
        [txtCangyouzhibo mas_updateConstraints:^(MASConstraintMaker* make) {
            make.height.mas_equalTo(1);
        }];
    }
}

- (void)getImage:(NSMutableArray*)arrayVideo withNumber:(int)iNumber
{
    //1.设置请求参数
    NSString* strVideoID = [self getVideoIDWithVideoUrl:arrayVideo[iNumber]];
    if (strVideoID.length < 1) {
        return;
    }
    [arrayPlayer addObject:strVideoID];
    NSDictionary* dict = @{ @"client_id" : youKuclientId,
        @"video_id" : strVideoID };
    //1.管理器
    AFHTTPSessionManager* manager = [AFHTTPSessionManager manager];
    //2 设定类型
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", @"application/json", nil];
    manager.requestSerializer.timeoutInterval = 20.0f; //超时时间

    NSString* url = @"https://openapi.youku.com/v2/videos/show.json";
    //4 请求
    [manager GET:url
        parameters:dict
        success:^(NSURLSessionTask* operation, id responseObject) {
            NSString* strVideoUrl = [responseObject objectForKey:@"bigThumbnail"];
            [arrayVideoImage addObject:strVideoUrl];
            int iVideoNumber = iNumber + 1;
            if (arrayVideoImage.count == arrayVideo.count) {
                [self upDataVideo:arrayVideoImage];
            }
            else {
                [self getImage:arrayVideo withNumber:iVideoNumber];
            }
        }
        failure:^(NSURLSessionTask* operation, NSError* error){
        }];
}

- (void)upDataVideo:(NSMutableArray*)arrayVideo
{
    if (arrayVideo.count < 1) {
        return;
    }
    [arrayPlayer removeAllObjects];

    UIImageView* viewLast = nil;
    for (int i = 0; i < arrayVideo.count; i++) {
        UIImageView* viewVideoDetail = [[UIImageView alloc] init];
        [viewVideoDetail setBackgroundColor:kClearColor];
        [viewVideo addSubview:viewVideoDetail];
        [viewVideoDetail mas_makeConstraints:^(MASConstraintMaker* make) {
            make.centerY.equalTo(viewVideo);
            make.left.equalTo(viewVideo).offset(10 + (i * 130));
            make.width.mas_equalTo(120);
            make.height.mas_equalTo(120);
        }];

        viewVideoDetail.tag = i;
        viewLast = viewVideoDetail;

        viewVideoDetail.userInteractionEnabled = YES;
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imgVideo_Click:)];
        [viewVideoDetail addGestureRecognizer:tap];

        [viewVideoDetail sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@!120",arrayVideo[i]]] placeholderImage:[UIImage imageNamed:@"icon_Default_Product"]];

        UIImageView* imgState = [[UIImageView alloc] init];
        imgState.image = [UIImage imageNamed:@"icon_post_video"];
        [viewVideoDetail addSubview:imgState];
        [imgState mas_makeConstraints:^(MASConstraintMaker* make) {
            make.center.equalTo(viewVideoDetail);
        }];
        imgState.tag = 99;
    }

    [viewVideo mas_makeConstraints:^(MASConstraintMaker* make) {
        make.bottom.equalTo(viewLast).offset(25);
    }];
}

- (void)imgVideo_Click:(UITapGestureRecognizer*)tapClick
{
    NSString* videoID = @"";
    NSString* strVideo = modelDetail.splj;
    if (strVideo.length > 2) {
        NSMutableArray* arrayVideo = [[strVideo componentsSeparatedByString:@","] mutableCopy];
        for (NSString* strPic in arrayVideo) {
            if (strPic.length < 2) {
                [arrayVideo removeObject:strPic];
            }
        }
        videoID = arrayVideo[tapClick.view.tag];
        //        [self upDataVideo:arrayVideo];
    }

    videoID = [self getVideoIDWithVideoUrl:videoID];
    if (videoID.length > 1) {
//         播放 视频
        PlayerViewController* vc = [[PlayerViewController alloc] init];
        vc.videoID = videoID;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)upMember:(NSMutableArray*)arraySignure
{
    if (arraySignure.count < 1) {
        scrollMember.hidden = YES;
        [scrollMember mas_makeConstraints:^(MASConstraintMaker* make) {
            make.height.mas_equalTo(1);
        }];
        txtMembertitle.hidden = YES;
        [txtMembertitle mas_updateConstraints:^(MASConstraintMaker* make) {
            make.height.mas_equalTo(1);
        }];
        return;
    }

    for (int i = 0; i < arraySignure.count; i++) {
        NSMutableDictionary* modelUser = arraySignure[i];
        UIImageView* imgHead = [[UIImageView alloc] init];
        [imgHead sd_setImageWithURL:[NSURL URLWithString:[modelUser objectForKey:@"avatar"]] placeholderImage:[UIImage imageNamed:@"temp_Default_headProtrait"]];
        [viewMember addSubview:imgHead];
        [imgHead mas_makeConstraints:^(MASConstraintMaker* make) {
            make.left.equalTo(viewMember).offset(10 + i * 90);
            make.width.height.mas_equalTo(80);
            make.top.equalTo(viewMember).offset(10);
        }];
    }

    [viewMember mas_updateConstraints:^(MASConstraintMaker* make) {
        make.right.equalTo(viewMember.subviews.lastObject).offset(10);
    }];
}

- (void)upZhuanjia:(NSMutableArray*)arrayZHuanjia
{
    if (arrayZHuanjia.count < 1) {
        [scrollZhuanjia mas_updateConstraints:^(MASConstraintMaker* make) {
            make.height.mas_equalTo(1);
        }];
        scrollZhuanjia.hidden = YES;
        viewZhuanjiaBG.hidden = YES;
        [viewZhuanjiaBG mas_updateConstraints:^(MASConstraintMaker* make) {
            make.height.mas_equalTo(1);
        }];
        return;
    }

    NSMutableArray* arrayCopy = [arrayZHuanjia mutableCopy];
    ZhuanjiaView* zhuanjiLast = nil;
    for (int i = 0; i < arrayCopy.count; i++) {
        ExpertAppointmentZhuanjiaModel* model = arrayCopy[i];
        ZhuanjiaView* zhuanjia = [[ZhuanjiaView alloc] init];
        zhuanjia.model = model;
        zhuanjia.tag = i;
        zhuanjia.backgroundColor = kWhiteColor;
        UITapGestureRecognizer* tapZhuanjia = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapZhuanjia_Click:)];
        zhuanjia.userInteractionEnabled = YES;
        [zhuanjia addGestureRecognizer:tapZhuanjia];
        [viewZhuanjiaBG addSubview:zhuanjia];
        [zhuanjia mas_makeConstraints:^(MASConstraintMaker* make) {
            make.left.equalTo(viewZhuanjiaBG).offset(KKWidth(25) + i * (KKWidth(307)));
            make.width.mas_equalTo(kScreenW / 2 - 30);
            make.top.equalTo(scrollZhuanjia).offset(0);
            make.bottom.equalTo(scrollZhuanjia).offset(-10);
        }];
        zhuanjiLast = zhuanjia;
    }

    [viewZhuanjiaBG mas_makeConstraints:^(MASConstraintMaker* make) {
        make.right.equalTo(viewZhuanjiaBG.subviews.lastObject).offset(10);
    }];
}

- (NSString*)changeTime:(NSString*)time
{
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY年MM月dd日 HH:MM"];
    NSDate* confromTimesp = [NSDate dateWithTimeIntervalSince1970:time.intValue];
    return [formatter stringFromDate:confromTimesp];
}

//点击想去按钮
- (void)clickWangGo
{
    if (![self isNavLogin]) {
        return;
    }

    NSString* strAc = @"";
    if ([modelDetail.isliked isEqualToString:@"1"]) {
        //关闭想
        strAc = @"delactionevent";
    }
    else {
        strAc = @"actionevent";
    }
    if(![[Global sharedInstance] userID]){
        [ArtUIHelper addHUDInView:self.view text:@"您尚未登录" hideAfterDelay:1.0];
        return;
    }
    //1.设置请求参数
    [self showLoadingHUDWithTitle:@"正在加载数据" SubTitle:nil];
    NSDictionary* dict = @{ @"uid" : [Global sharedInstance].userID?:@"0",
        @"eid" : cid };
    //    //2.开始请求
    HHttpRequest* request = [[HHttpRequest alloc] init];
    [request httpPostRequestWithActionName:strAc
        andPramater:dict
        andDidDataErrorBlock:^(NSURLSessionTask* operation, id responseObject) {
            [self.hudLoading hide:YES];
            ResultModel* result = [ResultModel objectWithKeyValues:responseObject];
            [self showErrorHUDWithTitle:result.msg SubTitle:nil Complete:nil];
        }
        andDidRequestSuccessBlock:^(NSURLSessionTask* operation, id responseObject) {
            [self.hudLoading hide:YES];
            [self loadData];
        }
        andDidRequestFailedBlock:^(NSURLSessionTask* operation, NSError* error) {
            [self.hudLoading hide:YES];
        }];
}

- (void)clickFee
{

    viewFee.hidden = NO;
}

- (void)tapSelf_Click
{
    [self dismissSemiModalView];
}

- (void)tapZhuanjia_Click:(UITapGestureRecognizer*)tapZhuanjia
{
    ExpertAppointmentZhuanjiaModel* model = modelDetail.zhuanjia[tapZhuanjia.view.tag];
    MyHomePageDockerVC* vc = [[MyHomePageDockerVC alloc] init];
    vc.navTitle = model.username;
    vc.artId = model.uid;
    [self.navigationController pushViewController:vc animated:YES];
}

//报名成员点击事件
- (void)tapMember_Click
{
    CangyouBaomingJiluVC* vc = [[CangyouBaomingJiluVC alloc] init];
    vc.cID = cid;
    [self.navigationController pushViewController:vc animated:YES];
}

//我要报名点击事件
- (void)btnBaoming_Click
{
    if (![self isNavLogin]) {
        return;
    }

    BaoMingVC* vc = [[BaoMingVC alloc] init];
    vc.uID = cid;
    vc.money = modelDetail.price;
    [self.navigationController pushViewController:vc animated:YES];
}

- (NSString*)changModelTitle:(NSString*)name
{
    return [NSString stringWithFormat:@"%@", [name stringByReplacingOccurrencesOfString:@"|" withString:@"\n"]];
}

- (void)webViewDidFinishLoad:(UIWebView*)webView
{
    CGFloat height = webView.scrollView.contentSize.height;
    [viewHuodongJieShao mas_updateConstraints:^(MASConstraintMaker* make) {
        make.height.mas_equalTo(height);
    }];
}

@end
