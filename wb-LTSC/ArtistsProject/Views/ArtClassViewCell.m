//
//  ArtClassViewCell.m
//  ArtistsProject
//
//  Created by 黄兵 on 2017/7/5.
//  Copyright © 2017年 HELLO WORLD. All rights reserved.
//

#import "ArtClassViewCell.h"

@implementation ArtClassViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _imageV = [[UIImageView alloc] init];
        [self.contentView addSubview:_imageV];
        _imageV.sd_layout
        .leftSpaceToView(self.contentView, 15)
        .widthIs(40)
        .heightEqualToWidth()
        .centerYEqualToView(self.contentView);
        _title = [[UILabel alloc] init];
        _title.font = kFont(14);
        [self.contentView addSubview:_title];
        _title.sd_layout
        .leftSpaceToView(self.imageV, 10)
        .centerYEqualToView(self.contentView)
        .rightSpaceToView(self.contentView, 15)
        .heightIs(30);
//        _botView = [[UIView alloc] init];
//        [self.contentView addSubview:_botView];
//        _botView.sd_layout
//        .leftEqualToView(_imageV)
//        .rightSpaceToView(self.contentView, 15)
//        .bottomSpaceToView(self.contentView, 0)
//        .heightIs(1);
    }
    return self;
}

@end
