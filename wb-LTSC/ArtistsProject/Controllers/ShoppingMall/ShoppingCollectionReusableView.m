//
//  ShoppingCollectionReusableView.m
//  ArtistsProject
//
//  Created by 黄兵 on 2017/7/27.
//  Copyright © 2017年 HELLO WORLD. All rights reserved.
//

#import "ShoppingCollectionReusableView.h"

@implementation ShoppingCollectionReusableView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.imageV = [[UIImageView alloc] init];
        [self addSubview:_imageV];
        [_imageV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self);
            make.left.equalTo(self).offset(15);
            make.right.equalTo(self).offset(-15);
        }];
    }
    return self;
}
@end
