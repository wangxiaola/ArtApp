//
//  IntroImageCell.h
//  ArtistProject
//
//  Created by HELLO WORLD on 2017/3/28.
//  Copyright © 2017年 HELLO WORLD. All rights reserved.
//

#import "ArtTableViewCell.h"

@interface IntroImageCell : ArtTableViewCell
@property (nonatomic, strong) void(^selectImgCilck)(NSArray*,UIImageView*);
@end
