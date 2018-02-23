//
//  IntroVideoCell.h
//  ArtistProject
//
//  Created by HELLO WORLD on 2017/3/28.
//  Copyright © 2017年 HELLO WORLD. All rights reserved.
//

#import "ArtTableViewCell.h"

@interface IntroVideoCell : ArtTableViewCell
@property (nonatomic, copy) void(^selectImgCilck)(NSInteger index);
@end
