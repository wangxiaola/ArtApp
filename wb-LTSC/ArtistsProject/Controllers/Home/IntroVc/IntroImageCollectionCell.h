//
//  IntroImageCollectionCell.h
//  ArtistProject
//
//  Created by HELLO WORLD on 2017/3/28.
//  Copyright © 2017年 HELLO WORLD. All rights reserved.
//

#import "ArtCollectionViewCell.h"

@interface IntroImageCollectionCell : ArtCollectionViewCell
@property(nonatomic,strong)UIImageView* iconView;
-(void)setArtCollectionViewCellStrValue:(NSString *)imgUrl andTag:(NSInteger)tag;
@end
