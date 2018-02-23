//
//  MSBPersonDetailController.m
//  meishubao
//
//  Created by T on 16/12/21.
//  Copyright © 2016年 benbun. All rights reserved.
//

#import "MSBPersonDetailController.h"
#import "MSBArticleDetailController.h"
#import "GeneralConfigure.h"
#import "MSBPersonCommentController.h"
#import "MSBPersonCenterController.h"
#import "UIView+MBProgressHUD.h"
#import "MSBArticleDetailBottom.h"
#import "MSBShareContentView.h"
#import "BBCommentView.h"
#import "MSBCommentView.h"
#import "MSBLoadingView.h"
#import "MSBArticleCommentModel.h"
#import "MSBArtistDetailModel.h"
#import "MSBHistoryModel.h"

#import "WYImageRequest.h"
#import "JSBridge.h"
#import "UIWebView+TS_JavaScriptContext.h"
#import "MWPhotoBrowser.h"
#import "IQKeyboardManager.h"
#import "MSBReadHistoryTool.h"
typedef NS_ENUM(NSInteger, MSBDetailFontType) {
    MSBDetailFontTypeSmall = 0,
    MSBDetailFontTypeMiddle,
    MSBDetailFontTypeBig,
    MSBDetailFontTypeEspecialBig
};
@interface MSBPersonDetailController ()<UIWebViewDelegate,TSWebViewDelegate, JSBridgeDelegate, UIGestureRecognizerDelegate,MWPhotoBrowserDelegate>{
    NSInteger _currentIndex;
    UIImage * _currentImage;

    BOOL _isWorksRequest;
    BOOL _isConmmentRequest;
}
@property(nonatomic,strong) JSBridge *bridge;
@property(nonatomic,strong) UIWebView *webView;
@property (nonatomic, weak) MSBArticleDetailBottom *detailBottom;

@property(nonatomic,strong) NSArray *hotComments;
@property(nonatomic,strong) MSBArtistDetailModel *detailModel;

@property (nonatomic, copy) NSString *fontSizeStr;

@property(nonatomic,strong) UIImage *shareImage;
@property (nonatomic,copy) NSArray * photoItems;
@property(nonatomic,strong) NSArray *photos;
@property(nonatomic,strong) NSArray *imgUrls;
@property (nonatomic,assign) BOOL isPush;//避免网络加载慢多点几次作品会push多个页面
@property (nonatomic,copy) NSDictionary * workData;
@end

@implementation MSBPersonDetailController{
    BOOL  _isJsbridgeInit;
    BOOL _isDataRequestInit;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // requestData
    [self setLogoTitle];
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = NO;
    manager.shouldResignOnTouchOutside = NO;
    manager.shouldToolbarUsesTextFieldTintColor = NO;
    manager.enableAutoToolbar = NO;
    
    // _commitRightItem
    [self _commitRightItem];
    
    // _commitWebView
    [self _commitWebView];
    //
    [self setupTitleSizeFont];
    // _commitBottom
    [self _commitBottom];
    
    [self requestData];
    
    [self webLoadView:self.view];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    
    NDLog(@"MSBArticleDetailController dealloc");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    if (self.webView) {
        [self.webView removeFromSuperview];
        self.webView.delegate = nil;
        self.webView = nil;
    }
    
    if (self.bridge) {
        self.bridge.delegate = nil;
        self.bridge = nil;
    }
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
    self.webView.backgroundColor = [UIColor clearColor];
    self.webView.scrollView.showsHorizontalScrollIndicator = NO;
    self.bridge.webview = self.webView;
    UISwipeGestureRecognizer *swipeGes = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(leftSwipe)];
    swipeGes.direction = UISwipeGestureRecognizerDirectionLeft;
    swipeGes.cancelsTouchesInView = false;
    swipeGes.delegate = self;
    [self.webView addGestureRecognizer:swipeGes];
    
    NSString *basePath = [NSString stringWithFormat:@"%@/html",  [[NSBundle mainBundle] bundlePath]];
    NSURL *baseURL = [NSURL fileURLWithPath:basePath isDirectory:YES];
    NSString *htmlString = [NSString stringWithContentsOfFile:[NSString stringWithFormat:@"%@/person_detail.html", basePath] encoding:NSUTF8StringEncoding error:NULL];
    [self.webView loadHTMLString:htmlString baseURL:baseURL];
}
/*
-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    //网页开启夜间模式
    webViewNight;
    //字号适配
    webFontSizeReSet;
}
*/

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
    detailBottom.isArtist = YES;
    self.detailBottom = detailBottom;
    [detailBottom setFrame:CGRectMake(0, SCREEN_HEIGHT - kBottomHeight, SCREEN_WIDTH, kBottomHeight)];
    [self.view addSubview:detailBottom];
    
    __block __weak typeof(self) weakSelf = self;
    
    detailBottom.messClick = ^(){
        MSBPersonCommentController *commentVC = [MSBPersonCommentController new];
        commentVC.artistId = weakSelf.artistId;
        commentVC.artistDetailModel = weakSelf.detailModel;
        commentVC.hotComments = weakSelf.hotComments;
        [weakSelf.navigationController pushViewController:commentVC animated:YES];
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
    shareContentView.post_id = self.detailModel.artist_id;
    shareContentView.post_type = @"3";
    [shareContentView shareTitle:self.detailModel.name desc:self.detailModel.intro url:self.detailModel.artist_url img:self.shareImage];
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

        [[LLRequestBaseServer shareInstance] requestArticleDetailPublishCommentPostId:nil artist_id:weakSelf.artistId video_id:nil
         type:2 commentId:nil mainCommentId:nil toUid:nil commentContent:commentText success:^(LLResponse *response, id data) {

            [weakSelf showSuccess:@"评论成功"];
        } failure:^(LLResponse *response) {

            [weakSelf showError:@"评论失败"];
        } error:^(NSError *error) {

            [weakSelf showError:@"评论失败"];
        }];
    }];
}


