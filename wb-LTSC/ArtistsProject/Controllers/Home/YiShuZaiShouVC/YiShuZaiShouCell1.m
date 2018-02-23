//
//  YiShuZaiShouCell.m
//  ArtistsProject
//
//  Created by 黄兵 on 2017/7/30.
//  Copyright © 2017年 HELLO WORLD. All rights reserved.
//

#import "YiShuZaiShouCell1.h"

@implementation YiShuZaiShouCell1

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.imageV = [[UIImageView alloc] init];
        [self.contentView addSubview:_imageV];
        _imageV.sd_layout.leftSpaceToView(self.contentView,0).rightSpaceToView(self.contentView, 0).topSpaceToView(self.contentView, 10).heightIs(kScreenW/3);
    }
    return self;
}
@end
