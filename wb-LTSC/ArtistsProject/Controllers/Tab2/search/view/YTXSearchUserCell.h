//
//  YTXSearchUserCell.h
//  ShesheDa
//
//  Created by lixianjun on 2016/12/25.
//  Copyright © 2016年 北京艺天下文化科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YTXSearchUserModel.h"

@interface YTXSearchUserCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *avactorView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *tagLabel;
@property (weak, nonatomic) IBOutlet UIButton *attentionBtn;

@property (strong, nonatomic) YTXSearchUserModel *model;

- (void)setModel:(YTXSearchUserModel*)model;

@end
