//
//  WorksFirstCell.m
//  ArtistProject
//
//  Created by HELLO WORLD on 2017/3/29.
//  Copyright © 2017年 HELLO WORLD. All rights reserved.
//

#import "WorksFirstCell.h"
#import "ArtShareView.h"

@interface WorksFirstCell ()
{
    shareModel* model;
}
@property(nonatomic,strong)UIImageView* baseImage;
@property(nonatomic,strong)UILabel * titleLabel;
@property(nonatomic,strong)UILabel * subLabel;
@property(nonatomic,strong)UILabel * timeLabel;
@property(nonatomic,strong)UILabel * numsLabel;
@property(nonatomic,strong)UIButton * seeNums;
@end
@implementation WorksFirstCell

-(void)addContentViews{
    _baseImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.bounds.size.height-10)];
    _baseImage.userInteractionEnabled = YES;
    [self.contentView addSubview:_baseImage];
    
    UIImageView* zhezhaocheng = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.bounds.size.height-10)];
    zhezhaocheng.userInteractionEnabled = YES;
    [zhezhaocheng setImage:[UIImage imageNamed:@"zhezhaocheng"]];
    [self.contentView addSubview:zhezhaocheng];
    
    _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(T_WIDTH(15), T_WIDTH(115),SCREEN_WIDTH- T_WIDTH(30),T_WIDTH(20))];
    _titleLabel.textColor = [UIColor whiteColor];
    _titleLabel.textAlignment = NSTextAlignmentLeft;
    _titleLabel.font = ART_FONT(ARTFONT_TT);
    [self.contentView addSubview:_titleLabel];
    
    _subLabel = [[UILabel alloc]initWithFrame:CGRectMake(T_WIDTH(17), getViewHeight(_titleLabel)+T_WIDTH(7), T_WIDTH(200),T_WIDTH(15))];
    _subLabel.textColor = [UIColor whiteColor];
    _subLabel.textAlignment = NSTextAlignmentLeft;
    _subLabel.font = ART_FONT(ARTFONT_OT);
    [self.contentView addSubview:_subLabel];
    
    UIImageView* line = [[UIImageView alloc]initWithFrame:CGRectMake(T_WIDTH(15), getViewHeight(_subLabel)+T_WIDTH(15),SCREEN_WIDTH-T_WIDTH(30),Art_Line_HEIGHT)];
    line.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:line];
    
    _timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(T_WIDTH(15), getViewHeight(line)+T_WIDTH(10), T_WIDTH(80),T_WIDTH(20))];
    _timeLabel.textColor = [UIColor whiteColor];
    _timeLabel.textAlignment = NSTextAlignmentLeft;
    _timeLabel.font = ART_FONT(ARTFONT_OT);
    [self.contentView addSubview:_timeLabel];
    
    _numsLabel = [[UILabel alloc]initWithFrame:CGRectMake(getViewWidth(_timeLabel)+T_WIDTH(10), getViewHeight(line)+T_WIDTH(10), T_WIDTH(120),T_WIDTH(20))];
    _numsLabel.textColor = [UIColor whiteColor];
    _numsLabel.textAlignment = NSTextAlignmentLeft;
    _numsLabel.font = ART_FONT(ARTFONT_OT);
    [self.contentView addSubview:_numsLabel];
    
//    _seeNums = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-T_WIDTH(120), getViewHeight(line)+T_WIDTH(10), T_WIDTH(105),T_WIDTH(20))];
//    _seeNums.textColor = [UIColor whiteColor];
//    _seeNums.textAlignment = NSTextAlignmentRight;
//    _seeNums.font = ART_FONT(ARTFONT_OT);
//    [self.contentView addSubview:_seeNums];
    
        _seeNums = [UIButton buttonWithType:UIButtonTypeCustom];
        _seeNums.frame = CGRectMake(SCREEN_WIDTH-65, getViewHeight(line)+T_WIDTH(15), 50,20);
        [_seeNums setImage:[UIImage imageNamed:@"ShareBtn"] forState:UIControlStateNormal];
        [_seeNums addTarget:self action:@selector(btnEdit_Click) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_seeNums];

}
-(void)setArtTableViewCellDicValue:(NSDictionary *)dic{
    
    model = [shareModel mj_objectWithKeyValues:dic];
    
    if(([dic[@"name"] rangeOfString:@"|"].location!=NSNotFound)){
        _titleLabel.text = [NSString stringWithFormat:@"%@",[dic[@"name"] componentsSeparatedByString:@"|"][0]];
        NSString* subtitle = [NSString stringWithFormat:@"%@",[dic[@"name"] componentsSeparatedByString:@"|"][1]];
        if (subtitle.length>0) {
            _subLabel.text = subtitle;
        }
    }else{
       _titleLabel.text = [NSString stringWithFormat:@"%@",dic[@"name"]];
    }

    NSMutableString* timeStr = [[NSMutableString alloc]init];
    NSString* minStr = [NSString stringWithFormat:@"%@",dic[@"minage"]];
    NSString* maxStr = [NSString stringWithFormat:@"%@",dic[@"maxage"]];
    if (minStr.length>0) {
        [timeStr appendString:minStr];
    }
    if (maxStr.length>0) {
        [timeStr appendFormat:@"-%@",maxStr];
    }
        _timeLabel.text = timeStr;
        _numsLabel.text = [NSString stringWithFormat:@"共%@件",dic[@"count"]];
        //_seeNums.text = [NSString stringWithFormat:@"阅读%@",dic[@"allnum"]];
    
    
        [_baseImage sd_setImageWithUrlStr:[NSString stringWithFormat:@"%@!3b2",dic[@"cover"]] tempTmage:@"icon_Default_Product.png"];
}
-(void)btnEdit_Click{
    
    ArtShareView *shareVc = [[ArtShareView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH)];
    shareVc.shareimage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:model.cover]]];
    shareVc.sharetitle=[NSString stringWithFormat:@"《%@》",model.name];
    shareVc.sharedes=@" ";
    shareVc.shareurl=model.weburl;
    shareVc.deleteEdit = YES;
    [shareVc showShareView];
}
@end
