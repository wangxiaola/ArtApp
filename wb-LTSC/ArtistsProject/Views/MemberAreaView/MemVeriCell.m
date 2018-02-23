//
//  MemVeriCell.m
//  ArtistsProject
//
//  Created by 黄兵 on 2017/6/26.
//  Copyright © 2017年 HELLO WORLD. All rights reserved.
//

#import "MemVeriCell.h"

@implementation MemVeriCell

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
        self.title = [[UILabel alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:_title];
        _title.sd_layout
        .leftSpaceToView(self.contentView, 15)
        .rightSpaceToView(self.contentView, 15)
        .topSpaceToView(self.contentView, 10)
        .heightIs(15);
        self.content = [[UILabel alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:_content];
        _content.sd_layout
        .leftEqualToView(_title)
        .rightEqualToView(_title)
        .topSpaceToView(_title, 5)
        .autoHeightRatio(0);
        self.title.font = self.content.font = kFont(14);
        //***********************高度自适应cell设置
        [self setupAutoHeightWithBottomView:_content bottomMargin:10];
    }
    return self;
}

- (void)setModel:(AuthenticationModel *)model
{
    _model = model;
    self.content.text = @"测试数据";
}

@end
