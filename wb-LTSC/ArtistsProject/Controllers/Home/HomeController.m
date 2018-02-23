//
//  HomeController.m
//  ArtistProject
//
//  Created by HELLO WORLD on 2017/3/27.
//  Copyright © 2017年 HELLO WORLD. All rights reserved.
//

#import "HomeController.h"
#import "MenuChooseView.h"
#import "IntroVc.h"
#import "RecentVc.h"
#import "WorksVc.h"
#import "TextsVc.h"
#import "MediaVc.h"
#import "ClassifyVc.h"
#import "LYShareMenuView.h"
#import "LYShareMenuItem.h"
#import "InviteVc.h"
#import "PublishDongtaiVC.h"
#import "DraftVC.h"
#import "YTXHomeSearchVC.h"
#import "MemSearchView.h"
#import "SearchGoodsViewController.h"
#import "RecentModel.h"
@interface HomeController ()<UIScrollViewDelegate,LYShareMenuViewDelegate,MemSearchDelegate,SDCycleScrollViewDelegate>
{
    MemSearchView *_search;
    UIView *_autoWidthViewsContainer;
    UIView *menuView;
    BOOL isShowMenu;
}
@property (nonatomic, strong) LYShareMenuView *shareMenuView;

@property(nonatomic,assign)BOOL iSHideStatus;
@property(nonatomic,strong)MenuChooseView* viewChoose;
@property(nonatomic,strong)UIScrollView* homeScrollView;
@property (nonatomic, strong) UIImageView *imageV;
@property(nonatomic,strong)UILabel* nameLabel;
@property(nonatomic,strong)UILabel* subTitle;
@property(nonatomic,strong)IntroVc* introVc;
@property(nonatomic,strong)RecentVc* recentVc;
@property(nonatomic,strong)WorksVc* worksVc;
@property(nonatomic,strong)TextsVc* textsVc;
@property(nonatomic,strong)MediaVc* mediaVc;
@property(nonatomic,strong)ClassifyVc* classifyVc;

@property (nonatomic, strong)NSMutableArray<GoodsCategoryModel *> *tableViewDataM;

@property (nonatomic, strong) RecentModel *recentModel;

@end

@implementation HomeController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"app_logo"]forBarMetrics:UIBarMetricsDefault];
//    [_recentVc refreshData];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self showStateView];
    [Global sharedInstance].isHideState = NO;
}
- (NSMutableArray *)tableViewDataM{
    if (!_tableViewDataM) {
        _tableViewDataM = [NSMutableArray array];
    }
    return _tableViewDataM;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.recentModel = [[RecentModel alloc] init];
    HHttpRequest *request1 = [[HHttpRequest alloc] init];
    [request1 httpGetRequestWithActionName:@"coincheck" andPramater:nil andDidDataErrorBlock:^(NSURLSessionTask *operation, id responseObject) {
        
    }andDidRequestSuccessBlock:^(NSURLSessionTask *operation, id responseObject){
        NSString* tempStr = [NSString stringWithFormat:@"%@",responseObject[@"res"]];
        if ([tempStr isEqualToString:@"0"]) {
            [Global sharedInstance].ishideMoney = false;
        }else{
            [Global sharedInstance].ishideMoney = true;
        }
        
        [self.hudLoading hideAnimated:YES];
    } andDidRequestFailedBlock:^(NSURLSessionTask *operation, NSError *error) {
        [self.hudLoading hideAnimated:YES];
    }];

    [self updataDate];
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    [window addSubview:self.shareMenuView];
    //配置item
    NSMutableArray *array = NSMutableArray.new;
    for (int i = 0; i < 6; i++) {
        LYShareMenuItem *item = nil;
        switch (i) {
            case 0:{
                item = [LYShareMenuItem shareMenuItemWithImageName:@"xiangce" itemTitle:@"近况"];
                break;
            }
            case 1:{
                item = [LYShareMenuItem shareMenuItemWithImageName:@"zuopin" itemTitle:@"作品"];
                break;
            }
            case 2:{
                item = [LYShareMenuItem shareMenuItemWithImageName:@"nainbiao" itemTitle:@"年表"];
                break;
            }
            case 3:{
                item = [LYShareMenuItem shareMenuItemWithImageName:@"meitiguanzu" itemTitle:@"媒体关注"];
                break;
            }
            case 4:{
                item = [LYShareMenuItem shareMenuItemWithImageName:@"wenzi" itemTitle:@"评论文字"];
                break;
            }
            case 5:{
                item = [LYShareMenuItem shareMenuItemWithImageName:@"caogaoxiang" itemTitle:@"草稿箱"];
                break;
            }
            default:
                break;
        }
        
        [array addObject:item];
    }
    self.shareMenuView.shareMenuItems = [array copy];
    //菜单选择器
    if (iOS7Later) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }

    UIImageView *line1=[[UIImageView alloc]initWithFrame:CGRectMake(0, 44, SCREEN_WIDTH, 0.5)];
    line1.backgroundColor=kLineColor;
    [self.view addSubview:line1];

    _homeScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0,0, SCREEN_WIDTH, SCREEN_HEIGHT-64-44)];
    _homeScrollView.delegate = self;
    _homeScrollView.bounces = NO;//设置弹簧效果
    _homeScrollView.pagingEnabled = YES;
    _homeScrollView.contentSize = CGSizeMake(kScreenW,0);
    [self.view addSubview:_homeScrollView];
        //近况
    _recentVc = [[UIStoryboard storyboardWithName:@"RencentVC" bundle:nil]  instantiateViewControllerWithIdentifier:@"RecentVC"];
