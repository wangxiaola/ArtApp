//
//  YTXInviteCodeViewController.m
//  ShesheDa
//
//  Created by Hongwei Chen on 2016/11/8.
//  Copyright © 2016年 北京艺天下文化科技有限公司. All rights reserved.
//

#import "YTXInviteCodeViewController.h"
#import "TitleView_Choose.h"
#import "YTXUserListViewController.h"
#import "GFPageSlider.h"
#import "sendBtn.h"
#import "InviteVc.h"

@interface YTXInviteCodeViewController ()

@property (nonatomic, strong) GFPageSlider * pageSlider;

@property (nonatomic, strong) TitleView_Choose * viewChoose;

@end

@implementation YTXInviteCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _viewChoose = [[TitleView_Choose alloc] initWithFrame:CGRectMake(0, 0, T_WIDTH(240), 44)];
    _viewChoose.arrayTitle = @[@"LV1",@"LV2",@"LV3"];
    _viewChoose.backgroundColor = kWhiteColor;
    __weak typeof(self)weakSelf = self;
    [_viewChoose setSelectBtnCilck:^(NSInteger iNumber) {
        weakSelf.pageSlider.selectedPageIndex = (int)iNumber;
    }];
    
    NSMutableArray* vcs = [[NSMutableArray alloc] initWithCapacity:0];
    
    YTXUserListViewController * vc1 = [[YTXUserListViewController alloc] init];
    vc1.level = @"1";
    [self addChildViewController:vc1];
    [vcs addObject:vc1];
    
    YTXUserListViewController * vc2 = [[YTXUserListViewController alloc] init];
    vc2.level = @"2";
    [self addChildViewController:vc2];
    [vcs addObject:vc2];
    
    YTXUserListViewController * vc3 = [[YTXUserListViewController alloc] init];
    vc3.level = @"3";
    [self addChildViewController:vc3];
    [vcs addObject:vc3];
    
    _pageSlider = [[GFPageSlider alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH - self.navBottomY)
                                        numberOfPage:3
                                     viewControllers:vcs
                                    menuButtonTitles:_viewChoose.arrayTitle];
    [self.view addSubview:_pageSlider];
    [_pageSlider mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.right.top.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
    
    _pageSlider.menuHeight = 1;
    _pageSlider.menuNumberPerPage = 3;
    _pageSlider.menuBackColor = kColor0;
    _pageSlider.indicatorLineColor = kTitleColor;
    [_pageSlider setDidPageChangedBlock:^(GFPageSlider* iNumber, NSInteger iChooos) {
        
        [weakSelf.viewChoose setIClick:iChooos];
    }];
    
    self.navigationItem.titleView = _viewChoose;
    // Do any additional setup after loading the view.
    
    UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = [UIColor blackColor];
    btn.titleLabel.font = ART_FONT(ARTFONT_OF);
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setTitle:@"马上邀请 >" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnSend_Click) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.height.mas_equalTo(44);
        make.bottom.equalTo(self.view.mas_bottom).offset(0);
    }];

}
-(void)btnSend_Click{
    InviteVc * search =[[InviteVc alloc]init];
    search.navTitle = @"邀请好友";
    search.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:search animated:YES];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
