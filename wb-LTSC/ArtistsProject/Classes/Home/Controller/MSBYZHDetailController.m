//
//  MSBYZHDetailController.m
//  meishubao
//
//  Created by T on 16/11/30.
//  Copyright © 2016年 benbun. All rights reserved.
//

#import "MSBYZHDetailController.h"
#import "MSBYZHCommentController.h"
#import "MSBPersonCenterController.h"

#import "MSBArticleDetailBottom.h"
#import "MSBShareContentView.h"
#import "MSBCommentView.h"
#import "ZFPlayer.h"

#import "GeneralConfigure.h"

#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "IQKeyboardManager.h"

#import "MSBVideoDetaiModel.h"
#import "MSBArticleCommentModel.h"

#import "JSBridge.h"
#import "UIWebView+TS_JavaScriptContext.h"
#import "AFNetworkReachabilityManager.h"

typedef NS_ENUM(NSInteger, MSBDetailFontType) {
    MSBDetailFontTypeSmall = 0,
    MSBDetailFontTypeMiddle,
    MSBDetailFontTypeBig,
    MSBDetailFontTypeEspecialBig
};
@interface MSBYZHDetailController ()<ZFPlayerDelegate,UIWebViewDelegate,TSWebViewDelegate, JSBridgeDelegate>{
   
}
@property (weak, nonatomic)  UIView *playerFatherView;
@property (strong, nonatomic) ZFPlayerView *playerView;
@property (nonatomic, assign) BOOL isPlaying;
@property (nonatomic, assign) BOOL isFirstPlay;
@property (nonatomic, strong) ZFPlayerModel *playerModel;

@property(nonatomic,strong) UIWebView *webView;
@property(nonatomic,strong) JSBridge *bridge;

@property (nonatomic, weak) MSBArticleDetailBottom *detailBottom;

@property(nonatomic,strong) NSArray *hotComments;
@property(nonatomic,strong) MSBVideoDetaiModel *detailModel;

@property (nonatomic, copy) NSString *fontSizeStr;
@property (nonatomic,strong) AFNetworkReachabilityManager * manager;

@property(nonatomic,strong) UIImage *shareImage;
@end

@implementation MSBYZHDetailController{
    BOOL  _isJsbridgeInit;
    BOOL _isDataRequestInit;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = NO;
    manager.shouldResignOnTouchOutside = NO;
    manager.shouldToolbarUsesTextFieldTintColor = NO;
    manager.enableAutoToolbar = NO;
   // [self commitStateBar];

    [self configCustomNavBar];

    [self commitPlayer];
    
    // _commitWebView
    [self _commitWebView];
    
    [self setupTitleSizeFont];
    
    // _commitBottom
    [self _commitBottom];
    
    // requestData
    [self requestData];
    
    [self webLoadView:self.view];
    
    _isFirstPlay = NO;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self manager];
    if (self.playerView) {
        self.playerView.isCurrentViewController = YES;
    }
    if (self.navigationController.viewControllers.count == 2 && self.playerView && self.isPlaying) {
        self.isPlaying = NO;
        [self.playerView play];
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if (self.navigationController.viewControllers.count == 3 && self.playerView && !self.playerView.isPauseByUser){
        self.isPlaying = YES;
        [self.playerView pause];
    }
    if (self.playerView) {
        self.playerView.isCurrentViewController = NO;
    }
}


- (void)dealloc{
    NDLog(@"%@释放了",self.class);
    if (self.webView) {
        [self.webView removeFromSuperview];
        self.webView.delegate = nil;
        self.webView = nil;
    }
        
    if (self.bridge) {
        self.bridge.delegate = nil;
        self.bridge = nil;
    }

    if (self.playerView) {
        [self.playerView pause];
        self.playerView = nil;
    }

    [self.manager stopMonitoring];
}
/*
- (void)commitStateBar{
    UIView *stateBar = [UIView new];
    [stateBar setFrame:CGRectMake(0, 0, SCREEN_WIDTH, 20.f)];
    [stateBar setBackgroundColor:RGBCOLOR(0, 0, 0)];
    [self.view insertSubview:stateBar atIndex:0];
}
*/
//自定制导航 防止视频全屏状态下切到后台再进入前台导航栏遮盖状态栏
- (void)configCustomNavBar {

    UIView * barView = [UIView new];
    barView.dk_backgroundColorPicker = DKColorPickerWithRGB(0xBB3A41, 0x6f141a);
    barView.frame = CGRectMake(0, 0, SCREEN_WIDTH, APP_NAVIGATIONBAR_H);
    [self.view addSubview:barView];

    UIImageView * logoView = [UIImageView new];
    logoView.image = [UIImage imageNamed:@"meishubao_logo"];
    logoView.frame = CGRectMake(0, 0, 110, 25);
    logoView.center = CGPointMake(barView.centerX, isiPhoneX?(44 + 22):(20 + 22));
    [barView addSubview:logoView];

    UIButton * backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, isiPhoneX?44:20, 44, 44);
    [backBtn setImage:[UIImage imageNamed:@"navigation_back"] forState:UIControlStateNormal];
    [barView addSubview:backBtn];
    [backBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
}

