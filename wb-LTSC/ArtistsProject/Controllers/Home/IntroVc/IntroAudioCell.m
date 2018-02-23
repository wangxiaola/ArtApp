//
//  IntroAudioCell.m
//  ArtistProject
//
//  Created by HELLO WORLD on 2017/3/28.
//  Copyright © 2017年 HELLO WORLD. All rights reserved.
//

#import "IntroAudioCell.h"
#import <AVFoundation/AVFoundation.h>

@interface IntroAudioCell ()<AVAudioPlayerDelegate>
{
    UIImageView* btnPalyer;
    UILabel* lblTitle;
    UILabel* lblSecond;
    
    
    BOOL isSanemSelect;
}
@property(nonatomic,strong)UIImageView* baseImg;
@property(nonatomic,strong)NSMutableDictionary* audioDic;
@property(nonatomic)AVAudioPlayer *player;
@property (nonatomic,strong) AVAudioPlayer *audioPlayer;//音频播放控制器

@property (strong, nonatomic)NSString *recordFileName;
@property (strong, nonatomic)NSString *recordFilePath;
@end

@implementation IntroAudioCell

- (void)addContentViews
{
    _baseImg = [[UIImageView alloc]init];
    _baseImg.backgroundColor = [UIColor whiteColor];
    _baseImg.layer.borderWidth = 1;
    _baseImg.layer.borderColor = [RGB(225, 225, 225) CGColor];
    [self.contentView addSubview:_baseImg];
    [_baseImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView).with.insets(UIEdgeInsetsMake(15, 5, 5, 5));
    }];
    btnPalyer=[[UIImageView alloc]init];
    btnPalyer.animationImages = [NSArray arrayWithObjects:
                               [UIImage imageNamed:@"icon_user_audio1"],
                               [UIImage imageNamed:@"icon_user_audio2"],
                               [UIImage imageNamed:@"icon_user_audio3"], nil];
    btnPalyer.animationDuration = 1.0;
    btnPalyer.image=[UIImage imageNamed:@"icon_user_audio3"];
    btnPalyer.animationRepeatCount = 0;
    [_baseImg addSubview:btnPalyer];
    [btnPalyer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_baseImg).offset(KKWidth(17));
        make.centerY.equalTo(_baseImg);
        make.height.mas_equalTo(KKWidth(33));
        make.width.mas_equalTo(KKWidth(22));
    }];
    
    lblTitle=[[UILabel alloc]init];
    lblTitle.textColor=ColorHex(@"2e2e2e");
    lblTitle.font=ART_FONT(ARTFONT_OE);
    [_baseImg addSubview:lblTitle];
    [lblTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_baseImg);
        make.left.equalTo(btnPalyer.mas_right).offset(KKWidth(30));
    }];
    
    lblSecond=[[UILabel alloc]init];
    lblSecond.textColor=kSubTitleColor;
    lblSecond.font=ART_FONT(ARTFONT_OZ);
    lblSecond.textAlignment=NSTextAlignmentRight;
    [_baseImg addSubview:lblSecond];
    [lblSecond mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_baseImg);
        make.right.equalTo(_baseImg).offset(-10);
        make.left.equalTo(lblTitle.mas_right);
    }];
    
    UITapGestureRecognizer *tapSelf=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapself_Click)];
    _baseImg.userInteractionEnabled=YES;
    [_baseImg addGestureRecognizer:tapSelf];
    
    _audioDic = [[NSMutableDictionary alloc]init];
    
    [self setupAudioRecoder];
}
-(void)setArtTableViewCellDicValue:(NSDictionary *)dic name:(NSString *)userName{
    [_audioDic removeAllObjects];
    [_audioDic addEntriesFromDictionary:dic];
    float dicWidth=[[dic objectForKey:@"duration"] floatValue];
    if (dicWidth>0&&dicWidth<200) {
        lblSecond.text=[NSString stringWithFormat:@"%.1f'",[[dic objectForKey:@"duration"] floatValue]];
    }
    
    lblTitle.text=[NSString stringWithFormat:@"%@语音",userName];
    //播放网络音频
    NSString* urlStr = [_audioDic objectForKey:@"url"];
    if([urlStr hasSuffix:@".amr"]){
        //存储路径
        NSString* filePath = [ArtUIHelper GetPathByFileName:self.recordFileName ofType:@"wav"];
        
        NSFileManager *fm=[NSFileManager defaultManager];
        //在指定的路径下创建文件
        NSURL *fileUrl=[NSURL URLWithString:urlStr];
        [fm createFileAtPath:filePath contents:[NSData dataWithContentsOfURL:fileUrl] attributes:nil];
        
        NSDate *date = [NSDate date];
        //根据当前时间生成文件名
        self.recordFileName = [ArtUIHelper GetCurrentTimeString];
        //获取路径
        self.recordFilePath = [ArtUIHelper GetPathByFileName:self.recordFileName ofType:@"wav"];
        
         NSString *amrPath = [ArtUIHelper GetPathByFileName:self.recordFileName ofType:@"amr"];
        NSString *convertedPath = [ArtUIHelper GetPathByFileName:[self.recordFileName stringByAppendingString:@"_AmrToWav"] ofType:@"wav"];
        
        if ([VoiceConverter ConvertAmrToWav:amrPath wavSavePath:convertedPath]){
            NSString* resultStr = [NSString stringWithFormat:@"amr转wav:\n%@",[ArtUIHelper getVoiceFileInfoByPath:convertedPath convertTime:[[NSDate date] timeIntervalSinceDate:date]]];
            ARTLog(@"resultStr==%@",resultStr);
            
             NSError *error=nil;
            _audioPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:[NSURL URLWithString:filePath] error:&error];
            if(error){
                ARTLog(@"创建播放器过程中发生错误，错误信息：%@",error.localizedDescription);
            }
            _audioPlayer.volume = 0.5;
            [_audioPlayer prepareToPlay];
            _audioPlayer.numberOfLoops = 0;
            _audioPlayer.delegate = self;
            [_audioPlayer play];
        }else{
            NSLog(@"amr转wav失败");
        }
        
        
        
        
        
        
        
        
        ARTLog(@"是.amr");
    }else if([urlStr hasSuffix:@".mp3"]){
        
        ARTLog(@"是.mp3");
        NSURL * url  = [NSURL URLWithString:urlStr];
        _player = [[AVAudioPlayer alloc]initWithData:[NSData dataWithContentsOfURL:url] error:nil];
        _player.delegate = self;
        _player.volume =0.8;
    }
}
- (NSString *)videoFileName {
    return [[NSDate date] description];
}
-(void)tapself_Click{
    
    if ([btnPalyer isAnimating]) {//判断iv 的动画状态
        [btnPalyer stopAnimating];//结束动画
        [_player stop];
        [[UIDevice currentDevice] setProximityMonitoringEnabled:NO];
        
    }else{
        [[UIDevice currentDevice] setProximityMonitoringEnabled:YES];
        [btnPalyer startAnimating];//开始动画
        [self.player play];
        _player.currentTime =0;
        
    }
}

//播放完成

-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    [btnPalyer stopAnimating];
    [_player stop];
    [[UIDevice currentDevice] setProximityMonitoringEnabled:NO];
    
}
- (void)setupAudioRecoder {
    NSError * err = nil;
    
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory :AVAudioSessionCategoryPlayAndRecord error:&err];
    //默认情况下扬声器播放
    [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
    
    //建议播放之前设置yes，播放结束设置no，这个功能是开启红外感应
    [[UIDevice currentDevice] setProximityMonitoringEnabled:YES];
    //添加监听
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(sensorStateChange:)
                                                 name:@"UIDeviceProximityStateDidChangeNotification"
                                               object:nil];
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
-(void)sensorStateChange:(NSNotificationCenter *)notification;
{
    //如果此时手机靠近面部放在耳朵旁，那么声音将通过听筒输出，并将屏幕变暗（省电啊）
    if ([[UIDevice currentDevice] proximityState] == YES)
    {
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    }
    else
    {
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    }
}
@end
