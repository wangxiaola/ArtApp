//
//  MainViewController.m
//  AudioRecorder
//
//  Created by jeliu on 4/22/16.
//  Copyright © 2016 hz. All rights reserved.
//

#import "MainViewController.h"
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>
#import "UIView+Toast.h"

const static CGFloat kTimerElapse = 0.35;//s
const static CGFloat kMaxAudioDuration = 60;//s
const static CGFloat kMinAudioDuration = 5;//s
const static NSInteger kVoiceAnimationImageCount = 13;
const static CGFloat kToastDuration = 3;

@interface MainViewController ()<AVAudioRecorderDelegate, AVAudioPlayerDelegate>{
    double cccTime;
}
@property (weak, nonatomic) IBOutlet UIButton *recordButton;
@property (weak, nonatomic) IBOutlet UILabel *recordTipLabel;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton *okButton;

@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
@property (weak, nonatomic) IBOutlet UIImageView *indicatorImageView;
@property (weak, nonatomic) IBOutlet UIView *containerView;

@property (weak, nonatomic) IBOutlet UIView *recordResultContainerView;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (nonatomic) NSMutableArray *displayImages;
@property (nonatomic) NSTimer *timer;
@property (nonatomic) AVAudioPlayer *avAudioPlayer;
@end

@implementation MainViewController {
    AVAudioRecorder *_recorder;
    NSURL *_urlPlay;
    BOOL _recording;
    BOOL _playing;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"录音";
    [self setupImages];
    [self setupView];
    [self setupAudioRecoder];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self.navigationController.navigationBar setTranslucent:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.timer invalidate];
    self.timer = nil;
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.navigationController.navigationBar setTranslucent:NO];

}

- (void)setupView {
    self.indicatorImageView.hidden = YES;
    self.recordResultContainerView.hidden = YES;
    self.containerView.hidden = YES;
}