- (void)backClick {

    [self.navigationController popViewControllerAnimated:YES];
}

- (void)commitPlayer{
    UIView *playerFatherView = [UIView new];
    [self.view addSubview:playerFatherView];
    self.playerFatherView = playerFatherView;
    [playerFatherView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(APP_NAVIGATIONBAR_H);
        make.leading.trailing.mas_equalTo(0);
        make.height.mas_equalTo(playerFatherView.mas_width).multipliedBy(9.0f/16.0f);
    }];
    
    
    self.playerView = [[ZFPlayerView alloc] init];
    ZFPlayerControlView *controlView = [[ZFPlayerControlView alloc] init];
    [self.playerView playerControlView:controlView playerModel:self.playerModel];
    self.playerView.delegate = self;
    
    //（可选设置）可以设置视频的填充模式，内部设置默认（ZFPlayerLayerGravityResizeAspect：等比例填充，直到一个维度到达区域边界）
    self.playerView.playerLayerGravity = ZFPlayerLayerGravityResizeAspect;
    //self.playerView;
    // 打开下载功能（默认没有这个功能）
    self.playerView.hasDownload    = NO;
    // 打开预览图
    self.playerView.hasPreviewView = YES;
    
    __weak typeof(self) weakSelf = self;
    [self.manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        //当网络状态发生变化时会调用这个block
        switch (status) {
            case AFNetworkReachabilityStatusReachableViaWiFi:
                if (!weakSelf.isFirstPlay) {
                    [weakSelf setCurrentPlayModel];
                    weakSelf.isFirstPlay = YES;
                }else{
                    if (weakSelf.playerView.state == ZFPlayerStatePlaying) {
                        
                    }else{
                        weakSelf.playerModel.videoURL = [NSURL URLWithString:weakSelf.videoUrl];
                        [weakSelf.playerView resetToPlayNewVideo:weakSelf.playerModel];
                    }
                }
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                [weakSelf showNetTip];
                [weakSelf setNullPlayModel];
                break;
            case AFNetworkReachabilityStatusNotReachable:
                [weakSelf hudTip:@"无网络"];
                break;
            case AFNetworkReachabilityStatusUnknown:
                NDLog(@"未知网络");
                break;
                
            default:
                break;
        }
    }];
}

- (void)setNullPlayModel
{
    self.playerModel.videoURL = [NSURL URLWithString:@""];
    [self.playerView resetToPlayNewVideo:self.playerModel];
}

- (void)setCurrentPlayModel
{
    self.playerModel.videoURL = [NSURL URLWithString:self.videoUrl];
    [self.playerView resetToPlayNewVideo:self.playerModel];
    //[self.playerView autoPlayTheVideo];
}

- (void)showNetTip
{
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"当前非Wifi状态，是否继续播放?" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"暂不播放" style:UIAlertActionStyleCancel handler:nil]];
    [alert addAction:[UIAlertAction actionWithTitle:@"继续播放" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self setCurrentPlayModel];
        [self.playerView autoPlayTheVideo];
        _isFirstPlay = YES;
    }]];
    [self.navigationController presentViewController:alert animated:YES completion:nil];
}

