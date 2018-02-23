//
//  IntroImageCollectionCell.m
//  ArtistProject
//
//  Created by HELLO WORLD on 2017/3/28.
//  Copyright © 2017年 HELLO WORLD. All rights reserved.
//

#import "MediasFirstCollectionCell.h"

@interface MediasFirstCollectionCell ()
@property(nonatomic,strong)UIImageView* iconView;
@property(nonatomic,strong)UILabel * nameLabel;
@end
@implementation MediasFirstCollectionCell
-(void)addContentViews{
    _iconView = [[UIImageView alloc]initWithFrame:CGRectMake(self.bounds.size.width/2-T_WIDTH(30), 0, T_WIDTH(60), T_WIDTH(60))];
    _iconView.userInteractionEnabled = YES;
    [self.contentView addSubview:_iconView];
    
    _nameLabel= [[UILabel alloc]initWithFrame:CGRectMake(0,getViewHeight(_iconView), self.bounds.size.width, T_WIDTH(15))];
    _nameLabel.font = ART_FONT(ARTFONT_OZ);
    _nameLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_nameLabel];
    
    //    UIImageView* zhezhaocheng = [[UIImageView alloc]initWithFrame:self.bounds];
    //    zhezhaocheng.userInteractionEnabled = YES;
    //    [zhezhaocheng setImage:[UIImage imageNamed:@"zhezhaocheng"]];
    //    [self.contentView addSubview:zhezhaocheng];
}
-(void)setArtCollectionViewCellValue:(NSDictionary *)dic{
    if (dic.count>0) {
        [_iconView sd_setImageWithUrlStr:[NSString stringWithFormat:@"%@",dic[@"avatar"]] tempTmage:@"temp_Default_headProtrait"];
        _nameLabel.text = dic[@"username"];
    }else{
        [_iconView setImage:[UIImage imageNamed:@"temp_Default_headProtrait"]];
        _nameLabel.text = @"";
    }
}
@end
