//
//  RecentInfoTableCell.h
//  ArtistsProject
//
//  Created by 黄兵 on 2018/2/7.
//  Copyright © 2018年 HELLO WORLD. All rights reserved.
//

#import "BaseTableCell.h"

@interface RecentInfoTableCell : BaseTableCell

@property (weak, nonatomic) IBOutlet UIImageView *imageV;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *date;
@property (weak, nonatomic) IBOutlet UILabel *comment;

@end
