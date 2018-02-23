//
//  MSBPersonCenterController.m
//  meishubao
//
//  Created by T on 16/12/1.
//  Copyright © 2016年 benbun. All rights reserved.
//

#import "MSBPersonCenterController.h"
#import "YPTabBarController.h"
#import "MSBPersonCenterArticleVC.h"
#import "MSBPersonCenterFollowVC.h"
#import "MSBPersonCenterPhotoVC.h"
#import "MSBCollectVideoController.h"

#import "MSBFollowModel.h"

#import "GeneralConfigure.h"

static const CGFloat kPersonCenterTopHeaderH = 91.f;
static const CGFloat kPersonCenterBottomHeaderH = 25.f;

@interface MSBPersonController : YPTabBarController
@property (nonatomic, copy) NSString *uid;

@end

@implementation MSBPersonController

- (void)viewDidLoad{
    [super viewDidLoad];

    [self commitInit];
}

- (void)commitInit{
    
    [self setTabBarFrame:CGRectMake(0, 0, SCREEN_WIDTH, APP_SEGMENT_H)
        contentViewFrame:CGRectMake(0,APP_SEGMENT_H, SCREEN_WIDTH, SCREEN_HEIGHT - APP_NAVIGATIONBAR_H - APP_SEGMENT_H - (kPersonCenterTopHeaderH + kPersonCenterBottomHeaderH))];
//    self.tabBar.itemTitleColor = [UIColor colorWithHex:0x989898];
    self.tabBar.itemTitleSelectedColor = [UIColor colorWithHex:0xB51B20];
    self.tabBar.itemTitleFont = [UIFont systemFontOfSize:14];
    self.tabBar.itemTitleSelectedFont = [UIFont systemFontOfSize:14];
    //    [self.tabBar setScrollEnabledAndItemWidth:30.f];
    self.tabBar.leftAndRightSpacing = (SCREEN_WIDTH - 280) / 2;
   
    self.tabBar.itemFontChangeFollowContentScroll = YES;
    self.tabBar.itemSelectedBgScrollFollowContent = YES;
    self.tabBar.itemSelectedBgColor = RGBCOLOR(192, 17, 20);
    [self.tabBar setItemSelectedBgInsets:UIEdgeInsetsMake(38, 15, 0, 15) tapSwitchAnimated:NO];
    [self.tabBar setScrollEnabledAndItemFitTextWidthWithSpacing:40];
    [self setContentScrollEnabledAndTapSwitchAnimated:YES];
    
    MSBPersonCenterArticleVC *articleVC = [MSBPersonCenterArticleVC new];
    articleVC.yp_tabItemTitle = @"文章";
    articleVC.uid = self.uid;
    
    MSBPersonCenterFollowVC *followVC = [MSBPersonCenterFollowVC new];
    followVC.yp_tabItemTitle = @"跟帖";
    followVC.uid = self.uid;
    
    MSBCollectVideoController *videoVC = [MSBCollectVideoController new];
    videoVC.yp_tabItemTitle = @"视频";
    videoVC.uid = self.uid;
    
    MSBPersonCenterPhotoVC *photoVC = [MSBPersonCenterPhotoVC new];
    photoVC.yp_tabItemTitle = @"图片";
    photoVC.uid = self.uid;
    
    self.viewControllers = @[articleVC,followVC,videoVC, photoVC];
    
    //设置夜间模式
    self.tabBar.dk_backgroundColorPicker =  DKColorSwiftWithRGB(0xe0e0e0, 0x222222);
    self.view.dk_backgroundColorPicker = DKColorPickerWithKey(BG);
}

@end

@interface MSBPersonCenterController ()
@property(nonatomic,strong) MSBPersonController *personController;
@property(nonatomic,strong) MSBFollowModel *followModel;
@property (nonatomic, weak) UIImageView  *headerImageView;
@property (nonatomic, weak) UILabel  *nickNameLab;
@property (nonatomic, weak) UILabel  *followNumLab;
@property (nonatomic, weak) UILabel  *fenNumLab;
@property (nonatomic, weak) UIButton  *followBtn;
@property (nonatomic, weak) UILabel  *headerBottomLab;
@end

