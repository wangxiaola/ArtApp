//
//  YTXGoodsCollectionViewCell.m
//  ShesheDa
//
//  Created by Hongwei Chen on 2016/11/9.
//  Copyright © 2016年 北京艺天下文化科技有限公司. All rights reserved.
//

#import "YTXGoodsCollectionViewCell.h"

@interface YTXGoodsCollectionViewCell ()

@property (nonatomic, strong) UIImageView * goodsImageView;

@end

@implementation YTXGoodsCollectionViewCell

- (void)setModel:(YTXGoodsViewModel *)model {
    _model = model.modelCopy;
    [self.goodsImageView setImageWithURL:_model.goodsImageURL placeholder:nil];
}

- (UIImageView *)goodsImageView {
    if (!_goodsImageView) {
        _goodsImageView = [[UIImageView alloc]init];
        _goodsImageView.contentMode = UIViewContentModeScaleAspectFill;
        _goodsImageView.clipsToBounds = YES;
        [self.contentView addSubview:_goodsImageView];
        [_goodsImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
    }
    return _goodsImageView;
}

@end
