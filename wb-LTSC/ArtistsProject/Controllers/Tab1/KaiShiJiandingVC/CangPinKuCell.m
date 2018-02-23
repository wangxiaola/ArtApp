//
//  CangPinKuCell.m
//  ShesheDa
//
//  Created by chen on 16/7/30.
//  Copyright © 2016年 上海翔汇网络有限公司. All rights reserved.
//

#import "CangPinKuCell.h"

@implementation CangPinKuCell{
    UIImageView *imgTitle;
    HLabel *lblTitle;
}

-(id) initWithFrame:(CGRect)frame
{
    if (self=[super initWithFrame:frame]){
        [self createView];
    }
    return self;
}
- (void) createView
{
    imgTitle=[[UIImageView alloc]init];
    [self addSubview:imgTitle];
    [imgTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self);
        make.width.height.mas_equalTo((kScreenW-30)/2);
    }];
    
    lblTitle=[[HLabel alloc]init];
    lblTitle.textColor=kTitleColor;
    lblTitle.font=kFont(15);
    lblTitle.numberOfLines=2;
    lblTitle.textAlignment=NSTextAlignmentCenter;
    [self addSubview:lblTitle];
    [lblTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.equalTo(imgTitle);
        make.top.equalTo(imgTitle.mas_bottom);
        make.height.mas_equalTo(40);
    }];
}

-(void)setModel:(CangyouQuanDetailModel *)model{
    _model=model;
    NSArray *arrayPhoto=[model.photos componentsSeparatedByString:@","];
    if (arrayPhoto.count>0) {
        [imgTitle sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@!450a",arrayPhoto[0]]] placeholderImage:[UIImage imageNamed:@"icon_Default_Product"]];
    }
    NSString *strCangpinResult=@"";
    
    switch (model.status.intValue) {
        case 1:{
            strCangpinResult=@"真";
        }break;
        case 2:{
            strCangpinResult=@"假";
        }break;
        case 3:{
            strCangpinResult=@"无法鉴定";
        }break;
        case 4:{
            strCangpinResult=@"未鉴定";
        }break;
        default:
            break;
    }
    lblTitle.text=[NSString stringWithFormat:@"%@-%@",model.topictitle,strCangpinResult];
}


@end