@implementation MSBPersonCenterController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor whiteColor]];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.title = @"个人中心";
//    [self setTitle:@"个人中心"];
    
    [self commitInitHeader];
    
    [self commitInitController];
    
    //
    [self requestDatas];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)requestDatas{
    [self hudLoding];
    __weak __block typeof(self) weakSelf = self;
    [[LLRequestBaseServer shareInstance] requestOtherUserInfoWithUid:self.uid success:^(LLResponse *response, id data) {
        if (data && [data isKindOfClass:[NSDictionary class]]) {
            [weakSelf hiddenHudLoding];
            [weakSelf setModel:[MSBFollowModel mj_objectWithKeyValues:data]];
        }
    } failure:^(LLResponse *response) {
        [weakSelf hiddenHudLoding];
    } error:^(NSError *error) {
        [weakSelf hiddenHudLoding];
    }];
}

- (void)setModel:(MSBFollowModel *)model{
    [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:model.avatar] placeholderImage:[UIImage imageNamed:@"people_collection_cell"]];
    self.nickNameLab.text = model.name;
    self.followNumLab.text =[NSString stringWithFormat:@"%tu",model.attention_num];
    self.fenNumLab.text =[NSString stringWithFormat:@"%tu",model.fans_num];
    self.headerBottomLab.text = model.signature;
    
    self.followBtn.selected = model.attention_status;
    // people_collection_cell
    // @property (nonatomic, weak) UIImageView  *headerImageView;
//    @property (nonatomic, weak) UILabel  *nickNameLab;
//    @property (nonatomic, weak) UILabel  *followNumLab;
//    @property (nonatomic, weak) UILabel  *fenNumLab;
//    @property (nonatomic, weak) UIButton  *followBtn;
//    @property (nonatomic, weak) UILabel  *headerBottomLab;
}