- (void)_commitWebView{
    self.bridge = [[JSBridge alloc] init];
    [self.bridge setDelegate:self];
    self.webView = [UIWebView new];
    self.webView.backgroundColor = [UIColor clearColor];
    [self.webView setDelegate:self];
    [self.webView setFrame:CGRectMake(0, (SCREEN_WIDTH * 9 /16) + APP_NAVIGATIONBAR_H, SCREEN_WIDTH, SCREEN_HEIGHT - (SCREEN_WIDTH * 9 /16) - APP_NAVIGATIONBAR_H - kBottomHeight)];
    [self.view addSubview:self.webView];
    self.bridge.webview = self.webView;
    
    NSString *basePath = [NSString stringWithFormat:@"%@/html",  [[NSBundle mainBundle] bundlePath]];
    NSURL *baseURL = [NSURL fileURLWithPath:basePath isDirectory:YES];
    NSString *htmlString = [NSString stringWithContentsOfFile:[NSString stringWithFormat:@"%@/video_detail.html", basePath] encoding:NSUTF8StringEncoding error:NULL];
    [self.webView loadHTMLString:htmlString baseURL:baseURL];
}

- (void)setupTitleSizeFont{
    NSInteger fontType = [[NSUserDefaults standardUserDefaults] integerForKey:APP_WEBVIEW_FONTSIZE];
    
    switch (fontType) {
        case MSBDetailFontTypeSmall:{
            self.fontSizeStr = @"font-small";
            break;
        }
        case MSBDetailFontTypeMiddle:{
            self.fontSizeStr = @"font-mid";
            break;
        }
        case MSBDetailFontTypeBig:{
            self.fontSizeStr = @"font-big";
            break;
        }
        case MSBDetailFontTypeEspecialBig:{
            self.fontSizeStr = @"font-especial-big";
            break;
        }
        default:
            break;
    }
}

- (void)_commitBottom{
    MSBArticleDetailBottom *detailBottom = [MSBArticleDetailBottom new];
    self.detailBottom = detailBottom;
    [detailBottom setFrame:CGRectMake(0, SCREEN_HEIGHT - kBottomHeight, SCREEN_WIDTH, kBottomHeight)];
    [self.view addSubview:detailBottom];
    
    __block __weak typeof(self) weakSelf = self;
    
    detailBottom.messClick = ^(){
        MSBYZHCommentController *commentVC = [MSBYZHCommentController new];
        commentVC.video_id = weakSelf.videoId;
        commentVC.detailModel = weakSelf.detailModel;
        commentVC.hotComments = weakSelf.hotComments;
        [weakSelf.navigationController pushViewController:commentVC animated:YES];
    };
    
    detailBottom.storeClick = ^(UIButton *btn){
        
        if ([MSBJumpLoginVC jumpLoginVC:weakSelf]) {
            return;
        }
        
        [[LLRequestBaseServer shareInstance] requestArticleDetailArticleCollectionPostId:nil isCollect:!btn.selected video_id:weakSelf.videoId pic_url:nil type:2 success:^(LLResponse *response, id data) {
            if (btn.selected) {
                btn.selected = NO;
                [weakSelf showSuccess:@"取消收藏成功"];
            }else{
                btn.selected = YES;
                [weakSelf showSuccess:@"收藏成功"];
            }
        } failure:^(LLResponse *response) {
            if (btn.selected) {
                [weakSelf showError:@"取消收藏失败"];
            }else{
                [weakSelf showError:@"收藏失败"];
            }
        } error:^(NSError *error) {
            if (btn.selected) {
                [weakSelf showError:@"取消收藏失败"];
            }else{
                [weakSelf showError:@"收藏失败"];
            }
        }];
    };
    
    detailBottom.shareClick = ^(){
        [weakSelf shareItemClick];
    };
    
    detailBottom.commentBlock = ^(){
        [weakSelf commentClick];
    };
}

- (void)shareItemClick{
    MSBShareContentView * shareContentView = [MSBShareContentView shareInstance];
    shareContentView.post_id = self.detailModel.video_id;
    shareContentView.post_type = @"2";
    [shareContentView shareTitle:self.detailModel.video_title desc:self.detailModel.video_intro url:self.detailModel.video_url img:self.shareImage];
    [shareContentView setArticleDetialVC:self];
    [shareContentView show];
}

