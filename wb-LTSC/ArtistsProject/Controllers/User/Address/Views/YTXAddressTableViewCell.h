//
//  YTXAddressTableViewCell.h
//  ShesheDa
//
//  Created by Hongwei Chen on 2016/11/12.
//  Copyright © 2016年 北京艺天下文化科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YTXAddressViewModel.h"

extern NSString * kYTXAddressTableViewCell;

@interface YTXAddressTableViewCell : UITableViewCell

@property (nonatomic, strong) YTXAddressViewModel * model;

@property (nonatomic, copy) void(^editBtnAcionBlock)();

+ (CGFloat)heightForViewModel:(YTXAddressViewModel *)model;

@end