- (void)setupImages {
    self.displayImages = [NSMutableArray array];
    for (int index = 1; index <= kVoiceAnimationImageCount; ++ index) {
        NSString *fileName = [NSString stringWithFormat:@"录音中%d.png", index];
        UIImage *image = [UIImage imageNamed:fileName];
        if (image) {
            [self.displayImages addObject:image];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onCancel:(id)sender {
    if (_recording) {
        [self stopRecording:NO];
        [self deleteFile];
    } else {
        if (_playing) {
            [self.avAudioPlayer stop];
            [self.timer invalidate];
            self.timer = nil;
        }
        if (_urlPlay) {
            self.recordResultContainerView.hidden = NO;
            self.recordTipLabel.text = @"重新录音";
            self.containerView.hidden = NO;
        } else {
            self.recordTipLabel.text = @"点击录音";
            self.containerView.hidden = YES;
        }
        self.indicatorImageView.hidden = YES;
        [self.recordButton setImage:[UIImage imageNamed:@"开始录音.png"] forState:UIControlStateNormal];
        self.cancelButton.hidden = NO;
        [self.okButton setImage:[UIImage imageNamed:@"确定.png"] forState:UIControlStateNormal];
        
        if (_urlPlay) {
            [self deleteFile];
            self.containerView.hidden = YES;
            self.recordTipLabel.text = @"点击录音";
        } else {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

- (IBAction)onRecord:(id)sender {
    if (_playing) {
        [self.avAudioPlayer stop];
        [self.progressView setProgress:0];
        
        _playing = NO;
        [self.timer invalidate];
        self.timer = nil;
        [self stopRecording:NO];
        [self onRecord:nil];
        self.containerView.hidden = YES;
    } else if (_recording) {
        [self stopRecording:YES];
    } else {
        [self prepareAudioRecorder];
        if (_recorder) {
            _recorder.meteringEnabled = YES;
            [_recorder prepareToRecord];
            //开启音量检测
            _recorder.delegate = self;
            [_recorder record];
            self.indicatorImageView.hidden = NO;
            if (self.timer == nil) {
                self.timer = [NSTimer scheduledTimerWithTimeInterval:kTimerElapse target:self selector:@selector(onFire:) userInfo:nil repeats:YES];
            }
            _recording = YES;
            [self.recordButton setImage:[UIImage imageNamed:@"停止录音.png"] forState:UIControlStateNormal];
            [self.okButton setImage:[UIImage imageNamed:@"删除.png"] forState:UIControlStateNormal];
            self.cancelButton.hidden = YES;
            self.recordTipLabel.text = @"点击结束";
            self.recordResultContainerView.hidden = YES;
        }else{
            NSLog(@"音频格式和文件存储格式不匹配,无法初始化Recorder");
            
        }

    }
}

- (void)stopRecording:(BOOL)withToast {
    _recording = NO;
    [self.timer invalidate];
    self.timer = nil;
    double cTime = _recorder.currentTime;
    cccTime=cTime;
    NSLog(@"%lf", cTime);
    [_recorder stop];
    if (cTime < kMinAudioDuration && withToast) {
        [self.view makeToast:[NSString stringWithFormat:@"录音时长不能少于 %ld秒", (long)kMinAudioDuration] duration:kToastDuration position:CSToastPositionCenter];
        [self deleteFile];
    }
    if (_urlPlay) {
        self.recordResultContainerView.hidden = NO;
        self.timeLabel.text = [NSString stringWithFormat:@"%ld\"", (long)cTime];
        self.recordTipLabel.text = @"重新录音";
        self.containerView.hidden = NO;
    } else {
        self.recordTipLabel.text = @"点击录音";
        self.containerView.hidden = YES;
    }
    self.indicatorImageView.hidden = YES;
    [self.recordButton setImage:[UIImage imageNamed:@"开始录音.png"] forState:UIControlStateNormal];
    self.cancelButton.hidden = NO;
    [self.okButton setImage:[UIImage imageNamed:@"确定.png"] forState:UIControlStateNormal];
}

- (void)onFire:(NSTimer *)timer {
    [_recorder updateMeters];//刷新音量数据
    
    double lowPassResults = pow(10, (0.05 * [_recorder peakPowerForChannel:0]));;
    //NSLog(@"%lf",lowPassResults);
    CGFloat step = 1./kVoiceAnimationImageCount;
    NSInteger index = lowPassResults/step;
    if (index > kVoiceAnimationImageCount-1 || index < 0) {
        index = 0;
    }
    self.indicatorImageView.image = [self.displayImages objectAtIndex:index];
    
    double cTime = _recorder.currentTime;
    if (cTime > kMaxAudioDuration) {
        [self onRecord:nil];
    }
}

- (IBAction)onOK:(id)sender {
    if (_recording) {//delete
        [self stopRecording:NO];
        [self deleteFile];
        self.containerView.hidden = YES;
        self.recordTipLabel.text = @"点击录音";
    } else {
        NSString *title = nil;
        if (_urlPlay) {
            title = @"进入发布界面";
            if (self.btnRecorderCilck) {
                self.btnRecorderCilck(_urlPlay,cccTime);
            }
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            title = @"请先录音";
        }
        [self.view makeToast:title duration:kToastDuration position:CSToastPositionCenter];
    }
}

- (void)setupAudioRecoder {
    NSError * err = nil;
    
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory :AVAudioSessionCategoryPlayAndRecord error:&err];
    
    if(err){
        return;
    }
    
    [audioSession setActive:YES error:&err];
    
    err = nil;
    if(err){
        return;
    }
    //UInt32 doChangeDefault = 1;
    //AudioSessionSetProperty(kAudioSessionProperty_OverrideCategoryDefaultToSpeaker, sizeof(doChangeDefault), &doChangeDefault);
}

- (void)prepareAudioRecorder
{
    
    //录音设置
    NSMutableDictionary *recordSetting = [[NSMutableDictionary alloc] init];
    //设置录音格式  AVFormatIDKey==kAudioFormatLinearPCM
    [recordSetting setValue:[NSNumber numberWithInt:kAudioFormatMPEG4AAC] forKey:AVFormatIDKey];
    //设置录音采样率(Hz) 如：AVSampleRateKey==8000/44100/96000（影响音频的质量）
    [recordSetting setValue:[NSNumber numberWithFloat:44100] forKey:AVSampleRateKey];
    //录音通道数  1 或 2
    [recordSetting setValue:[NSNumber numberWithInt:1] forKey:AVNumberOfChannelsKey];
    //线性采样位数  8、16、24、32
    [recordSetting setValue:[NSNumber numberWithInt:16] forKey:AVLinearPCMBitDepthKey];
    //录音的质量
    [recordSetting setValue:[NSNumber numberWithInt:AVAudioQualityHigh] forKey:AVEncoderAudioQualityKey];
    
    //存储路径
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString* filePath =  [NSString stringWithFormat:@"%@/%@.aac", path, [self videoFileName]];
    NSURL *url = [NSURL fileURLWithPath:filePath];
    _urlPlay = url;
    
    NSError *error;
    //初始化
    _recorder = [[AVAudioRecorder alloc]initWithURL:url settings:recordSetting error:&error];
    
}

- (NSString *)videoFileName {
    return [[NSDate date] description];
}

- (void)deleteFile {
    if (_urlPlay) {
        NSFileManager *fileManager = [[NSFileManager alloc] init];
        NSError *error = nil;
        [fileManager removeItemAtURL:_urlPlay error:&error];
        _urlPlay = nil;
    }
}

- (IBAction)onPlay:(id)sender {
    if (_urlPlay != nil) {
        if (self.avAudioPlayer.playing) {
            [self.avAudioPlayer stop];
            return;
        }
        
        AVAudioPlayer *player = [[AVAudioPlayer alloc]initWithContentsOfURL:_urlPlay error:nil];
        self.avAudioPlayer = player;
        self.avAudioPlayer.volume = 1;
        self.avAudioPlayer.delegate = self;
        [self.avAudioPlayer play];
        self.containerView.hidden = NO;
        self.recordResultContainerView.hidden = YES;
        [self.progressView setProgress:0 animated:NO];
        self.timer = [NSTimer scheduledTimerWithTimeInterval:0.025 target:self selector:@selector(onPlaying:) userInfo:nil repeats:YES];
        _playing = YES;
    }
}

- (void)onPlaying:(NSTimer *)timer {
    CGFloat progress = self.avAudioPlayer.currentTime/self.avAudioPlayer.duration;
    [self.progressView setProgress:progress animated:YES];
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    [self.progressView setProgress:0 animated:NO];
    _playing = NO;
    [self.timer invalidate];
    self.timer = nil;
    self.recordResultContainerView.hidden = NO;
}

@end
