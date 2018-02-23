//
//  ListShowView.m
//  ShesheDa
//
//  Created by chen on 16/7/8.
//  Copyright © 2016年 上海翔汇网络有限公司. All rights reserved.
//

#import "ListShowView.h"

@implementation ListShowView{
    NSMutableArray *array;
}

-(id)init{
    if (self=[super init]) {
        [self customInit];
    }
    return self;
}

- (void) customInit
{
    self.backgroundColor=[UIColor whiteColor];
    array=[[NSMutableArray alloc]init];
}

-(void)addAudio:(NSDictionary *)dic{
//    if (array.count==0) {
        HButton *btnPalyer=[[HButton alloc]init];
        [btnPalyer setImage:[UIImage imageNamed:@"icon_userinfo_addaudio"] forState:UIControlStateNormal];
        [btnPalyer addTarget:self action:@selector(btnPlayer_Click:) forControlEvents:UIControlEventTouchUpInside];
        btnPalyer.tag=0;
        [self addSubview:btnPalyer];
        [btnPalyer mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(10);
            make.top.equalTo(self).offset(40*array.count);
            make.width.height.mas_equalTo(40);
        }];
    
    HLabel *lblTitle=[[HLabel alloc]init];
    lblTitle.text=[NSString stringWithFormat:@"音频%lu",(unsigned long)array.count+1];
//    }
    [array addObject:dic];
}

-(void)btnPlayer_Click:(HButton *)btnClick{
    NSDictionary *dic=array[btnClick.tag];
    NSString *strUrl=[dic objectForKey:@"url"];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kMutAPIDomain,strUrl]];
    
    NSData * audioData = [NSData dataWithContentsOfURL:url];
    AVAudioPlayer *player = [[AVAudioPlayer alloc] initWithData:audioData error:nil];//使用NSData创建
    player.volume = 1.0f;
    [player play];
}

-(NSMutableArray *)arrayList{
    return [array mutableCopy];
}

@end
