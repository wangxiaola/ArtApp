//
//  MSBArticleDetailController.m
//  meishubao
//
//  Created by T on 16/11/16.
//  Copyright © 2016年 benbun. All rights reserved.
//

#import "MSBArticleDetailController.h"
#import "MSBArticleCommentController.h"
#import "MSBPersonCenterController.h"
#import "UIView+MBProgressHUD.h"
#import "MSBArticleDetailBottom.h"
#import "MSBShareContentView.h"
#import "BBCommentView.h"
#import "MSBCommentView.h"
#import "MSBLoadingView.h"
#import "MSBArticleCommentModel.h"
#import "MSBArticleDetailModel.h"
#import "MSBHistoryModel.h"

#import "WYImageRequest.h"
#import "GeneralConfigure.h"
#import "JSBridge.h"
#import "UIWebView+TS_JavaScriptContext.h"
#import "TFHpple.h"
#import "MWPhotoBrowser.h"
#import "AFNetworkReachabilityManager.h"
#import "IQKeyboardManager.h"
#import "MSBReadHistoryTool.h"
#import "NSString+Extension.h"

typedef NS_ENUM(NSInteger, MSBDetailFontType) {
    MSBDetailFontTypeSmall = 0,
    MSBDetailFontTypeMiddle,
    MSBDetailFontTypeBig,
    MSBDetailFontTypeEspecialBig
};
static BOOL _isClickImage;
static NSArray * _currentImgUrls;
@interface MSBArticleDetailController ()<UIWebViewDelegate,TSWebViewDelegate, JSBridgeDelegate, UIGestureRecognizerDelegate, SDPhotoBrowserDelegate,MWPhotoBrowserDelegate>{
    
//    BOOL _isClickImage;
//    NSArray * _currentImgUrls;
}
@property(nonatomic,strong) JSBridge *bridge;
@property(nonatomic,strong) UIWebView *webView;
@property (nonatomic, weak) MSBArticleDetailBottom *detailBottom;

@property(nonatomic,strong) NSArray *hotComments;
@property(nonatomic,strong) MSBArticleDetailModel *detailModel;

@property (nonatomic, copy) NSString *fontSizeStr;

@property(nonatomic,strong) NSMutableArray *imgs;
@property(nonatomic,strong) NSMutableArray *imgUrls;
@property(nonatomic,strong) NSMutableArray *smetaUrls;

@property(nonatomic,strong) NSArray *photos;

@property(nonatomic,strong) UIImage *shareImage;
@end

@implementation MSBArticleDetailController{
    BOOL _isJsbridgeInit;
    BOOL _isDataRequestInit;
    NSInteger _currentIndex;
    UIImage * _currentImage;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setLogoTitle];
    
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = NO;
    manager.shouldResignOnTouchOutside = NO;
    manager.shouldToolbarUsesTextFieldTintColor = NO;
    manager.enableAutoToolbar = NO;
    
    NDLog(@"themeVersion ===== %@",self.dk_manager.themeVersion);
    
    // _commitRightItem
    [self _commitRightItem];
    
    //
    [self setupTitleSizeFont];
    
    // _commitWebView
    [self _commitWebView];

    // _commitBottom
    [self _commitBottom];

    [self requestData];
    
    [self webLoadView:self.view];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        NDLog(@"%ld",(long)status);
    }];
    _isClickImage = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] postNotificationName:MSBCanCelWYImageRequest object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    
    NDLog(@"MSBArticleDetailController dealloc");
    
    if (self.imgs) {
        [self.imgs removeAllObjects];
    }
    
    if (self.imgUrls) {
        [self.imgUrls removeAllObjects];
    }
    
    if (self.smetaUrls) {
        [self.smetaUrls removeAllObjects];
    }
    
    if (self.photos) {
        self.photos = nil;
    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];

    //清除cookies
    NSHTTPCookie *cookie;
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (cookie in [storage cookies]){
        [storage deleteCookie:cookie];
    }
    //清除UIWebView的缓存
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    NSURLCache * cache = [NSURLCache sharedURLCache];
    [cache removeAllCachedResponses];
    [cache setDiskCapacity:0];
    [cache setMemoryCapacity:0];

    if (self.webView) {
        [self.webView removeFromSuperview];
        self.webView.delegate = nil;
        self.webView = nil;
    }
    
    if (self.bridge) {
        self.bridge.delegate = nil;
        self.bridge = nil;
    }
    [[AFNetworkReachabilityManager sharedManager] stopMonitoring];
}

