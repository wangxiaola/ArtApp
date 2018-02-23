//
//  ShopSearchListCell.m
//  ArtistsProject
//
//  Created by 黄兵 on 2017/7/5.
//  Copyright © 2017年 HELLO WORLD. All rights reserved.
//

#import "ShopSearchListCell.h"

@implementation ShopSearchListCell

- (UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, self.contentView.width-30, self.contentView.width-30)];
        _imageView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [self.contentView addSubview:_imageView];
    }
    return _imageView;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, _imageView.endY, CGRectGetWidth(self.bounds)-30, 30)];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.font = kFont(14);
        [self.contentView addSubview:_titleLabel];
    }
    return _titleLabel;
}

- (UILabel *)price{
    if (!_price) {
        _price = [[UILabel alloc] initWithFrame:CGRectMake(15, _titleLabel.endY, CGRectGetWidth(self.bounds)-30, 20)];
        _price.textAlignment = NSTextAlignmentLeft;
        _price.font = kFont(14);
        [self.contentView addSubview:_price];
    }
    return _price;
}

- (UIView *)rightView
{
    if (!_rightView) {
        _rightView = [[UIView alloc] initWithFrame:CGRectMake(_imageView.endX + 14, 15, 1, self.contentView.height-15)];
        _rightView.backgroundColor = [UIColor hexChangeFloat:@"ebebeb"];
        [self.contentView addSubview:_rightView];
    }
    return _rightView;
}
- (UIView *)rightView2
{
    if (!_rightView2) {
        _rightView2 = [[UIView alloc] initWithFrame:CGRectMake(_imageView.endX + 14, 0, 1, self.contentView.height)];
        _rightView2.backgroundColor = [UIColor hexChangeFloat:@"ebebeb"];
        [self.contentView addSubview:_rightView2];
    }
    return _rightView2;
}

- (UIView *)leftbotView
{
    if (!_leftbotView) {
        _leftbotView = [[UIView alloc] initWithFrame:CGRectMake(15, self.price.endY +10, self.contentView.width-15, 1)];
        _leftbotView.backgroundColor = [UIColor hexChangeFloat:@"ebebeb"];
        [self.contentView addSubview:_leftbotView];
    }
    return _leftbotView;
}
- (UIView *)rightbotView
{
    if (!_rightbotView) {
        _rightbotView = [[UIView alloc] initWithFrame:CGRectMake(0, self.price.endY +10, self.contentView.width-15, 1)];
        _rightbotView.backgroundColor = [UIColor hexChangeFloat:@"ebebeb"];
        [self.contentView addSubview:_rightbotView];
    }
    return _rightbotView;
}

@end
