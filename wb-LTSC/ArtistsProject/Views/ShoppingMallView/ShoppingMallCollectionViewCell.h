//
//  ShoppingMallCollectionViewCell.h
//  ArtistsProject
//
//  Created by 大锅 on 2017/6/10.
//  Copyright © 2017年 HELLO WORLD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShoppingMallCollectionViewCell : UICollectionViewCell

@property (nonatomic,strong)UIImageView *imageView; // 显示图片
@property (nonatomic,strong)UILabel *titleLabel; // 显示文字
// 图片
@property (nonatomic, strong) UILabel *price;// 显示价格

// rightView
@property (nonatomic, strong) UIView *rightView;
// 下分割线
@property (nonatomic, strong) UIView *botView;

@end
