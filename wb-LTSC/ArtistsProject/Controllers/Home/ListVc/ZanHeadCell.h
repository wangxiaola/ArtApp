//
//  ZanHeadCell.h
//  ArtistsProject
//
//  Created by HELLO WORLD on 2017/4/22.
//  Copyright © 2017年 HELLO WORLD. All rights reserved.
//

#import "ArtTableViewCell.h"

@interface ZanHeadCell : ArtTableViewCell
@property(nonatomic,strong)UIButton* shangBtn;
@property(nonatomic,strong)UILabel* peopleNums;
@property(nonatomic,copy)void(^shangSendClick)();
-(void)setArtTableViewCellDicValue:(NSInteger)num;
@end
