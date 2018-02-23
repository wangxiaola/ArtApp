//
//  MSBFollowCell.h
//  meishubao
//
//  Created by T on 16/11/25.
//  Copyright © 2016年 benbun. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MSBFollowItem.h"

typedef void(^FollowClickBlock)(UIButton *);

@interface MSBFollowCell : UITableViewCell
- (void)setModel:(MSBFollowItem *)item;
@property (nonatomic, copy) FollowClickBlock followBlock;

@end
