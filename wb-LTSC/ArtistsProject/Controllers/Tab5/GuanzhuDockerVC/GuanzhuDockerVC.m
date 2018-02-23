//
//  GuanzhuDockerVC.m
//  ShesheDa
//
//  Created by chen on 16/7/31.
//  Copyright © 2016年 上海翔汇网络有限公司. All rights reserved.
//

#import "GuanzhuDockerVC.h"
#import "GuanzhuVC.h"
#import "FensiVC.h"
#import "TitleView_Choose.h"
#import "GFPageSlider.h"

@interface GuanzhuDockerVC (){
    GFPageSlider* pageSlider;
}

@end

@implementation GuanzhuDockerVC

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.navigationController.navigationBar setTranslucent:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kWhiteColor;
    self.edgesForExtendedLayout = UIRectEdgeNone; // 内容不扩展
    
    TitleView_Choose *viewChoose=[[TitleView_Choose alloc]initWithFrame:CGRectMake(0, 0, T_WIDTH(160), 45)];
    viewChoose.arrayTitle=@[ @"我的关注",@"我的粉丝"];
    viewChoose.backgroundColor=kWhiteColor;
    [viewChoose setSelectBtnCilck:^(NSInteger iNumber) {
        pageSlider.selectedPageIndex=iNumber ;
    }];
    self.navigationItem.titleView=viewChoose;
    
    
    NSMutableArray* vcs = [[NSMutableArray alloc] initWithCapacity:0];
    
    GuanzhuVC* coupon1 = [[GuanzhuVC alloc] init];
    [self addChildViewController:coupon1];
    [vcs addObject:coupon1];
    
    FensiVC *coupon2=[[FensiVC alloc] init];
    [self addChildViewController:coupon2];
    [vcs addObject:coupon2];
    
    pageSlider = [[GFPageSlider alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH - self.navBottomY)
                                        numberOfPage:2
                                     viewControllers:vcs
                                    menuButtonTitles:@[ @"我的关注",@"我的粉丝"]];
    
    [self.view addSubview:pageSlider];
    pageSlider.menuTitleColor = kColor12;
    pageSlider.menuHeight = 1;
    pageSlider.menuNumberPerPage = 2;
    pageSlider.menuBackColor = [UIColor whiteColor];
    pageSlider.indicatorLineColor = kTitleColor;
    [pageSlider setDidPageChangedBlock:^(GFPageSlider *iNumber, NSInteger iChooos) {
        [viewChoose setIClick:iChooos];
    }];
}


@end