- (void)leftSwipe{
    
}

#pragma mark - jsbridge
- (void)webView:(UIWebView *)webView didCreateJavaScriptContext:(JSContext *)ctx {
    ctx[@"__jsbridge"] = self.bridge;
}


- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return true;
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
    
    // 点击热门评论区域
    [self.bridge registerHandler:@"page" handlerName:@"hotCommentClick" callback:^(id data) {
        MSBPersonCommentController *commentVC = [MSBPersonCommentController new];
        commentVC.artistId = weakSelf.artistId;
        commentVC.artistDetailModel = weakSelf.detailModel;
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

    
    // 点击segement
    [self.bridge registerHandlerForResult:weakSelf module:@"page" handlerName:@"clickAritistSegment" callbackResult:^(id data, callBackBlock responseCallback) {
          NDLog(@"clickAritistSegment       %@", data);

        NSInteger type = [[NSString stringWithFormat:@"%@", data[@"type"]] integerValue];
        if (type == 1) {
            [weakSelf loadWorksDataOffset:@"0"  responseCallback:responseCallback];
        }else  if (type == 2){
            [weakSelf loadAdviseDataOfPostType:@"information" offset:@"0" responseCallback:responseCallback];
        }
//        else{
//            [weakSelf loadAdviseDataOfPostType:@"composition" offset:@"0" responseCallback:responseCallback];
//        }
    }];
    
    // 加载更多
    [self.bridge registerHandlerForResult:weakSelf module:@"page" handlerName:@"loadMoreData" callbackResult:^(id data, callBackBlock responseCallback) {
        NDLog(@"loadMoreData       %@", data);
        NSString *offset = [NSString stringWithFormat:@"%@", data[@"offset"]];
        NSInteger type = [[NSString stringWithFormat:@"%@", data[@"type"]] integerValue];
        if (offset.integerValue == 0) {
            return;
        }
        _isWorksRequest = NO;
        _isConmmentRequest = NO;
        if (type == 1) {
            [weakSelf loadWorksDataOffset:offset  responseCallback:responseCallback];
        }else if (type == 2) {
            [weakSelf loadAdviseDataOfPostType:@"information" offset:offset responseCallback:responseCallback];
        }
        /*else{
             [weakSelf loadAdviseDataOfPostType:@"composition" offset:offset responseCallback:responseCallback];
        }*/
        
    }];
    
    // 点击item
    [self.bridge registerHandler:@"page" handlerName:@"clickAritistItem" callback:^(id data) {
        NDLog(@"clickAritistItem       %@", data);
        NSString *postId = [NSString stringWithFormat:@"%@", data[@"post_id"]];
        MSBArticleDetailController *detailVC = [MSBArticleDetailController new];
        detailVC.tid = postId;
        [weakSelf.navigationController pushViewController:detailVC animated:YES];
    }];
    
    //点击作品
    weakSelf.isPush = NO;
    [self.bridge registerHandler:@"page" handlerName:@"clickPubItem" callback:^(id data) {
        NDLog(@"clickPubItem       %@", data);
        NSString * work_id = [NSString stringWithFormat:@"%@",data[@"work_id"]];
        if (weakSelf.isPush == YES) {
            return;
        }
        weakSelf.isPush = YES;
        __weak __block typeof(self) weakSelf = self;
        if (weakSelf.photos && weakSelf.photos.count > 0) {
            if (work_id && work_id.length != 0) {
                [weakSelf pushPhotosVcWithIndex:[self getIndexWithImages:work_id]];
                weakSelf.isPush = YES;
            }
            return;
        }
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [[LLRequestServer shareInstance] requestArtistWorksWithArtistId:weakSelf.artistId offset:@"0" pagesize:10 isAll:@"all" success:^(LLResponse *response, id data) {
                if (data && [data isKindOfClass:[NSDictionary class]]) {
                    self.photoItems = data[@"items"];
                    
                    weakSelf.photos = [weakSelf photoWithUrls:self.photoItems];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [weakSelf pushPhotosVcWithIndex:[self getIndexWithImages:work_id]];
                        weakSelf.isPush = YES;
                    });
                }
            } failure:^(LLResponse *response) {
            } error:^(NSError *error) {
            }];
        });
    }];
}

