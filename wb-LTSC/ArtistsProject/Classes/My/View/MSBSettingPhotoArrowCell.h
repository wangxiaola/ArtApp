//
//  MSBSettingPhotoArrowCell.h
//  meishubao
//
//  Created by T on 16/11/24.
//  Copyright © 2016年 benbun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MSBSettingPhotoArrowCell : UITableViewCell
- (void)setTitle:(NSString *)title;
- (void)setValue:(UIImage *)value;
+ (CGFloat)rowHeight;

@property (strong, nonatomic) UIColor *cellTintColor;
@end
