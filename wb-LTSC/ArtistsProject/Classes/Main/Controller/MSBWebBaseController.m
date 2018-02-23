//
//  MSBWebBaseController.m
//  meishubao
//
//  Created by benbun－mac on 17/2/10.
//  Copyright © 2017年 benbun. All rights reserved.
//

#import "MSBWebBaseController.h"
#import "NJKWebViewProgress.h"
#import "NJKWebViewProgressView.h"
#import "GeneralConfigure.h"
#import "Ann30ImageModel.h"
#import "ArticleImageModel.h"
#import "MWPhotoBrowser.h"

@interface MSBWebBaseController ()<NJKWebViewProgressDelegate,UIWebViewDelegate,MWPhotoBrowserDelegate> {
    
    NJKWebViewProgressView *_progressView;
    NJKWebViewProgress *_progressProxy;
    UIButton * _closeItem;
    NSInteger _currentIndex;
    UIImage * _currentImage;
}
@property (nonatomic,strong) UIWebView * webView;
@property (nonatomic, strong) NSMutableArray *photos;
@property(nonatomic,strong) NSMutableArray *imgUrls;

@end

@implementation MSBWebBaseController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadWebUrl];
    
    if (self.isWeb) {
        [self setNavItem];
        [self setUpProgress];
    }else{
        [self webLoadView:self.view];
        [self loadImages];
    }
}

- (void)setNavItem
{
    UIView * leftItemView = [UIView new];
    UIButton * backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, 30, 30);
    [backBtn setImage:[UIImage imageNamed:@"navigation_back"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    [leftItemView addSubview:backBtn];
    
    UIButton * closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    closeBtn.frame = CGRectMake(CGRectGetMaxX(backBtn.frame), 0, 50, 30);
    [closeBtn addTarget:self action:@selector(closeClick) forControlEvents:UIControlEventTouchUpInside];
    closeBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    [closeBtn setTitle:@"关闭" forState:UIControlStateNormal];
    [closeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    closeBtn.hidden = YES;
    [leftItemView addSubview:closeBtn];
    leftItemView.frame = CGRectMake(0, 0, CGRectGetMaxX(closeBtn.frame), 30);
    
    UIBarButtonItem * left = [[UIBarButtonItem alloc] initWithCustomView:leftItemView];
    self.navigationItem.leftBarButtonItem = left;
    _closeItem = closeBtn;
    
    UIBarButtonItem * more = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"detailpage_item_more"] style:UIBarButtonItemStylePlain target:self action:@selector(moreClick)];
    self.navigationItem.rightBarButtonItem = more;
}

#pragma mark - NJKWebViewProgressDelegate
-(void)webViewProgress:(NJKWebViewProgress *)webViewProgress updateProgress:(float)progress
{
    [_progressView setProgress:progress animated:YES];
    self.title = [self.webView stringByEvaluatingJavaScriptFromString:@"document.title"];
}

- (void)closeClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)backClick
{
    if ([self.webView canGoBack]) {
        [self.webView goBack];
        _closeItem.hidden = NO;
    }else{
        [self closeClick];
    }
}

- (void)moreClick
{
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    alert.view.tintColor = RGBCOLOR(181, 27, 32);
    [alert addAction:[UIAlertAction actionWithTitle:@"刷新" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //刷新
        [self.webView reload];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"用Safari打开" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //用Safari打开
        [[UIApplication sharedApplication] openURL:self.webView.request.URL];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"复制链接" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //复制链接
        [self clone];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    
    [self.navigationController presentViewController:alert animated:YES completion:nil];
}

- (void)clone
{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = self.webView.request.URL.absoluteString;
    [self hudTip:@"复制链接完成"];
}

- (void)setUpProgress
{
    _progressProxy = [[NJKWebViewProgress alloc] init];
    self.webView.delegate = _progressProxy;
    
    _progressProxy.webViewProxyDelegate = self;
    _progressProxy.progressDelegate = self;
    
    CGFloat progressBarHeight = 2.f;
    CGRect navigationBarBounds = self.navigationController.navigationBar.bounds;
    CGRect barFrame = CGRectMake(0, navigationBarBounds.size.height - progressBarHeight, navigationBarBounds.size.width, progressBarHeight);
    _progressView = [[NJKWebViewProgressView alloc] initWithFrame:barFrame];
    _progressView.barAnimationDuration = 0.3;
    _progressView.fadeAnimationDuration = 0.3;
    _progressView.fadeOutDelay = 0.15;
    [_progressView setProgress:0.0 animated:NO];
    _progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
}


-(void)loadWebUrl
{
    NSURLRequest * request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.webUrl]];
    
    [self.webView loadRequest:request];
}

- (void)loadImages {
    
    [[LLRequestServer shareInstance] requestAnniversary30WithPostId:self.post_id success:^(LLResponse *response, id data) {
        if (data && [data isKindOfClass:[NSDictionary class]]) {
            Ann30ImageModel * imageModel = [Ann30ImageModel mj_objectWithKeyValues:data];
            for (ArticleImageModel *model in imageModel.smeta) {
                
                [self.photos addObject:[MWPhoto photoWithURL:[NSURL URLWithString:model.url]]];
                [self.imgUrls addObject:model.url];
            }
        }
    } failure:^(LLResponse *response) {
        
    } error:^(NSError *error) {
        
    }];
}

