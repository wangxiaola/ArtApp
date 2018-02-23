//
//  RecentCourseTableCell.h
//  ArtistsProject
//
//  Created by 黄兵 on 2018/2/7.
//  Copyright © 2018年 HELLO WORLD. All rights reserved.
//

#import "BaseTableCell.h"

@interface RecentCourseTableCell : BaseTableCell
@property (weak, nonatomic) IBOutlet UIImageView *imageV;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *applyPerson;
@property (weak, nonatomic) IBOutlet UILabel *price;

@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *desc;

@end
