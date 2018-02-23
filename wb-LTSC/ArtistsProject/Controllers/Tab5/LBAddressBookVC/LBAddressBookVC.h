//
//  LBAddressBookVC.h
//  ShesheDa
//
//  Created by chen on 16/7/28.
//  Copyright © 2016年 上海翔汇网络有限公司. All rights reserved.
//

#import "HViewController.h"

@interface LBAddressBookVC : HViewController <UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, copy) NSMutableArray *personArray;
@property(nonatomic,strong) OSMessage *msg;
@end
