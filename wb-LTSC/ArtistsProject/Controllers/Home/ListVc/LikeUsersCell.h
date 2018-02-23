//
//  LikeUsersCell.h
//  ArtistProject
//
//  Created by HELLO WORLD on 2017/4/9.
//  Copyright © 2017年 HELLO WORLD. All rights reserved.
//

#import "ArtTableViewCell.h"

@interface LikeUsersCell : ArtTableViewCell
@property (nonatomic, strong)void(^selectImgCilck)(NSDictionary*);
@property(nonatomic,strong)void(^enterBtnClick)();
@end
