//
//  MSBReadHistoryTool.h
//  meishubao
//
//  Created by T on 16/12/21.
//  Copyright © 2016年 benbun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MSBHistoryModel.h"

@interface MSBReadHistoryTool : NSObject
+ (void)insertDBModel:(MSBHistoryModel *)model;
+ (NSMutableArray *)searchDBWithTime:(NSString *)time;
@end
