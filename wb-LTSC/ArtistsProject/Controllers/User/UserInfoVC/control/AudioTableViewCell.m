//
//  AudioTableViewCell.m
//  ShesheDa
//
//  Created by chen on 16/7/8.
//  Copyright © 2016年 上海翔汇网络有限公司. All rights reserved.
//

#import "AudioTableViewCell.h"

@implementation AudioTableViewCell {
    HLabel* lblTime;
}
@synthesize lblTitle, btnPalyer;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createView];
    }
    return self;
}
- (void)createView
{
    HView* viewBG = [[HView alloc] init];
    viewBG.backgroundColor = ColorHex(@"f6f6f6");
    viewBG.layer.cornerRadius = 3;
    viewBG.layer.borderColor = kLineColor.CGColor;
    viewBG.layer.borderWidth = 1;
    viewBG.layer.masksToBounds = YES;
    [self addSubview:viewBG];
    [viewBG mas_makeConstraints:^(MASConstraintMaker* make) {
        //        make.center.equalTo(self);
        //make.right.mas_equalTo(KKWidth(400));
        make.left.equalTo(self).offset(KKWidth(30));
        make.right.equalTo(self).offset(-KKWidth(80));
        make.height.mas_equalTo(40);
    }];

    btnPalyer = [[UIImageView alloc] init];
    btnPalyer.animationImages = [NSArray arrayWithObjects:
                                             [UIImage imageNamed:@"icon_user_audio1"],
                                         [UIImage imageNamed:@"icon_user_audio2"],
                                         [UIImage imageNamed:@"icon_user_audio3"], nil];
    btnPalyer.animationDuration = 1.0;
    btnPalyer.image = [UIImage imageNamed:@"icon_user_audio3"];
    btnPalyer.animationRepeatCount = 0;
    [viewBG addSubview:btnPalyer];
    [btnPalyer mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.equalTo(viewBG).offset(10);
        make.centerY.equalTo(viewBG);
        make.width.mas_equalTo(KKWidth(34));
        make.height.mas_equalTo(KKWidth(51));
    }];

    lblTitle = [[HLabel alloc] init];
    lblTitle.textColor = kTitleColor;
    lblTitle.font = kFont(15);
    [viewBG addSubview:lblTitle];
    [lblTitle mas_makeConstraints:^(MASConstraintMaker* make) {
        make.centerY.equalTo(viewBG);
        make.left.equalTo(btnPalyer.mas_right).offset(10);
    }];

    lblTime = [[HLabel alloc] init];
    lblTime.textColor = kTitleColor;
    lblTime.font = kFont(15);
    [viewBG addSubview:lblTime];
    [lblTime mas_makeConstraints:^(MASConstraintMaker* make) {
        make.centerY.equalTo(viewBG);
        make.right.equalTo(viewBG).offset(-5);
    }];

    
    UIButton* btnRecord = [[UIButton alloc] init];
    [btnRecord setImage:[UIImage imageNamed:@"icon_del"] forState:UIControlStateNormal];
    [btnRecord setTitleColor:kTitleColor forState:UIControlStateNormal];
    btnRecord.titleLabel.font = kFont(15); //[[Global sharedInstance]fontWithSize:15];
    [btnRecord addTarget:self action:@selector(btnRecord_Click) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btnRecord];
    [btnRecord mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.equalTo(viewBG).offset(10);
        make.left.equalTo(self).offset(KKWidth(570));
        make.height.width.width.mas_equalTo(20);
    }];
}

- (void)btnRecord_Click
{
    if (self.btndelBlock) {
        self.btndelBlock();
    }
}

- (void)stateBofang
{
    [btnPalyer startAnimating];
}
- (void)endBofang
{
    [btnPalyer stopAnimating];
    btnPalyer.image = [UIImage imageNamed:@"icon_user_audio3"];
}

- (void)btnPlayer_Click:(HButton*)btnClick
{
    //    NSDictionary *dic=array[btnClick.tag];
    //    NSString *strUrl=[dic objectForKey:@"url"];
    //    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kMutAPIDomain,strUrl]];
    //
    //    NSData * audioData = [NSData dataWithContentsOfURL:url];
    //    AVAudioPlayer *player = [[AVAudio   Player alloc] initWithData:audioData error:nil];//使用NSData创建
    //    player.volume = 1.0f;
    //    [player play];
}

- (void)setDic:(NSDictionary*)dic
{
    _dic = dic;
    lblTime.text = [NSString stringWithFormat:@"%.01f'", [[dic objectForKey:@"duration"] floatValue]];
}

- (void)setName:(NSString*)name
{
    _name = name;
    lblTitle.text = [NSString stringWithFormat:@"%@语音", name];
}

@end
