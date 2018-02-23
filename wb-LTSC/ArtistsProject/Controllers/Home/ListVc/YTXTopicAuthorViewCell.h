//
//  YTXTopicAuthorViewCell.h
//  ArtistProject
//
//  Created by HELLO WORLD on 2017/4/6.
//  Copyright © 2017年 HELLO WORLD. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UserInfoUserModel;
@interface YTXTopicAuthorViewCell : UITableViewCell

@property (nonatomic, copy) void (^accountTouch)(UserInfoUserModel *model);

@property (nonatomic, strong)UserInfoUserModel *model;

+ (CGFloat)defaultCellHeight;

@end
