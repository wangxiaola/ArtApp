//
//  ZhuanjiaView.m
//  ShesheDa
//
//  Created by chen on 16/7/15.
//  Copyright © 2016年 上海翔汇网络有限公司. All rights reserved.
//

#import "ZhuanjiaView.h"
#import "ViewAudioShow.h"

@implementation ZhuanjiaView{
    UIImageView *imgHead;
    HLabel *lblName,*lblSubmit;
}

- (id)init{
    
    if ([super init]) {
        [self createView];
    }
    return self;
}

//初始化控件
- (void)createView{
    imgHead=[[UIImageView alloc]init];
    imgHead.backgroundColor=kClearColor;
    [self addSubview:imgHead];
    [imgHead mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(00);
        make.top.equalTo(self).offset(0);
//        make.right.equalTo(self).offset(-10);
        make.height.mas_equalTo(KKWidth(200));
        make.width.mas_equalTo(KKWidth(282));
    }];
    
    lblName=[[HLabel alloc]init];
    lblName.textColor=kTitleColor;
    lblName.font=kFont(14);
    lblName.textAlignment=NSTextAlignmentCenter;
    [self addSubview:lblName];
    [lblName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(imgHead.mas_bottom).offset(5);
    }];
    
    lblSubmit=[[HLabel alloc]init];
    lblSubmit.textColor=kTitleColor;
    lblSubmit.font=kFont(12);
    lblSubmit.textAlignment=NSTextAlignmentCenter;
    [self addSubview:lblSubmit];
    [lblSubmit mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(lblName.mas_bottom).offset(5);
    }];
}

- (void)setModel:(ExpertAppointmentZhuanjiaModel *)model{
    _model=model;
    [imgHead sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@!3b2",model.avatar]] placeholderImage:[UIImage imageNamed:@"temp_Default_headProtrait"]];
    lblName.text = model.username;
    lblSubmit.text = model.tag;
    NSArray *arrayAudio = model.audio;//[(HViewController *)self.containingViewController stringToJSON:model.audio];
    if (arrayAudio.count>0) {
        [self upDataAudio:arrayAudio];
    }
}

-(void)upDataAudio:(NSArray *)arrayAudio{
    
    ViewAudioShow *viewAudioDetailLast=nil;
    
    for (int i=0; i<arrayAudio.count; i++) {
        ExpertAppointmentAudioModel *modelAudioDetail=arrayAudio[i];
        NSMutableDictionary *dic=[[NSMutableDictionary alloc]init];
        [dic setObject:modelAudioDetail.url forKey:@"url"];
        [dic setObject:modelAudioDetail.duration forKey:@"duration"];
        ViewAudioShow *viewAudioShowDetail=[[ViewAudioShow alloc]init];
        viewAudioShowDetail.dic=dic;
        viewAudioShowDetail.strName=_model.username;
        [self addSubview:viewAudioShowDetail];
        [viewAudioShowDetail mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(10);
            make.right.equalTo(self).offset(-10);
            make.top.equalTo(self).offset(kScreenW/2+50+(i*50));
            make.height.mas_equalTo(40);
        }];
        viewAudioDetailLast=viewAudioShowDetail;
    }
    
//    [self mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(viewAudioDetailLast).offset(10);
//    }];
}

@end
