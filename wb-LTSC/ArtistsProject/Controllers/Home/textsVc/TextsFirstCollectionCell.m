//
//  IntroImageCollectionCell.m
//  ArtistProject
//
//  Created by HELLO WORLD on 2017/3/28.
//  Copyright © 2017年 HELLO WORLD. All rights reserved.
//

#import "TextsFirstCollectionCell.h"

@interface TextsFirstCollectionCell ()
@property(nonatomic,strong)UIImageView* iconView;
@property(nonatomic,strong)UILabel * nameLabel;
@end
@implementation TextsFirstCollectionCell
-(void)addContentViews{
    //self.contentView.backgroundColor = BACK_VIEW_COLOR;
    _iconView = [[UIImageView alloc]initWithFrame:CGRectMake(self.bounds.size.width/2-T_WIDTH(30), 0, T_WIDTH(60), T_WIDTH(60))];
    _iconView.userInteractionEnabled = YES;
    _iconView.layer.cornerRadius = T_WIDTH(30);
    _iconView.layer.masksToBounds = YES;
    [self.contentView addSubview:_iconView];
    
    _nameLabel= [[UILabel alloc]initWithFrame:CGRectMake(self.bounds.size.width/2-T_WIDTH(30),getViewHeight(_iconView)+5, T_WIDTH(60), T_WIDTH(15))];
    _nameLabel.font = ART_FONT(ARTFONT_OT);
    _nameLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_nameLabel];
    
//    UIImageView* zhezhaocheng = [[UIImageView alloc]initWithFrame:self.bounds];
//    zhezhaocheng.userInteractionEnabled = YES;
//    [zhezhaocheng setImage:[UIImage imageNamed:@"zhezhaocheng"]];
//    [self.contentView addSubview:zhezhaocheng];
}
-(void)setLikeCollectionViewCellValue:(NSDictionary*)dic{
    _nameLabel.hidden = YES;
    _iconView.layer.cornerRadius  = 15;
    _iconView.frame = CGRectMake(0, 0, 30, 30);
    [_iconView sd_setImageWithUrlStr:[NSString stringWithFormat:@"%@!120a",dic[@"avatar"]] tempTmage:@"temp_Default_headProtrait"];
}
-(void)setArtCollectionViewCellValue:(NSDictionary *)dic{
    if (dic.count>0) {
        [_iconView sd_setImageWithUrlStr:[NSString stringWithFormat:@"%@!120a",dic[@"avatar"]] tempTmage:@"temp_Default_headProtrait"];
        _nameLabel.text = dic[@"username"];
    }else{
    [_iconView setImage:[UIImage imageNamed:@"temp_Default_headProtrait"]];
     _nameLabel.text = @"";
    }
}
@end
