//
//  WebviewCell.h
//  ShesheDa
//
//  Created by chen on 16/8/3.
//  Copyright © 2016年 上海翔汇网络有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebviewCell : UITableViewCell

@property(strong,nonatomic)NSString *Url;
@property (nonatomic, copy) void (^btndelBlock)();
@end
