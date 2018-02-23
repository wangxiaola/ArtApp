//
//  ListTitleCell.h
//  ArtistProject
//
//  Created by HELLO WORLD on 2017/4/6.
//  Copyright © 2017年 HELLO WORLD. All rights reserved.
//

#import "ArtTableViewCell.h"

@class CangyouQuanDetailModel;
@interface ListTitleCell : ArtTableViewCell
@property (strong, nonatomic) CangyouQuanDetailModel *model;
+ (CGFloat)heightWithModel:(CangyouQuanDetailModel *)model;
@end
