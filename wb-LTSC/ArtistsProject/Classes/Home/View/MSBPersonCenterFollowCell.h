//
//  MSBPersonCenterFollowCell.h
//  meishubao
//
//  Created by T on 16/12/1.
//  Copyright © 2016年 benbun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MSBPersonCenterFollowCell : UITableViewCell
- (void)setModel:(NSDictionary *)item;

+ (CGFloat)rowHeight:(NSDictionary *)item
           cellWidth:(CGFloat)cellWidth;
@end
