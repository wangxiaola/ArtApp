//
//  RecentShopCollectionCell.h
//  ArtistsProject
//
//  Created by 黄兵 on 2018/2/7.
//  Copyright © 2018年 HELLO WORLD. All rights reserved.
//

#import "BaseCollectionCell.h"

@interface RecentShopCollectionCell : BaseCollectionCell

@property (weak, nonatomic) IBOutlet UIImageView *imageV;
@property (weak, nonatomic) IBOutlet UIImageView *hotView;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UILabel *desc;
@property (weak, nonatomic) IBOutlet UIImageView *smImage;
@property (weak, nonatomic) IBOutlet UILabel *source;


@end