- (void)commitInitHeader{

    UIView *headerView = [UIView new];
    headerView.dk_backgroundColorPicker = DKColorPickerWithKey(BG);
    [headerView setFrame:CGRectMake(0, 0, SCREEN_WIDTH, kPersonCenterTopHeaderH + kPersonCenterBottomHeaderH)];
    [self.view addSubview:headerView];
    
    UIView *headerTopView = [UIView new];
    [headerTopView setFrame:CGRectMake(0, 0, SCREEN_WIDTH, kPersonCenterTopHeaderH)];
    [headerTopView setBackgroundColor:[UIColor clearColor]];
    [headerView addSubview:headerTopView];
    
    UIImageView *headerImageView = [UIImageView new];
    [headerImageView setFrame:CGRectMake(30, (kPersonCenterTopHeaderH - 55) / 2, 55, 55)];
    [headerImageView.layer setCornerRadius:55/2];
    [headerImageView.layer setBorderColor:RGBALCOLOR(181, 27, 32, 1.0f).CGColor];
    [headerImageView.layer setBorderWidth:0.5f];
    [headerImageView setContentMode:UIViewContentModeScaleAspectFill];
    [headerImageView setClipsToBounds:YES];
    [headerTopView addSubview:headerImageView];
    self.headerImageView = headerImageView;
    
    UILabel *nickNameLab = [UILabel new];
    [nickNameLab setFrame:CGRectMake(CGRectGetMaxX(headerImageView.frame) + 20, headerImageView.y + 2, headerTopView.width - (CGRectGetMaxX(headerImageView.frame) + 20)-20, 37/2)];
    nickNameLab.dk_textColorPicker = DKColorPickerWithRGB(0x000000, 0x989898);
//    [nickNameLab setTextColor:RGBCOLOR(35, 24, 21)];
    [nickNameLab setFont:[UIFont boldSystemFontOfSize:18]];
     [headerTopView addSubview:nickNameLab];
    self.nickNameLab = nickNameLab;
    
    // 关注数
    UILabel *followNumLab = [UILabel new];
    [followNumLab setTextColor:RGBCOLOR(181, 27, 32)];
    [followNumLab setFont:[UIFont systemFontOfSize:12]];
    [followNumLab setFrame:CGRectMake(nickNameLab.x, CGRectGetMaxY(nickNameLab.frame) + 8, 25, 10)];
    [headerTopView addSubview:followNumLab];
    self.followNumLab = followNumLab;
    
    // 关注lab
    UILabel *followLab = [UILabel new];
    [followLab setTextColor:RGBCOLOR(181, 27, 32)];
    [followLab setFont:[UIFont systemFontOfSize:12]];
    [followLab setText:@"关注"];
    [followLab setFrame:CGRectMake(nickNameLab.x, CGRectGetMaxY(followNumLab.frame) + 1, 25, 13)];
    [headerTopView addSubview:followLab];
    
    // 粉丝数
    UILabel *fenNumLab = [UILabel new];
    [fenNumLab setTextColor:RGBCOLOR(181, 27, 32)];
    [fenNumLab setFont:[UIFont systemFontOfSize:12]];
    self.fenNumLab = fenNumLab;
    [fenNumLab setFrame:CGRectMake(CGRectGetMaxX(followLab.frame)+ 20, followNumLab.y, 50, 10)];
    [headerTopView addSubview:fenNumLab];
    
    // 粉丝lab
    UILabel *fenLab = [UILabel new];
    [fenLab setTextColor:RGBCOLOR(181, 27, 32)];
    [fenLab setFont:[UIFont systemFontOfSize:12]];
    [fenLab setText:@"粉丝人数"];
    [fenLab setFrame:CGRectMake(fenNumLab.x, CGRectGetMaxY(fenNumLab.frame) + 1, 50, 13)];
    [headerTopView addSubview:fenLab];
    
    UIButton *followBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [followBtn setFrame:CGRectMake(CGRectGetMaxX(fenLab.frame) + 20, fenNumLab.y - 5, 87, 26)];
    [followBtn.layer setCornerRadius:5.f];
    [followBtn.layer setBorderColor:RGBCOLOR(150, 150, 150.f).CGColor];
    [followBtn.layer setBorderWidth:0.5f];
    [followBtn setClipsToBounds:YES];
    [followBtn setBackgroundColor:RGBCOLOR(255, 255, 255)];
    [followBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [followBtn setTitleColor:RGBCOLOR(150, 150, 150) forState:UIControlStateNormal];
    [followBtn setTitle:@"关注TA" forState:UIControlStateNormal];
    [followBtn setTitle:@"取消关注TA" forState:UIControlStateSelected];
    [followBtn addTarget:self action:@selector(followBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [headerTopView addSubview:followBtn];
    self.followBtn = followBtn;
    
    UILabel *headerBottomLab = [UILabel new];
    [headerBottomLab setFrame:CGRectMake(0, kPersonCenterTopHeaderH, SCREEN_WIDTH, kPersonCenterBottomHeaderH)];
    [headerBottomLab setTextAlignment:NSTextAlignmentCenter];
    [headerBottomLab setBackgroundColor:RGBALCOLOR(240, 240, 240, 0)];
//    [headerBottomLab setText:@"画画的技巧成分越少,艺术成分就越高"];
    self.headerBottomLab = headerBottomLab;
    [headerBottomLab setFont:[UIFont systemFontOfSize:12]];
//    [headerBottomLab setTextColor:RGBCOLOR(35, 24, 21)];
    headerBottomLab.dk_textColorPicker = DKColorPickerWithRGB(0x000000, 0x989898);
    [headerView addSubview:headerBottomLab];
}

- (void)commitInitController{
    MSBPersonController *personController = [[MSBPersonController alloc] init];
    personController.uid = self.uid;
    [self addChildViewController:personController];
    [self.view addSubview:personController.view];
    [personController.view setFrame:CGRectMake(0, kPersonCenterTopHeaderH + kPersonCenterBottomHeaderH, SCREEN_WIDTH, SCREEN_HEIGHT - (kPersonCenterTopHeaderH + kPersonCenterBottomHeaderH))];
}

- (void)followBtnClick:(UIButton *)btn{
    [self hudLoding];
    __weak __block typeof(self) weakSelf = self;
    [[LLRequestServer shareInstance] requestUserPayAttentionWithUid:self.uid org_id:nil type:1 attention_status:!btn.selected success:^(LLResponse *response, id data) {
        [weakSelf hiddenHudLoding];
        btn.selected = !btn.selected;
    } failure:^(LLResponse *response) {
        [weakSelf hiddenHudLoding];
    } error:^(NSError *error) {
        [weakSelf hiddenHudLoding];
    }];
}

- (void)setUid:(NSString *)uid{
    _uid = uid;
}
@end


