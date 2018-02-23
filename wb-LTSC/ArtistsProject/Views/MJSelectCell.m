//
//  MJSelectCell.m
//  ArtistsProject
//
//  Created by HELLO WORLD on 2017/4/22.
//  Copyright © 2017年 HELLO WORLD. All rights reserved.
//

#import "MJSelectCell.h"

@implementation MJSelectCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        
        _titleLabel = [[UILabel alloc]init];
        [self.contentView addSubview:_titleLabel];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.left.mas_offset(15);
            make.size.mas_equalTo(CGSizeMake(100, 20));
        }];

        _selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.contentView addSubview:_selectBtn];
        [_selectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.right.mas_offset(-15);
            make.size.mas_equalTo(CGSizeMake(20, 20));
        }];
    }
    return self;
}
-(void)setMjSelectCell:(NSString*)titleStr{
    _titleLabel.text = titleStr;
}
@end
