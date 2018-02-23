//
//  TableViewCell.h
//  category
//
//  Created by 大锅 on 2017/6/9.
//  Copyright © 2017年 daguo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GoodsCategoryTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIView *leftView;
@property (weak, nonatomic) IBOutlet UIView *botView;
@property (weak, nonatomic) IBOutlet UIView *rightView;


@end
