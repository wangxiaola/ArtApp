//
//  GoodsListCollectionViewCell.m
//  ArtistsProject
//
//  Created by 大锅 on 2017/6/10.
//  Copyright © 2017年 HELLO WORLD. All rights reserved.
//

#import "GoodsListCollectionViewCell.h"

@implementation GoodsListCollectionViewCell

- (UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.contentView.width, self.contentView.width)];
        _imageView.backgroundColor = [UIColor lightGrayColor];
        [self.contentView addSubview:_imageView];
    }return _imageView;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.bounds) - 30, CGRectGetWidth(self.bounds), 30)];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_titleLabel];
    }return _titleLabel;
}

@end