//
//  AudioTableViewCell.h
//  ShesheDa
//
//  Created by chen on 16/7/8.
//  Copyright © 2016年 上海翔汇网络有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AudioTableViewCell : UITableViewCell

@property (strong, nonatomic) HLabel* lblTitle;

@property (strong, nonatomic) NSDictionary* dic;
@property (strong, nonatomic) NSString* name;

@property (strong, nonatomic) UIImageView* btnPalyer;

@property (nonatomic, copy) void (^btndelBlock)();

- (void)stateBofang;
- (void)endBofang;
@end
