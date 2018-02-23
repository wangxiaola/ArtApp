//
//  ArtApplyCell.m
//  ArtistsProject
//
//  Created by 黄兵 on 2017/6/27.
//  Copyright © 2017年 HELLO WORLD. All rights reserved.
//

#import "ArtApplyCell.h"

@implementation ArtApplyCell

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
        // 箭头
        self.direImg = [[UIImageView alloc] initWithFrame:CGRectZero];
        _direImg.image = ImageNamed(@"更多ym");
        [self.contentView addSubview:_direImg];
        self.direImg.sd_layout
        .rightSpaceToView(self.contentView, 10)
        .centerYEqualToView(self.contentView)
        .widthIs(6)
        .heightIs(12);
        // 标题
        self.title = [[UILabel alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:_title];
        _title.font = kFont(14);
        _title.textAlignment = NSTextAlignmentLeft;
        _title.sd_layout
        .leftSpaceToView(self.contentView, 15)
        .centerYEqualToView(self.contentView)
        .rightSpaceToView(self.direImg, 10)
        .heightIs(25);
        // 底线
        self.botView = [[UIView alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:_botView];
        _botView.backgroundColor = [UIColor grayColor];
        _botView.sd_layout
        .leftEqualToView(self.contentView)
        .rightEqualToView(self.contentView)
        .bottomEqualToView(self.contentView)
        .heightIs(0.5);
    }
    return self;
}


@end
