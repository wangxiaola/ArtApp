//
//  LGMessSettingValueCell.h
//  evtmaster
//
//  Created by T on 16/7/20.
//  Copyright © 2016年 benbun. All rights reserved.
//

#import <UIKit/UIKit.h>
static NSString *const CellIdentifier_LGMessSettingValue = @"LGMessSettingValueCell";

@interface LGMessSettingValueCell : UITableViewCell
- (void)setTitle:(NSString *)title;
- (void)setValue:(NSString *)value;
- (void)setTitle:(NSString *)title
           value:(NSString *)value;
+ (CGFloat)rowHeight;


@property (strong, nonatomic) UIColor *cellTintColor;
@end
