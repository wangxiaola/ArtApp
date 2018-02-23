//
//  IntroHeadCell.m
//  ArtistProject
//
//  Created by HELLO WORLD on 2017/3/28.
//  Copyright © 2017年 HELLO WORLD. All rights reserved.
//

#import "IntroHeadCell.h"

@interface IntroHeadCell ()
@property(nonatomic,strong)UIImageView* baseImage;
@property(nonatomic,strong)UILabel * titleLabel;
@property(nonatomic,strong)UILabel * subLabel;
@property(nonatomic,strong)UILabel * timeLabel;
@property(nonatomic,strong)UILabel * numsLabel;
@property(nonatomic,strong)UILabel * seeNums;
@end

@implementation IntroHeadCell

-(void)addContentViews{
    self.contentView.backgroundColor = BACK_CELL_COLOR;
    _baseImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 10, SCREEN_WIDTH, self.bounds.size.height-10)];
    _baseImage.userInteractionEnabled = YES;
    [self.contentView addSubview:_baseImage];
    
    UIImageView* zhezhaocheng = [[UIImageView alloc]initWithFrame:CGRectMake(0, 10, SCREEN_WIDTH, self.bounds.size.height-10)];
    zhezhaocheng.userInteractionEnabled = YES;
    [zhezhaocheng setImage:[UIImage imageNamed:@"zhezhaocheng"]];
    [self.contentView addSubview:zhezhaocheng];
    
    _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, T_WIDTH(70), T_WIDTH(100),22)];
    _titleLabel.textColor = [UIColor whiteColor];
    _titleLabel.textAlignment = NSTextAlignmentLeft;
    _titleLabel.font = ART_FONT(ARTFONT_TT);
    [self.contentView addSubview:_titleLabel];
    
    _subLabel = [[UILabel alloc]initWithFrame:CGRectMake(getViewWidth(_titleLabel)+10, getViewHeight(_titleLabel)-12, T_WIDTH(200),12)];
    _subLabel.textColor = [UIColor whiteColor];
    _subLabel.textAlignment = NSTextAlignmentLeft;
    _subLabel.font = ART_FONT(ARTFONT_OT);
    [self.contentView addSubview:_subLabel];
    
    UIImageView* line = [[UIImageView alloc]initWithFrame:CGRectMake(15, getViewHeight(_titleLabel)+T_WIDTH(25),SCREEN_WIDTH-T_WIDTH(30),Art_Line_HEIGHT)];
    line.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:line];
    
    _timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, getViewHeight(line)+T_WIDTH(10), T_WIDTH(80),T_WIDTH(20))];
    _timeLabel.textColor = [UIColor whiteColor];
    _timeLabel.textAlignment = NSTextAlignmentLeft;
    _timeLabel.font =ART_FONT(ARTFONT_OT); 
    [self.contentView addSubview:_timeLabel];
    
    _numsLabel = [[UILabel alloc]initWithFrame:CGRectMake(getViewWidth(_timeLabel)+T_WIDTH(10), getViewHeight(line)+T_WIDTH(10), T_WIDTH(120),T_WIDTH(20))];
    _numsLabel.textColor = [UIColor whiteColor];
    _numsLabel.textAlignment = NSTextAlignmentLeft;
    _numsLabel.font = ART_FONT(ARTFONT_OT);
    [self.contentView addSubview:_numsLabel];
    
    _seeNums = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-T_WIDTH(120), getViewHeight(line)+T_WIDTH(10), T_WIDTH(105),T_WIDTH(20))];
    _seeNums.textColor = [UIColor whiteColor];
    _seeNums.textAlignment = NSTextAlignmentRight;
    _seeNums.font = ART_FONT(ARTFONT_OT);
    [self.contentView addSubview:_seeNums];
}
//简介
-(void)setArtTableViewHeadCellDicValue:(NSDictionary *)dic andTitle:(NSString*)title subTitle:(NSString *)subtitle{
    
    NSArray* arrayYuanlai = [dic[@"photos"] componentsSeparatedByString:@","];
    if (arrayYuanlai.count>0) {
        NSString* imgUrl = arrayYuanlai[0];
        [_baseImage sd_setImageWithUrlStr:[NSString stringWithFormat:@"%@!3b2",imgUrl] tempTmage:@"icon_Default_Product.png"];
    }

     _titleLabel.text = title;
    CGSize maximumLabelSize = CGSizeMake(T_WIDTH(100), 22);//labelsize的最大值
    CGSize expectSize = [_titleLabel sizeThatFits:maximumLabelSize];
    
    _titleLabel.frame =CGRectMake(15, T_WIDTH(70), expectSize.width, 22);
     _subLabel.frame = CGRectMake(getViewWidth(_titleLabel)+10, getViewHeight(_titleLabel)-12, T_WIDTH(200),12);
    
    _subLabel.text = subtitle;
    
    NSString* minageStr = [NSString stringWithFormat:@"%@",dic[@"minage"]];
    NSString* maxageStr = [NSString stringWithFormat:@"%@",dic[@"maxage"]];
     NSString* timeStr =   [ArtUIHelper returnTimeStrWithMin:minageStr Max:maxageStr];
    if (timeStr.length>0) {
        _timeLabel.text = timeStr;
    }
                           
    
    _numsLabel.text = [NSString stringWithFormat:@"共%@篇",dic[@"count"]];
    _seeNums.text = [NSString stringWithFormat:@"查看%@",dic[@"allnum"]];
    [_baseImage sd_setImageWithUrlStr:[NSString stringWithFormat:@"%@!2b1",dic[@"photo"]] tempTmage:@"icon_Default_Product.png"];
}

