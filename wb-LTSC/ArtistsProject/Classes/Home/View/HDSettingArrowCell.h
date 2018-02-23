//
//  HDSettingSwitchCell.h
//  evtmaster
//
//  Created by T on 16/8/22.
//  Copyright © 2016年 benbun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSBInfoStoreItem.h"
#import "MSBHistoryModel.h"

@interface HDSettingArrowCell : UITableViewCell
- (void)setTitle:(NSString *)title;
- (void)setArrowTitle:(NSString *)title;
- (void)setModel:(MSBInfoStoreItem *)item;
- (void)setHistoryModel:(MSBHistoryModel *)item;
+ (CGFloat)rowHeight;

@property (strong, nonatomic) UIColor *cellTintColor;
@end
