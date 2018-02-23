//
//  YTXTagsTableViewCell.m
//  ShesheDa
//
//  Created by Hongwei Chen on 2016/11/8.
//  Copyright © 2016年 北京艺天下文化科技有限公司. All rights reserved.
//

#import "YTXTagsTableViewCell.h"

@interface YTXTagsTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;

@end

@implementation YTXTagsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    // Initialization code
}

- (void)setModel:(YTXTagsViewModel *)model {
    _model = model.modelCopy;
    _titleLabel.text = [NSString stripNullWithString:_model.name];
    _countLabel.text = [NSString stripNullWithString:_model.count];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
