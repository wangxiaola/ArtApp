//
//  ShoppingMallCollectionViewCell.m
//  ArtistsProject
//
//  Created by 大锅 on 2017/6/10.
//  Copyright © 2017年 HELLO WORLD. All rights reserved.
//

#import "ShoppingMallCollectionViewCell.h"

@implementation ShoppingMallCollectionViewCell

- (UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.contentView.width, self.contentView.width)];
        _imageView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [self.contentView addSubview:_imageView];
    }return _imageView;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _imageView.endY, CGRectGetWidth(self.bounds), 30)];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = kFont(14);
        [self.contentView addSubview:_titleLabel];
    }return _titleLabel;
}

- (UILabel *)price{
    if (!_price) {
        _price = [[UILabel alloc] initWithFrame:CGRectMake(0, _titleLabel.endY, CGRectGetWidth(self.bounds), 20)];
        _price.textAlignment = NSTextAlignmentLeft;
        _price.font = kFont(14);
        [self.contentView addSubview:_price];
    }return _price;
}

- (UIView *)rightView
{
    if (!_rightView) {
        _rightView = [[UIView alloc] initWithFrame:CGRectMake(_imageView.endX + 7, 0, 1, self.contentView.height)];
        _rightView.backgroundColor = [UIColor hexChangeFloat:@"ebebeb"];
        [self.contentView addSubview:_rightView];
    }
    return _rightView;
}

- (UIView *)botView
{
    if (!_botView) {
        _botView = [[UIView alloc] initWithFrame:CGRectMake(0, self.contentView.height-1, self.contentView.width, 1)];
        _botView.backgroundColor = [UIColor hexChangeFloat:@"ebebeb"];
        [self.contentView addSubview:_botView];
    }
    return _botView;
}

@end
