//
//  MSBFollowController.m
//  meishubao
//
//  Created by T on 16/11/25.
//  Copyright © 2016年 benbun. All rights reserved.
//
/**关注*/
#import "MSBFollowController.h"
#import "GeneralConfigure.h"

#import "MSBFollowRecommendController.h"
@interface MSBFollowController ()

@end

@implementation MSBFollowController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"我的关注";
    [self commitInit];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)commitInit{
    
    [self setTabBarFrame:CGRectMake(0, APP_NAVIGATIONBAR_H, SCREEN_WIDTH, APP_SEGMENT_H)
        contentViewFrame:CGRectMake(0, APP_NAVIGATIONBAR_H + APP_SEGMENT_H, SCREEN_WIDTH, SCREEN_HEIGHT - APP_NAVIGATIONBAR_H - APP_SEGMENT_H)];
//    self.tabBar.itemTitleColor = [UIColor colorWithHex:0x989898];
    self.tabBar.itemTitleSelectedColor = [UIColor colorWithHex:0xB51B20];
    self.tabBar.itemTitleFont = [UIFont systemFontOfSize:14];
    self.tabBar.itemTitleSelectedFont = [UIFont systemFontOfSize:18];
    //    [self.tabBar setScrollEnabledAndItemWidth:30.f];
    self.tabBar.leftAndRightSpacing = (SCREEN_WIDTH - 200) / 2;
    self.tabBar.itemFontChangeFollowContentScroll = YES;
    self.tabBar.itemSelectedBgScrollFollowContent = YES;
    self.tabBar.itemColorChangeFollowContentScroll = NO;
    self.tabBar.itemSelectedBgColor = RGBCOLOR(192, 17, 20);
    [self.tabBar setItemSelectedBgInsets:UIEdgeInsetsMake(36, 15, 2, 15) tapSwitchAnimated:YES];
    [self.tabBar setScrollEnabledAndItemFitTextWidthWithSpacing:40];
    [self setContentScrollEnabledAndTapSwitchAnimated:YES];
    
    MSBFollowRecommendController *recommendVC = [MSBFollowRecommendController new];
     recommendVC.yp_tabItemTitle = @"推荐关注";
    recommendVC.followType = MSBFollowTypeRecommend;
   
    
    MSBFollowRecommendController *allVC = [MSBFollowRecommendController new];
    allVC.yp_tabItemTitle = @"全部关注";
    allVC.followType = MSBFollowTypeAll;
    
    self.viewControllers = @[recommendVC,allVC];
    
    //设置夜间模式
    self.tabBar.dk_backgroundColorPicker = DKColorSwiftWithRGB(0xe0e0e0, 0x222222);
    self.view.dk_backgroundColorPicker = DKColorPickerWithKey(BG);
}
@end