- (void)commentClick{

    if ([MSBJumpLoginVC showLoginAlert:self]) {
        return;
    }
    
    __weak __block typeof(self) weakSelf = self;
    
    [MSBCommentView commentshowSuccess:^(NSString *commentText) {

        if (commentText.length == 0) {
            [weakSelf hudTip:@"请输入内容"];
            return ;
        }

        [weakSelf hudLoding];

        [[LLRequestBaseServer shareInstance] requestArticleDetailPublishCommentPostId:nil artist_id:nil video_id:weakSelf.videoId type:3 commentId:nil mainCommentId:nil toUid:nil commentContent:commentText success:^(LLResponse *response, id data) {

            [weakSelf showSuccess:@"评论成功"];
        } failure:^(LLResponse *response) {

            [weakSelf showError:@"评论失败"];
        } error:^(NSError *error) {

            [weakSelf showError:@"评论失败"];
        }];
    }];
}

- (void)requestData{
    __weak __block typeof(self)  weakSelf = self;
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_enter(group);
    
    [[LLRequestServer shareInstance] requestVideoDetailWithVideoId:self.videoId success:^(LLResponse *response, id data) {
        if (data && [data isKindOfClass:[NSDictionary class]]) {
            weakSelf.detailModel = [MSBVideoDetaiModel mj_objectWithKeyValues:data];
        }
         dispatch_group_leave(group);
    } failure:^(LLResponse *response) {
        dispatch_group_leave(group);
        //[weakSelf endLoading];
    } error:^(NSError *error) {
        dispatch_group_leave(group);
        //[weakSelf endLoading];
    }];
    
    dispatch_group_enter(group);
    [[LLRequestServer shareInstance] requestArticleDetailHotCommentWithArticleId:nil artist_id:nil video_id:self.videoId
    type:3 success:^(LLResponse *response, id data) {
            if (data && [data isKindOfClass:[NSArray class]]) {
                weakSelf.hotComments = [MSBArticleCommentModel mj_objectArrayWithKeyValuesArray:data];
            }
            dispatch_group_leave(group);
        } failure:^(LLResponse *response) {
            dispatch_group_leave(group);
            
        } error:^(NSError *error) {
            dispatch_group_leave(group);
        }];
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        _isDataRequestInit = YES;
       // [weakSelf endLoading];
        if (!weakSelf.videoUrl || weakSelf.videoUrl.length == 0) {
            weakSelf.videoUrl = weakSelf.detailModel.video;
            [weakSelf setCurrentPlayModel];
        }
        [weakSelf initConfigData:weakSelf.detailModel comment:weakSelf.hotComments];
    });
}

- (void)initConfigData:(MSBVideoDetaiModel *)articleDetail comment:(NSArray *)comment{
    if (!(_isJsbridgeInit && _isDataRequestInit)) return;
    //if (articleDetail == nil)return;
    NSDictionary *dic = nil;
    if (articleDetail == nil){
        dic = @{};
    }else{
        dic = [articleDetail mj_keyValues];
    }
    
    self.detailBottom.commentCount = self.detailModel.comment_num;
    self.detailBottom.is_collect = self.detailModel.is_collect;
    
    NSMutableArray *hotComments = [NSMutableArray array];
    [hotComments removeAllObjects];
    
    
    if (comment.count > 0 && comment != nil) {
        [hotComments addObjectsFromArray:[MSBArticleCommentModel mj_keyValuesArrayWithObjectArray:comment]];
    }
    
    NSDictionary* initParams = @{
                                 @"videoDetail": dic,
                                 @"hotComments":@{@"items":hotComments},
                                 @"fontSize":self.fontSizeStr,
                                 @"themeVersion":self.dk_manager.themeVersion,
                                 @"assetsPath":[[NSBundle mainBundle] bundlePath]
                                 };
    [self.bridge nativeCallJsInitConfig:[NSString dictionaryToJson:initParams]];
    
    __weak typeof(self) weakSelf = self;
    [[SDWebImageManager sharedManager] loadImageWithURL:[NSURL URLWithString:articleDetail.video_image] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
        
    } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
        weakSelf.shareImage = image;
    }];
}


#pragma mark - jsbridge
- (void)webView:(UIWebView *)webView didCreateJavaScriptContext:(JSContext *)ctx {
    ctx[@"__jsbridge"] = self.bridge;
}

// onJsBridgeInit
- (void)onJsBridgeInit{
    _isJsbridgeInit = YES;
    [self initConfigData:self.detailModel comment:self.hotComments];
}

