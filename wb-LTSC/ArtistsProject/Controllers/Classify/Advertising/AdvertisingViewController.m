//
//  AdvertisingViewController.m
//  ArtistsProject
//
//  Created by 大锅 on 2017/6/17.
//  Copyright © 2017年 HELLO WORLD. All rights reserved.
//

#import "AdvertisingViewController.h"
#import "ZJSliderView.h"
#import "MediaVc.h"
#import "YTXMyFriendsViewController.h"
#import "ADParterMediaVC.h"
@interface AdvertisingViewController (){
    MediaVc *_mediaVc;
    YTXMyFriendsViewController *_friendsVC;
    ZJSliderView *_slider;
    ADParterMediaVC *_parterVC;
}
@property (nonatomic, strong)UIView *navigationBarView;

@end

@implementation AdvertisingViewController

-(UIView *)navigationBarView{
    if (!_navigationBarView) {
        _navigationBarView  = [[UIView alloc]initWithFrame:CGRectMake(0, 20, kScreenW, 44)];
        [self.view addSubview:_navigationBarView];
    }
    return _navigationBarView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self createSliderView];
    [self setUpNavigationBar];

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

#pragma mark - UI
-(void)setUpNavigationBar{
    
    UIButton *backBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 44)];
    [backBtn setImage:[UIImage imageNamed:@"icon_navigationbar_back"]  forState:UIControlStateNormal];
    
    [backBtn addTarget:self action:@selector(clickBack:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationBarView addSubview:backBtn];
    
    UIView *controlView = [_slider topControlViewWithFrame:CGRectMake(80, 0, SCREEN_WIDTH - 160, 44) titleLabelWidth:SCREEN_WIDTH/2 - 100];
    controlView.backgroundColor = [UIColor whiteColor];
    [self.navigationBarView addSubview:controlView];
}

-(void)clickBack:(UIButton *)btn{
    [self.navigationController popViewControllerAnimated:YES];
}



-(void)createSliderView
{
    _slider = [[ZJSliderView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-44)];
    //媒体
    _mediaVc = [[MediaVc alloc]init];
    _mediaVc.title = @"媒体报道";
//    _mediaVc.artId = [[Global sharedInstance] getBundleID];
    _mediaVc.isOpenHeaderRefresh = YES;
    _mediaVc.isOpenFooterRefresh = YES;
    _mediaVc.obj = self;
    
    _parterVC = [[ADParterMediaVC alloc]init];
    _parterVC.title  = @"合作媒体";
    [_slider setViewControllers:@[_mediaVc,_parterVC] owner:self];
    [self.view addSubview:_slider];
}

@end
