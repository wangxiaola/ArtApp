//
//  HomeController.m
//  ArtistProject
//
//  Created by HELLO WORLD on 2017/3/27.
//  Copyright © 2017年 HELLO WORLD. All rights reserved.
//

#import "MyHomePageDockerVC.h"
#import "MenuChooseView.h"
#import "IntroVc.h"
#import "RecentVc.h"
#import "WorksVc.h"
#import "SellVC.h"
#import "TextsVc.h"
#import "MediaVc.h"
#import "ClassifyVc.h"
#import "ArtCirclesVc.h"
#import "LYShareMenuView.h"
#import "LYShareMenuItem.h"
#import "InviteVc.h"
#import "PublishDongtaiVC.h"
#import "DraftVC.h"
#import "YiShuZaiShouVC.h"
#import "UserInfoModel.h"
#define iOS7Later ([UIDevice currentDevice].systemVersion.floatValue >= 7.0f)


@interface MyHomePageDockerVC ()<UIScrollViewDelegate,LYShareMenuViewDelegate>
{
    BOOL _isArtist;//判断艺术家
    UserInfoModel *model;
}
@property (nonatomic, strong) LYShareMenuView *shareMenuView;
@property(nonatomic,assign)BOOL iSHideStatus;
@property (nonatomic, strong)NSMutableArray<GoodsCategoryModel *> *tableViewDataM;
@property(nonatomic,strong)MenuChooseView* viewChoose;
@property(nonatomic,strong)UIScrollView* homeScrollView;
@property(nonatomic,strong)UILabel* nameLabel;
@property(nonatomic,strong)UILabel* subTitle;
@property(nonatomic,strong)IntroVc* introVc;
@property(nonatomic,strong)RecentVc* recentVc;
@property(nonatomic,strong)WorksVc* worksVc;
@property (nonatomic, strong) SellVC *sellVc;
@property(nonatomic,strong)TextsVc* textsVc;
@property(nonatomic,strong)MediaVc* mediaVc;
@property(nonatomic,strong)ClassifyVc* classifyVc;
@property(nonatomic,strong)ArtCirclesVc* circlesVc;
@property (nonatomic, strong) YiShuZaiShouVC *zaishouVC;

@end

@implementation MyHomePageDockerVC
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    _tableViewDataM = [NSMutableArray array];
//    if (!_artName) {
//    [self loadUserData];
//    }
    [self updataDate];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self showStateView];
    [Global sharedInstance].isHideState = NO;
}
//请求数据
-(void)updataDate{
    [self showLoadingHUDWithTitle:@"正在加载" SubTitle:nil];
    [ArtRequest GetRequestWithActionName:@"goodstype" andPramater:nil succeeded:^(id responseObject) {
        kPrintLog(responseObject);
        [self hideHUD];
        [self.tableViewDataM addObjectsFromArray:[GoodsCategoryModel mj_objectArrayWithKeyValuesArray:(NSArray *)responseObject]];
    } failed:^(id responseObject) {
        
        [self hideHUD];
    }];
}
//加载用户信息
- (void)loadUserData{
    
    //1.设置请求参数
    NSDictionary *dict = @{@"uid":self.artId?:@"0"};
    //    //2.开始请求
    HHttpRequest *request = [[HHttpRequest alloc] init];
    [request httpGetRequestWithActionName:@"userinfo" andPramater:dict andDidDataErrorBlock:^(NSURLSessionTask *operation, id responseObject) {
        ResultModel *result=[ResultModel modelWithDictionary:responseObject];
        [self showErrorHUDWithTitle:result.msg SubTitle:nil Complete:nil];
    }andDidRequestSuccessBlock:^(NSURLSessionTask *operation, id responseObject) {
        kPrintLog(responseObject)
        model=[UserInfoModel modelWithDictionary:responseObject];
        self.artName = model.nickname;
        [self createArtistView];
    }andDidRequestFailedBlock:^(NSURLSessionTask *operation, NSError *error) {
    }];
}

