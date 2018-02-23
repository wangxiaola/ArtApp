//
//  ArtSelectCell.h
//  ArtistProject
//
//  Created by HELLO WORLD on 2017/4/19.
//  Copyright © 2017年 HELLO WORLD. All rights reserved.
//

#import "ArtTableViewCell.h"

@interface ArtSelectCell : ArtTableViewCell
@property(nonatomic,strong)UIButton* selectBtn;
@property(nonatomic,copy)void(^addSelectBlock)(NSInteger);
@property(nonatomic,copy)void(^deleteSelectBlock)(NSInteger);
-(void)setSelectCellDic:(NSDictionary*)dic;
@end
