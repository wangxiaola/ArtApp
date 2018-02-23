//
//  UserInfoVideoCell.h
//  ShesheDa
//
//  Created by chen on 16/8/2.
//  Copyright © 2016年 上海翔汇网络有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserInfoVideoCell : UITableViewCell

@property(strong,nonatomic)NSString *videoUrl;
@property (nonatomic, copy) void (^btndelBlock)();
@end
