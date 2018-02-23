//
//  IntroVideoCollectionCell.m
//  ArtistProject
//
//  Created by HELLO WORLD on 2017/3/28.
//  Copyright © 2017年 HELLO WORLD. All rights reserved.
//

#import "IntroVideoCollectionCell.h"

@interface IntroVideoCollectionCell ()
@property(nonatomic,strong)UIImageView* iconView;
@end
@implementation IntroVideoCollectionCell
-(void)addContentViews{
    _iconView = [[UIImageView alloc]initWithFrame:self.bounds];
    _iconView.userInteractionEnabled = YES;
    [self.contentView addSubview:_iconView];
    UIImageView* zhezhaocheng = [[UIImageView alloc]initWithFrame:self.bounds];
    zhezhaocheng.userInteractionEnabled = YES;
    [zhezhaocheng setImage:[UIImage imageNamed:@"zhezhaocheng"]];
    [self.contentView addSubview:zhezhaocheng];
    UIImageView* imgState=[[UIImageView alloc]init];
    imgState.image=[UIImage imageNamed:@"icon_post_video"];
    [self.contentView addSubview:imgState];
    [imgState mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.contentView);
    }];
}
-(void)setArtCollectionViewCellStrValue:(NSString *)imgUrl{
    [_iconView sd_setImageWithUrlStr:imgUrl tempTmage:@"icon_Default_Product"];
}
@end