#pragma mark -webViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {

    NSURL *url = request.URL;
    NSString *urlEncode = [[url absoluteString] stringByRemovingPercentEncoding];
    if ([urlEncode containsString:@"bb:open"]) {
        NDLog(@"url === %@---%@", url.absoluteString,urlEncode);
        NSRange range = [urlEncode rangeOfString:@"?"];
        if (range.location != NSNotFound) {
            NSString *propertys = [urlEncode substringFromIndex:(NSInteger)(range.location+1)];
            //NSLog(@"propertys === %@", propertys);

            NSArray *subArray = [propertys componentsSeparatedByString:@"&"];
            NSMutableDictionary *tempDic = [NSMutableDictionary dictionary];
            for (int j = 0 ; j < subArray.count; j++){
                //在通过=拆分键和值
                NSArray *dicArray = [subArray[j] componentsSeparatedByString:@"="];
                //给字典加入元素
                [tempDic setObject:dicArray[1] forKey:dicArray[0]];
            }
            NDLog(@"打印参数列表生成的字典：%@", tempDic);

            if ([[tempDic valueForKey:@"bb:open_native"] isEqualToString:@"post/imagelist"]) {

                NSString *jsonStr = [tempDic valueForKey:@"bb:applink_data"];

                NSDictionary *param = [NSString dictionaryWithJsonString: jsonStr];
                NSInteger index = [param[@"position"] integerValue];

                MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
                browser.displayActionButton = YES;
                browser.displayNavArrows = YES;
                browser.displaySelectionButtons = NO;
                browser.alwaysShowControls = YES;
                browser.zoomPhotosToFill = YES;
                browser.enableGrid = NO;
                browser.startOnGrid = NO;
                browser.enableSwipeToDismiss = NO;
                browser.autoPlayOnAppear = NO;
                [browser setCurrentPhotoIndex:index];
                [self.navigationController pushViewController:browser animated:YES];
                return NO;
            }
        }
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
    [self showActionSheet];
}

- (void)photoBrowser:(MWPhotoBrowser *)photoBrowser actionButtonPressedForPhotoAtIndex:(NSUInteger)index image:(UIImage *)currentImage
{
    _currentIndex = index;
    _currentImage = currentImage;
    
    [self showActionSheet];
}

-(void)showActionSheet
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

-(void)webViewDidStartLoad:(UIWebView *)webView
{
    
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    if (!self.isWeb) {
        [self endLoading];
        self.title =  [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    }else{
        [_progressView setProgress:1.0 animated:YES];
    }
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    if (!self.isWeb) {
        [self endLoading];
    }
}

- (void)collectImage {
    BOOL isLogin =  [MSBJumpLoginVC jumpLoginVC:self];
    if (isLogin) {return;}
    __weak __block typeof(self) weakSelf = self;
    [[LLRequestBaseServer shareInstance] requestArticleDetailArticleCollectionPostId:nil isCollect:NO video_id:nil pic_url:self.imgUrls[_currentIndex] type:3 success:^(LLResponse *response, id data) {
        [weakSelf hudTip:@"图片收藏成功"];
    } failure:^(LLResponse *response) {
        if (response.code == 10016) {
            
            [weakSelf hudTip:@"图片已收藏"];
        }else {
        
            [weakSelf hudTip:@"图片收藏失败"];
        }
    } error:^(NSError *error) {
        [weakSelf hudTip:@"图片收藏失败"];
    }];
}

- (void)saveImageToAlbum
{
    UIImageWriteToSavedPhotosAlbum(_currentImage, self, @selector(image:didFinishSavingWithError:contextInfo:), (__bridge void *)self);
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (error == nil) {
        [self hudTip:@"保存成功"];
    }else{
        [self hudTip:@"保存失败"];
    }
}

-(UIWebView *)webView
{
    if (!_webView) {
        _webView = [UIWebView new];
        _webView.frame = self.view.bounds;
        _webView.backgroundColor = [UIColor clearColor];
        _webView.delegate = self;
        _webView.scalesPageToFit = YES;
        [self.view addSubview:_webView];
    }
    return _webView;
}

-(void)setWebUrl:(NSString *)webUrl
{
    if (!webUrl||webUrl.length == 0) {
        return;
    }
    _webUrl = webUrl;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.isWeb) {
        [self.navigationController.navigationBar addSubview:_progressView];
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if (self.isWeb) {
        [_progressView removeFromSuperview];
    }
}

- (NSMutableArray *)photos {

    if (!_photos) {
        
        _photos = [[NSMutableArray alloc] init];
    }
    return _photos;
}

- (NSMutableArray *)imgUrls {

    if (!_imgUrls) {
        
        _imgUrls = [[NSMutableArray alloc] init];
    }
    return _imgUrls;
}

- (void)dealloc{
    
    if (self.webView) {
        [self.webView removeFromSuperview];
        self.webView.delegate = nil;
        self.webView = nil;
    }
    
    if (self.imgUrls) {
        [self.imgUrls removeAllObjects];
    }
    
    if (self.photos) {
        self.photos = nil;
    }

    NSURLCache * cache = [NSURLCache sharedURLCache];
    [cache removeAllCachedResponses];
    [cache setDiskCapacity:0];
    [cache setMemoryCapacity:0];
}

- (void)didReceiveMemoryWarning {

    [super didReceiveMemoryWarning];

    NSURLCache * cache = [NSURLCache sharedURLCache];
    [cache removeAllCachedResponses];
    [cache setDiskCapacity:0];
    [cache setMemoryCapacity:0];
}

@end
