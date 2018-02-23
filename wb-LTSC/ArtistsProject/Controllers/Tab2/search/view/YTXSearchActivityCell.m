//
//  YTXSearchActivityCell.m
//  ShesheDa
//
//  Created by lixianjun on 2016/12/25.
//  Copyright © 2016年 北京艺天下文化科技有限公司. All rights reserved.
//

#import "YTXSearchActivityCell.h"
#import "YTXPhotoscbkModel.h"

@implementation YTXSearchActivityCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(YTXSearchActivityModel*)model
{
    _model = model;
    _nameLabel.text = model.name;
    if (model.tips.length > 0) {
        _tagLabel.text = [NSString stringWithFormat:@"%@", model.tips];
    }
    _timeLabel.text = [NSString stringWithFormat:@"%@至%@",[self changeTime:model.stime],[self changeTime:model.etime]];
    
    
    _locLabel.text = [NSString stringWithFormat:@"%@   %@  ",model.location,model.place];
    
    
    [_imageView1 sd_setImageWithURL:[NSURL URLWithString:model.image] placeholderImage:[UIImage imageNamed:@"icon_Default_Product"]];
    
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
    }
    
}


- (NSString*)changeTime:(NSString*)time
{
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY/MM/dd"];
    NSDate* confromTimesp = [NSDate dateWithTimeIntervalSince1970:time.intValue];
    return [formatter stringFromDate:confromTimesp];
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
