//
//  YTXSearchDynamicCell.m
//  ShesheDa
//
//  Created by lixianjun on 2016/12/25.
//  Copyright © 2016年 北京艺天下文化科技有限公司. All rights reserved.
//

#import "YTXSearchDynamicCell.h"

@implementation YTXSearchDynamicCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(YTXSearchDynamicModel*)model
{
    _model = model;
    [_avactorView sd_setImageWithURL:[NSURL URLWithString:model.user.avatar] placeholderImage:[UIImage imageNamed:@"temp_Default_headProtrait"]];
    _nameLabel.text = model.user.username;
    if (model.topictypeName.length > 0) {
        _sourceLabel.text = [NSString stringWithFormat:@"%@", model.topictypeName];
    }
    _timeLabel.text = [self changeTime:model.dateline];
    
    if ([_model.statusName isEqualToString:@"未鉴定"]) {
        
        if ([_model.topictitle isEqualToString:@""]) {
//            _contentLabel.text = [NSString stringWithFormat:@"未鉴定"];
        }
        else{
            _contentLabel.text = [NSString stringWithFormat:@"%@  |  %@",_model.topictitle,_model.catetypeName];
        }

    }else{
        _contentLabel.text = [NSString stringWithFormat:@"%@ | %@ \n\n 专家鉴定结果：%@  |  年代：%@  |  估价：%@",_model.topictitle,_model.catetypeName,_model.statusName,_model.statusName,_model.price];
    }
    
    if (model.photoscbk.count > 0) {
        if (model.photoscbk.count == 1) {
            
            YTXPhotoscbkModel *photoModel = [model.photoscbk objectAtIndex:0];
            [_imageView1 sd_setImageWithURL:[NSURL URLWithString:photoModel.photo] placeholderImage:[UIImage imageNamed:@"temp_Default_headProtrait"]];

        }
        else if (model.photoscbk.count == 2) {
            
            YTXPhotoscbkModel *photoModel1 = [model.photoscbk objectAtIndex:0];
            YTXPhotoscbkModel *photoModel2 = [model.photoscbk objectAtIndex:1];
            [_imageView1 sd_setImageWithURL:[NSURL URLWithString:photoModel1.photo] placeholderImage:[UIImage imageNamed:@"temp_Default_headProtrait"]];
            [_imageView2 sd_setImageWithURL:[NSURL URLWithString:photoModel2.photo] placeholderImage:[UIImage imageNamed:@"temp_Default_headProtrait"]];

        }
        else if (model.photoscbk.count == 3) {
            
            YTXPhotoscbkModel *photoModel1 = [model.photoscbk objectAtIndex:0];
            YTXPhotoscbkModel *photoModel2 = [model.photoscbk objectAtIndex:1];
            YTXPhotoscbkModel *photoModel3 = [model.photoscbk objectAtIndex:2];

            [_imageView1 sd_setImageWithURL:[NSURL URLWithString:photoModel1.photo] placeholderImage:[UIImage imageNamed:@"temp_Default_headProtrait"]];
            [_imageView2 sd_setImageWithURL:[NSURL URLWithString:photoModel2.photo] placeholderImage:[UIImage imageNamed:@"temp_Default_headProtrait"]];
            [_imageView3 sd_setImageWithURL:[NSURL URLWithString:photoModel3.photo] placeholderImage:[UIImage imageNamed:@"temp_Default_headProtrait"]];

            
        }
        else if (model.photoscbk.count == 4) {
            
            YTXPhotoscbkModel *photoModel1 = [model.photoscbk objectAtIndex:0];
            YTXPhotoscbkModel *photoModel2 = [model.photoscbk objectAtIndex:1];
            YTXPhotoscbkModel *photoModel3 = [model.photoscbk objectAtIndex:2];
            YTXPhotoscbkModel *photoModel4 = [model.photoscbk objectAtIndex:3];

            [_imageView1 sd_setImageWithURL:[NSURL URLWithString:photoModel1.photo] placeholderImage:[UIImage imageNamed:@"temp_Default_headProtrait"]];
            [_imageView2 sd_setImageWithURL:[NSURL URLWithString:photoModel2.photo] placeholderImage:[UIImage imageNamed:@"temp_Default_headProtrait"]];
            [_imageView3 sd_setImageWithURL:[NSURL URLWithString:photoModel3.photo] placeholderImage:[UIImage imageNamed:@"temp_Default_headProtrait"]];
            [_imageView4 sd_setImageWithURL:[NSURL URLWithString:photoModel4.photo] placeholderImage:[UIImage imageNamed:@"temp_Default_headProtrait"]];

            
        }
        else if (model.photoscbk.count > 4) {
            
            YTXPhotoscbkModel *photoModel1 = [model.photoscbk objectAtIndex:0];
            YTXPhotoscbkModel *photoModel2 = [model.photoscbk objectAtIndex:1];
            YTXPhotoscbkModel *photoModel3 = [model.photoscbk objectAtIndex:2];
            YTXPhotoscbkModel *photoModel4 = [model.photoscbk objectAtIndex:3];
            
            [_imageView1 sd_setImageWithURL:[NSURL URLWithString:photoModel1.photo] placeholderImage:[UIImage imageNamed:@"temp_Default_headProtrait"]];
            [_imageView2 sd_setImageWithURL:[NSURL URLWithString:photoModel2.photo] placeholderImage:[UIImage imageNamed:@"temp_Default_headProtrait"]];
            [_imageView3 sd_setImageWithURL:[NSURL URLWithString:photoModel3.photo] placeholderImage:[UIImage imageNamed:@"temp_Default_headProtrait"]];
            [_imageView4 sd_setImageWithURL:[NSURL URLWithString:photoModel4.photo] placeholderImage:[UIImage imageNamed:@"temp_Default_headProtrait"]];
            
            
        }
    }
}

- (NSString*)changeTime:(NSString*)time
{
    
   //获取当前时间 钱币
    NSDate *currentDate = [NSDate date];//获取当前时间，日期
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY/MM/dd"];
    NSString *dateString = [dateFormatter stringFromDate:currentDate];
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY/MM/dd"];
    NSDate* confromTimesp = [NSDate dateWithTimeIntervalSince1970:time.intValue];
    NSString *originDateString = [formatter stringFromDate:confromTimesp];
     NSArray *currentArray=[dateString componentsSeparatedByString:@"/"];
    NSArray * originDateArray=[originDateString componentsSeparatedByString:@"/"];
    NSString * differenceDate;
    if ([currentArray[0] isEqualToString:originDateArray[0]]) {
        
        if ([currentArray[1] isEqualToString:originDateArray[1]]) {
            
            if ([currentArray[2] isEqualToString:originDateArray[2]]) {
               differenceDate = [NSString stringWithFormat:@"%@天前",[ @([currentArray[2] integerValue] - [originDateArray[2] integerValue]) stringValue]];
            }
        }else{
        differenceDate = [NSString stringWithFormat:@"%@个月前",[ @([currentArray[1] integerValue] - [originDateArray[1] integerValue]) stringValue]];
        }
    }else{
        differenceDate = [NSString stringWithFormat:@"%@年前",[ @([currentArray[0] integerValue] - [originDateArray[0] integerValue]) stringValue]];
    }
    
    return differenceDate;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
