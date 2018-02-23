//
//  YTXPublishViewCell.h
//  ShesheDa
//
//  Created by Hongwei Chen on 2016/12/24.
//  Copyright © 2016年 北京艺天下文化科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YTXPublishViewCell : UITableViewCell

- (void)setTitle:(NSString *)title;
- (NSString *)title;
- (void)setSubtitle:(NSString *)subtitle;
- (NSString *)subtitle;
@property (strong, nonatomic) UILabel *subtitleLabel;
@property (nonatomic, strong) UISwitch *huiyuan;
@property (nonatomic, strong) UILabel *miaoshu;

@end
