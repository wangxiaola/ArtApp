//
//  LGMessSettingSwitchCell.h
//  evtmaster
//
//  Created by T on 16/7/20.
//  Copyright © 2016年 benbun. All rights reserved.
//

#import <UIKit/UIKit.h>
static NSString *const CellIdentifier_LGMessSettingSwitch = @"LGMessSettingSwitchCell";
typedef void(^LGMessSettingSwitchCellBlock)(BOOL isOn);

@interface LGMessSettingSwitchCell : UITableViewCell
@property (assign, nonatomic, readonly) BOOL isOn;

@property (copy, nonatomic) LGMessSettingSwitchCellBlock changeBlock;

- (void)setOn:(BOOL)on;

- (void)setTitle:(NSString *)title;

- (void)setTitle:(NSString *)title icon:(NSString *)icon;

- (void)setTitle:(NSString *)title
            isOn:(BOOL)isOn;

- (void)setEnbaled:(BOOL)enabled;

+ (CGFloat)rowHeight;


@property (strong, nonatomic) UIColor *cellTintColor;
@end
