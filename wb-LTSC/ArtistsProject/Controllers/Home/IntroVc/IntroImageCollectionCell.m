//
//  IntroImageCollectionCell.m
//  ArtistProject
//
//  Created by HELLO WORLD on 2017/3/28.
//  Copyright © 2017年 HELLO WORLD. All rights reserved.
//

#import "IntroImageCollectionCell.h"

@implementation IntroImageCollectionCell
-(void)addContentViews{
    _iconView = [[UIImageView alloc]initWithFrame:self.bounds];
    _iconView.userInteractionEnabled = YES;
    [self.contentView addSubview:_iconView];
    UIImageView* zhezhaocheng = [[UIImageView alloc]initWithFrame:self.bounds];
    zhezhaocheng.userInteractionEnabled = YES;
    [zhezhaocheng setImage:[UIImage imageNamed:@"zhezhaocheng"]];
    [self.contentView addSubview:zhezhaocheng];
}
-(void)setArtCollectionViewCellStrValue:(NSString *)imgUrl andTag:(NSInteger)tag{
    _iconView.tag = tag;
    [_iconView sd_setImageWithUrlStr:[NSString stringWithFormat:@"%@!450a",imgUrl] tempTmage:@"icon_Default_Product"];
    
}
@end
