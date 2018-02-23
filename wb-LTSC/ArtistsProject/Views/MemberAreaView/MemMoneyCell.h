//
//  MemMoneyCell.h
//  ArtistsProject
//
//  Created by 黄兵 on 2017/6/27.
//  Copyright © 2017年 HELLO WORLD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MemMoneyCell : UITableViewCell

// 图片
@property (nonatomic, strong) UIImageView *imageV;
// 标题
@property (nonatomic, strong) UILabel *title;
// 箭头
@property (nonatomic, strong) UIImageView *direImg;
// 底线
@property (nonatomic, strong) UIView *botView;

@end