// onWebPageReady
- (void)onWebPageReady{
    self.navigationItem.rightBarButtonItem.enabled = YES;
    __weak __block typeof(self) weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakSelf endLoading];
    });
    
    // 评论点赞
    [self.bridge registerHandlerForResult:self module:@"page" handlerName:@"upvoteComment"  callbackResult:^(id data, callBackBlock responseCallback) {
        NDLog(@"----upvoteComment %@--%@", data, @"xxx");
        BOOL isPraise = [[NSString stringWithFormat:@"%@", data[@"is_praise"]] integerValue];
        
        if ([MSBAccount userLogin]) {
            NSString *commentId = [NSString stringWithFormat:@"%@", data[@"comment_id"]];
            BOOL isPraise = [[NSString stringWithFormat:@"%@", data[@"is_praise"]] integerValue];
            [weakSelf hudLoding];
            [[LLRequestServer shareInstance] requestArticleDetailCommentPraisePostId:nil commentId:commentId videoId:nil artistId:nil orgId:nil parise:!isPraise type:3 success:^(LLResponse *response, id data) {
                [weakSelf hiddenHudLoding];
                NSString *result;
                if (isPraise) {
                    result = [NSString dictionaryToJson:@{@"is_praise":@NO}];
                }else{
                    result = [NSString dictionaryToJson:@{@"is_praise":@YES}];
                }
                responseCallback(result);
            } failure:^(LLResponse *response) {
                [weakSelf hiddenHudLoding];
                NSString *result;
                if (isPraise) {
                    result = [NSString dictionaryToJson:@{@"is_praise":@YES}];
                }else{
                    result = [NSString dictionaryToJson:@{@"is_praise":@NO}];
                }
                responseCallback(result);
            } error:^(NSError *error) {
                [weakSelf hiddenHudLoding];
                NSString *result;
                if (isPraise) {
                    result = [NSString dictionaryToJson:@{@"is_praise":@YES}];
                }else{
                    result = [NSString dictionaryToJson:@{@"is_praise":@NO}];
                }
                responseCallback(result);
            }];
        }else{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                NSString *result;
                if (isPraise) {
                    result = [NSString dictionaryToJson:@{@"is_praise":@NO}];
                }else{
                    result = [NSString dictionaryToJson:@{@"is_praise":@YES}];
                }
                responseCallback(result);
            });
        }
    }];
    
    // 点击热门评论区域
    [self.bridge registerHandler:@"page" handlerName:@"hotCommentClick" callback:^(id data) {
        MSBYZHCommentController *commentVC = [MSBYZHCommentController new];
        commentVC.video_id = weakSelf.videoId;
        commentVC.detailModel = weakSelf.detailModel;
        commentVC.hotComments = weakSelf.hotComments;
        [weakSelf.navigationController pushViewController:commentVC animated:YES];
    }];

    // 点击关联视频
    [self.bridge registerHandler:@"page" handlerName:@"correlationVideoClick" callback:^(id data) {
        NDLog(@"----correlationVideoClick---%@",data);
        NSString * videoId = data[@"video_id"];
        NSString * videoUrl = data[@"video"];

        MSBYZHDetailController *videoDetailVc = [MSBYZHDetailController new];
        videoDetailVc.videoId = videoId;
        videoDetailVc.videoUrl = videoUrl;
        videoDetailVc.wantsNavigationBarVisible = NO;
        [weakSelf.navigationController pushViewController:videoDetailVc animated:YES];
    }];
}

// 返回值要必须为NO
- (BOOL)shouldAutorotate
{
    return NO;
}

#pragma mark - ZFPlayerDelegate
- (void)zf_playerBackAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Getter

- (ZFPlayerModel *)playerModel
{
    if (!_playerModel) {
        _playerModel                  = [[ZFPlayerModel alloc] init];
        _playerModel.title            = @"";
        _playerModel.videoURL         = [NSURL URLWithString:self.videoUrl];
        _playerModel.placeholderImage = [UIImage imageNamed:@"video_default"];
        _playerModel.fatherView       = self.playerFatherView;
        
    }
    return _playerModel;
}

- (AFNetworkReachabilityManager *)manager
{
    if (!_manager) {
        _manager = [AFNetworkReachabilityManager sharedManager];
        [_manager startMonitoring];
    }
    return _manager;
}

@end
