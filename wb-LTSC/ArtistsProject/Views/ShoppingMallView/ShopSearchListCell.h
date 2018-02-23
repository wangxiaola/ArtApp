//
//  ShopSearchListCell.h
//  ArtistsProject
//
//  Created by 黄兵 on 2017/7/5.
//  Copyright © 2017年 HELLO WORLD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShopSearchListCell : UICollectionViewCell

@property (nonatomic,strong)UIImageView *imageView; // 显示图片
@property (nonatomic,strong)UILabel *titleLabel; // 显示文字
// 图片
@property (nonatomic, strong) UILabel *price;// 显示价格

// rightView
@property (nonatomic, strong) UIView *rightView;
// rightView2
@property (nonatomic, strong) UIView *rightView2;
// 左下分割线
@property (nonatomic, strong) UIView *leftbotView;
// 右下分割线
@property (nonatomic, strong) UIView *rightbotView;

@end