//    _recentVc.artId = [[Global sharedInstance] getBundleID];
    _recentVc.zhiding = @"1";
    _recentVc.isOpenHeaderRefresh = YES;
    _recentVc.isOpenFooterRefresh = YES;
    _recentVc.obj = self;
    _recentVc.view.frame = CGRectMake(0,0,SCREEN_WIDTH, _homeScrollView.bounds.size.height);
    [_homeScrollView addSubview:_recentVc.view];
    
    
    [self loadUserData];


}

- (void)getHomeArticleCategoryList
{
    kWeakSelf
    [[LLRequestServer shareInstance]requestHomeArticleCategoryWithSuccess:^(LLResponse *response, id data) {
        weakSelf.recentModel = [RecentModel mj_objectWithKeyValues:data];
    } failure:^(LLResponse *response) {
        
    } error:^(NSError *error) {
        
    }];
}

- (void)getMenuList
{
    menuView = [[UIView alloc] initWithFrame:CGRectMake(15, 10, 200, 180)];
    menuView.backgroundColor = RGBA_COLOR(100, 100, 100, 0.5);
    NSArray *titleArr = @[@[@"国内头条",@"新闻时评"],@[@"批评家专栏",@"艺术财富"],@[@"艺术机构",@"艺术设计"],@[@"城外艺术",@"艺术人文"],@[@"艺术家",@"艺术教育"]];
    for (NSInteger i = 0; i < 5; i ++) {
        for (NSInteger j = 0; j < 2; j ++) {
            UIButton *btn = [UIButton buttonWithType:(UIButtonTypeSystem)];
            [btn setTitle:titleArr[i][j] forState:(UIControlStateNormal)];
            btn.frame = CGRectMake(10 + j * 90, 10 + i * 35, 80, 25);
            [btn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
            btn.backgroundColor = RGBCOLOR(169, 33, 41);
            btn.tag = 2*i + j;
            [btn addTarget:self action:@selector(btnAction:) forControlEvents:(UIControlEventTouchUpInside)];
            [menuView addSubview:btn];
        }
    }
    menuView.alpha = 0;
    [self.view addSubview:menuView];
}

- (void)btnAction:(UIButton *)btn
{
    if (btn.tag == 0) {//国内头条
        HeadlineBaseController *lineBaseVC = [[HeadlineBaseController alloc] init];
        lineBaseVC.term_id = @"13";
        [self.navigationController pushViewController:lineBaseVC animated:YES];
    }else if (btn.tag == 1) {//新闻时评
        HeadlineBaseController *lineBaseVC = [[HeadlineBaseController alloc] init];
        lineBaseVC.term_id = @"15";
        [self.navigationController pushViewController:lineBaseVC animated:YES];
    }else if (btn.tag == 2) {//批评家专栏
        HeadlineBaseController *lineBaseVC = [[HeadlineBaseController alloc] init];
        lineBaseVC.term_id = @"17";
        [self.navigationController pushViewController:lineBaseVC animated:YES];
    }else if (btn.tag == 3) {//艺术财富
        HeadlineBaseController *lineBaseVC = [[HeadlineBaseController alloc] init];
        lineBaseVC.term_id = @"4";
        [self.navigationController pushViewController:lineBaseVC animated:YES];
    }else if (btn.tag == 4) {//艺术机构
        HeadlineBaseController *lineBaseVC = [[HeadlineBaseController alloc] init];
        lineBaseVC.term_id = @"15";
        [self.navigationController pushViewController:lineBaseVC animated:YES];
    }else if (btn.tag == 5) {//艺术设计
        HeadlineBaseController *lineBaseVC = [[HeadlineBaseController alloc] init];
        lineBaseVC.term_id = @"8";
        [self.navigationController pushViewController:lineBaseVC animated:YES];
    }else if (btn.tag == 6) {//域外艺术
        HeadlineBaseController *lineBaseVC = [[HeadlineBaseController alloc] init];
        lineBaseVC.term_id = @"15";
        [self.navigationController pushViewController:lineBaseVC animated:YES];
    }else if (btn.tag == 7) {//艺术人文
        HeadlineBaseController *lineBaseVC = [[HeadlineBaseController alloc] init];
        lineBaseVC.term_id = @"7";
        [self.navigationController pushViewController:lineBaseVC animated:YES];
    }else if (btn.tag == 8) {//艺术家
        HeadlineBaseController *lineBaseVC = [[HeadlineBaseController alloc] init];
        lineBaseVC.term_id = @"8";
        [self.navigationController pushViewController:lineBaseVC animated:YES];
    }else if (btn.tag == 9) {//艺术教育
        HeadlineBaseController *lineBaseVC = [[HeadlineBaseController alloc] init];
        lineBaseVC.term_id = @"15";
        [self.navigationController pushViewController:lineBaseVC animated:YES];
    }
    RecommendViewController *commendVC = [[RecommendViewController alloc] init];
    commendVC.title = btn.titleLabel.text;
    [self.navigationController pushViewController:commendVC animated:YES];
}
- (void)leftBtnByImageNamedAction
{
    isShowMenu = !isShowMenu;//显示菜单栏与隐藏菜单栏
    if (isShowMenu) {
        menuView.alpha = 1;
    }else{
        menuView.alpha = 0;
    }
}

-(void)addRightBarItem {
    UIBarButtonItem *search = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"navi_search"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style: UIBarButtonItemStylePlain target:self action:@selector(changeSearch)];
    // 扫一扫
    UIBarButtonItem *contact=[[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"navi_contact"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style: UIBarButtonItemStylePlain target:self action:@selector(changeContact)];
    
    self.navigationItem.rightBarButtonItems = @[search,contact];
}

- (void)changeSearch
{
    
}
- (void)changeContact
{
    
}

//请求数据
- (void)updataDate{
    [self showLoadingHUDWithTitle:@"正在加载" SubTitle:nil];
    [ArtRequest GetRequestWithActionName:@"goodstype" andPramater:nil succeeded:^(id responseObject) {
        [self hideHUD];
        [self.tableViewDataM addObjectsFromArray:[GoodsCategoryModel mj_objectArrayWithKeyValuesArray:(NSArray *)responseObject]];
    } failed:^(id responseObject) {
        
        [self hideHUD];
    }];
}

// 搜索视图消息代理方法
- (void)menSearchNewMessage:(UIButton *)button
{
    [self.view endEditing:YES];
    [button setTitle:@"" forState:(UIControlStateNormal)];
}

-(void)loadUserData{
    NSDictionary *dict = @{@"uid":[[Global sharedInstance] getBundleID]};
    __weak HomeController* weakf = self;
    [ArtRequest GetRequestWithActionName:@"userinfo" andPramater:dict succeeded:^(id responseObject) {
        __strong typeof(weakf)strongSelf = weakf;
        strongSelf.model=[UserInfoModel mj_objectWithKeyValues:responseObject];
        weakf.subTitle.text = [NSString stringWithFormat:@"%@",self.model.ename];
    } failed:^(id responseObject) {
       
    }];
}
-(void)rightBtnClick:(UIButton*)sender{
    
    NSInteger tag = sender.tag;
    switch (tag) {
        case 0:
        {
           [self.shareMenuView show];
        }
            break;
        case 1:
        {
            YTXHomeSearchVC * search =[YTXHomeSearchVC new];
            search.hidesBottomBarWhenPushed = YES;
            search.navigationController.navigationBarHidden = YES;
            [self.navigationController pushViewController:search animated:YES];
        }
            break;
        case 2:
        {
            if (![self isNavLogin]) {
                return;
            }
                        InviteVc * search =[[InviteVc alloc]init];
                         search.navTitle = @"邀请好友";
                        search.hidesBottomBarWhenPushed = YES;
                        [self.navigationController pushViewController:search animated:YES];
        }
            break;
        default:
            break;
    }
}
#pragma - mark - 发布
- (void)shareMenuView:(LYShareMenuView *)shareMenuView didSelecteShareMenuItem:(LYShareMenuItem *)shareMenuItem atIndex:(NSInteger)index{
    if (![self isNavLogin]) {
        return;
    }
    switch (index) {
        case 0:{

            PublishDongtaiVC *vc=[[PublishDongtaiVC alloc]init];
            vc.hidesBottomBarWhenPushed = YES;
            vc.topictype = @"7";
            [self.navigationController pushViewController:vc animated:YES];
            
            break;
        }
        case 1:{
            if (![self isNavLogin]) {
                return;
            }
            PublishDongtaiVC *vc=[[PublishDongtaiVC alloc]init];
            vc.topictype = @"6";
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case 2:{
            if (![self isNavLogin]) {
                return;
            }
            PublishDongtaiVC *vc=[[PublishDongtaiVC alloc]init];
            vc.hidesBottomBarWhenPushed = YES;
            vc.topictype = @"8";
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case 3:
        {
            if (![self isNavLogin]) {
                return;
            }
            PublishDongtaiVC *vc=[[PublishDongtaiVC alloc]init];
            vc.hidesBottomBarWhenPushed = YES;
            vc.topictype = @"17";
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case 4:
        {
            if (![self isNavLogin]) {
                return;
            }
            PublishDongtaiVC *vc=[[PublishDongtaiVC alloc]init];
            vc.hidesBottomBarWhenPushed = YES;
            vc.topictype = @"9";
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case 5:
        {
            if (![self isNavLogin]) {
                return;
            }
            
            DraftVC *VC = [[DraftVC alloc] init];
            VC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:VC animated:YES];
        }
        default:
            break;
    }
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
//    if (scrollView==_homeScrollView) {
//         _viewChoose.selectedPageIndex = scrollView.contentOffset.x / scrollView.frame.size.width;
//    }
}
//返回宽度
-(CGFloat)getLabelWidthWithStr:(NSString*)textStr font:(UIFont*)font{
    
    CGSize size = [textStr sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil]];
    CGFloat w = size.width;
    return w;
}
-(void)showStateView{
    self.iSHideStatus = NO;
    [UIView animateWithDuration:0.5 animations:^{
//        _viewChoose.frame = CGRectMake(0,0, kScreenW, 44);
        _homeScrollView.frame = CGRectMake(0,0, SCREEN_WIDTH, SCREEN_HEIGHT-64-44);
         [self changeStateView];
       }];
   
//[self performSelector:@selector(changeStateView) withObject:self afterDelay:0.1];

}
- (void)hideStateView{
    self.iSHideStatus = YES;
    [UIView animateWithDuration:0.2 animations:^{
//        _viewChoose.frame = CGRectMake(0,0, kScreenW, 44);
        _homeScrollView.frame = CGRectMake(0,0, SCREEN_WIDTH, SCREEN_HEIGHT-44);
        [self changeStateView];
    }];
    
    
//    [self performSelector:@selector(changeStateView) withObject:self afterDelay:0.1];
}
-(void)changeStateView{
    [self.navigationController setNavigationBarHidden:self.iSHideStatus animated:YES];//隐藏导航
    [self setNeedsStatusBarAppearanceUpdate];//重载
}
//重载
- (UIStatusBarAnimation )preferredStatusBarUpdateAnimation
{
    return UIStatusBarAnimationSlide;
}
-(BOOL)prefersStatusBarHidden{
    return self.iSHideStatus;
}
- (LYShareMenuView *)shareMenuView{
    if (!_shareMenuView) {
        _shareMenuView = [[LYShareMenuView alloc] init];
        __weak typeof(self)wself = self;
        _shareMenuView.delegate = wself;
    }
    return _shareMenuView;
}
@end
