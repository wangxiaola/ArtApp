//
//  YTXAddressModel.h
//  ShesheDa
//
//  Created by Hongwei Chen on 2016/11/14.
//  Copyright © 2016年 北京艺天下文化科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#

@interface YTXAddressModel : NSObject<YYModel,NSCoding>

@property (nonatomic, copy) NSString * aid;
@property (nonatomic, copy) NSString * defaultStr;
@property (nonatomic, copy) NSString * uid;
@property (nonatomic, copy) NSString * name;
@property (nonatomic, copy) NSString * phone;
@property (nonatomic, copy) NSString * address;

@end
