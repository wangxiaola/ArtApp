//
//  YTXSearchDynamicCell.h
//  ShesheDa
//
//  Created by lixianjun on 2016/12/25.
//  Copyright © 2016年 北京艺天下文化科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YTXSearchDynamicModel.h"

@interface YTXSearchDynamicCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *avactorView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *sourceLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentHeight;
@property (weak, nonatomic) IBOutlet UIImageView *imageView1;
@property (weak, nonatomic) IBOutlet UIImageView *imageView2;
@property (weak, nonatomic) IBOutlet UIImageView *imageView3;
@property (weak, nonatomic) IBOutlet UIImageView *imageView4;

@property (strong, nonatomic) YTXSearchDynamicModel *model;

- (void)setModel:(YTXSearchDynamicModel*)model;
@end