-(void)viewWillAppear:(BOOL)animated
{
    self.isPush = NO;//初始化
}

- (NSInteger)getIndexWithImages:(NSString *)workId {

    if (!self.photoItems || self.photoItems.count == 0) {
        return HUGE_VALF;
    }
    if (!workId || workId.length == 0) {
        return HUGE_VALF;
    }
    for (int i = 0; i < self.photoItems.count; i++) {
        id photo = self.photoItems[i];
        if ([photo isKindOfClass:[NSDictionary class]]) {
            NSString * work_id = photo[@"work_id"];
            //NSLog(@"点击的id:%@",work_id);
            if (work_id && work_id.length != 0) {
                if ([workId isEqualToString:work_id]) {
                    return i;
                }
            }
        }
    }
    return 0;
}

-(void)pushPhotosVcWithIndex:(NSInteger)index
{
    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    browser.displayActionButton = YES;
    browser.displayNavArrows = NO;
    browser.displaySelectionButtons = NO;
    browser.alwaysShowControls = NO;
    browser.zoomPhotosToFill = YES;
    browser.enableGrid = NO;
    browser.startOnGrid = NO;
    browser.enableSwipeToDismiss = NO;
    browser.autoPlayOnAppear = NO;
    if (index != HUGE_VALF) {
        [browser setCurrentPhotoIndex:index];
    }
    [self.navigationController pushViewController:browser animated:YES];
}

-(NSArray *)photoWithUrls:(NSArray *)items
{
    if (!items) {
        return nil;
    }
    NSMutableArray * photos = [NSMutableArray array];
    NSMutableArray * urls = [NSMutableArray array];
    for (NSDictionary * item in items) {
        NSString * urlStr = item[@"work_url"];
        NSString * url = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        [photos addObject:[MWPhoto photoWithURL:[NSURL URLWithString:url]]];
        [urls addObject:url];
    }
    self.imgUrls = urls;
    return photos.copy;
}

- (void)loadWorksDataOffset:(NSString *)offset responseCallback:(callBackBlock)responseCallback{
    if (_isWorksRequest) {
        return;
    }
    __weak __block typeof(self) weakSelf = self;
    [[LLRequestServer shareInstance] requestArtistWorksWithArtistId:weakSelf.artistId offset:offset pagesize:10 isAll:nil success:^(LLResponse *response, id data) {
        if (data && [data isKindOfClass:[NSDictionary class]]) {
            responseCallback([NSString dictionaryToJson:data]);
            _isWorksRequest = YES;
        }
    } failure:^(LLResponse *response) {
        if (response.code == 10006) {
            NSDictionary * dic = @{@"offset":@(offset.integerValue + 1),@"total":@0,@"pagesize":@10,@"items":@[]};
            responseCallback([NSString dictionaryToJson:dic]);
            _isWorksRequest = YES;
        }
    } error:^(NSError *error) {
    }];
}


