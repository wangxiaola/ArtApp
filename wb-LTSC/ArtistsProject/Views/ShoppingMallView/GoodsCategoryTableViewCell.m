//
//  TableViewCell.m
//  category
//
//  Created by 大锅 on 2017/6/9.
//  Copyright © 2017年 daguo. All rights reserved.
//

#import "GoodsCategoryTableViewCell.h"
@interface GoodsCategoryTableViewCell()



@end

@implementation GoodsCategoryTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self setupUI];
}
- (void)setupUI
{
    self.topView.backgroundColor = [UIColor hexChangeFloat:@"e5e5e6"];
    self.leftView.backgroundColor = [UIColor hexChangeFloat:@"e5e5e6"];
    self.rightView.backgroundColor = [UIColor hexChangeFloat:@"e5e5e6"];
    self.botView.backgroundColor = [UIColor hexChangeFloat:@"e5e5e6"];
    self.botView.hidden = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];


}



@end
