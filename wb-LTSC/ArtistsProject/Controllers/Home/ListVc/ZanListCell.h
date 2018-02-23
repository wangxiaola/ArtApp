//
//  ZanListCell.h
//  ArtistsProject
//
//  Created by HELLO WORLD on 2017/4/22.
//  Copyright © 2017年 HELLO WORLD. All rights reserved.
//

#import "ArtTableViewCell.h"
#import "UserInfoModel.h"

@interface ZanListCell : ArtTableViewCell
@property(nonatomic,strong)UIImageView* iconView;
@property(nonatomic,strong)UILabel* nameLabel;
@property(nonatomic,strong)UILabel* moneyLabel;
@property(nonatomic,strong)UILabel* dateLabel;
@property(nonatomic,strong)UserInfoUserModel* model;
@end
