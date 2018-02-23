//
//  MSBCollectController.m
//  meishubao
//
//  Created by T on 16/11/25.
//  Copyright © 2016年 benbun. All rights reserved.
//

#import "MSBCollectController.h"
#import "GeneralConfigure.h"

#import "MSBCollectArticleController.h"
#import "MSBCollectVideoController.h"

#import "MSBPersonCenterArticleVC.h"
#import "MSBPersonCenterPhotoVC.h"
@interface MSBCollectController ()
@property (nonatomic, weak) MSBPersonCenterArticleVC *articleVC;
@property (nonatomic, weak) MSBCollectVideoController *videoVC;
@property (nonatomic, weak) MSBPersonCenterPhotoVC *photoVC;

@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, weak) UIButton  *editBtn;
@end

@implementation MSBCollectController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"我的收藏";
//     [self setTitle:@"我的收藏"];
    // commitInit
    [self commitInit];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)commitInit{
    UIButton *editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.editBtn = editBtn;
    [editBtn setTitle:@"编辑" forState:UIControlStateNormal];
//    [editBtn setImage:[UIImage imageNamed:@"info_collection_edit_icon"] forState:UIControlStateNormal];
    [editBtn.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [editBtn setTitleColor:RGBCOLOR(255, 255, 255) forState:UIControlStateNormal];
    [editBtn sizeToFit];
    [editBtn addTarget:self action:@selector(editClick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:editBtn];
    
    [self setTabBarFrame:CGRectMake(0, APP_NAVIGATIONBAR_H, SCREEN_WIDTH, APP_SEGMENT_H)
        contentViewFrame:CGRectMake(0, APP_NAVIGATIONBAR_H + APP_SEGMENT_H, SCREEN_WIDTH, SCREEN_HEIGHT - APP_NAVIGATIONBAR_H - APP_SEGMENT_H)];
    
    // 文字颜色
//    self.tabBar.itemTitleColor = [UIColor colorWithHex:0x989898];
    self.tabBar.itemTitleSelectedColor = [UIColor colorWithHex:0xB51B20];
    self.tabBar.itemTitleFont = [UIFont systemFontOfSize:14];
    self.tabBar.itemTitleSelectedFont = [UIFont systemFontOfSize:18];
//    [self.tabBar setScrollEnabledAndItemWidth:30.f];
    self.tabBar.leftAndRightSpacing = (SCREEN_WIDTH - 220) / 2;
    
    self.tabBar.itemFontChangeFollowContentScroll = YES;
    self.tabBar.itemSelectedBgScrollFollowContent = YES;
    self.tabBar.itemSelectedBgColor = RGBCOLOR(192, 17, 20);
    [self.tabBar setItemSelectedBgInsets:UIEdgeInsetsMake(36, 15, 2, 15) tapSwitchAnimated:YES];
    [self.tabBar setScrollEnabledAndItemFitTextWidthWithSpacing:40];
    [self setContentScrollEnabledAndTapSwitchAnimated:YES];
    
    MSBPersonCenterArticleVC *articleVC = [MSBPersonCenterArticleVC new];
    articleVC.yp_tabItemTitle = @"文章";
    self.articleVC = articleVC;
    
    MSBCollectVideoController *videoVC = [MSBCollectVideoController new];
    videoVC.yp_tabItemTitle = @"视频";
    self.videoVC = videoVC;
    
    MSBPersonCenterPhotoVC *photoVC = [MSBPersonCenterPhotoVC new];
    photoVC.yp_tabItemTitle = @"图片";
    self.photoVC = photoVC;
    
    self.viewControllers = @[articleVC,videoVC, photoVC];
    //设置夜间模式
    self.tabBar.dk_backgroundColorPicker =DKColorSwiftWithRGB(0xe0e0e0, 0x222222);
    self.view.dk_backgroundColorPicker = DKColorPickerWithKey(BG);
}


- (void)didSelectViewControllerAtIndex:(NSUInteger)index{
    NDLog(@"didSelectViewControllerAtIndex %tu", self.selectedControllerIndex);
    switch (self.selectedControllerIndex) {
        case 0:{
            [self.editBtn setHidden:NO];
            break;
        }
        case 1:{
            [self.editBtn setHidden:NO];
            break;
        }
        case 2:{
            [self.editBtn setHidden:YES];
            break;
        }
        default:
            break;
    }
}

- (void)editClick:(UIButton *)btn{
    self.selectedIndex = self.selectedControllerIndex;
    switch (self.selectedControllerIndex) {
        case 0:
        {
            if (self.articleVC.deleteBlock) {
                self.articleVC.deleteBlock(btn);
            }
            break;
        }
        case 1:
        {
            if (self.videoVC.deleteBlock) {
                self.videoVC.deleteBlock(btn);
            }
            break;
        }
        case 2:
        {
            if (self.photoVC.deleteBlock) {
                self.photoVC.deleteBlock(btn);
            }
            break;
        }
        default:
            break;
    }
}

@end
