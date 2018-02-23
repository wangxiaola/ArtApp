//
//  PlayerViewController.m
//  TestYKMediaPlayer
//
//  Created by 周娜 on 13-6-25.
//  Copyright (c) 2013年 Youku Inc. All rights reserved.
//

#import "PlayerViewController.h"
#import "YTEngineOpenViewManager.h"
#import "YYMediaPlayerEvents.h"

#define MARGIN 5
#define BACK_WIDTH (DEVICE_TYPE_IPAD ? 30 : 20)
#define ui_round_size(x) (DEVICE_TYPE_IPAD ? ((x) < 50 ? 50 : (x)) : ((x) < 44 ? 44 : (x)))
#define TEXTVIEW_FONT (DEVICE_TYPE_IPAD ? 15 : 12)
#define TEXTVIEW_WIDTH (DEVICE_TYPE_IPAD ? 400 : 250)
#define TEXTVIEW_HEIGHT 30
#define BETWEEN_BOUND_FULL 100
#define BETWEEN_BOUND_NORMAL 20

@interface PlayerViewController () <YYMediaPlayerEvents>

@property (nonatomic, retain) YTEngineOpenViewManager *viewManager;
@property (nonatomic, retain) UIButton *backButton;
@property (nonatomic, retain) UITextView *textView;

@end

@implementation PlayerViewController

@synthesize player = _player;
@synthesize islocal;
@synthesize videoItem;

//- (void)dealloc {
//    [_viewManager release];
//    [_backButton release];
//    [_player release];
//    [_textView release];
//    [self.videoItem release];
//    [super dealloc];
//}
#pragma mark - View lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title=@"视频";
    self.view.backgroundColor = [UIColor whiteColor];
    
    CGSize size = self.view.bounds.size;
    CGFloat width = 0.f;
    if (DEVICE_TYPE_IPAD) {
        width = 681.f;
    } else {
        width = size.width;
    }
    CGFloat height = width * 9.0f / 16.0f;
    CGFloat sheight = 20.0f; //状态栏高度
    CGRect frame = CGRectMake(0, 0, width, height);
    
    self.player = [[YYMediaPlayer alloc] init];
    
    self.player.controller = self;
    self.player.view.frame = frame;
    self.player.view.clipsToBounds = YES;
    self.player.fullscreen = NO;
    
    self.player.platform = @"youku";
    
    //竖屏时露出状态栏
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 7) {
        CGRect bounds = self.view.frame;
        bounds.origin.y -= sheight;
        self.view.bounds = bounds;
    }
    
    [self.view addSubview:self.player.view];
    
    [self initViews];
    
    [self.player addEventsObserver:self];
    
    self.player.clientId = @"e7b7e2b85d590387";
    self.player.clientSecret = @"cc74658b2df9a05ffd257eed24c6f7ad";
    
    // 初始化播放器界面管理器
    _viewManager = [[YTEngineOpenViewManager alloc] initWithPlayer:self.player];
    _viewManager.controllerFrame = self.view.bounds;
    [self.player addEventsObserver:_viewManager];
    
    // youku
    // mv: XMzU0OTQ2MDUy 爱情公寓: XNDMzNDAzNjQw 老友记: XNTg5NTkxMzAw
    // 龙门镖局: XNTg5OTE4MDEy 琅琊榜第10集: XMTM0MzE3NTAyNA== 大好时光01: XMTM2MTIwODM4MA==
    
    // tudou
    // 学校2015第一集:TfNdUm9wxIE 异镇01:LavAOw4K2KA running man:3ATirEqDEh0 原创:caCSxH7sM7c
    // ugc:PmdB55l53v8
    
    // 播放视频
    NSString *vid = @"XMTYxMDM0NjM2OA";
    if (self.videoID.length>0) {
        vid=self.videoID;
    }
    
    if (!islocal) {
        [self.player playVid:vid quality:kYYVideoQualityFLV password:nil from:10];
    } else {
        if (self.videoItem) {
            [self.player playVideo:(id<YYMediaPlayerItem>)self.videoItem quality:kYYVideoQualityFLV from:0 oldEncrypt:NO];
        }
    }
    
    [self.navigationController.navigationBar setHidden:NO];
    [self.navigationController.navigationBar setTranslucent:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAllButUpsideDown;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)orien
{
    if (DEVICE_TYPE_IPAD) {
        if (orien == UIInterfaceOrientationPortrait || orien == UIInterfaceOrientationPortraitUpsideDown) {
            return NO;
        } else {
            return [self rotatePlayer:orien];
        }
    } else {
        if (orien == UIInterfaceOrientationPortraitUpsideDown) {
            return NO;
            
        } else {
            return [self rotatePlayer:orien];
        }
    }
}

- (BOOL)shouldAutorotate
{
    UIInterfaceOrientation orien = [self interfaceOrientation:[UIDevice currentDevice].orientation];
    return [self rotatePlayer:orien];
}

- (BOOL)rotatePlayer:(UIInterfaceOrientation)orien
{
    if (!DEVICE_TYPE_IPAD) {
        if (orien == UIInterfaceOrientationPortrait &&
            self.interfaceOrientation != orien) {
            [self.player setFullscreen:NO];
        } else if (UIInterfaceOrientationIsLandscape(orien)) {
            UIInterfaceOrientation corien = self.interfaceOrientation;
            if (!UIInterfaceOrientationIsLandscape(corien)) {
                [self.player setFullscreen:YES];
            }
        }
    }
    return YES;
}

