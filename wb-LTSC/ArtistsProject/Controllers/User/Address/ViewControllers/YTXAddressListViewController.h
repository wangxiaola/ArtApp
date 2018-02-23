//
//  YTXAddressListViewController.h
//  ShesheDa
//
//  Created by Hongwei Chen on 2016/11/12.
//  Copyright © 2016年 北京艺天下文化科技有限公司. All rights reserved.
//

#import "HViewController.h"
#import "YTXAddressViewModel.h"

@interface YTXAddressListViewController : HViewController

@property (nonatomic, copy) void(^didSelectAddress)(YTXAddressViewModel *);

@end
