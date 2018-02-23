//
//  ViewAudioShow.m
//  ShesheDa
//
//  Created by chen on 16/7/14.
//  Copyright © 2016年 上海翔汇网络有限公司. All rights reserved.
//

#import "ViewAudioShow.h"

@implementation ViewAudioShow{
    HLabel *lblSecond;
    HLabel *lblTitle;
    AVPlayer *player;
    UIImageView *btnPalyer;
    BOOL isSanemSelect;
}

- (id)init{
    
    if ([super init]) {
        [self createView];
        self.backgroundColor=[UIColor colorWithHexString:@"f6f6f6" alpha:0.3];
        self.layer.borderWidth=1;
        self.layer.borderColor=kLineColor.CGColor;
        self.layer.masksToBounds=YES;
        self.layer.cornerRadius=3;
    }
    return self;
}

//初始化控件
- (void)createView{
    btnPalyer=[[UIImageView alloc]init];
    btnPalyer.animationImages=[NSArray arrayWithObjects:
                               [UIImage imageNamed:@"icon_user_audio1"],
                               [UIImage imageNamed:@"icon_user_audio2"],
                               [UIImage imageNamed:@"icon_user_audio3"], nil];
    btnPalyer.animationDuration = 1.0;
    btnPalyer.image=[UIImage imageNamed:@"icon_user_audio3"];
    btnPalyer.animationRepeatCount = 0;
    [self addSubview:btnPalyer];
    [btnPalyer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(KKWidth(17));
        make.centerY.equalTo(self);
        make.height.mas_equalTo(KKWidth(33));
        make.width.mas_equalTo(KKWidth(22));
    }];

    
    lblTitle=[[HLabel alloc]init];
    lblTitle.textColor=ColorHex(@"2e2e2e");
    lblTitle.font=kFont(18);
    [self addSubview:lblTitle];
    [lblTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(btnPalyer.mas_right).offset(KKWidth(30));
    }];

    lblSecond=[[HLabel alloc]init];
    lblSecond.textColor=kSubTitleColor;
    lblSecond.font=kFont(11);
    lblSecond.textAlignment=NSTextAlignmentRight;
    [self addSubview:lblSecond];
    [lblSecond mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.equalTo(self).offset(-10);
        make.left.equalTo(lblTitle.mas_right);
    }];
    
    UITapGestureRecognizer *tapSelf=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapself_Click)];
    self.userInteractionEnabled=YES;
    [self addGestureRecognizer:tapSelf];
}

-(void)tapself_Click{
    self.userInteractionEnabled=NO;
    
    NSURL * url  = [NSURL URLWithString:[_dic objectForKey:@"url"]];
    AVPlayerItem * songItem = [[AVPlayerItem alloc]initWithURL:url];
    player = [[AVPlayer alloc]initWithPlayerItem:songItem];
    [songItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackFinished:) name:AVPlayerItemDidPlayToEndTimeNotification object:songItem];
}

- (void)playbackFinished:(NSNotification *)notice {
    isSanemSelect=NO;
    [btnPalyer stopAnimating];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary*)change context:(void *)context {
    
    
    if ([keyPath isEqualToString:@"status"]) {
        switch (player.status) {
            case AVPlayerStatusUnknown:
                //                BASE_INFO_FUN(@"KVO：未知状态，此时不能播放");
                NSLog(@"不能播放");
                break;
            case AVPlayerStatusReadyToPlay:
                //                self.status = SUPlayStatusReadyToPlay;
                //                BASE_INFO_FUN(@"KVO：准备完毕，可以播放");
                NSLog(@"可以播放");
                self.userInteractionEnabled=YES;
                if (isSanemSelect) {
                    
                    [player pause];
                    [object removeObserver:self forKeyPath:@"status"];
                    [btnPalyer stopAnimating];
                    isSanemSelect=NO;
                }else{
                    [player play];
                    [btnPalyer startAnimating];
                    isSanemSelect=YES;
                    [object removeObserver:self forKeyPath:@"status"];
                }
                break;
            case AVPlayerStatusFailed:
                //                BASE_INFO_FUN(@"KVO：加载失败，网络或者服务器出现问题");
                NSLog(@"播放出现问题");
                break;
            default:
                break;
        }
    }
}

-(void)setDic:(NSMutableDictionary *)dic{
    _dic=dic;
    float dicWidth=[[dic objectForKey:@"duration"] floatValue];
    if (dicWidth>0&&dicWidth<200) {
        lblSecond.text=[NSString stringWithFormat:@"%.1f'",[[dic objectForKey:@"duration"] floatValue]];
    }
}

-(void)setStrName:(NSString *)strName{
    lblTitle.text=[NSString stringWithFormat:@"%@语音",strName];
}

@end