- (void)createView {
    [super createView];
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
    if (iOS7Later) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    NSDictionary* dict = @{@"uid":self.artId?self.artId:@"0"};
    kPrintLog(dict)
    __weak typeof(self)weakSelf = self;
    [ArtRequest GetRequestWithActionName:@"getuserverified" andPramater:dict succeeded:^(id responseObject) {
        [self.hudLoading hideAnimated:YES];
        kPrintLog(responseObject)
        if ([responseObject isKindOfClass:[NSArray class]]){
            for (NSDictionary* dic in responseObject) {
                NSString* idStr = [NSString stringWithFormat:@"%@",dic[@"id"]];
                if ([idStr isEqualToString:@"2"]){//判断艺术家
                NSString* statusStr = [NSString stringWithFormat:@"%@",dic[@"status"]];
                    if ([statusStr isEqualToString:@"1"]){//1是艺术家  -1不是艺术家
                        _isArtist = YES;
                        break;
                    }
                }
            }
        }
        if (_isArtist){
            if (!self.artName) {
                [self loadUserData];
            }else{
                [self createArtistView];
            }
        }else{
            [self createCommonView];
        }
    } failed:^(id responseObject) {
        //[weakSelf showErrorHUDWithTitle:@"您的网络不给力" SubTitle:nil Complete:nil];
        __strong typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf.hudLoading hideAnimated:YES];
        [PHNoResponse showHUDAddedTo:KEY_WINDOW :^(id responseObject) {
            [strongSelf loadData];
        }];
        
    }];
    
    NSString* uid = [Global sharedInstance].userID;
    
    if ((self.artId&&uid.length>0)&&[self.artId isEqualToString:uid]) {
        //导航右侧2个按钮
        UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 45, 40)];
        UIBarButtonItem *barItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
        self.navigationItem.rightBarButtonItem = barItem;
        UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        negativeSpacer.width = 0;
        self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:negativeSpacer,barItem,nil];
        NSArray * itemArray  = @[@"homePush",@"homeMore"];
        for (int i = 0; i < 2; i ++){
            UIButton *itmeButton = [UIButton buttonWithType:UIButtonTypeCustom];
            itmeButton.frame = CGRectMake(30*i, 7.5, 25, 25);
//            [itmeButton setImageEdgeInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
            [itmeButton addTarget:self action:@selector(rightBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [itmeButton  setImage:[UIImage imageNamed:itemArray[i]] forState:UIControlStateNormal];
            [rightButton addSubview:itmeButton];
            itmeButton.tag = i;
        }
    }else{
        //导航右侧1个按钮
        UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        UIBarButtonItem *barItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
        self.navigationItem.rightBarButtonItem = barItem;
        NSArray * itemArray  = @[@"homeMore"];
        UIButton *itmeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        itmeButton.frame = CGRectMake(0, 2, 40, 40);
        [itmeButton addTarget:self action:@selector(rightBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        itmeButton.tag = 1;
        [itmeButton  setImage:[UIImage imageNamed:itemArray[0]] forState:UIControlStateNormal];
        [rightButton addSubview:itmeButton];
    }
}
- (void)createCommonView{
    NSArray* titleArr = @[@"简介",@"赞"];
    NSArray* subTitleArr = @[@"RECENTLY",@"PRAISE"];
    _viewChoose=[[MenuChooseView alloc]initWithFrame:CGRectMake(0,0, kScreenW, 44)];
    _viewChoose.subTitleArr = subTitleArr;
    _viewChoose.arrayTitle= titleArr;
    [_viewChoose addBtnAndTitLabel];
    [self.view addSubview:_viewChoose];
    __weak MyHomePageDockerVC* wself = self;
    [_viewChoose  setSelectBtnCilck:^(NSInteger iNumber){
        [wself.homeScrollView setContentOffset:CGPointMake(SCREEN_WIDTH*iNumber, 0) animated:YES];
    }];
    
    UIImageView *line1=[[UIImageView alloc]initWithFrame:CGRectMake(0, 44, SCREEN_WIDTH, 0.5)];
    line1.backgroundColor=kLineColor;
    [self.view addSubview:line1];
    
    // Do any additional setup after loading the view.
    _homeScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0,getViewHeight(_viewChoose)+2, SCREEN_WIDTH, SCREEN_HEIGHT-64-44-2)];
    _homeScrollView.delegate = self;
    _homeScrollView.bounces = NO;//设置弹簧效果
    _homeScrollView.pagingEnabled = YES;
    _homeScrollView.contentSize = CGSizeMake(kScreenW*3,0);
    [self.view addSubview:_homeScrollView];
    
    //简介
    _introVc = [[IntroVc alloc]init];
    _introVc.obj = self;
    _introVc.artId = self.artId;
    _introVc.view.frame = CGRectMake(0,0,SCREEN_WIDTH, _homeScrollView.bounds.size.height);
    [_homeScrollView addSubview:_introVc.view];
    
    //近况
//    _recentVc = [[RecentVc alloc]init];
//    _recentVc.artId = self.artId;
//    _recentVc.isOpenHeaderRefresh = YES;
//    _recentVc.isOpenFooterRefresh = YES;
//    _recentVc.obj = self;
//    _recentVc.view.frame = CGRectMake(SCREEN_WIDTH,0,SCREEN_WIDTH, _homeScrollView.bounds.size.height);
//    [_homeScrollView addSubview:_recentVc.view];
    
    //赞
    _circlesVc = [[ArtCirclesVc alloc]init];
    _circlesVc.artId = self.artId;
    _circlesVc.acStr = @"liketopiclist";
    _circlesVc.isOpenHeaderRefresh = YES;
    _circlesVc.isOpenFooterRefresh = YES;
    _circlesVc.obj = self;
    _circlesVc.view.frame = CGRectMake(SCREEN_WIDTH,0,SCREEN_WIDTH, _homeScrollView.bounds.size.height);
    [_homeScrollView addSubview:_circlesVc.view];

}
-(void)createArtistView{
    //菜单选择器
        NSArray* titleArr = @[self.artName,@"简介",@"作品",@"在售",@"文字" ,@"媒体",@"分类"];
        NSArray* subTitleArr = @[@"RECENTLY",@"RESUME",@"WORKS",@"SELL",@"COMMENTS",@"NEWS",@"TAG"];
    _viewChoose=[[MenuChooseView alloc]initWithFrame:CGRectMake(0,0, kScreenW, 44)];
    _viewChoose.subTitleArr = subTitleArr;
    _viewChoose.arrayTitle= titleArr;
    [_viewChoose addBtnAndTitLabel];
    [self.view addSubview:_viewChoose];
    __weak MyHomePageDockerVC* wself = self;
    [_viewChoose  setSelectBtnCilck:^(NSInteger iNumber){
        [wself.homeScrollView setContentOffset:CGPointMake(SCREEN_WIDTH*iNumber, 0) animated:YES];
    }];
    
    UIImageView *line1=[[UIImageView alloc]initWithFrame:CGRectMake(0, 44, SCREEN_WIDTH, 0.5)];
    line1.backgroundColor=kLineColor;
    [self.view addSubview:line1];
    
    _homeScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0,getViewHeight(_viewChoose)+2, SCREEN_WIDTH, SCREEN_HEIGHT-64-44-2)];
    _homeScrollView.delegate = self;
    _homeScrollView.bounces = NO;//设置弹簧效果
    _homeScrollView.pagingEnabled = YES;
    _homeScrollView.contentSize = CGSizeMake(kScreenW*titleArr.count,0);
    [self.view addSubview:_homeScrollView];
    //首页
    _zaishouVC = [[YiShuZaiShouVC alloc]init];
    _zaishouVC.obj = self;
    _zaishouVC.artId = self.artId;
    _zaishouVC.isOpenFooterRefresh = YES;
    _zaishouVC.isOpenHeaderRefresh = YES;
    _zaishouVC.view.frame = CGRectMake(0,0,SCREEN_WIDTH, _homeScrollView.bounds.size.height);
    [_homeScrollView addSubview:_zaishouVC.view];
    
    //简介
    _introVc = [[IntroVc alloc]init];
    _introVc.obj = self;
    _introVc.artId = self.artId;
    _introVc.view.frame = CGRectMake(SCREEN_WIDTH,0,SCREEN_WIDTH, _homeScrollView.bounds.size.height);
    [_homeScrollView addSubview:_introVc.view];