//文字
-(void)setArtTableViewHeadCellDicValue:(NSDictionary *)dic{
   
    NSArray* arrayYuanlai = [dic[@"photos"] componentsSeparatedByString:@","];
    if (arrayYuanlai.count>0) {
        NSString* imgUrl = arrayYuanlai[0];
        [_baseImage sd_setImageWithUrlStr:[NSString stringWithFormat:@"%@!3b2",imgUrl] tempTmage:@"icon_Default_Product.png"];
      
        
    }
    
    if(([dic[@"title"] rangeOfString:@"|"].location!=NSNotFound)){
        _titleLabel.text = [NSString stringWithFormat:@"%@",[dic[@"title"] componentsSeparatedByString:@"|"][0]];
        NSString* subtitle = [NSString stringWithFormat:@"%@",[dic[@"title"] componentsSeparatedByString:@"|"][1]];
        if (subtitle.length>0) {
        _subLabel.text = subtitle;
        }
        CGSize maximumLabelSize = CGSizeMake(T_WIDTH(100), T_WIDTH(23));//labelsize的最大值
        CGSize expectSize = [_titleLabel sizeThatFits:maximumLabelSize];
        _titleLabel.frame =CGRectMake(15, T_WIDTH(70), expectSize.width,22);
        
        _subLabel.frame = CGRectMake(getViewWidth(_titleLabel)+10, getViewHeight(_titleLabel)-12, T_WIDTH(200),12);
    }else{
        _titleLabel.text = [NSString stringWithFormat:@"%@",dic[@"title"]];
        CGSize maximumLabelSize = CGSizeMake(T_WIDTH(100), 22);//labelsize的最大值
        CGSize expectSize = [_titleLabel sizeThatFits:maximumLabelSize];
        _titleLabel.frame =CGRectMake(15, T_WIDTH(70), expectSize.width, 22);
        _subLabel.text = @" ";
    }

    NSString* minageStr = [NSString stringWithFormat:@"%@",dic[@"minage"]];
    NSString* maxageStr = [NSString stringWithFormat:@"%@",dic[@"maxage"]];
    NSString* timeStr =   [ArtUIHelper returnTimeStrWithMin:minageStr Max:maxageStr];
    if (timeStr.length>0) {
        _timeLabel.text = timeStr;
    }
    _numsLabel.text = [NSString stringWithFormat:@"共%@篇",dic[@"count"]];
    _seeNums.text = [NSString stringWithFormat:@"查看%@",dic[@"allnum"]];
    [_baseImage sd_setImageWithUrlStr:[NSString stringWithFormat:@"%@!2b1",dic[@"photo"]] tempTmage:@"icon_Default_Product.png"];
}
@end