- (void)loadAdviseDataOfPostType:(NSString *)postType offset:(NSString *)offset responseCallback:(callBackBlock)responseCallback{
    if (_isConmmentRequest) {
        return;
    }
    __weak __block typeof(self) weakSelf = self;
    [[LLRequestServer shareInstance] requestArtistArticleWithArtistId:weakSelf.artistId articleType:postType offset:offset pagesize:10 success:^(LLResponse *response, id data) {
        if (data && [data isKindOfClass:[NSDictionary class]]) {
            responseCallback([NSString dictionaryToJson:data]);
            _isConmmentRequest = YES;
        }
    } failure:^(LLResponse *response) {
        if (response.code == 10006) {
            NSDictionary * dic = @{@"offset":@(offset.integerValue + 1),@"total":@0,@"pagesize":@10,@"items":@[]};
            responseCallback([NSString dictionaryToJson:dic]);
            _isConmmentRequest = YES;
        }
    } error:^(NSError *error) {

    }];
}

- (void)requestData{
    __weak __block typeof(self)  weakSelf = self;
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_enter(group);
    [[LLRequestBaseServer shareInstance] requestPeopleDetailWithArtist_id:self.artistId success:^(LLResponse *response, id data) {
        if (data && [data isKindOfClass:[NSDictionary class]]) {
            weakSelf.detailModel = [MSBArtistDetailModel mj_objectWithKeyValues:data];
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
    [[LLRequestServer shareInstance] requestArtistWorksWithArtistId:weakSelf.artistId offset:0 pagesize:10 isAll:nil success:^(LLResponse *response, id data) {
        if (data && [data isKindOfClass:[NSDictionary class]]) {
            weakSelf.workData = data;
            _isWorksRequest = YES;
        }
        dispatch_group_leave(group);
    } failure:^(LLResponse *response) {
        if (response.code == 10006) {
            NSDictionary * dic = @{@"offset":@(0 + 1),@"total":@0,@"pagesize":@10,@"items":@[]};
            weakSelf.workData = dic;
            _isWorksRequest = YES;
        }
        dispatch_group_leave(group);
    } error:^(NSError *error) {
        dispatch_group_leave(group);
    }];
    
     dispatch_group_enter(group);
    [[LLRequestServer shareInstance] requestArticleDetailHotCommentWithArticleId:nil artist_id:weakSelf.artistId  video_id:nil type:2 success:^(LLResponse *response, id data) {
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

- (void)initConfigData:(MSBArtistDetailModel *)artistDetail comment:(NSArray *)comment{
    if (!(_isJsbridgeInit && _isDataRequestInit)) return;
    //if (artistDetail == nil)return;
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    if (artistDetail == nil){
        //dic = @{};
    }else{
        dic = [artistDetail mj_keyValues];
        [dic setValue:self.workData forKey:@"workData"];
    }
    
    self.detailBottom.commentCount = self.detailModel.comment_num;
    
    NSMutableArray *hotComments = [NSMutableArray array];
    [hotComments removeAllObjects];
    
    
    if (comment.count > 0 && comment != nil) {
        [hotComments addObjectsFromArray:[MSBArticleCommentModel mj_keyValuesArrayWithObjectArray:comment]];
    }

    NSDictionary* initParams = @{
                                 @"personDetail": dic,
                                 @"hotComments":@{@"items":hotComments},
                                 @"fontSize":self.fontSizeStr,
                                 @"themeVersion":self.dk_manager.themeVersion,
                                 @"assetsPath":[[NSBundle mainBundle] bundlePath]
                                 };
    [self.bridge nativeCallJsInitConfig:[NSString dictionaryToJson:initParams]];
    
    __weak typeof(self) weakSelf = self;
    [[SDWebImageManager sharedManager] loadImageWithURL:[NSURL URLWithString:artistDetail.photo] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
    } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
        weakSelf.shareImage = image;
    }];
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

- (void)collectImage
{
    BOOL isLogin =  [MSBJumpLoginVC jumpLoginVC:self];
    if (isLogin) {return;}
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    __weak __block typeof(window) weakWindow = window;
    [[LLRequestBaseServer shareInstance] requestArticleDetailArticleCollectionPostId:nil isCollect:YES video_id:nil pic_url:self.imgUrls[_currentIndex] type:3 success:^(LLResponse *response, id data) {
        [weakWindow showSuccess:@"图片收藏成功"];
    } failure:^(LLResponse *response) {
        [weakWindow showError:@"图片收藏失败"];
    } error:^(NSError *error) {
        [weakWindow showError:@"图片收藏失败"];
    }];
}

- (void)setArtistId:(NSString *)artistId{
    _artistId = artistId;
}
@end