//    //近况
//    _recentVc = [[RecentVc alloc]init];
//    _recentVc.artId = self.artId;
//    _recentVc.isOpenHeaderRefresh = YES;
//    _recentVc.isOpenFooterRefresh = YES;
//    _recentVc.obj = self;
//    _recentVc.view.frame = CGRectMake(SCREEN_WIDTH*2,0,SCREEN_WIDTH, _homeScrollView.bounds.size.height);
//    [_homeScrollView addSubview:_recentVc.view];
    
    //作品
    _worksVc = [[WorksVc alloc]init];
    _worksVc.artId = self.artId;
    _worksVc.obj = self;
    _worksVc.view.frame = CGRectMake(SCREEN_WIDTH*2,0,SCREEN_WIDTH, _homeScrollView.bounds.size.height);
    [_homeScrollView addSubview:_worksVc.view];
    //可售
    _sellVc = [[SellVC alloc]init];
    _sellVc.artId = self.artId;
    _sellVc.gtype = @"";
    _sellVc.searchText = @"";
    _sellVc.huiyuan = @"1";// 0不过滤，1为会员，2为非会员
    _sellVc.goodsCategorys = self.tableViewDataM;
    _sellVc.isOpenFooterRefresh = YES;
    _sellVc.isOpenHeaderRefresh = YES;
    _sellVc.obj = self;
    _sellVc.view.frame = CGRectMake(SCREEN_WIDTH*3,0,SCREEN_WIDTH, _homeScrollView.bounds.size.height);
    [_homeScrollView addSubview:_sellVc.view];

    //文字
    _textsVc = [[TextsVc alloc]init];
    _textsVc.artId = self.artId;
    _textsVc.obj = self;
    _textsVc.view.frame = CGRectMake(SCREEN_WIDTH*4,0,SCREEN_WIDTH, _homeScrollView.bounds.size.height);
    [_homeScrollView addSubview:_textsVc.view];
    
    //媒体
    _mediaVc = [[MediaVc alloc]init];
    _mediaVc.artId = self.artId;
    _mediaVc.isOpenHeaderRefresh = YES;
    _mediaVc.isOpenFooterRefresh = YES;
    _mediaVc.obj = self;
    _mediaVc.view.frame = CGRectMake(SCREEN_WIDTH*5,0,SCREEN_WIDTH, _homeScrollView.bounds.size.height);
    [_homeScrollView addSubview:_mediaVc.view];