#pragma mark - Private Method
/**
 * page _commit
 */
- (void)_commitRightItem{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"detailpage_item_more"] style:UIBarButtonItemStyleDone target:self action:@selector(shareItemClick)];
    self.navigationItem.rightBarButtonItem.enabled = NO;
}

- (void)_commitWebView{
    self.bridge = [[JSBridge alloc] init];
    [self.bridge setDelegate:self];
    self.webView = [UIWebView new];
    [self.webView setDelegate:self];
    [self.webView setFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - kBottomHeight)];
    [self.view addSubview:self.webView];
    self.webView.scalesPageToFit = YES;
    //self.webView.scrollView.bounces = NO;
    self.webView.scrollView.showsHorizontalScrollIndicator = NO;
    self.webView.backgroundColor = [UIColor clearColor];
    self.bridge.webview = self.webView;
//    UISwipeGestureRecognizer *swipeGes = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(leftSwipe)];
//    swipeGes.direction = UISwipeGestureRecognizerDirectionLeft;
//    swipeGes.cancelsTouchesInView = false;
//    swipeGes.delegate = self;
//    [self.webView addGestureRecognizer:swipeGes];

    [self loadWebViewData];
}

-(void)loadWebViewData
{
    NSString *basePath = [NSString stringWithFormat:@"%@/html",  [[NSBundle mainBundle] bundlePath]];
    NSURL *baseURL = [NSURL fileURLWithPath:basePath isDirectory:YES];
    NSString *htmlString = [NSString stringWithContentsOfFile:[NSString stringWithFormat:@"%@/article_detail.html", basePath] encoding:NSUTF8StringEncoding error:NULL];
    [self.webView loadHTMLString:htmlString baseURL:baseURL];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView {
     [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"WebKitCacheModelPreferenceKey"];
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
    [detailBottom setFrame:CGRectMake(0, SCREEN_HEIGHT - (kBottomHeight), SCREEN_WIDTH, kBottomViewHeight)];
    [self.view addSubview:detailBottom];
    
    __block __weak typeof(self) weakSelf = self;
    
    detailBottom.messClick = ^(){
        MSBArticleCommentController *commentVC = [MSBArticleCommentController new];
        commentVC.tid = weakSelf.tid;
        commentVC.detailModel = weakSelf.detailModel;
        commentVC.hotComments = weakSelf.hotComments;
        [weakSelf.navigationController pushViewController:commentVC animated:YES];
    };

    detailBottom.storeClick = ^(UIButton *btn){
        
        if ([MSBJumpLoginVC jumpLoginVC:weakSelf]) {
            return;
        }
        [[LLRequestBaseServer shareInstance] requestArticleDetailArticleCollectionPostId:weakSelf.tid isCollect:!btn.selected video_id:nil pic_url:nil type:1 success:^(LLResponse *response, id data) {
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
    shareContentView.post_id = self.detailModel.post_id;
    shareContentView.post_type = @"1";
    [shareContentView shareTitle:self.detailModel.share_title desc:self.detailModel.share_desc url:self.detailModel.share_url img:self.shareImage];
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
        [[LLRequestBaseServer shareInstance] requestArticleDetailPublishCommentPostId:weakSelf.tid artist_id:nil video_id:nil type:1 commentId:nil mainCommentId:nil toUid:nil commentContent:commentText success:^(LLResponse *response, id data) {
            [weakSelf showSuccess:@"评论成功"];
        } failure:^(LLResponse *response) {

            [weakSelf showError:@"评论失败"];
        } error:^(NSError *error) {

            [weakSelf showError:@"评论失败"];
        }];
    }];
}

- (void)requestData{
    
    if (self.articleModel) {
        
        _isDataRequestInit = YES;
        self.detailModel = self.articleModel;
        [self initConfigData:self.detailModel comment:@[]];
    }else {
    
        __weak __block typeof(self)  weakSelf = self;
        dispatch_group_t group = dispatch_group_create();
        dispatch_group_enter(group);
        
        [[LLRequestServer shareInstance] requestArticleDetailWithArticleId:_tid success:^(LLResponse *response, id data) {
            if (data && [data isKindOfClass:[NSDictionary class]]) {
                weakSelf.detailModel = [MSBArticleDetailModel mj_objectWithKeyValues:data];
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
        [[LLRequestServer shareInstance] requestArticleDetailHotCommentWithArticleId:_tid artist_id:nil video_id:nil
                                                                                type:1 success:^(LLResponse *response, id data) {
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
            [weakSelf initConfigData:weakSelf.detailModel comment:weakSelf.hotComments];
        });
    }
}

- (void)initConfigData:(MSBArticleDetailModel *)articleDetail comment:(NSArray *)comment{
    if (!(_isJsbridgeInit && _isDataRequestInit)) return;
    
    NSDictionary *dic = nil;
    if (articleDetail == nil){
        dic = @{};
    }else{
        BOOL isWifiImage = [[NSUserDefaults standardUserDefaults] boolForKey:APP_WIFI_PHOTO_MODE];
        AFNetworkReachabilityStatus status = [AFNetworkReachabilityManager sharedManager].networkReachabilityStatus;
        if (isWifiImage == YES && status != AFNetworkReachabilityStatusReachableViaWiFi) {
            //正则替换
            NSRegularExpression *wenRegex = [NSRegularExpression regularExpressionWithPattern:@"<(\\w+?)>文\\s?\\/.*?<\\/\\1>(<br( /)?>\r\\n(&nbsp;)?<br( /)?>)?" options:0 error:nil];
            NSUInteger minWenRange = MIN(articleDetail.post_content.length, 500);
            NSString *noWenContent = [wenRegex stringByReplacingMatchesInString:articleDetail.post_content options:0 range:NSMakeRange(0, minWenRange) withTemplate:@""];
            NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"<img([^>]+)src=\"" options:0 error:nil];
            NSString *esrcContent = [regex stringByReplacingMatchesInString:noWenContent options:0 range:NSMakeRange(0, noWenContent.length) withTemplate:@"<img$1src=\"img/placehoder.png\""];
            articleDetail.post_content = esrcContent;
            
        }

        dic = [articleDetail mj_keyValues];
    }
//    if (articleDetail == nil)return;
    
    self.detailBottom.commentCount = self.detailModel.comment_num;
    self.detailBottom.is_collect = self.detailModel.is_collect;
    
    NSMutableArray *hotComments = [NSMutableArray array];
    [hotComments removeAllObjects];
    
    
    if (comment.count > 0 && comment != nil) {
        [hotComments addObjectsFromArray:[MSBArticleCommentModel mj_keyValuesArrayWithObjectArray:comment]];
    }

  self.imgs =  [self getImgTags:articleDetail.post_content];
    
    NSDictionary* initParams = @{
//                                 @"articleDetail": [articleDetail mj_keyValues],
                                 @"articleDetail": dic,
                                 @"hotComments":@{@"items":hotComments},
                                 @"fontSize":self.fontSizeStr,
                                 @"themeVersion":self.dk_manager.themeVersion,
                                 @"assetsPath":[[NSBundle mainBundle] bundlePath]
                                 };
    NDLog(@"========正文内容：%@",[NSString dictionaryToJson:initParams]);
    [self.bridge nativeCallJsInitConfig:[NSString dictionaryToJson:initParams]];
    
    __weak typeof(self) weakSelf = self;
    [[SDWebImageManager sharedManager] loadImageWithURL:[NSURL URLWithString:articleDetail.share_image] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
        
    } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
        weakSelf.shareImage = image;
    }];
}


#pragma mark - jsbridge
- (void)webView:(UIWebView *)webView didCreateJavaScriptContext:(JSContext *)ctx {
    ctx[@"__jsbridge"] = self.bridge;
}


- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return true;
}

//- (void)leftSwipe{
//    MSBArticleCommentController *commentVC = [MSBArticleCommentController new];
//    commentVC.tid = self.tid;
//    commentVC.detailModel = self.detailModel;
//    commentVC.hotComments = self.hotComments;
//    [self.navigationController pushViewController:commentVC animated:YES];
//}

// onJsBridgeInit
- (void)onJsBridgeInit{
    _isJsbridgeInit = YES;
    [self initConfigData:self.detailModel comment:self.hotComments];
}

// onWebPageReady
- (void)onWebPageReady{
    self.navigationItem.rightBarButtonItem.enabled = YES;
     __weak __block typeof(self) weakSelf = self;
    CGFloat s = 0.5;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(s * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakSelf endLoading];
    });
    
     [self insertReadHistory];

    // 点击热门评论区域
    [self.bridge registerHandler:@"page" handlerName:@"hotCommentClick" callback:^(id data) {
        MSBArticleCommentController *commentVC = [MSBArticleCommentController new];
        commentVC.tid = weakSelf.tid;
        commentVC.detailModel = weakSelf.detailModel;
        commentVC.hotComments = weakSelf.hotComments;
        [weakSelf.navigationController pushViewController:commentVC animated:YES];
    }];
    
    // 评论点赞
    [self.bridge registerHandlerForResult:self module:@"page" handlerName:@"upvoteComment"  callbackResult:^(id data, callBackBlock responseCallback) {
        NDLog(@"----upvoteComment %@--%@", data, @"xxx");
        BOOL isPraise = [[NSString stringWithFormat:@"%@", data[@"is_praise"]] integerValue];
        
        if ([MSBAccount userLogin]) {
            NSString *commentId = [NSString stringWithFormat:@"%@", data[@"comment_id"]];
            BOOL isPraise = [[NSString stringWithFormat:@"%@", data[@"is_praise"]] integerValue];
            [weakSelf hudLoding];
            [[LLRequestServer shareInstance] requestArticleDetailCommentPraisePostId:nil commentId:commentId videoId:nil artistId:nil orgId:nil parise:!isPraise type:2 success:^(LLResponse *response, id data) {
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
    
    // 图片点击
    [self.bridge registerHandler:@"page" handlerName:@"imageDidClick" callback:^(id data) {
        
        if (_isClickImage) {
            
            return ;
        }
        _isClickImage = YES;
        NDLog(@"imageDidClick  %@", data);
//      __strong  typeof(self) strongSelf = self;
        NSString *url = [NSString stringWithFormat:@"%@", data[@"url"]];
        NDLog(@"imageDidClick  URL%@", url);

        NSInteger index = [weakSelf imgIndex:[NSString imageUrlString:url]];
        NDLog(@"imageDidClick  index%tu", index);
        
        weakSelf.photos = [weakSelf photosOfDetail];
        _currentImgUrls = weakSelf.imgUrls;
        
        MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:weakSelf];
        browser.displayActionButton = YES;
        browser.displayNavArrows = NO;
        browser.displaySelectionButtons = NO;
        browser.alwaysShowControls = NO;
        browser.zoomPhotosToFill = YES;
        browser.enableGrid = NO;
        browser.startOnGrid = NO;
        browser.enableSwipeToDismiss = NO;
        browser.autoPlayOnAppear = NO;
        [browser setCurrentPhotoIndex:index];
        [weakSelf.navigationController pushViewController:browser animated:YES];
    }];
    
    // 图集点击
    [self.bridge registerHandler:@"page" handlerName:@"galleryClick" callback:^(id data) {

        if (_isClickImage) {

            return ;
        }
        _isClickImage = YES;

        NDLog("返回的数据:%@",data);
        NSArray * images = [ArticleImageModel mj_objectArrayWithKeyValuesArray:data[@"smeta"]];
        NSString * currentUrl = data[@"url"];

        NSInteger currentIndex = 0;
        for (int i = 0 ; i < images.count; i++) {
            ArticleImageModel * model = images[i];
            if ([[model.url componentsSeparatedByString:@"?"].firstObject isEqualToString:[currentUrl componentsSeparatedByString:@"?"].firstObject]) {
                currentIndex = i;
            }
        }

        TopViewController * top = [TopViewController new];
        top.wantsNavigationBarVisible = NO;
        top.imgSmeta = images;
        top.index = currentIndex;
        [weakSelf.navigationController pushViewController:top animated:YES];
/*
        [weakSelf.smetaUrls removeAllObjects];
        NSInteger currentIndex = 0;

        NSMutableArray * photos = [NSMutableArray array];
        for (int i = 0 ; i < images.count; i++) {
            ArticleImageModel * model = images[i];
            [weakSelf.smetaUrls addObject:model.url];
            if ([[model.url componentsSeparatedByString:@"?"].firstObject isEqualToString:[currentUrl componentsSeparatedByString:@"?"].firstObject]) {
                currentIndex = i;
            }
            MWPhoto * photo = [MWPhoto photoWithURL:[NSURL URLWithString:model.url]];
            photo.caption = [NSString stringWithFormat:@"%@\n%@",model.name,model.desc];
            [photos addObject:photo];
        }
        
        weakSelf.photos = photos.copy;
        _currentImgUrls = weakSelf.smetaUrls;
        
        MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:weakSelf];
        browser.displayActionButton = YES;
        browser.displayNavArrows = NO;//
        browser.displaySelectionButtons = NO;
        browser.alwaysShowControls = NO;
        browser.zoomPhotosToFill = YES;
        browser.enableGrid = NO;
        browser.startOnGrid = NO;
        browser.enableSwipeToDismiss = NO;
        browser.autoPlayOnAppear = NO;
        [browser setCurrentPhotoIndex:currentIndex];
        [weakSelf.navigationController pushViewController:browser animated:YES];*/
    }];

    // 点击超链接
    [self.bridge registerHandler:@"page" handlerName:@"loadUrl" callback:^(id data) {
        NSString * webUrl = data[@"url"];
        if ([webUrl containsString:@"http://"] || [webUrl containsString:@"https://"]) {
            [weakSelf pushDetailTypeConfig:webUrl];
        }
    }];
}
//超链接跳转分析
- (void)pushDetailTypeConfig:(NSString *)webUrl {

    AdOpenTypeModel * typeModel = [AdUrlTool typeWithAdUrl:webUrl];
    switch (typeModel.openType) {
        case AdOpenTypeArticle:
            //文章
            [self pushArticleDetail:typeModel];
            break;
        case AdOpenTypeArtist:
            //人物
            [self pushArtistDetail:typeModel];
            break;
        case AdOpenTypeVideo:
            //视频
            [self pushVideoDetail:typeModel];
            break;
        default:
            //普通网页
            [self pushWebViewController:webUrl];
            break;
    }
}

- (void)pushArticleDetail:(AdOpenTypeModel *)typeModel {

    MSBArticleDetailController * detail = [MSBArticleDetailController new];
    detail.tid = typeModel.contentId;
    [self.navigationController pushViewController:detail animated:YES];
}

- (void)pushArtistDetail:(AdOpenTypeModel *)typeModel {

    MSBPersonDetailController * detail = [MSBPersonDetailController new];
    detail.artistId = typeModel.contentId;
    [self.navigationController pushViewController:detail animated:YES];
}

- (void)pushVideoDetail:(AdOpenTypeModel *)typeModel {

    MSBYZHDetailController * detail = [MSBYZHDetailController new];
    detail.wantsNavigationBarVisible = NO;
    detail.videoId = typeModel.contentId;
    [self.navigationController pushViewController:detail animated:YES];
}

- (void)pushWebViewController:(NSString *)url {

    MSBWebBaseController * web = [MSBWebBaseController new];
    web.isWeb = YES;
    web.webUrl = url;
    [self.navigationController pushViewController:web animated:YES];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {

    NSString * url = request.URL.absoluteString;
    if ([url containsString:@"http://"] || [url containsString:@"https://"]) {
        [self pushDetailTypeConfig:url];
        return NO;
    }
    return YES;
}

#pragma mark - MWPhotoBrowserDelegate

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return self.photos.count;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    NDLog(@"-----%tu", index);
    if (index < self.photos.count)
        return [self.photos objectAtIndex:index];
    return nil;
}

-(void)photoBrowser:(MWPhotoBrowser *)photoBrowser longPressedForPhotoAtIndex:(NSUInteger)index image:(UIImage *)currentImage
{
    NDLog(@"--------%tu",index);
    _currentIndex = index;
    _currentImage = currentImage;
    [self showMoreItem];
}

- (void)photoBrowser:(MWPhotoBrowser *)photoBrowser actionButtonPressedForPhotoAtIndex:(NSUInteger)index image:(UIImage *)currentImage
{
    _currentIndex = index;
    _currentImage = currentImage;
    [self showMoreItem];
}

- (void)collectImage
{
    if ([MSBJumpLoginVC jumpLoginVC:self]) {
        return;
    }

    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    __weak __block typeof(window) weakWindow = window;
    [[LLRequestBaseServer shareInstance] requestArticleDetailArticleCollectionPostId:nil isCollect:YES video_id:nil pic_url:_currentImgUrls[_currentIndex] type:3 success:^(LLResponse *response, id data) {
        [weakWindow showSuccess:@"图片收藏成功"];
    } failure:^(LLResponse *response) {
        if (response.code == 10016) {
            [weakWindow showTitle:@"图片已收藏"];
        }else {
            
            [weakWindow showError:@"图片收藏失败"];
        }
    } error:^(NSError *error) {
        [weakWindow showError:@"图片收藏失败"];
    }];
}

- (void)showMoreItem
{
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    alert.view.tintColor = RGBCOLOR(181, 27, 32);
    [alert addAction:[UIAlertAction actionWithTitle:@"收藏" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //收藏
        [self collectImage];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"保存图片" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //保存
        [self saveImageToAlbum];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    
    [self.navigationController presentViewController:alert animated:YES completion:nil];
}


- (void)saveImageToAlbum
{
   UIImageWriteToSavedPhotosAlbum(_currentImage, self, @selector(image:didFinishSavingWithError:contextInfo:), (__bridge void *)self);
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    if (error == nil) {
        [window showSuccess:@"保存成功"];
    }else{
        [window showError:@"保存失败"];
    }
}

- (NSMutableArray *)photosOfDetail{
    NSMutableArray *photos = [[NSMutableArray alloc] init];
    for (NSString *strUrl in self.imgUrls) {
        [photos addObject:[MWPhoto photoWithURL:[NSURL URLWithString:strUrl]]];
    }
    return photos;
}

- (NSInteger)imgIndex:(NSString *)url{
    NSInteger index = 0;
    for (NSInteger i = 0; i<self.imgs.count; i++) {
        NSDictionary *dic = self.imgs[i];
        for (NSString *key in dic.allKeys) {
            if ([key isEqualToString:url]) {
                index = i;
                return index;
            }
        }
    }
    return 0;
}

- (id)upvoteComment:(NSString *)commentId{
     __weak __block typeof(self) weakSelf = self;
    __block BOOL myResult;
    [[LLRequestServer shareInstance] requestArticleDetailCommentPraisePostId:nil commentId:commentId videoId:nil artistId:nil orgId:nil parise:0 type:2 success:^(LLResponse *response, id data) {
         myResult = YES;
    } failure:^(LLResponse *response) {
        myResult = YES;
    } error:^(NSError *error) {
        myResult = YES;
    }];
    return @(myResult);
}

// 返回高质量图片的url
- (NSURL *)photoBrowser:(SDPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index{
    NSString *urlStr = self.imgUrls[index];
//    NSString *urlStr = [[self.modelsArray[index] thumbnail_pic] stringByReplacingOccurrencesOfString:@"thumbnail" withString:@"bmiddle"];
    return [NSURL URLWithString:urlStr];
}

/**获取<img >标签的正则表达式，*/
-(NSMutableArray*)getImgTags:(NSString *)htmlText{
    if ([NSString isNull:htmlText]) {
        return nil;
    }
    NSData *data =[htmlText dataUsingEncoding:NSUTF8StringEncoding];
    TFHpple *doc = [[TFHpple alloc] initWithHTMLData:data];
    NSArray *imgTags = [doc searchWithXPathQuery:@"//img"];
    
    NSMutableArray *images = [NSMutableArray array];
    
    for (NSInteger i = 0; i<imgTags.count; i++) {
        NSString *url = [imgTags[i] objectForKey:@"src"];
        NSString * imageUrl = [NSString imageUrlString:url];
        [self.imgUrls addObject:imageUrl];
        [images addObject:@{imageUrl:@(i)}];
        NDLog(@"==imgdic==%@", @{imageUrl:@(i)});
    }
    return images;
}

- (void)insertReadHistory{
    MSBHistoryModel *historyModel = [MSBHistoryModel new];
    historyModel.tid = self.tid;
    historyModel.title = self.detailModel.post_title;
    historyModel.time = [NSString timeForReadHistory];
    [MSBReadHistoryTool insertDBModel:historyModel];
}

#pragma mark - setter
- (void)setTid:(NSString *)tid{
    _tid = tid;
}

- (NSMutableArray *)imgs{
    if (!_imgs) {
        _imgs = [NSMutableArray array];
    }
    return _imgs;
}

- (NSMutableArray *)imgUrls{
    if (!_imgUrls) {
        _imgUrls = [NSMutableArray array];
    }
    return _imgUrls;
}
- (NSMutableArray *)smetaUrls{
    if (!_smetaUrls) {
        _smetaUrls = [NSMutableArray array];
    }
    return _smetaUrls;
}
@end
