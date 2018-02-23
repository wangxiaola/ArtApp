//
//  LiveListCell.h
//  ArtistsProject
//
//  Created by 黄兵 on 2018/2/8.
//  Copyright © 2018年 HELLO WORLD. All rights reserved.
//

#import "BaseTableCell.h"

@interface LiveListCell : BaseTableCell
@property (weak, nonatomic) IBOutlet UILabel *title;

@property (weak, nonatomic) IBOutlet UIImageView *imageV;

@property (weak, nonatomic) IBOutlet UILabel *play;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *playCount;
@property (weak, nonatomic) IBOutlet UIImageView *smImg;

@end