- (NSInteger)interfaceOrientation:(UIDeviceOrientation)orien
{
    if (DEVICE_TYPE_IPAD) {
        switch (orien) {
            case UIDeviceOrientationLandscapeLeft:
                return UIInterfaceOrientationLandscapeRight;
            case UIDeviceOrientationLandscapeRight:
                return UIInterfaceOrientationLandscapeLeft;
            default:
                return -1;
        }
    } else {
        switch (orien) {
            case UIDeviceOrientationPortrait:
                return UIInterfaceOrientationPortrait;
            case UIDeviceOrientationLandscapeLeft:
                return UIInterfaceOrientationLandscapeRight;
            case UIDeviceOrientationLandscapeRight:
                return UIInterfaceOrientationLandscapeLeft;
            default:
                return -1;
        }
    }
}

- (void)initViews
{
    _backButton = [[UIButton alloc] init];
    UIImage *backImg = [UIImage imageNamed:@"back.png"];
    [_backButton setImage:backImg
                 forState:UIControlStateNormal];
    CGFloat h = ui_round_size(backImg.size.height);
    _backButton.bounds = CGRectMake(0, 0, BACK_WIDTH, h);
    _backButton.adjustsImageWhenHighlighted = NO;
    [_backButton addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    CGSize size = _backButton.bounds.size;
    _backButton.frame = CGRectMake(MARGIN, 0, size.width, size.height);
    [self.view addSubview:_backButton];
    
    // 返回错误码
    _textView = [[UITextView alloc] init];
    _textView.backgroundColor = [UIColor clearColor];
    _textView.textColor = [UIColor whiteColor];
    _textView.font = [UIFont systemFontOfSize:TEXTVIEW_FONT];
    _textView.editable = NO;
    _textView.userInteractionEnabled = NO;
    _textView.frame = CGRectMake(self.player.view.center.x - TEXTVIEW_WIDTH/2, self.player.view.center.y - TEXTVIEW_HEIGHT/2, TEXTVIEW_WIDTH, TEXTVIEW_HEIGHT);
    [_textView setTextAlignment:NSTextAlignmentCenter];
    [self.player.view addSubview:_textView];
}

- (void)back:(UIButton *)sender {
    if (self.player.fullscreen) {
        if (DEVICE_TYPE_IPAD) {
            [self.player setFullscreen:!self.player.fullscreen];
        } else {
            [self setNewOrientation:!self.player.fullscreen];
        }
    } else {
        [self.player removeEventsObserver:_viewManager];
        [self.player.controller.navigationController popViewControllerAnimated:YES];
        [self.player stop];
        [self.player deinit];
    }
}

- (void) leftBarItem_Click
{
    if (self.player.fullscreen) {
        if (DEVICE_TYPE_IPAD) {
            [self.player setFullscreen:!self.player.fullscreen];
        } else {
            [self setNewOrientation:!self.player.fullscreen];
        }
    } else {
        [self.player removeEventsObserver:_viewManager];
        [self.player.controller.navigationController popViewControllerAnimated:YES];
        [self.player stop];
        [self.player deinit];
    }
}

- (void)setNewOrientation:(BOOL)fullscreen
{
    UIDeviceOrientation lastDeviceOrien = [UIDevice currentDevice].orientation;
    UIDeviceOrientation deviceOiren = fullscreen ?
    UIDeviceOrientationLandscapeLeft : UIDeviceOrientationPortrait;
    
    if([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        [[UIDevice currentDevice] performSelector:@selector(setOrientation:)];
    }
    if (lastDeviceOrien == deviceOiren) {
        if ([[UIDevice currentDevice].systemVersion floatValue] >= 5.0) {
            [UIViewController attemptRotationToDeviceOrientation];
        }
    }
}

- (void)endPlayCode:(YYErrorCode)err
{
    NSString *tip;
    switch (err) {
        case YYPlayCompleted:
            tip = @"该视频已播放完成，点击重新播放";
            _textView.text = tip;
            break;
        case YYPlayCanceled:
            break;
        case YYErrorClientFormat:
            tip = [NSString stringWithFormat:@"client参数格式错误，错误码：%ld", (long)err];
            _textView.text = tip;
            break;
        case YYErrorInvalidClient:
            tip = [NSString stringWithFormat:@"client无效或sdk版本过低，错误码：%ld", (long)err];
            _textView.text = tip;
            break;
        case YYErrorPermissionDeny:
            tip = [NSString stringWithFormat:@"视频无权限播放，错误码：%ld", (long)err];
            _textView.text = tip;
            break;
        case YYErrorInitOpenView:
            tip = [NSString stringWithFormat:@"初始化界面无效，错误码：%ld", (long)err];
            _textView.text = tip;
            break;
        case YYDataSourceError:
            tip = [NSString stringWithFormat:@"媒体文件错误,错误码：%ld", (long)err];
            _textView.text = tip;
            break;
        case YYNetworkError:
            tip = [NSString stringWithFormat:@"网络连接超时，错误码：%ld, 点击重试", (long)err];
            _textView.text = tip;
            break;
        default:
            tip = [NSString stringWithFormat:@"播放发生错误，错误码：%ld, 点击重试", (long)err];
            _textView.text = tip;
            break;
    }
}

- (void)startPlay {
    if (_viewManager) {
        _textView.hidden = YES;
    }
}

@end
