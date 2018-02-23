//
//  YTXOrderViewController.m
//  ShesheDa
//
//  Created by Hongwei Chen on 2016/11/14.
//  Copyright © 2016年 北京艺天下文化科技有限公司. All rights reserved.
//

#import "YTXOrderViewController.h"
#import "TitleView_Choose.h"
#import "YTXOrderListViewController.h"

@interface YTXOrderViewController ()

@property (nonatomic, strong) GFPageSlider * pageSlider;

@property (nonatomic, strong) TitleView_Choose * viewChoose;

@end

@implementation YTXOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSMutableArray* vcs = [[NSMutableArray alloc] initWithCapacity:0];
    YTXOrderListViewController * vc1 = [[YTXOrderListViewController alloc] init];
    vc1.orderType = @"2"; // 买入
    [self addChildViewController:vc1];
    [vcs addObject:vc1];
    
    YTXOrderListViewController * vc2 = [[YTXOrderListViewController alloc] init];
    vc2.orderType = @"1"; // 卖出
    [self addChildViewController:vc2];

    _viewChoose = [[TitleView_Choose alloc] initWithFrame:CGRectMake(0, 0, 160, 44)];
    if ([_isgroup isEqualToString:@"1"]) {// 判断是否为编辑管理用户组
        _viewChoose.arrayTitle = @[@"买入",@"卖出"];
        [vcs addObject:vc2];
    }else{
        _viewChoose.arrayTitle = @[@"买入"];
    }
    _viewChoose.backgroundColor = kWhiteColor;
    __weak typeof(self)weakSelf = self;
    [_viewChoose setSelectBtnCilck:^(NSInteger iNumber) {
        weakSelf.pageSlider.selectedPageIndex = (int)iNumber;
    }];
    _pageSlider = [[GFPageSlider alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH - self.navBottomY)
                                         numberOfPage:vcs.count
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
