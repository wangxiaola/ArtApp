//
//  ArtCollectionViewCell.h
//  ArtistProject
//
//  Created by HELLO WORLD on 2017/3/28.
//  Copyright © 2017年 HELLO WORLD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ArtCollectionViewCell : UICollectionViewCell
-(void)addContentViews;
-(void)setArtCollectionViewCellValue:(NSDictionary *)dic;
-(void)setArtCollectionViewCellStrValue:(NSString *)imgUrl;
@end