//
//    //分类
    _classifyVc = [[ClassifyVc alloc]init];
    _classifyVc.artId = self.artId;
    _classifyVc.obj = self;
    _classifyVc.view.frame = CGRectMake(SCREEN_WIDTH*6,0,SCREEN_WIDTH, _homeScrollView.bounds.size.height);
    [_homeScrollView addSubview:_classifyVc.view];
}

- (void)rightBtnClick:(UIButton*)sender{
    
    NSInteger tag = sender.tag;
    switch (tag) {
        case 0:
        {
            [self.shareMenuView show];
        }
            break;
        case 1:
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

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (scrollView==_homeScrollView) {
        kPrintLog(@"0");
        _viewChoose.selectedPageIndex = scrollView.contentOffset.x / scrollView.frame.size.width;
    }else{
        kPrintLog(@"1");
    }
}

//返回宽度
- (CGFloat)getLabelWidthWithStr:(NSString*)textStr font:(UIFont*)font{
    
    CGSize size = [textStr sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil]];
    CGFloat w = size.width;
    return w;
}
-(void)showStateView{
    self.iSHideStatus = NO;
    [UIView animateWithDuration:0.5 animations:^{
        _viewChoose.frame = CGRectMake(0,0, kScreenW, 44);
        _homeScrollView.frame = CGRectMake(0,getViewHeight(_viewChoose)+2, SCREEN_WIDTH, SCREEN_HEIGHT-64-44-2);
        [self changeStateView];
    }];
    
    
    //[self performSelector:@selector(changeStateView) withObject:self afterDelay:0.1];
    
}
- (void)hideStateView{
    self.iSHideStatus = YES;
    [UIView animateWithDuration:0.2 animations:^{
        _viewChoose.frame = CGRectMake(0,0, kScreenW, 44);
        _homeScrollView.frame = CGRectMake(0,getViewHeight(_viewChoose), SCREEN_WIDTH, SCREEN_HEIGHT-44);
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
