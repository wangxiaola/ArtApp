//
//  BalancePaymentsModel.h
//  ShesheDa
//
//  Created by chen on 16/7/16.
//  Copyright © 2016年 上海翔汇网络有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BalancePaymentsDetailModel : NSObject
@property(nonatomic,copy) NSString *coin;
@end

@interface BalancePaymentsModel : NSObject

@property(nonatomic,copy) NSString *action;
@property(nonatomic,copy) NSString *coinnum;
@property(nonatomic,copy) NSString *ctime;
@property(nonatomic,strong) BalancePaymentsDetailModel *detail;
@property(nonatomic,copy) NSString *type;
@end
